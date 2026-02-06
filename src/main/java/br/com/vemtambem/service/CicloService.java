package br.com.vemtambem.service;

import java.util.List;

import br.com.vemtambem.model.Ciclo;

public interface CicloService {

	public void salvar(Ciclo ciclo);

	public List<Ciclo> pesquisarCiclos();
	
	public Ciclo pesquisarPorId(Long idPessoa);

	public List<Ciclo> pesquisarCiclosUsuario(String login);

	public List<Ciclo> pesquisarCiclosUsuariosDonatarios(String login);

}