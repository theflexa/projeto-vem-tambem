package br.com.vemtambem.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.UsuarioDAO;
import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.utils.SenhaUtils;

@Service
public class LoginServiceImpl implements LoginService {

	@Autowired
	private UsuarioDAO usuarioDAO;

	@Override
	@Transactional
	public Usuario realizarLogin(String login, String senha) {
		String loginNormalizado = login == null ? "" : login.trim();
		String senhaHash = SenhaUtils.convertStringToMd5(senha);

		Usuario usuario = usuarioDAO.pesquisarPorLoginSenha(loginNormalizado, senhaHash);
		if (usuario != null) {
			return usuario;
		}

		// Compatibilidade: login legado "vemtambem" deve autenticar no usuário administrativo.
		if ("vemtambem".equalsIgnoreCase(loginNormalizado)) {
			return usuarioDAO.pesquisarPorLoginSenha("admin", senhaHash);
		}

		return null;
	}

}
