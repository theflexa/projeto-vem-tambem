package br.com.vemtambem.dao;

import java.util.List;

import br.com.vemtambem.model.Ciclo;
import br.com.vemtambem.model.RedePosicaoPreview;

public interface CicloDAO {

	public void salvar(Ciclo ciclo);

	public List<Ciclo> pesquisarCiclos();

	public Ciclo pesquisarPorId(Long id);
	
	public Ciclo pesquisarCicloAtivoIdUsuario(Long idUsuario);

	public List<Ciclo> pesquisarCiclosUsuarios(String login);
	
	public List<Ciclo> pesquisarCiclosUsuariosDonatarios(String login);
	
	public Ciclo getCicloAtivoPorLogin(String login);

	public RedePosicaoPreview pesquisarPosicaoUsuarioNaRede(Long idUsuario);

	public int vincularTipoCicloPadraoEmCiclosSemTipo(Long idTipoCicloPadrao);
	
}
