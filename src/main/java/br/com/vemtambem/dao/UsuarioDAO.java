package br.com.vemtambem.dao;

import java.util.List;

import br.com.vemtambem.model.Usuario;

public interface UsuarioDAO {

	public void salvar(Usuario usuario);

	public List<Usuario> pesquisarUsuarios();

	public Usuario pesquisarPorId(Long idPessoa);

	public Usuario pesquisarPorLoginSenha(String login, String senha);

	public Usuario pesquisarPorLogin(String login);

	public Usuario pesquisarPorEmail(String email);

	public Usuario pesquisarPorDocumento(String documento);

	public List<Usuario> pesquisarDesativadas();

	public Usuario pesquisarUsuarioParaDoadores(Long idUsuario);

	public Usuario pesquisarUsuarioParaDonatarios(Long idUsuario);

	public Usuario pesquisarUsuarioParaConvite(String login);

	public Usuario pesquisarUsuarioParaDownloadArquivo(Long id);

}
