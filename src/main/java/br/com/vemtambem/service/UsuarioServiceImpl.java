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
import br.com.vemtambem.dao.UsuarioDAO;
import br.com.vemtambem.dao.UsuarioTokenDAO;
import br.com.vemtambem.model.Ciclo;
import br.com.vemtambem.model.TipoChavePix;
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
	 * Adiciona o novo usuário a arvore e retorna a pessoa que ele foi inserido.
	 * 
	 * @param indicador
	 * @param novaPessoa
	 */
	public Usuario inserirIndicado(Usuario indicador, Usuario novaPessoa) {

		Usuario usuario = new Usuario();

		if (indicador.getId() != novaPessoa.getId()) {
			Queue<Usuario> fila = new LinkedList<>();
			fila.add(indicador);

			while (!fila.isEmpty()) {
				Usuario pessoaAtual = fila.poll();

				if (pessoaAtual.getIndicadoEsquerda() == null) {
					// A posição da esquerda está vazia, insira a nova pessoa aqui.
					pessoaAtual.setIndicadoEsquerda(novaPessoa);
					usuario = pessoaAtual;
					break; // Importante: encerrar a busca assim que encontrar a posição vazia.

				} else if (pessoaAtual.getIndicadoDireita() == null) {
					// A posição da direita está vazia, insira a nova pessoa aqui.
					pessoaAtual.setIndicadoDireita(novaPessoa);
					usuario = pessoaAtual;
					break; // Importante: encerrar a busca assim que encontrar a posição vazia.

				}

				// Adicionar os indicados à fila para continuar a busca.
				if (pessoaAtual.getIndicadoEsquerda() != null) {
					fila.add(pessoaAtual.getIndicadoEsquerda());
				}
				if (pessoaAtual.getIndicadoDireita() != null) {
					fila.add(pessoaAtual.getIndicadoDireita());
				}
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

		// usuário que está sendo ativado
		Usuario usuario = usuarioDAO.pesquisarPorId(idUsuario);
		usuario.setAtivo(true);
		usuario.setQuantCiclos(usuario.getQuantCiclos() + 1);

		Usuario indicadorDireto = null;
		if (usuario.getLogin().equals("vemtambem")) {

			// inserir o novo usuário à árvore do indicador
			indicadorDireto = this.inserirIndicado(usuario.getIndicador(), usuario);
			usuarioDAO.salvar(usuario);
		} else {
			// pegar o ciclo ativo do usuário indicador, para passar o id atualizado
			Ciclo cicloAtivoIndicador = cicloDAO
					.getCicloAtivoPorLogin(usuario.getIndicador().getCicloAtivo().getLogin());

			// inserir o novo usuário à árvore do indicador
			indicadorDireto = this.inserirIndicado(cicloAtivoIndicador.getUsuario(), usuario);
			usuarioDAO.salvar(usuario);
		}

		// atualizar o ciclo do indicador colocando o novo usuário
		Ciclo cicloIndicador = cicloDAO.pesquisarCicloAtivoIdUsuario(indicadorDireto.getId());
		if (cicloIndicador != null) {
			if (cicloIndicador.getIndicadoEsquerda() == null)
				cicloIndicador.setIndicadoEsquerda(usuario);
			else if (cicloIndicador.getIndicadoDireita() == null)
				cicloIndicador.setIndicadoDireita(usuario);
			cicloDAO.salvar(cicloIndicador);
		}

		// Criar o ciclo do novo usuário
		Ciclo ciclo = new Ciclo();
		ciclo.setIndicador(usuario.getIndicador());
		ciclo.setAtivo(true);
		ciclo.setNome("CICLO " + usuario.getQuantCiclos());
		ciclo.setUsuario(usuario);
		ciclo.setIndicadoPrincipal(indicadorDireto);
		ciclo.setLogin(usuario.getLogin());
		cicloDAO.salvar(ciclo);

		usuario.setCicloAtivo(ciclo);
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
	 * Pesquisa de usuário
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