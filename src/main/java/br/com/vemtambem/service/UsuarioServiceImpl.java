package br.com.vemtambem.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.CicloDAO;
import br.com.vemtambem.dao.TipoCicloDAO;
import br.com.vemtambem.dao.UsuarioDAO;
import br.com.vemtambem.dao.UsuarioTokenDAO;
import br.com.vemtambem.model.Ciclo;
import br.com.vemtambem.model.TipoChavePix;
import br.com.vemtambem.model.TipoCiclo;
import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.model.UsuarioToken;
import br.com.vemtambem.utils.EmailSender;
import br.com.vemtambem.utils.SenhaUtils;

@Service
public class UsuarioServiceImpl implements UsuarioService {

	@Autowired
	private UsuarioDAO usuarioDAO;

	@Autowired
	private CicloDAO cicloDAO;

	@Autowired
	private TipoCicloDAO tipoCicloDAO;

	@Autowired
	private UsuarioTokenDAO usuarioTokenDAO;

	@Override
	@Transactional
	public void salvar(Usuario pessoa) {
		this.usuarioDAO.salvar(pessoa);
	}

	@Override
	@Transactional
	public void salvarExterno(Usuario usuario) {

		usuario.setDataCadastro(LocalDateTime.now());
		usuario.setSenha(SenhaUtils.convertStringToMd5(usuario.getSenha()));
		usuario.setTipoChavePix(TipoChavePix.fromCodigo(usuario.getCodigoTipoChavePix()));

		if (usuario.getIndicador() == null || usuario.getIndicador().getId() == null) {
			usuario.setIndicador(Usuario.ID_USUARIO_ADMIN);
		} else {
			usuario.setIndicador(new Usuario(usuario.getIndicador().getId()));
		}

		this.usuarioDAO.salvar(usuario);

	}

	/**
	 * Adiciona o novo usuÃ¡rio a arvore e retorna a pessoa que ele foi inserido.
	 * 
	 * @param indicador
	 * @param novaPessoa
	 */
	public Usuario inserirIndicado(Usuario indicador, Usuario novaPessoa) {

		if (indicador == null || indicador.getId() == null || novaPessoa == null || novaPessoa.getId() == null) {
			return null;
		}
		if (indicador.getId().equals(novaPessoa.getId())) {
			return null;
		}

		Usuario usuario = null;
		Queue<Usuario> fila = new LinkedList<>();
		fila.add(indicador);

		while (!fila.isEmpty()) {
			Usuario pessoaAtual = fila.poll();

			if (pessoaAtual.getIndicadoEsquerda() == null) {
				pessoaAtual.setIndicadoEsquerda(novaPessoa);
				usuario = pessoaAtual;
				break;
			} else if (pessoaAtual.getIndicadoDireita() == null) {
				pessoaAtual.setIndicadoDireita(novaPessoa);
				usuario = pessoaAtual;
				break;
			}

			if (pessoaAtual.getIndicadoEsquerda() != null) {
				fila.add(pessoaAtual.getIndicadoEsquerda());
			}
			if (pessoaAtual.getIndicadoDireita() != null) {
				fila.add(pessoaAtual.getIndicadoDireita());
			}
		}
		return usuario;
	}
	@Override
	@Transactional
	public void atualizarDados(Usuario pessoa) {

		Usuario pessoaBD = pesquisarPorId(pessoa.getId());

		pessoa.setLogin(pessoaBD.getLogin());
		pessoa.setSenha(pessoaBD.getSenha());

		this.usuarioDAO.salvar(pessoa);

	}

	@Override
	@Transactional
	public List<Usuario> pesquisarTodas() {
		return usuarioDAO.pesquisarUsuarios();
	}

	@Override
	@Transactional
	public List<Usuario> pesquisarDesativadas() {
		return usuarioDAO.pesquisarDesativadas();
	}

	@Override
	@Transactional
	public Usuario reativar(Long idUsuario) {

		Usuario usuario = usuarioDAO.pesquisarPorId(idUsuario);

		Usuario usuarioNovo = new Usuario();
		usuarioNovo.setNome(usuario.getNome());
		usuarioNovo.setEmail(usuario.getEmail());
		usuarioNovo.setLogin(usuario.getLogin());
		usuarioNovo.setSenha(usuario.getSenha());
		usuarioNovo.setTipoConta(usuario.isTipoConta());
		usuarioNovo.setDocumento(usuario.getDocumento());
		usuarioNovo.setWhatsapp(usuario.getWhatsapp());
		usuarioNovo.setCelular(usuario.getCelular());
		usuarioNovo.setEndereco(usuario.getEndereco());
		usuarioNovo.setDataCadastro(LocalDateTime.now());
		usuarioNovo.setTipoChavePix(usuario.getTipoChavePix());
		usuarioNovo.setChavePix(usuario.getChavePix());
		usuarioNovo.setAtivo(false);
		usuarioNovo.setDoacaoFeita(false);
		usuarioNovo.setAdmin(false);
		usuarioNovo.setComprovanteAtivacao(null);
		usuarioNovo.setComprovanteDeposito(null);
		usuarioNovo.setIndicador(usuario.getIndicador());
		usuarioNovo.setIndicadoEsquerda(null);
		usuarioNovo.setIndicadoDireita(null);
		usuarioNovo.setQuantCiclos(usuario.getQuantCiclos());
		usuarioNovo.setQuantDoacoesRecebidas(0);
		usuarioNovo.setCicloAtivo(null);
		usuarioDAO.salvar(usuarioNovo);

		usuario.setLogin(null);
		usuario.setSenha(null);
		usuarioDAO.salvar(usuario);

		Ciclo ciclo = cicloDAO.pesquisarPorId(usuario.getCicloAtivo().getId());
		ciclo.setAtivo(false);
		cicloDAO.salvar(ciclo);

		return usuarioNovo;
	}

	@Override
	@Transactional
	public void ativar(Long idUsuario) {

		Usuario usuario = usuarioDAO.pesquisarPorId(idUsuario);
		if (usuario == null) {
			return;
		}

		usuario.setAtivo(true);
		usuario.setMotivoRecusaAtivacao(null);
		usuario.setQuantCiclos(usuario.getQuantCiclos() + 1);

		Usuario indicador = usuario.getIndicador();
		if (indicador == null || indicador.getId() == null) {
			indicador = usuarioDAO.pesquisarPorLogin("admin");
			if (indicador == null) {
				indicador = usuarioDAO.pesquisarPorLogin("vemtambem");
			}
			usuario.setIndicador(indicador);
		}

		Usuario indicadorDireto = null;
		if ("vemtambem".equalsIgnoreCase(usuario.getLogin())) {
			indicadorDireto = this.inserirIndicado(indicador, usuario);
			usuarioDAO.salvar(usuario);
		} else {
			Usuario baseArvore = indicador;
			if (indicador != null && indicador.getCicloAtivo() != null
					&& indicador.getCicloAtivo().getLogin() != null) {
				Ciclo cicloAtivoIndicador = cicloDAO.getCicloAtivoPorLogin(indicador.getCicloAtivo().getLogin());
				if (cicloAtivoIndicador != null && cicloAtivoIndicador.getUsuario() != null) {
					baseArvore = cicloAtivoIndicador.getUsuario();
				}
			}

			indicadorDireto = this.inserirIndicado(baseArvore, usuario);
			usuarioDAO.salvar(usuario);
		}

		if (indicadorDireto != null && indicadorDireto.getId() != null) {
			Ciclo cicloIndicador = cicloDAO.pesquisarCicloAtivoIdUsuario(indicadorDireto.getId());
			if (cicloIndicador != null) {
				if (cicloIndicador.getIndicadoEsquerda() == null)
					cicloIndicador.setIndicadoEsquerda(usuario);
				else if (cicloIndicador.getIndicadoDireita() == null)
					cicloIndicador.setIndicadoDireita(usuario);
				cicloDAO.salvar(cicloIndicador);
			}
		}

		Ciclo ciclo = new Ciclo();
		ciclo.setIndicador(usuario.getIndicador());
		ciclo.setAtivo(true);
		ciclo.setNome("CICLO " + usuario.getQuantCiclos());
		ciclo.setUsuario(usuario);
		ciclo.setIndicadoPrincipal(indicadorDireto != null ? indicadorDireto : indicador);
		ciclo.setLogin(usuario.getLogin());

		TipoCiclo tipoCiclo = tipoCicloDAO.pesquisarPorOrdem(1);
		if (tipoCiclo != null) {
			ciclo.setTipoCiclo(tipoCiclo);
		}

		cicloDAO.salvar(ciclo);

		usuario.setCicloAtivo(ciclo);
		usuarioDAO.salvar(usuario);
	}
	@Override
	@Transactional
	public void recusarAtivacao(Long idUsuario, String motivoRecusa) {
		Usuario usuario = usuarioDAO.pesquisarPorId(idUsuario);
		if (usuario == null) {
			return;
		}

		usuario.setAtivo(false);
		usuario.setMotivoRecusaAtivacao(motivoRecusa);
		usuario.setComprovanteAtivacao(null);
		usuario.setComprovanteDeposito(null);
		usuario.setDoacaoFeita(false);
		usuarioDAO.salvar(usuario);
	}

	@Override
	@Transactional
	public void ativarDoador(Long idUsuarioAtivacao) {
		Usuario usuarioAtivacao = usuarioDAO.pesquisarPorId(idUsuarioAtivacao);
		usuarioAtivacao.setDoacaoFeita(true);
	}

	@Override
	@Transactional
	public Usuario pesquisarPorId(Long idPessoa) {
		return usuarioDAO.pesquisarPorId(idPessoa);
	}

	@Override
	@Transactional
	public Usuario pesquisarPorLoginSenha(String login, String senha) {
		String senhaMD5 = SenhaUtils.convertStringToMd5(senha);
		return usuarioDAO.pesquisarPorLoginSenha(login, senhaMD5);
	}

	@Override
	@Transactional
	public Usuario pesquisarPorDocumento(String documento) {
		return usuarioDAO.pesquisarPorDocumento(documento);
	}

	@Override
	@Transactional
	public Usuario pesquisarPorLogin(String login) {
		return usuarioDAO.pesquisarPorLogin(login);
	}

	@Override
	@Transactional
	public Usuario pesquisarPorEmail(String email) {
		return usuarioDAO.pesquisarPorEmail(email);
	}

	@Override
	@Transactional
	public void alterarSenha(Long idPessoa, String senha) {
		Usuario pessoa = pesquisarPorId(idPessoa);
		pessoa.setSenha(SenhaUtils.convertStringToMd5(senha));
		this.usuarioDAO.salvar(pessoa);

	}

	@Override
	public List<Usuario> recuperarDoadores(Usuario usuario) {

		List<Usuario> doadores = new ArrayList<Usuario>();

		if (usuario.getIndicadoEsquerda() != null) {
			if (usuario.getIndicadoEsquerda().getIndicadoEsquerda() != null) {
				doadores.add(usuario.getIndicadoEsquerda().getIndicadoEsquerda());
			}
			if (usuario.getIndicadoEsquerda().getIndicadoDireita() != null) {
				doadores.add(usuario.getIndicadoEsquerda().getIndicadoDireita());
			}
		}

		if (usuario.getIndicadoDireita() != null) {
			if (usuario.getIndicadoDireita().getIndicadoEsquerda() != null) {
				doadores.add(usuario.getIndicadoDireita().getIndicadoEsquerda());
			}
			if (usuario.getIndicadoDireita().getIndicadoDireita() != null) {
				doadores.add(usuario.getIndicadoDireita().getIndicadoDireita());
			}
		}

		return doadores;
	}

	@Override
	public List<Usuario> recuperarRede(Usuario usuario) {

		List<Usuario> rede = new ArrayList<Usuario>();

		if (usuario.getIndicadoEsquerda() != null) {

			rede.add(usuario.getIndicadoEsquerda());

			if (usuario.getIndicadoEsquerda().getIndicadoEsquerda() != null) {
				rede.add(usuario.getIndicadoEsquerda().getIndicadoEsquerda());
			}
			if (usuario.getIndicadoEsquerda().getIndicadoDireita() != null) {
				rede.add(usuario.getIndicadoEsquerda().getIndicadoDireita());
			}
		}

		if (usuario.getIndicadoDireita() != null) {

			rede.add(usuario.getIndicadoDireita());

			if (usuario.getIndicadoDireita().getIndicadoEsquerda() != null) {
				rede.add(usuario.getIndicadoDireita().getIndicadoEsquerda());
			}
			if (usuario.getIndicadoDireita().getIndicadoDireita() != null) {
				rede.add(usuario.getIndicadoDireita().getIndicadoDireita());
			}
		}

		return rede;
	}

	/**
	 * Pesquisa de usuÃ¡rio
	 * 
	 * O objeto carrega o: id, quantDoacoesRecebidas e login
	 * 
	 */
	@Override
	public Usuario pesquisarUsuarioParaDoadores(Long idUsuario) {
		return this.usuarioDAO.pesquisarUsuarioParaDoadores(idUsuario);
	}

	@Override
	public Usuario pesquisarUsuarioParaDonatarios(Long idUsuario) {
		return this.usuarioDAO.pesquisarUsuarioParaDonatarios(idUsuario);
	}

	@Override
	public Usuario pesquisarUsuarioParaConvite(String login) {
		return this.usuarioDAO.pesquisarUsuarioParaConvite(login);
	}

	@Override
	public Usuario pesquisarUsuarioParaDownloadArquivo(Long id) {
		return this.usuarioDAO.pesquisarUsuarioParaDownloadArquivo(id);
	}

	@Override
	public void enviarCodigoRedefinicao(Usuario usuario) {
		
		String codigo = EmailSender.gerarCodigoNumerico(6);
        long validadeMinutos = 15;
        
		try {
			EmailSender.enviarCodigoRedefinicao(usuario.getEmail(), usuario.getNome(), codigo, validadeMinutos);
			
			UsuarioToken usuarioToken = new UsuarioToken();
			usuarioToken.setIdUsuario(usuario.getId());
			usuarioToken.setEmailUsuario(usuario.getEmail());

			LocalDateTime dataHoraAtual = LocalDateTime.now();
			usuarioToken.setDataHoraSolicitacao(dataHoraAtual);
			usuarioToken.setTokenTrocaSenha(codigo);
			usuarioToken.setTokenTrocaSenhaValidade(dataHoraAtual.plusMinutes(validadeMinutos));
			
			this.usuarioTokenDAO.salvar(usuarioToken);
			
		} catch (MessagingException e) {
            System.err.println("Erro ao enviar e-mail: " + e.getMessage());
			e.printStackTrace();
		}
		
	}

}

