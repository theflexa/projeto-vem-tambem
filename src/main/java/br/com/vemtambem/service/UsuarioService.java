package br.com.vemtambem.service;

import java.util.List;

import br.com.vemtambem.model.Usuario;

public interface UsuarioService {

	public void salvar(Usuario usuario);

	public void salvarExterno(Usuario usuario);

	public void alterarSenha(Long idFuncionario, String senha);

	public List<Usuario> pesquisarTodas();

	public List<Usuario> pesquisarDesativadas();

	public Usuario pesquisarPorId(Long idPessoa);

	public Usuario pesquisarPorLoginSenha(String login, String senha);

	public void atualizarDados(Usuario pessoa);

	public Usuario pesquisarPorLogin(String login);

	public Usuario pesquisarPorEmail(String email);

	public Usuario pesquisarPorDocumento(String documento);

	public void ativar(Long idPessoa);

	public void ativarDoador(Long idUsuarioAtivacao);

	public List<Usuario> recuperarDoadores(Usuario usuarioLogado);

	public List<Usuario> recuperarRede(Usuario usuarioLogado);

	public Usuario reativar(Long idUsuario);

	public Usuario pesquisarUsuarioParaDoadores(Long idUsuario);

	public Usuario pesquisarUsuarioParaDonatarios(Long idUsuario);
	
	public Usuario pesquisarUsuarioParaConvite(String login);

	public Usuario pesquisarUsuarioParaDownloadArquivo(Long id);

	public void enviarCodigoRedefinicao(Usuario usuario);


}