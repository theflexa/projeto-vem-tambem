package br.com.vemtambem.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.UsuarioTokenDAO;
import br.com.vemtambem.model.UsuarioToken;

@Service
public class UsuarioTokenServiceImpl implements UsuarioTokenService {

	@Autowired
	private UsuarioTokenDAO usuarioTokenDAO;

	@Override
	@Transactional
	public void salvar(UsuarioToken usuarioToken) {
		this.usuarioTokenDAO.salvar(usuarioToken);
	}

}