package br.com.vemtambem.service;

import java.util.List;

import br.com.vemtambem.model.TipoCiclo;

public interface TipoCicloService {

	TipoCiclo pesquisarPorId(Long id);

	List<TipoCiclo> listarAtivos();

	TipoCiclo pesquisarPorOrdem(int ordem);

	void salvar(TipoCiclo tipoCiclo);

}
