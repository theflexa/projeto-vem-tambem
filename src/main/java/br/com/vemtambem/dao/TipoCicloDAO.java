package br.com.vemtambem.dao;

import java.util.List;

import br.com.vemtambem.model.TipoCiclo;

public interface TipoCicloDAO {

	TipoCiclo pesquisarPorId(Long id);

	List<TipoCiclo> listarAtivos();

	TipoCiclo pesquisarPorOrdem(int ordem);

	void salvar(TipoCiclo tipoCiclo);

}
