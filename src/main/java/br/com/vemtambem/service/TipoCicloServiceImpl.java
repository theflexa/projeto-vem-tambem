package br.com.vemtambem.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.com.vemtambem.dao.CicloDAO;
import br.com.vemtambem.dao.TipoCicloDAO;
import br.com.vemtambem.model.TipoCiclo;

@Service
public class TipoCicloServiceImpl implements TipoCicloService {

	@Autowired
	private TipoCicloDAO tipoCicloDAO;

	@Autowired
	private CicloDAO cicloDAO;

	@Override
	@Transactional
	public TipoCiclo pesquisarPorId(Long id) {
		return tipoCicloDAO.pesquisarPorId(id);
	}

	@Override
	@Transactional
	public List<TipoCiclo> listarAtivos() {
		return tipoCicloDAO.listarAtivos();
	}

	@Override
	@Transactional
	public List<TipoCiclo> listarTodosOrdenados() {
		return tipoCicloDAO.listarTodosOrdenados();
	}

	@Override
	@Transactional
	public TipoCiclo pesquisarPorOrdem(int ordem) {
		return tipoCicloDAO.pesquisarPorOrdem(ordem);
	}

	@Override
	@Transactional
	public void salvar(TipoCiclo tipoCiclo) {
		tipoCicloDAO.salvar(tipoCiclo);
	}

	@Override
	@Transactional
	public void garantirJornadasPadraoEVinculoCiclos() {
		List<TipoCiclo> tiposCiclo = tipoCicloDAO.listarTodosOrdenados();
		if (tiposCiclo == null || tiposCiclo.isEmpty()) {
			criarJornadasPadrao();
			tiposCiclo = tipoCicloDAO.listarTodosOrdenados();
		}

		TipoCiclo jornadaSemente = null;
		for (TipoCiclo tipoCiclo : tiposCiclo) {
			if (tipoCiclo != null && tipoCiclo.getOrdem() == 1) {
				jornadaSemente = tipoCiclo;
				break;
			}
		}
		if (jornadaSemente == null) {
			jornadaSemente = criarTipoCiclo("Jornada da Semente", 1, new BigDecimal("60.00"), new BigDecimal("5.70"), true);
		}
		cicloDAO.vincularTipoCicloPadraoEmCiclosSemTipo(jornadaSemente.getId());
	}

	private void criarJornadasPadrao() {
		criarTipoCiclo("Jornada da Semente", 1, new BigDecimal("60.00"), new BigDecimal("5.70"), true);
		criarTipoCiclo("Jornada do Jardim", 2, new BigDecimal("450.00"), new BigDecimal("42.75"), false);
		criarTipoCiclo("Jornada da Floresta", 3, new BigDecimal("900.00"), new BigDecimal("85.50"), false);
	}

	private TipoCiclo criarTipoCiclo(String nome, int ordem, BigDecimal valorDoacao, BigDecimal valorTI, boolean ativo) {
		TipoCiclo tipoCiclo = new TipoCiclo();
		tipoCiclo.setNome(nome);
		tipoCiclo.setOrdem(ordem);
		tipoCiclo.setValorDoacao(valorDoacao);
		tipoCiclo.setValorTI(valorTI);
		tipoCiclo.setQuantDoadores(8);
		tipoCiclo.setAtivo(ativo);
		tipoCicloDAO.salvar(tipoCiclo);
		return tipoCiclo;
	}

}
