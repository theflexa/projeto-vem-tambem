package br.com.vemtambem.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.com.vemtambem.model.TipoCiclo;

@Repository
public class TipoCicloDAOImpl implements TipoCicloDAO {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public TipoCiclo pesquisarPorId(Long id) {
		return (TipoCiclo) sessionFactory.getCurrentSession().get(TipoCiclo.class, id);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TipoCiclo> listarAtivos() {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(TipoCiclo.class);
		criteria.add(Restrictions.eq("ativo", true));
		criteria.addOrder(Order.asc("ordem"));
		return criteria.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TipoCiclo> listarTodosOrdenados() {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(TipoCiclo.class);
		criteria.addOrder(Order.asc("ordem"));
		return criteria.list();
	}

	@Override
	public TipoCiclo pesquisarPorOrdem(int ordem) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(TipoCiclo.class);
		criteria.add(Restrictions.eq("ordem", ordem));
		criteria.add(Restrictions.eq("ativo", true));
		return (TipoCiclo) criteria.uniqueResult();
	}

	@Override
	public void salvar(TipoCiclo tipoCiclo) {
		Session session = null;
		try {
			session = sessionFactory.openSession();
			session.beginTransaction();
			session.saveOrUpdate(tipoCiclo);
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
