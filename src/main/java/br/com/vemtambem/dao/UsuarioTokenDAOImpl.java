package br.com.vemtambem.dao;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.com.vemtambem.model.UsuarioToken;

@Repository
public class UsuarioTokenDAOImpl implements UsuarioTokenDAO {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void salvar(UsuarioToken usuarioToken) {

		Session session = null;

		try {
			session = sessionFactory.openSession();
			session.beginTransaction();
			session.saveOrUpdate(usuarioToken);
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

}
