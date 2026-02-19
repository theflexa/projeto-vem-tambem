package br.com.vemtambem.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.com.vemtambem.model.Conexao;
import br.com.vemtambem.model.Endereco;
import br.com.vemtambem.model.TipoChavePix;
import br.com.vemtambem.model.Usuario;

@Repository
public class UsuarioDAOImpl implements UsuarioDAO {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void salvar(Usuario pessoa) {

		Session session = null;

		try {
			session = sessionFactory.openSession();
			session.beginTransaction();
			session.saveOrUpdate(pessoa);
			session.getTransaction().commit();
		} catch (HibernateException hex) {
			if (session != null && session.getTransaction().isActive()) {
				session.getTransaction().rollback();
			}
			throw hex;
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> pesquisarUsuarios() {
		return sessionFactory.getCurrentSession().createQuery("from Pessoa").list();

	}

//	@SuppressWarnings("unchecked")
//	@Override
//	public List<Usuario> pesquisarDesativadas() {
//		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Usuario.class);
//		criteria.add(Restrictions.eq("ativo", false));
//		criteria.add(Restrictions.isNotNull("comprovanteAtivacao"));
//
//		return criteria.list();
//	}

	@Override
	public List<Usuario> pesquisarDesativadas() {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<Usuario> usuarios = new ArrayList<>();

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

		    String sql = "SELECT id, nome, documento, whatsapp FROM usuario WHERE ativo = 0 AND comprovante_ativacao IS NOT NULL ORDER BY data_cadastro";

			preparedStatement = connection.prepareStatement(sql);

			resultSet = preparedStatement.executeQuery();

			while (resultSet.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setNome(resultSet.getString("nome"));
				usuario.setDocumento(resultSet.getString("documento"));
				usuario.setWhatsapp(resultSet.getString("whatsapp"));

				usuarios.add(usuario);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuarios;
	}

	@Override
	public Usuario pesquisarPorId(Long id) {
		if (id == null) {
			return null;
		}

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT "
					+ "u.id, u.nome, u.email, u.login, u.senha, u.tipo_conta, u.documento, u.celular, u.whatsapp, "
					+ "u.tipo_chave_pix, u.chave_pix, u.ativo, u.admin, u.doacao_feita, u.comprovante_ativacao, "
					+ "u.comprovante_deposito, u.motivo_recusa_ativacao, u.quantDoacoesRecebidas, u.quant_ciclos, u.termo_aceito, "
					+ "e.logradouro, e.bairro, e.municipio, e.estado, e.cep, e.complemento "
					+ "FROM usuario u "
					+ "LEFT JOIN endereco e ON e.id = u.endereco_id "
					+ "WHERE u.id = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setLong(1, id);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setNome(resultSet.getString("nome"));
				usuario.setEmail(resultSet.getString("email"));
				usuario.setLogin(resultSet.getString("login"));
				usuario.setSenha(resultSet.getString("senha"));
				usuario.setTipoConta(resultSet.getBoolean("tipo_conta"));
				usuario.setDocumento(resultSet.getString("documento"));
				usuario.setCelular(resultSet.getString("celular"));
				usuario.setWhatsapp(resultSet.getString("whatsapp"));
				usuario.setChavePix(resultSet.getString("chave_pix"));
				usuario.setAtivo(resultSet.getBoolean("ativo"));
				usuario.setAdmin(resultSet.getBoolean("admin"));
				usuario.setDoacaoFeita(resultSet.getBoolean("doacao_feita"));
				usuario.setComprovanteAtivacao(resultSet.getString("comprovante_ativacao"));
				usuario.setComprovanteDeposito(resultSet.getString("comprovante_deposito"));
				usuario.setMotivoRecusaAtivacao(resultSet.getString("motivo_recusa_ativacao"));
				usuario.setQuantDoacoesRecebidas(resultSet.getInt("quantDoacoesRecebidas"));
				usuario.setQuantCiclos(resultSet.getInt("quant_ciclos"));
				usuario.setTermoAceito(resultSet.getBoolean("termo_aceito"));

				String tipoChavePix = resultSet.getString("tipo_chave_pix");
				if (tipoChavePix != null && !tipoChavePix.trim().isEmpty()) {
					try {
						usuario.setTipoChavePix(TipoChavePix.valueOf(tipoChavePix.trim()));
					} catch (IllegalArgumentException ignored) {
						// Mantém nulo caso o valor esteja inválido no banco.
					}
				}

				Endereco endereco = new Endereco();
				endereco.setLogradouro(resultSet.getString("logradouro"));
				endereco.setBairro(resultSet.getString("bairro"));
				endereco.setMunicipio(resultSet.getString("municipio"));
				endereco.setEstado(resultSet.getString("estado"));
				endereco.setCep(resultSet.getString("cep"));
				endereco.setComplemento(resultSet.getString("complemento"));
				usuario.setEndereco(endereco);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

//	public Usuario pesquisarPorId(Long id) {
//		Connection connection = null;
//		PreparedStatement preparedStatement = null;
//		ResultSet resultSet = null;
//		Usuario usuario = null;
//
//		try {
//			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);
//
//			String sql = "SELECT "
//					+ "usuario.id, nome, email, login, senha, tipo_conta, documento, celular, whatsapp, chave_pix, "
//					+ "endereco.logradouro, endereco.bairro, endereco.municipio, endereco.estado, endereco.cep, endereco.complemento "
//					+ "FROM usuario as usuario "
//					+ "inner join endereco as endereco on endereco.id = usuario.endereco_id "
//					+ " WHERE usuario.id = ?";
//
//			preparedStatement = connection.prepareStatement(sql);
//			preparedStatement.setLong(1, id);
//
//			resultSet = preparedStatement.executeQuery();
//
//			if (resultSet.next()) {
//				usuario = new Usuario();
//				usuario.setId(resultSet.getLong("id"));
//				usuario.setNome(resultSet.getString("nome"));
//				usuario.setEmail(resultSet.getString("email"));
//				usuario.setLogin(resultSet.getString("login"));
//				usuario.setSenha(resultSet.getString("senha"));
//				usuario.setTipoConta(resultSet.getBoolean("tipo_conta"));
//				usuario.setDocumento(resultSet.getString("documento"));
//				usuario.setCelular(resultSet.getString("celular"));
//				usuario.setWhatsapp(resultSet.getString("whatsapp"));
//				usuario.setChavePix(resultSet.getString("chave_pix"));
//
//				Endereco endereco = new Endereco();
//				endereco.setLogradouro(resultSet.getString("logradouro"));
//				endereco.setBairro(resultSet.getString("bairro"));
//				endereco.setMunicipio(resultSet.getString("municipio"));
//				endereco.setEstado(resultSet.getString("estado"));
//				endereco.setCep(resultSet.getString("cep"));
//				endereco.setComplemento(resultSet.getString("complemento"));
//
//				usuario.setEndereco(endereco);
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		} finally {
//			try {
//				if (resultSet != null)
//					resultSet.close();
//				if (preparedStatement != null)
//					preparedStatement.close();
//				if (connection != null)
//					connection.close();
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}
//
//		return usuario;
//	}

//	@Override
//	public Usuario pesquisarPorLoginSenha(String login, String senha) {
//		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Usuario.class);
//		criteria.add(Restrictions.eq("login", login));
//		criteria.add(Restrictions.eq("senha", senha));
//
//		Usuario pessoa = (Usuario) criteria.uniqueResult();
//
//		return pessoa;
//	}

	@Override
	public Usuario pesquisarPorLoginSenha(String login, String senha) {

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT id, ativo, admin, nome FROM usuario "
					+ "WHERE LOWER(TRIM(login)) = LOWER(TRIM(?)) AND senha = ?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, login);
			preparedStatement.setString(2, senha);

			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setAtivo(resultSet.getBoolean("ativo"));
				usuario.setAdmin(resultSet.getBoolean("admin"));
				usuario.setNome(resultSet.getString("nome"));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

	@Override
	public Usuario pesquisarPorLogin(String login) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Usuario.class);
		criteria.add(Restrictions.eq("login", login));

		Usuario pessoa = (Usuario) criteria.uniqueResult();
		return pessoa;
	}

	@Override
	public Usuario pesquisarPorDocumento(String documento) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Usuario.class);
		criteria.add(Restrictions.eq("documento", documento));

		Usuario pessoa = (Usuario) criteria.uniqueResult();
		return pessoa;
	}

	@Override
	public Usuario pesquisarPorEmail(String email) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Usuario.class);
		criteria.add(Restrictions.eq("email", email));

		Usuario pessoa = (Usuario) criteria.uniqueResult();
		return pessoa;
	}

	@Override
	public Usuario pesquisarUsuarioParaDoadores(Long idUsuario) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT id, quantDoacoesRecebidas, login FROM usuario WHERE id = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setLong(1, idUsuario);

			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setLogin(resultSet.getString("login"));
				usuario.setQuantDoacoesRecebidas(resultSet.getInt("quantDoacoesRecebidas"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

	@Override
	public Usuario pesquisarUsuarioParaDonatarios(Long idUsuario) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT id, comprovante_deposito, doacao_feita, login FROM usuario WHERE id = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setLong(1, idUsuario);

			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setComprovanteDeposito(resultSet.getString("comprovante_deposito"));
				usuario.setDoacaoFeita(resultSet.getBoolean("doacao_feita"));
				usuario.setLogin(resultSet.getString("login"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

	@Override
	public Usuario pesquisarUsuarioParaConvite(String login) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT id, nome, login FROM usuario WHERE login = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, login);

			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setNome(resultSet.getString("nome"));
				usuario.setLogin(resultSet.getString("login"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

	@Override
	public Usuario pesquisarUsuarioParaDownloadArquivo(Long id) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Usuario usuario = null;

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "SELECT id, comprovante_ativacao, comprovante_deposito FROM usuario WHERE id = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setLong(1, id);

			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				usuario = new Usuario();
				usuario.setId(resultSet.getLong("id"));
				usuario.setComprovanteAtivacao(resultSet.getString("comprovante_ativacao"));
				usuario.setComprovanteDeposito(resultSet.getString("comprovante_deposito"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuario;
	}

}
