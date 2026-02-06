package br.com.vemtambem.service;

import br.com.vemtambem.model.Usuario;

public interface LoginService {

	public Usuario realizarLogin(String login, String senha);

}