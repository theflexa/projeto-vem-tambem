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
		return usuarioDAO.pesquisarPorLoginSenha(login, SenhaUtils.convertStringToMd5(senha));
	}

}