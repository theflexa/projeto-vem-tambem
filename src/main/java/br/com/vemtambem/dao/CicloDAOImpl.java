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

import br.com.vemtambem.model.Ciclo;
import br.com.vemtambem.model.Conexao;
import br.com.vemtambem.model.TipoChavePix;
import br.com.vemtambem.model.Usuario;

@Repository
public class CicloDAOImpl implements CicloDAO {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void salvar(Ciclo ciclo) {

		Session session = null;

		try {
			session = sessionFactory.openSession();
			session.beginTransaction();
			session.saveOrUpdate(ciclo);
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
	public List<Ciclo> pesquisarCiclos() {
		return sessionFactory.getCurrentSession().createQuery("from Pessoa").list();

	}

	@Override
	public Ciclo pesquisarPorId(Long id) {
		return (Ciclo) sessionFactory.getCurrentSession().get(Ciclo.class, id);
	}

	@Override
	public Ciclo pesquisarCicloAtivoIdUsuario(Long idUsuario) {

		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Ciclo.class);
		criteria.add(Restrictions.eq("usuario.id", idUsuario));
		criteria.add(Restrictions.eq("ativo", true));

		return (Ciclo) criteria.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Ciclo> pesquisarCiclosUsuarios(String login) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Ciclo.class);
		criteria.add(Restrictions.eq("login", login));
		return criteria.list();
	}
	
	@Override
	public List<Ciclo> pesquisarCiclosUsuariosDonatarios(String login) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		List<Ciclo> ciclos = new ArrayList<>();

		try {
			connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA);

			String sql = "select ciclo.id, ciclo.nome as nome_ciclo, ciclo.login, ciclo.ativo, usu_principal.nome, usu_principal.whatsapp, usu_principal.celular, usu_principal.tipo_chave_pix, usu_principal.chave_pix, usu_principal.doacao_feita, usu_principal.admin, usu_principal.termo_aceito \r\n"
					+ "from ciclo as ciclo\r\n"
					+ "inner join usuario as usu on usu.id = ciclo.indicado_principal_id\r\n"
					+ "inner join ciclo as ciclo_ativo on ciclo_ativo.id = usu.ciclo_ativo_id\r\n"
					+ "inner join usuario as usu_principal on usu_principal.id = ciclo_ativo.indicado_principal_id\r\n"
					+ "where ciclo.login = ?";

			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, login);

			resultSet = preparedStatement.executeQuery();

			while (resultSet.next()) {
				Usuario indicador2 = new Usuario();
				indicador2.setNome(resultSet.getString("nome"));
				indicador2.setWhatsapp(resultSet.getString("whatsapp"));
				indicador2.setCelular(resultSet.getString("celular"));
				indicador2.setTipoChavePix(TipoChavePix.valueOf(resultSet.getString("tipo_chave_pix")));
				indicador2.setChavePix(resultSet.getString("chave_pix"));
				indicador2.setDoacaoFeita(resultSet.getBoolean("doacao_feita"));
				indicador2.setAdmin(resultSet.getBoolean("admin"));
				indicador2.setTermoAceito(resultSet.getBoolean("termo_aceito"));

				Ciclo ciclo2 = new Ciclo();
				ciclo2.setIndicadoPrincipal(indicador2);

				Usuario indicador = new Usuario();
				indicador.setCicloAtivo(ciclo2);

				Ciclo ciclo = new Ciclo();
				ciclo.setId(resultSet.getLong("id"));
				ciclo.setLogin(resultSet.getString("login"));
				ciclo.setAtivo(resultSet.getBoolean("ativo"));
				ciclo.setNome(resultSet.getString("nome_ciclo"));
				ciclo.setIndicadoPrincipal(indicador);

				ciclos.add(ciclo);

				// ciclo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.nome
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

		return ciclos;
	}

	@Override
	public Ciclo getCicloAtivoPorLogin(String login) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Ciclo.class);
		criteria.add(Restrictions.eq("login", login));
		criteria.add(Restrictions.eq("ativo", true));

		return (Ciclo) criteria.uniqueResult();
	}

}
