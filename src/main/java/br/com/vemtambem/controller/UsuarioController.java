package br.com.vemtambem.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import br.com.vemtambem.model.Ciclo;
import br.com.vemtambem.model.Endereco;
import br.com.vemtambem.model.RedePosicaoPreview;
import br.com.vemtambem.model.TipoChavePix;
import br.com.vemtambem.model.TipoCiclo;
import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.service.CicloService;
import br.com.vemtambem.service.TipoCicloService;
import br.com.vemtambem.service.UsuarioService;
import br.com.vemtambem.utils.DocumentValidator;

@Controller
@RequestMapping("/usuario")
public class UsuarioController {

	@Autowired
	private UsuarioService usuarioService;

	@Autowired
	private CicloService cicloService;

	@Autowired
	private TipoCicloService tipoCicloService;

	private static final BigDecimal PERCENTUAL_TAXA_TI_PADRAO = new BigDecimal("0.095");
	private static final BigDecimal DEFAULT_VALOR_JORNADA = new BigDecimal("60.00");
	private static final String JORNADA_SEMENTE = "Jornada da Semente";
	private static final String JORNADA_JARDIM = "Jornada do Jardim";
	private static final String JORNADA_FLORESTA = "Jornada da Floresta";
	private static final String PIX_TI_CHAVE_FALLBACK = "85997151515";
	private static final String PIX_TI_TIPO_FALLBACK = "Telefone";

	public UsuarioController() {
	}

	/**
	 * Apresenta os dados do usuÃ¡rio logado na tela Meus Dados
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/dados-pessoais", method = RequestMethod.GET)
	public ModelAndView meusDados(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = null;
		if (idUsuario != null) {
			usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		}
		if (usuarioLogado == null) {
			Usuario usuarioSessao = (Usuario) request.getSession().getAttribute("usuarioLogado");
			if (usuarioSessao != null && usuarioSessao.getId() != null) {
				usuarioLogado = usuarioService.pesquisarPorId(usuarioSessao.getId());
				if (usuarioLogado == null) {
					usuarioLogado = usuarioSessao;
				}
			}
		}
		if (usuarioLogado == null) {
			usuarioLogado = new Usuario();
		}
		if (isPerfilVazio(usuarioLogado) && "vemtambem".equalsIgnoreCase(usuarioLogado.getLogin())) {
			Usuario usuarioAdmin = usuarioService.pesquisarPorLogin("admin");
			if (usuarioAdmin != null) {
				usuarioLogado = usuarioAdmin;
			}
		}
		if (usuarioLogado.getEndereco() == null) {
			usuarioLogado.setEndereco(new Endereco());
		}
		request.getSession().setAttribute("usuarioLogado", usuarioLogado);

		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuarioLogado);
		model.addObject("perfilIncompleto", isPerfilIncompleto(usuarioLogado));
		model.setViewName("pessoa-dados-pessoais");
		return model;
	}

	/**
	 * Apresenta os donatarios do usuÃ¡rio logado.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/donatarios", method = RequestMethod.GET)
	public ModelAndView getDonatarios(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		if (usuarioLogado == null) {
			usuarioLogado = usuarioService.pesquisarUsuarioParaDonatarios(idUsuario);
		}
		request.getSession().setAttribute("usuarioLogado", usuarioLogado);

		ModelAndView model = new ModelAndView();
		addDonatariosContext(model, usuarioLogado);
		model.setViewName("donatarios");
		return model;
	}

	private boolean isPerfilVazio(Usuario usuario) {
		if (usuario == null) {
			return true;
		}
		return isBlank(usuario.getNome())
				&& isBlank(usuario.getEmail())
				&& isBlank(usuario.getDocumento())
				&& isBlank(usuario.getCelular())
				&& isBlank(usuario.getWhatsapp())
				&& isBlank(usuario.getChavePix());
	}

	private boolean isPerfilIncompleto(Usuario usuario) {
		if (usuario == null) {
			return true;
		}
		if (isBlank(usuario.getNome()) || isBlank(usuario.getDocumento()) || isBlank(usuario.getEmail())) {
			return true;
		}
		Endereco endereco = usuario.getEndereco();
		return endereco == null
				|| isBlank(endereco.getLogradouro())
				|| isBlank(endereco.getBairro())
				|| isBlank(endereco.getMunicipio())
				|| isBlank(endereco.getEstado())
				|| isBlank(endereco.getCep());
	}

	private boolean isBlank(String valor) {
		return valor == null || valor.trim().isEmpty();
	}

	@RequestMapping(value = "/jornadas", method = RequestMethod.GET)
	public ModelAndView jornadas(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		if (idUsuario != null) {
			Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
			request.getSession().setAttribute("usuarioLogado", usuarioLogado);
		}

		List<TipoCiclo> tiposCiclo = tipoCicloService.listarAtivos();
		normalizarNomesTipoCiclo(tiposCiclo);
		TipoCiclo tipoCicloAtual = tiposCiclo.isEmpty() ? null : tiposCiclo.get(0);

		ModelAndView model = new ModelAndView();
		model.addObject("tiposCiclo", tiposCiclo);
		model.addObject("tipoCicloAtual", tipoCicloAtual);
		model.addObject("nomeJornadaAtual", obterNomeJornadaAtual(tipoCicloAtual));
		model.setViewName("jornadas");
		return model;
	}

	private void addDonatariosContext(ModelAndView model, Usuario usuarioLogado) {
		tipoCicloService.garantirJornadasPadraoEVinculoCiclos();
		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());
		List<TipoCiclo> tiposCiclo = tipoCicloService.listarAtivos();
		normalizarNomesCiclo(ciclos);
		normalizarNomesTipoCiclo(tiposCiclo);
		TipoCiclo tipoCicloAtual = tiposCiclo.isEmpty() ? null : tiposCiclo.get(0);
		BigDecimal valorJornada = calcularValorJornada(tipoCicloAtual);
		BigDecimal valorTaxaTi = calcularValorTaxaTI(tipoCicloAtual, valorJornada);
		BigDecimal valorContribuicaoTotal = calcularValorContribuicaoTotal(tipoCicloAtual);
		String percentualTaxaTi = formatarPercentualTaxaTi(valorTaxaTi, valorJornada);
		Usuario recebedorAtual = resolverRecebedorAtual(ciclos);
		Usuario contaTi = resolverContaTi();
		String pixTiTipo = contaTi != null && contaTi.getTipoChavePix() != null
				? contaTi.getTipoChavePix().getDescricao()
				: PIX_TI_TIPO_FALLBACK;
		String pixTiChave = contaTi != null && !isBlank(contaTi.getChavePix())
				? contaTi.getChavePix()
				: PIX_TI_CHAVE_FALLBACK;

		model.addObject("pessoa", usuarioLogado);
		model.addObject("ciclos", ciclos);
		model.addObject("tipoCicloAtual", tipoCicloAtual);
		model.addObject("tiposCiclo", tiposCiclo);
		model.addObject("nomeJornadaAtual", obterNomeJornadaAtual(tipoCicloAtual));
		model.addObject("valorJornada", valorJornada);
		model.addObject("valorJornadaFormatado", formatarValorMonetario(valorJornada));
		model.addObject("valorTaxaTi", valorTaxaTi);
		model.addObject("valorTaxaTiFormatado", formatarValorMonetario(valorTaxaTi));
		model.addObject("percentualTaxaTi", percentualTaxaTi);
		model.addObject("valorContribuicaoTotal", valorContribuicaoTotal);
		model.addObject("valorContribuicaoTotalFormatado", formatarValorMonetario(valorContribuicaoTotal));
		model.addObject("pixTiTipo", pixTiTipo);
		model.addObject("pixTiChave", pixTiChave);
		model.addObject("recebedorAtualNome", recebedorAtual != null ? recebedorAtual.getNome() : null);
		model.addObject("recebedorAtualTipoChavePix",
				recebedorAtual != null && recebedorAtual.getTipoChavePix() != null
						? recebedorAtual.getTipoChavePix().getDescricao()
						: null);
		model.addObject("recebedorAtualChavePix", recebedorAtual != null ? recebedorAtual.getChavePix() : null);
	}

	private Usuario resolverContaTi() {
		Usuario admin = usuarioService.pesquisarPorLogin("admin");
		if (admin != null) {
			return admin;
		}
		return usuarioService.pesquisarPorLogin("vemtambem");
	}

	private Usuario resolverRecebedorAtual(List<Ciclo> ciclos) {
		if (ciclos == null || ciclos.isEmpty()) {
			return null;
		}

		Ciclo cicloAtual = null;
		for (Ciclo ciclo : ciclos) {
			if (ciclo != null && ciclo.isAtivo()) {
				cicloAtual = ciclo;
				break;
			}
		}
		if (cicloAtual == null) {
			cicloAtual = ciclos.get(0);
		}

		return extrairRecebedor(cicloAtual);
	}

	private Usuario extrairRecebedor(Ciclo ciclo) {
		if (ciclo == null || ciclo.getIndicadoPrincipal() == null) {
			return null;
		}

		Usuario atual = ciclo.getIndicadoPrincipal();
		Usuario ultimoValido = atual;
		Set<Long> visitados = new HashSet<>();

		while (atual != null && atual.getId() != null && !visitados.contains(atual.getId())) {
			visitados.add(atual.getId());
			ultimoValido = atual;

			Ciclo cicloAtual = atual.getCicloAtivo();
			if (cicloAtual == null || cicloAtual.getIndicadoPrincipal() == null) {
				break;
			}
			atual = cicloAtual.getIndicadoPrincipal();
		}

		return ultimoValido;
	}

	@RequestMapping(value = "/doadores", method = RequestMethod.GET)
	public ModelAndView getDoadores(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuario = usuarioService.pesquisarUsuarioParaDoadores(idUsuario);
		if (usuario == null) {
			usuario = usuarioService.pesquisarPorId(idUsuario);
		}
		request.getSession().setAttribute("usuarioLogado", usuario);

		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuario.getLogin());
		
		boolean isCicloFinalizado = false;
		if (usuario.getQuantDoacoesRecebidas() >= 8)
			isCicloFinalizado = true;
				
		List<TipoCiclo> tiposCiclo = tipoCicloService.listarAtivos();
		normalizarNomesCiclo(ciclos);
		normalizarNomesTipoCiclo(tiposCiclo);
		TipoCiclo tipoCicloAtual = tiposCiclo.isEmpty() ? null : tiposCiclo.get(0);

		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuario);
		model.addObject("isCicloFinalizado", isCicloFinalizado);
		model.addObject("ciclos", ciclos);
		model.addObject("tipoCicloAtual", tipoCicloAtual);
		model.addObject("nomeJornadaAtual", obterNomeJornadaAtual(tipoCicloAtual));

		model.setViewName("doadores");
		return model;
	}

	@RequestMapping(value = "/minha-rede", method = RequestMethod.GET)
	public ModelAndView minhaRede(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		request.getSession().setAttribute("usuarioLogado", usuarioLogado);

		tipoCicloService.garantirJornadasPadraoEVinculoCiclos();
		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());
		boolean usuarioPendenteAtivacao = usuarioLogado != null && !usuarioLogado.isAtivo();
		RedePosicaoPreview posicaoRedePreview = null;
		if (usuarioPendenteAtivacao && usuarioLogado.getId() != null) {
			posicaoRedePreview = cicloService.pesquisarPosicaoUsuarioNaRede(usuarioLogado.getId());
			if (posicaoRedePreview != null && (ciclos == null || ciclos.isEmpty())) {
				ciclos = new ArrayList<>();
				Ciclo cicloPreview = new Ciclo();
				cicloPreview.setNome(posicaoRedePreview.getNomeCiclo());
				cicloPreview.setAtivo(posicaoRedePreview.isCicloAtivo());
				ciclos.add(cicloPreview);
			}
		}

		List<TipoCiclo> tiposCiclo = tipoCicloService.listarAtivos();
		normalizarNomesCiclo(ciclos);
		normalizarNomesTipoCiclo(tiposCiclo);
		if (posicaoRedePreview != null) {
			posicaoRedePreview.setNomeCiclo(mapearNomeJornada(posicaoRedePreview.getNomeCiclo()));
		}
		if (usuarioPendenteAtivacao) {
			mascararDadosRedeTerceiros(ciclos, usuarioLogado.getId());
		}
		TipoCiclo tipoCicloAtual = tiposCiclo.isEmpty() ? null : tiposCiclo.get(0);

		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuarioLogado);
		model.addObject("ciclos", ciclos);
		model.addObject("tipoCicloAtual", tipoCicloAtual);
		model.addObject("nomeJornadaAtual", obterNomeJornadaAtual(tipoCicloAtual));
		model.addObject("ocultarDadosRede", usuarioPendenteAtivacao);
		model.addObject("posicaoRedePreview", posicaoRedePreview);

		model.setViewName("minha-rede");
		return model;
	}

	private void mascararDadosRedeTerceiros(List<Ciclo> ciclos, Long idUsuarioLogado) {
		if (ciclos == null || ciclos.isEmpty()) {
			return;
		}
		for (Ciclo ciclo : ciclos) {
			if (ciclo == null) {
				continue;
			}
			mascararUsuarioRede(ciclo.getIndicadoEsquerda(), idUsuarioLogado, new HashSet<Long>());
			mascararUsuarioRede(ciclo.getIndicadoDireita(), idUsuarioLogado, new HashSet<Long>());
		}
	}

	private void mascararUsuarioRede(Usuario usuario, Long idUsuarioLogado, Set<Long> visitados) {
		if (usuario == null) {
			return;
		}
		if (usuario.getId() != null && !visitados.add(usuario.getId())) {
			return;
		}

		if (idUsuarioLogado == null || !idUsuarioLogado.equals(usuario.getId())) {
			String nomeOriginal = usuario.getNome();
			usuario.setNome(isBlank(nomeOriginal) ? "Participante" : usuario.getNomeCurto());
			usuario.setWhatsapp("Oculto");
			usuario.setCelular("Oculto");
			usuario.setDocumento("Oculto");
			usuario.setChavePix(null);
		}

		mascararUsuarioRede(usuario.getIndicadoEsquerda(), idUsuarioLogado, visitados);
		mascararUsuarioRede(usuario.getIndicadoDireita(), idUsuarioLogado, visitados);
	}

	private void normalizarNomesCiclo(List<Ciclo> ciclos) {
		if (ciclos == null || ciclos.isEmpty()) {
			return;
		}

		for (Ciclo ciclo : ciclos) {
			if (ciclo == null) {
				continue;
			}
			ciclo.setNome(mapearNomeJornada(ciclo.getNome()));
		}
	}

	private void normalizarNomesTipoCiclo(List<TipoCiclo> tiposCiclo) {
		if (tiposCiclo == null || tiposCiclo.isEmpty()) {
			return;
		}

		for (TipoCiclo tipoCiclo : tiposCiclo) {
			if (tipoCiclo == null) {
				continue;
			}
			tipoCiclo.setNome(mapearNomeJornada(tipoCiclo.getNome()));
		}
	}

	private String obterNomeJornadaAtual(TipoCiclo tipoCicloAtual) {
		if (tipoCicloAtual == null) {
			return JORNADA_SEMENTE;
		}
		return mapearNomeJornada(tipoCicloAtual.getNome());
	}

	private String mapearNomeJornada(String nomeOriginal) {
		if (nomeOriginal == null || nomeOriginal.trim().isEmpty()) {
			return JORNADA_SEMENTE;
		}

		String nome = nomeOriginal.trim();
		String nomeLower = nome.toLowerCase(Locale.ROOT);
		if ("tabuleiro 1".equals(nomeLower)) {
			return JORNADA_SEMENTE;
		}
		if ("tabuleiro 2".equals(nomeLower)) {
			return JORNADA_JARDIM;
		}
		if ("tabuleiro 3".equals(nomeLower)) {
			return JORNADA_FLORESTA;
		}
		if ("jornada da semente".equals(nomeLower)) {
			return JORNADA_SEMENTE;
		}
		if ("jornada do jardim".equals(nomeLower)) {
			return JORNADA_JARDIM;
		}
		if ("jornada da floresta".equals(nomeLower)) {
			return JORNADA_FLORESTA;
		}
		return nome;
	}

	private BigDecimal calcularValorJornada(TipoCiclo tipoCicloAtual) {
		if (tipoCicloAtual == null) {
			return DEFAULT_VALOR_JORNADA.setScale(2, RoundingMode.HALF_UP);
		}

		if (tipoCicloAtual.getValorDoacao() != null) {
			return tipoCicloAtual.getValorDoacao().setScale(2, RoundingMode.HALF_UP);
		}

		return DEFAULT_VALOR_JORNADA.setScale(2, RoundingMode.HALF_UP);
	}

	private BigDecimal calcularValorTaxaTI(TipoCiclo tipoCicloAtual, BigDecimal valorJornada) {
		if (tipoCicloAtual != null && tipoCicloAtual.getValorTI() != null) {
			return tipoCicloAtual.getValorTI().setScale(2, RoundingMode.HALF_UP);
		}
		BigDecimal valorBase = valorJornada == null ? DEFAULT_VALOR_JORNADA : valorJornada;
		return valorBase.multiply(PERCENTUAL_TAXA_TI_PADRAO).setScale(2, RoundingMode.HALF_UP);
	}

	private BigDecimal calcularValorContribuicaoTotal(TipoCiclo tipoCicloAtual) {
		BigDecimal valorJornada = calcularValorJornada(tipoCicloAtual);
		BigDecimal valorTaxaTi = calcularValorTaxaTI(tipoCicloAtual, valorJornada);
		return valorJornada.add(valorTaxaTi).setScale(2, RoundingMode.HALF_UP);
	}

	private String formatarPercentualTaxaTi(BigDecimal valorTaxaTi, BigDecimal valorJornada) {
		if (valorTaxaTi == null || valorJornada == null || valorJornada.compareTo(BigDecimal.ZERO) <= 0) {
			return "0";
		}

		BigDecimal percentual = valorTaxaTi
				.multiply(new BigDecimal("100"))
				.divide(valorJornada, 2, RoundingMode.HALF_UP);

		DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("pt", "BR"));
		symbols.setDecimalSeparator(',');
		symbols.setGroupingSeparator('.');
		DecimalFormat formatter = new DecimalFormat("#,##0.##", symbols);
		formatter.setRoundingMode(RoundingMode.HALF_UP);
		return formatter.format(percentual);
	}

	private String formatarValorMonetario(BigDecimal valor) {
		BigDecimal valorSeguro = valor == null ? BigDecimal.ZERO : valor;
		DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("pt", "BR"));
		symbols.setDecimalSeparator(',');
		symbols.setGroupingSeparator('.');
		DecimalFormat formatter = new DecimalFormat("#,##0.00", symbols);
		formatter.setRoundingMode(RoundingMode.HALF_UP);
		return formatter.format(valorSeguro);
	}

	@RequestMapping(value = "/listar")
	public ModelAndView listar(ModelAndView model) throws IOException {
		List<Usuario> listPessoa = usuarioService.pesquisarTodas();
		model.addObject("listPessoa", listPessoa);
		model.setViewName("pessoa-lista");
		return model;
	}

	@RequestMapping(value = "/novo", method = RequestMethod.GET)
	public ModelAndView novo(ModelAndView model) {
		Usuario pessoa = new Usuario();
		model.addObject("pessoa", pessoa);
		model.setViewName("pessoa-formulario");
		return model;
	}

	public boolean isCpfCadastrado(Usuario pessoa) {

		Usuario pessoaBD = usuarioService.pesquisarPorDocumento(pessoa.getDocumento());

		if (pessoaBD != null) {
			if (pessoa.getId() != null) {
				if (pessoaBD.getDocumento().equals(pessoa.getDocumento())) {
					if (pessoaBD.getId() == pessoa.getId())
						return false;
					else
						return true;
				}
			}

			return true;
		} else {
			return false;
		}

	}

	public boolean isEmailCadastrado(Usuario pessoa) {

		Usuario pessoaBD = usuarioService.pesquisarPorEmail(pessoa.getEmail());

		if (pessoaBD != null) {
			if (pessoa.getId() != null) {
				if (pessoaBD.getEmail().equals(pessoa.getEmail())) {
					if (pessoaBD.getId() == pessoa.getId())
						return false;
					else
						return true;
				}
			}

			return true;
		} else {
			return false;
		}

	}

	public boolean isLoginCadastrado(Usuario pessoa) {

		Usuario pessoaBD = usuarioService.pesquisarPorLogin(pessoa.getLogin());

		if (pessoaBD != null) {
			if (pessoa.getId() != null) {
				if (pessoaBD.getLogin().equals(pessoa.getLogin())) {
					if (pessoaBD.getId() == pessoa.getId())
						return false;
					else
						return true;
				}
			}

			return true;
		} else {
			return false;
		}

	}

	/**
	 * Ativar usuÃ¡rio depois da doaÃ§Ã£o.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/ativar-doador", method = RequestMethod.GET)
	public ModelAndView ativarDoador(HttpServletRequest request) {

		// id do doador para ativar
		Long idUsuarioAtivacao = Long.parseLong(request.getParameter("id"));
		Usuario usuarioAtivacao = usuarioService.pesquisarPorId(idUsuarioAtivacao);
		
		Long idUsuarioLogado = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuarioLogado);
		
		if (!usuarioAtivacao.isDoacaoFeita()) {
			usuarioAtivacao.setDoacaoFeita(true);
			usuarioService.salvar(usuarioAtivacao);
			
			usuarioLogado.setQuantDoacoesRecebidas(usuarioLogado.getQuantDoacoesRecebidas() + 1);
			usuarioService.salvar(usuarioLogado);
		}

		List<Usuario> doadores = usuarioService.recuperarDoadores(usuarioLogado);

		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());

		ModelAndView model = new ModelAndView();
		model.addObject("sucesso", true);
		model.addObject("doadores", doadores);
		model.addObject("ciclos", ciclos);
		model.addObject("pessoa", usuarioLogado);

		model.setViewName("doadores");
		return model;
	}

	@RequestMapping(value = "/convite", method = RequestMethod.GET)
	public ModelAndView convite(HttpServletRequest request) {
		String login = request.getParameter("id");
		tipoCicloService.garantirJornadasPadraoEVinculoCiclos();
		List<TipoCiclo> tiposCiclo = tipoCicloService.listarTodosOrdenados();
		normalizarNomesTipoCiclo(tiposCiclo);
		TipoCiclo jornadaAtiva = null;
		for (TipoCiclo tipoCiclo : tiposCiclo) {
			if (tipoCiclo != null && tipoCiclo.isAtivo()) {
				jornadaAtiva = tipoCiclo;
				break;
			}
		}
		if (jornadaAtiva == null && !tiposCiclo.isEmpty()) {
			jornadaAtiva = tiposCiclo.get(0);
		}

		ModelAndView model = new ModelAndView("recrutador");
		model.addObject("login", login);
		model.addObject("tiposCiclo", tiposCiclo);
		model.addObject("jornadaAtiva", jornadaAtiva);
		return model;
	}
	
	@RequestMapping(value = "/cadastrar", method = RequestMethod.GET)
	public ModelAndView cadastrar(HttpServletRequest request) {
		String login = request.getParameter("login");
		Usuario indicador = usuarioService.pesquisarUsuarioParaConvite(login);

		List<TipoChavePix> tipoChavesPix = Arrays.asList(TipoChavePix.values());

		ModelAndView model = new ModelAndView("cadastro-form");
		model.addObject("indicador", indicador);
		model.addObject("tipoChavesPix", tipoChavesPix);

		return model;
	}

	@RequestMapping(value = { "/salvar", "/dados-pessoais/salvar" }, method = RequestMethod.POST)
	public ModelAndView salvar(@ModelAttribute Usuario pessoa, HttpSession session)
			throws GeneralSecurityException, IOException {

		Usuario usuario = usuarioService.pesquisarPorId(pessoa.getId());
		if (usuario == null) {
			ModelAndView model = new ModelAndView();
			model.addObject("sucesso", Boolean.FALSE);
			model.addObject("pessoa", pessoa);
			model.addObject("perfilIncompleto", Boolean.TRUE);
			model.setViewName("pessoa-dados-pessoais");
			return model;
		}

		usuario.setWhatsapp(pessoa.getWhatsapp());
		usuario.setCelular(pessoa.getCelular());
		usuario.setChavePix(pessoa.getChavePix());
		usuarioService.salvar(usuario);

		session.setAttribute("usuarioLogado", usuario);
		session.setAttribute("idUsuarioLogado", usuario.getId());

		ModelAndView model = new ModelAndView();
		model.addObject("sucesso", Boolean.TRUE);
		model.addObject("pessoa", usuario);
		model.addObject("perfilIncompleto", isPerfilIncompleto(usuario));
		model.setViewName("pessoa-dados-pessoais");

		return model;
	}

	@RequestMapping(value = "/salvar-externo", method = RequestMethod.POST)
	public ModelAndView salvarExterno(@ModelAttribute Usuario usuario, HttpSession session)
			throws GeneralSecurityException, IOException {

		ModelAndView model = new ModelAndView();

		List<String> erros = new ArrayList<String>();
		boolean erro = false;

		if (isCpfCadastrado(usuario)) {
			erro = true;
			erros.add("JÃ¡ existe um pessoa cadastrado para o CPF informado.");
		}
		if (isLoginCadastrado(usuario)) {
			erro = true;
			erros.add("JÃ¡ existe um pessoa cadastrado para o login informado.");
		}
		if (isEmailCadastrado(usuario)) {
			erro = true;
			erros.add("JÃ¡ existe um pessoa cadastrado para o e-mail informado.");
		}
		if (!DocumentValidator.validarDocumento(usuario.getDocumento())) {
			erro = true;
			erros.add(usuario.isTipoConta() ? "CPF informado estÃ¡ invÃ¡lido." : "CNPJ informado estÃ¡ invÃ¡lido.");
		}

		if (erro) {
			Usuario indicador = usuarioService.pesquisarPorId(usuario.getIndicador().getId());

			model.addObject("pessoa", usuario);
			model.addObject("erro", erro);
			model.addObject("erros", erros);
			model.addObject("indicador", indicador);

			List<TipoChavePix> tipoChavesPix = Arrays.asList(TipoChavePix.values());
			model.addObject("tipoChavesPix", tipoChavesPix);

			model.setViewName("cadastro-form");
		} else {
			usuarioService.salvarExterno(usuario);

			session.setAttribute("usuarioLogado", usuario);
			session.setAttribute("idUsuarioLogado", usuario.getId());

			model.addObject("sucesso", Boolean.TRUE);
			model.setViewName("onboarding");
		}

		return model;
	}

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ModelAndView uploadFile(HttpServletRequest request, @RequestParam("file") MultipartFile file) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		ModelAndView model = new ModelAndView("donatarios");
		addDonatariosContext(model, usuarioLogado);

		if (!file.isEmpty()) {
			try {
				Path uploadDir = getUploadDirAtivacao(request);
				Files.createDirectories(uploadDir);
				String fileExtension = FilenameUtils.getExtension(file.getOriginalFilename());

				String novoNomeArquivo = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "." + fileExtension;

				Path filePath = uploadDir.resolve(novoNomeArquivo);

				Files.write(filePath, file.getBytes());

				usuarioLogado.setComprovanteAtivacao(novoNomeArquivo);
				usuarioLogado.setMotivoRecusaAtivacao(null);
				usuarioService.salvar(usuarioLogado);

				usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
				request.getSession().setAttribute("usuarioLogado", usuarioLogado);
				addDonatariosContext(model, usuarioLogado);
				model.addObject("sucessoUpload", true);
				model.addObject("sucessoUploadEntrada", true);
				return model;
			} catch (IOException e) {
				e.printStackTrace();
				model.addObject("sucessoUpload", false);
				return model;
			}
		} else {
			model.addObject("sucessoUpload", false);
			return model;
		}

	}

	@RequestMapping(value = "/upload-comprovantes-entrada", method = RequestMethod.POST)
	public ModelAndView uploadComprovantesEntrada(HttpServletRequest request,
			@RequestParam("fileTi") MultipartFile fileTi,
			@RequestParam("fileJornada") MultipartFile fileJornada) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		ModelAndView model = new ModelAndView("donatarios");
		addDonatariosContext(model, usuarioLogado);

		if (fileTi == null || fileTi.isEmpty() || fileJornada == null || fileJornada.isEmpty()) {
			model.addObject("sucessoUpload", false);
			return model;
		}

		try {
			Path uploadDirAtivacao = getUploadDirAtivacao(request);
			Path uploadDirDoacao = getUploadDirDoacao(request);
			Files.createDirectories(uploadDirAtivacao);
			Files.createDirectories(uploadDirDoacao);

			String extensionTi = FilenameUtils.getExtension(fileTi.getOriginalFilename());
			String extensionJornada = FilenameUtils.getExtension(fileJornada.getOriginalFilename());

			String nomeArquivoTi = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "_ti." + extensionTi;
			String nomeArquivoJornada = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "_doacao_entrada."
					+ extensionJornada;

			Path filePathTi = uploadDirAtivacao.resolve(nomeArquivoTi);
			Path filePathJornada = uploadDirDoacao.resolve(nomeArquivoJornada);

			Files.write(filePathTi, fileTi.getBytes());
			Files.write(filePathJornada, fileJornada.getBytes());

			usuarioLogado.setComprovanteAtivacao(nomeArquivoTi);
			usuarioLogado.setComprovanteDeposito(nomeArquivoJornada);
			usuarioLogado.setMotivoRecusaAtivacao(null);
			usuarioService.salvar(usuarioLogado);

			usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
			request.getSession().setAttribute("usuarioLogado", usuarioLogado);
			addDonatariosContext(model, usuarioLogado);
			model.addObject("sucessoUpload", true);
			model.addObject("sucessoUploadEntrada", true);
			return model;
		} catch (IOException e) {
			e.printStackTrace();
			model.addObject("sucessoUpload", false);
			return model;
		}
	}

	@RequestMapping(value = "/upload-comprovante-doacao", method = RequestMethod.POST)
	public ModelAndView uploadComprovanteDoacao(HttpServletRequest request, @RequestParam("file") MultipartFile file) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		ModelAndView model = new ModelAndView("donatarios");
		addDonatariosContext(model, usuarioLogado);

		if (!file.isEmpty()) {
			try {
				Path uploadDir = getUploadDirDoacao(request);
				Files.createDirectories(uploadDir);
				String fileExtension = FilenameUtils.getExtension(file.getOriginalFilename());

				String novoNomeArquivo = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "_doacao" + "."
						+ fileExtension;

				Path filePath = uploadDir.resolve(novoNomeArquivo);

				Files.write(filePath, file.getBytes());

				usuarioLogado.setComprovanteDeposito(novoNomeArquivo);
				usuarioLogado.setMotivoRecusaAtivacao(null);
				usuarioService.salvar(usuarioLogado);

				usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
				request.getSession().setAttribute("usuarioLogado", usuarioLogado);
				addDonatariosContext(model, usuarioLogado);
				model.addObject("sucessoUpload", true);
				return model;
			} catch (IOException e) {
				e.printStackTrace();
				model.addObject("sucessoUpload", false);
				return model;
			}
		} else {
			model.addObject("sucessoUpload", false);
			return model;
		}

	}

	@RequestMapping("/comprovante/download/{id}")
	public void downloadArquivo(@PathVariable Long id, HttpServletResponse response, HttpServletRequest request)
			throws IOException {

		Usuario pessoa = this.usuarioService.pesquisarUsuarioParaDownloadArquivo(id);
		if (pessoa == null) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		downloadComprovante(response, request, pessoa.getComprovanteAtivacao(), false);
	}

	@RequestMapping("/comprovante/download-comprovante-doacao/{id}")
	public void downloadArquivoDoacao(@PathVariable Long id, HttpServletResponse response, HttpServletRequest request)
			throws IOException {

		Usuario pessoa = this.usuarioService.pesquisarUsuarioParaDownloadArquivo(id);
		if (pessoa == null) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		downloadComprovante(response, request, pessoa.getComprovanteDeposito(), true);
	}

	private void downloadComprovante(HttpServletResponse response, HttpServletRequest request, String nomeArquivo,
			boolean comprovanteDoacao) throws IOException {
		if (isBlank(nomeArquivo)) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		Path arquivo = encontrarComprovante(request, nomeArquivo, comprovanteDoacao);
		if (arquivo == null || !Files.exists(arquivo)) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String contentType = Files.probeContentType(arquivo);
		if (isBlank(contentType)) {
			contentType = "application/octet-stream";
		}
		response.setContentType(contentType);
		response.setHeader("Content-Disposition", "inline; filename=\"" + arquivo.getFileName().toString() + "\"");

		try (OutputStream os = response.getOutputStream()) {
			Files.copy(arquivo, os);
			os.flush();
		}
	}

	private Path encontrarComprovante(HttpServletRequest request, String nomeArquivo, boolean comprovanteDoacao) {
		Path principal = (comprovanteDoacao ? getUploadDirDoacao(request) : getUploadDirAtivacao(request))
				.resolve(nomeArquivo);
		if (Files.exists(principal)) {
			return principal;
		}

		String caminhoLegado = request.getSession().getServletContext()
				.getRealPath(comprovanteDoacao ? "/resources/arquivos/doacao" : "/resources/arquivos");
		if (!isBlank(caminhoLegado)) {
			Path legado = Paths.get(caminhoLegado).resolve(nomeArquivo);
			if (Files.exists(legado)) {
				return legado;
			}
		}

		return principal;
	}

	private Path getUploadDirAtivacao(HttpServletRequest request) {
		return getUploadRootDir(request);
	}

	private Path getUploadDirDoacao(HttpServletRequest request) {
		return getUploadRootDir(request).resolve("doacao");
	}

	private Path getUploadRootDir(HttpServletRequest request) {
		String configured = System.getenv("VT_UPLOAD_DIR");
		if (!isBlank(configured)) {
			return Paths.get(configured.trim());
		}

		String realPath = request.getSession().getServletContext().getRealPath("/resources/arquivos");
		if (!isBlank(realPath)) {
			return Paths.get(realPath);
		}

		return Paths.get(System.getProperty("user.home"), "vemtambem-uploads");
	}
	@RequestMapping(value = "/reativar", method = RequestMethod.POST)
	public ModelAndView reativar(@ModelAttribute Usuario pessoa, HttpSession session)
			throws GeneralSecurityException, IOException {

		Usuario usuarioLogado = usuarioService.reativar(pessoa.getId());

		ModelAndView model = new ModelAndView();

		// usuÃ¡rio logado
		session.setAttribute("usuarioLogado", usuarioLogado);
		session.setAttribute("idUsuarioLogado", usuarioLogado.getId());

		model.addObject("sucesso", Boolean.TRUE);
		model.setViewName("painel");
		return model;

	}

}

