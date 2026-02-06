package br.com.vemtambem.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.service.UsuarioService;

@Controller
public class HomeController {

	@Autowired
	private UsuarioService usuarioService;

	@RequestMapping(value = "/")
	public ModelAndView home(ModelAndView model) throws IOException {
		model.setViewName("index");
		return model;
	}

	@RequestMapping(value = "/painel")
	public ModelAndView painel(ModelAndView model) throws IOException {
		model.setViewName("painel");
		return model;
	}

	@RequestMapping(value = "/esqueci-senha")
	public ModelAndView esqueciSenha(ModelAndView model) throws IOException {
		model.setViewName("esqueci-senha");
		return model;
	}

	@RequestMapping(value = "/enviar-codigo-senha")
	public ModelAndView enviarCodigoSenha(ModelAndView model, Usuario usuario) throws IOException {
		
		Usuario usuarioSolicitado = this.usuarioService.pesquisarPorEmail(usuario.getEmail());
		if (usuarioSolicitado == null) {
			model.setViewName("esqueci-senha");
			model.addObject("erro", "E-mail não encontrado em nossa base de dados.");
			return model;
		} 
		
		this.usuarioService.enviarCodigoRedefinicao(usuarioSolicitado);
		
		return model;
	}

	@RequestMapping("/termo/download")
	public void downloadTermo(HttpServletResponse response, HttpServletRequest request) throws IOException {

		String uploadDir = request.getSession().getServletContext().getRealPath("/resources/termo");

		File arquivo = new File(uploadDir, "termo.pdf");

		if (arquivo.exists()) {
			// Configura os cabeçalhos da resposta
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + "termo.pdf" + "\"");

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

	@RequestMapping(value = "/force-403")
	public ModelAndView force403(ModelAndView model) {
		model.setViewName("error/403");
		return model;
	}

	@RequestMapping("/force-exception")
	public String forceException() {
		// Simula uma exceção genérica
		throw new RuntimeException("Exceção de teste para tela genérica");
	}

	@SuppressWarnings("null")
	@RequestMapping("/null-exception")
	public String nullException() {
		String a = null;
		a.length();
		return "ok";
	}

}
