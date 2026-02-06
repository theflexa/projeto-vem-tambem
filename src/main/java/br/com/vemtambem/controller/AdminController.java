package br.com.vemtambem.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.service.UsuarioService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private UsuarioService usuarioService;

	public AdminController() {
	}

	@RequestMapping(value = "/listar-pendentes")
	public ModelAndView listarPendentes(ModelAndView model, HttpServletRequest request) throws IOException {
		
		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		
		if (!usuarioLogado.isAdmin()) {
			ModelAndView modelErro403 = new ModelAndView();
			modelErro403.setViewName("error/403");
			return modelErro403;
		}
		
		List<Usuario> listPessoa = usuarioService.pesquisarDesativadas();
		model.addObject("listPessoa", listPessoa);
		model.setViewName("pessoa-lista-pendentes");
		return model;
	}

	/**
	 * Ativar usuário depois do pagamento da taxa de ativação. Isso é feito por
	 * usuário admin.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/ativar", method = RequestMethod.GET)
	public ModelAndView ativar(HttpServletRequest request) {
		
		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		
		if (!usuarioLogado.isAdmin()) {
			ModelAndView modelErro403 = new ModelAndView();
			modelErro403.setViewName("error/403");
			return modelErro403;
		}
		
		Long id = Long.parseLong(request.getParameter("id"));
		usuarioService.ativar(id);

		List<Usuario> listPessoa = usuarioService.pesquisarDesativadas();

		ModelAndView model = new ModelAndView();
		model.addObject("listPessoa", listPessoa);
		model.addObject("sucesso", true);
		model.setViewName("pessoa-lista-pendentes");
		return model;
	}

}
