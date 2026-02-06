package br.com.vemtambem.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
import br.com.vemtambem.model.TipoChavePix;
import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.service.CicloService;
import br.com.vemtambem.service.UsuarioService;
import br.com.vemtambem.utils.DocumentValidator;

@Controller
@RequestMapping("/usuario")
public class UsuarioController {

	@Autowired
	private UsuarioService usuarioService;

	@Autowired
	private CicloService cicloService;

	public UsuarioController() {
	}

	/**
	 * Apresenta os dados do usuário logado na tela Meus Dados
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/dados-pessoais", method = RequestMethod.GET)
	public ModelAndView meusDados(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuarioLogado);
		model.setViewName("pessoa-dados-pessoais");
		return model;
	}

	/**
	 * Apresenta os donatarios do usuário logado.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/donatarios", method = RequestMethod.GET)
	public ModelAndView getDonatarios(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarUsuarioParaDonatarios(idUsuario);

		//List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuariosDonatarios(usuarioLogado.getLogin());
		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());
		
		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuarioLogado);
		model.addObject("ciclos", ciclos);
		model.setViewName("donatarios");
		return model;
	}

	@RequestMapping(value = "/doadores", method = RequestMethod.GET)
	public ModelAndView getDoadores(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuario = usuarioService.pesquisarUsuarioParaDoadores(idUsuario);

		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuario.getLogin());
		
		boolean isCicloFinalizado = false;
		if (usuario.getQuantDoacoesRecebidas() >= 8)
			isCicloFinalizado = true;
				
		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuario);
		model.addObject("isCicloFinalizado", isCicloFinalizado);
		model.addObject("ciclos", ciclos);

		model.setViewName("doadores");
		return model;
	}

	@RequestMapping(value = "/minha-rede", method = RequestMethod.GET)
	public ModelAndView minhaRede(HttpServletRequest request) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());

		ModelAndView model = new ModelAndView();
		model.addObject("pessoa", usuarioLogado);
		model.addObject("ciclos", ciclos);

		model.setViewName("minha-rede");
		return model;
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
	 * Ativar usuário depois da doação.
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

		ModelAndView model = new ModelAndView("recrutador");
		model.addObject("login", login);
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

	@RequestMapping(value = "/salvar", method = RequestMethod.POST)
	public ModelAndView salvar(@ModelAttribute Usuario pessoa, HttpSession session)
			throws GeneralSecurityException, IOException {

		Usuario usuario = usuarioService.pesquisarPorId(pessoa.getId());
		usuario.setWhatsapp(pessoa.getWhatsapp());
		usuario.setCelular(pessoa.getCelular());
		usuario.setChavePix(pessoa.getChavePix());
		usuarioService.salvar(usuario);

		session.setAttribute("usuarioLogado", usuario);
		session.setAttribute("idUsuarioLogado", usuario.getId());

		ModelAndView model = new ModelAndView();
		model.addObject("sucesso", Boolean.TRUE);
		model.addObject("pessoa", usuario);
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
			erros.add("Já existe um pessoa cadastrado para o CPF informado.");
		}
		if (isLoginCadastrado(usuario)) {
			erro = true;
			erros.add("Já existe um pessoa cadastrado para o login informado.");
		}
		if (isEmailCadastrado(usuario)) {
			erro = true;
			erros.add("Já existe um pessoa cadastrado para o e-mail informado.");
		}
		if (!DocumentValidator.validarDocumento(usuario.getDocumento())) {
			erro = true;
			erros.add(usuario.isTipoConta() ? "CPF informado está inválido." : "CNPJ informado está inválido.");
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
			model.setViewName("painel");
		}

		return model;
	}

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ModelAndView uploadFile(HttpServletRequest request, @RequestParam("file") MultipartFile file) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		ModelAndView model = new ModelAndView("painel");

		if (!file.isEmpty()) {
			try {
				String uploadDir = request.getSession().getServletContext().getRealPath("/resources/arquivos");

				String originalFileName = file.getOriginalFilename();

				String fileExtension = FilenameUtils.getExtension(originalFileName);

				String novoNomeArquivo = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "." + fileExtension;

				Path filePath = Paths.get(uploadDir, novoNomeArquivo);

				Files.write(filePath, file.getBytes());

				usuarioLogado.setComprovanteAtivacao(novoNomeArquivo);
				usuarioService.salvar(usuarioLogado);

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

	@RequestMapping(value = "/upload-comprovante-doacao", method = RequestMethod.POST)
	public ModelAndView uploadComprovanteDoacao(HttpServletRequest request, @RequestParam("file") MultipartFile file) {

		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);

		List<Ciclo> ciclos = cicloService.pesquisarCiclosUsuario(usuarioLogado.getLogin());

		ModelAndView model = new ModelAndView("donatarios");
		model.addObject("ciclos", ciclos);

		if (!file.isEmpty()) {
			try {
				String uploadDir = request.getSession().getServletContext().getRealPath("/resources/arquivos/doacao");

				String originalFileName = file.getOriginalFilename();

				String fileExtension = FilenameUtils.getExtension(originalFileName);

				String novoNomeArquivo = usuarioLogado.getLogin() + "_" + usuarioLogado.getId() + "_doacao" + "."
						+ fileExtension;

				Path filePath = Paths.get(uploadDir, novoNomeArquivo);

				Files.write(filePath, file.getBytes());

				usuarioLogado.setComprovanteDeposito(novoNomeArquivo);
				usuarioService.salvar(usuarioLogado);

				model.addObject("sucessoUpload", true);
				model.addObject("pessoa", usuarioLogado);
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

		String uploadDir = request.getSession().getServletContext().getRealPath("/resources/arquivos");

		File arquivo = new File(uploadDir, pessoa.getComprovanteAtivacao());

		if (arquivo.exists()) {
			// Configura os cabeçalhos da resposta
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment; filename=\"" + pessoa.getComprovanteAtivacao() + "\"");

			// Escreve os dados do arquivo no fluxo de saída da resposta
			try (OutputStream os = response.getOutputStream(); FileInputStream fis = new FileInputStream(arquivo)) {
				byte[] buffer = new byte[4096];
				int bytesRead;
				while ((bytesRead = fis.read(buffer)) != -1) {
					os.write(buffer, 0, bytesRead);
				}
			}
		} else {
			// Trate o caso em que o arquivo não existe
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@RequestMapping("/comprovante/download-comprovante-doacao/{id}")
	public void downloadArquivoDoacao(@PathVariable Long id, HttpServletResponse response, HttpServletRequest request)
			throws IOException {

		Usuario pessoa = this.usuarioService.pesquisarUsuarioParaDownloadArquivo(id);

		String uploadDir = request.getSession().getServletContext().getRealPath("/resources/arquivos/doacao");

		File arquivo = new File(uploadDir, pessoa.getComprovanteDeposito());

		if (arquivo.exists()) {
			// Configura os cabeçalhos da resposta
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment; filename=\"" + pessoa.getComprovanteDeposito() + "\"");

			// Escreve os dados do arquivo no fluxo de saída da resposta
			try (OutputStream os = response.getOutputStream(); FileInputStream fis = new FileInputStream(arquivo)) {
				byte[] buffer = new byte[4096];
				int bytesRead;
				while ((bytesRead = fis.read(buffer)) != -1) {
					os.write(buffer, 0, bytesRead);
				}
			}
		} else {
			// Trate o caso em que o arquivo não existe
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@RequestMapping(value = "/reativar", method = RequestMethod.POST)
	public ModelAndView reativar(@ModelAttribute Usuario pessoa, HttpSession session)
			throws GeneralSecurityException, IOException {

		Usuario usuarioLogado = usuarioService.reativar(pessoa.getId());

		ModelAndView model = new ModelAndView();

		// usuário logado
		session.setAttribute("usuarioLogado", usuarioLogado);
		session.setAttribute("idUsuarioLogado", usuarioLogado.getId());

		model.addObject("sucesso", Boolean.TRUE);
		model.setViewName("painel");
		return model;

	}

}
