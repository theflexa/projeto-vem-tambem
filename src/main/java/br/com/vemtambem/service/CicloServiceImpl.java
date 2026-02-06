package br.com.vemtambem.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.CicloDAO;
import br.com.vemtambem.model.Ciclo;

@Service
public class CicloServiceImpl implements CicloService {

	@Autowired
	private CicloDAO cicloDAO;

	@Override
	@Transactional
	public void salvar(Ciclo ciclo) {
		this.cicloDAO.salvar(ciclo);
	}

	@Override
	@Transactional
	public List<Ciclo> pesquisarCiclos() {
		return cicloDAO.pesquisarCiclos();
	}

	@Override
	@Transactional
	public Ciclo pesquisarPorId(Long idCiclo) {
		return cicloDAO.pesquisarPorId(idCiclo);
	}

	@Override
	@Transactional
	public List<Ciclo> pesquisarCiclosUsuario(String login) {
		return cicloDAO.pesquisarCiclosUsuarios(login);
	}

	@Override
	public List<Ciclo> pesquisarCiclosUsuariosDonatarios(String login) {
		return cicloDAO.pesquisarCiclosUsuariosDonatarios(login);
	}

}