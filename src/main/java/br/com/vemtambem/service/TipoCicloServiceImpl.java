package br.com.vemtambem.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.TipoCicloDAO;
import br.com.vemtambem.model.TipoCiclo;

@Service
public class TipoCicloServiceImpl implements TipoCicloService {

	@Autowired
	private TipoCicloDAO tipoCicloDAO;

	@Override
	@Transactional
	public TipoCiclo pesquisarPorId(Long id) {
		return tipoCicloDAO.pesquisarPorId(id);
	}

	@Override
	@Transactional
	public List<TipoCiclo> listarAtivos() {
		return tipoCicloDAO.listarAtivos();
	}

	@Override
	@Transactional
	public TipoCiclo pesquisarPorOrdem(int ordem) {
		return tipoCicloDAO.pesquisarPorOrdem(ordem);
	}

	@Override
	@Transactional
	public void salvar(TipoCiclo tipoCiclo) {
		tipoCicloDAO.salvar(tipoCiclo);
	}

}
