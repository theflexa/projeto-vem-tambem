package br.com.vemtambem.controller;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.com.vemtambem.model.Conexao;
import br.com.vemtambem.model.TipoCiclo;
import br.com.vemtambem.model.Usuario;
import br.com.vemtambem.service.TipoCicloService;
import br.com.vemtambem.service.UsuarioService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private UsuarioService usuarioService;

	@Autowired
	private TipoCicloService tipoCicloService;

	private static final String JORNADA_SEMENTE = "Jornada da Semente";
	private static final String JORNADA_JARDIM = "Jornada do Jardim";
	private static final String JORNADA_FLORESTA = "Jornada da Floresta";

	@RequestMapping(value = "/listar-pendentes")
	public ModelAndView listarPendentes(ModelAndView model, HttpServletRequest request) {
		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}
		return carregarPendentes(model, null, null, usuarioLogado);
	}

	@RequestMapping(value = "/ativar", method = RequestMethod.GET)
	public ModelAndView ativar(HttpServletRequest request) {
		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}

		Long id = Long.parseLong(request.getParameter("id"));
		usuarioService.ativar(id);
		return carregarPendentes(new ModelAndView(), true, "Cadastro ativado com sucesso.", usuarioLogado);
	}

	@RequestMapping(value = "/recusar", method = RequestMethod.POST)
	public ModelAndView recusar(HttpServletRequest request,
			@RequestParam("id") Long id,
			@RequestParam("motivoRecusa") String motivoRecusa) {

		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}

		String motivo = motivoRecusa == null ? "" : motivoRecusa.trim();
		if (motivo.isEmpty()) {
			return carregarPendentes(new ModelAndView(), false, "Informe o motivo da recusa para continuar.",
					usuarioLogado);
		}

		usuarioService.recusarAtivacao(id, motivo);
		return carregarPendentes(new ModelAndView(), true, "Cadastro recusado. O usuÃ¡rio jÃ¡ pode visualizar o motivo.",
				usuarioLogado);
	}

	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public ModelAndView dashboard(HttpServletRequest request) {
		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}

		DashboardSnapshot snapshot = carregarDashboardSnapshot();

		ModelAndView model = new ModelAndView();
		model.addObject("usuarioLogado", usuarioLogado);
		model.addObject("totalCiclosCriados", snapshot.totalCiclosCriados);
		model.addObject("ciclosAtivos", snapshot.ciclosAtivos);
		model.addObject("ativacoesPendentes", snapshot.ativacoesPendentes);
		model.addObject("usuariosAtivos", snapshot.usuariosAtivos);
		model.addObject("usuariosPendentes", snapshot.usuariosPendentes);
		model.addObject("usuariosAdmins", snapshot.usuariosAdmins);
		model.addObject("doacoesConfirmadas", snapshot.doacoesConfirmadas);
		model.addObject("ciclosPorTipo", snapshot.ciclosPorTipo);
		model.setViewName("admin-dashboard");
		return model;
	}

	@RequestMapping(value = "/administracao", method = RequestMethod.GET)
	public ModelAndView administracao(HttpServletRequest request) {
		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}
		return carregarAdministracao(new ModelAndView(), null, null, usuarioLogado);
	}

	@RequestMapping(value = "/administracao/salvar", method = RequestMethod.POST)
	public ModelAndView salvarConfiguracaoCiclo(
			HttpServletRequest request,
			@RequestParam("id") Long id,
			@RequestParam("valorDoacao") BigDecimal valorDoacao,
			@RequestParam("valorTI") BigDecimal valorTI) {

		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}

		if (id == null || valorDoacao == null || valorTI == null) {
			return carregarAdministracao(new ModelAndView(), false, "Dados invÃ¡lidos para atualizaÃ§Ã£o.", usuarioLogado);
		}
		if (valorDoacao.compareTo(BigDecimal.ZERO) <= 0 || valorTI.compareTo(BigDecimal.ZERO) < 0) {
			return carregarAdministracao(new ModelAndView(), false,
					"Valores invÃ¡lidos. Informe doaÃ§Ã£o maior que zero e taxa de manutenção maior ou igual a zero.",
					usuarioLogado);
		}

		TipoCiclo tipoCiclo = tipoCicloService.pesquisarPorId(id);
		if (tipoCiclo == null) {
			return carregarAdministracao(new ModelAndView(), false, "Ciclo nÃ£o encontrado.", usuarioLogado);
		}

		tipoCiclo.setValorDoacao(valorDoacao.setScale(2, RoundingMode.HALF_UP));
		tipoCiclo.setValorTI(valorTI.setScale(2, RoundingMode.HALF_UP));
		tipoCicloService.salvar(tipoCiclo);

		return carregarAdministracao(new ModelAndView(), true, "ConfiguraÃ§Ã£o do ciclo atualizada com sucesso.",
				usuarioLogado);
	}

	@RequestMapping(value = "/administracao/status", method = RequestMethod.POST)
	public ModelAndView atualizarStatusCiclo(HttpServletRequest request,
			@RequestParam("id") Long id,
			@RequestParam("ativo") boolean ativo) {

		Usuario usuarioLogado = recuperarUsuarioLogado(request);
		if (!isAdmin(usuarioLogado)) {
			return forbidden();
		}

		TipoCiclo tipoCiclo = tipoCicloService.pesquisarPorId(id);
		if (tipoCiclo == null) {
			return carregarAdministracao(new ModelAndView(), false, "Ciclo não encontrado.", usuarioLogado);
		}

		tipoCiclo.setAtivo(ativo);
		tipoCicloService.salvar(tipoCiclo);

		String mensagem = ativo ? "Jornada ativada com sucesso." : "Jornada desativada com sucesso.";
		return carregarAdministracao(new ModelAndView(), true, mensagem, usuarioLogado);
	}
	private ModelAndView carregarPendentes(ModelAndView model, Boolean sucesso, String mensagem, Usuario usuarioLogado) {
		List<Usuario> listPessoa = usuarioService.pesquisarDesativadas();
		model.addObject("usuarioLogado", usuarioLogado);
		model.addObject("listPessoa", listPessoa);
		if (sucesso != null) {
			model.addObject("sucesso", sucesso);
		}
		if (mensagem != null && !mensagem.trim().isEmpty()) {
			model.addObject("mensagem", mensagem);
		}
		model.setViewName("pessoa-lista-pendentes");
		return model;
	}

	private ModelAndView carregarAdministracao(ModelAndView model, Boolean sucesso, String mensagem,
			Usuario usuarioLogado) {
		tipoCicloService.garantirJornadasPadraoEVinculoCiclos();
		List<TipoCiclo> tiposCiclo = tipoCicloService.listarTodosOrdenados();
		normalizarNomesTipoCiclo(tiposCiclo);
		model.addObject("usuarioLogado", usuarioLogado);
		model.addObject("tiposCiclo", tiposCiclo);
		if (sucesso != null) {
			model.addObject("sucesso", sucesso);
		}
		if (mensagem != null && !mensagem.trim().isEmpty()) {
			model.addObject("mensagem", mensagem);
		}
		model.setViewName("admin-administracao");
		return model;
	}

	private DashboardSnapshot carregarDashboardSnapshot() {
		DashboardSnapshot snapshot = new DashboardSnapshot();

		try (Connection connection = DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA)) {
			snapshot.totalCiclosCriados = queryLong(connection, "SELECT COUNT(*) FROM ciclo");
			snapshot.ciclosAtivos = queryLong(connection, "SELECT COUNT(*) FROM ciclo WHERE ativo = 1");
			snapshot.ativacoesPendentes = queryLong(connection,
					"SELECT COUNT(*) FROM usuario WHERE ativo = 0 AND comprovante_ativacao IS NOT NULL");
			snapshot.usuariosAtivos = queryLong(connection, "SELECT COUNT(*) FROM usuario WHERE ativo = 1");
			snapshot.usuariosPendentes = queryLong(connection, "SELECT COUNT(*) FROM usuario WHERE ativo = 0");
			snapshot.usuariosAdmins = queryLong(connection, "SELECT COUNT(*) FROM usuario WHERE admin = 1");
			snapshot.doacoesConfirmadas = queryLong(connection, "SELECT COUNT(*) FROM usuario WHERE doacao_feita = 1");

			String sqlCiclosPorTipo = "SELECT tc.nome, COUNT(c.id) AS total "
					+ "FROM tipo_ciclo tc "
					+ "LEFT JOIN ciclo c ON c.tipo_ciclo_id = tc.id "
					+ "WHERE tc.ativo = 1 "
					+ "GROUP BY tc.id, tc.nome, tc.ordem "
					+ "ORDER BY tc.ordem";
			try (PreparedStatement ps = connection.prepareStatement(sqlCiclosPorTipo);
					ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					String nome = mapearNomeJornada(rs.getString("nome"));
					long total = rs.getLong("total");
					snapshot.ciclosPorTipo.add(new DashboardSerieItem(nome, total));
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException("NÃ£o foi possÃ­vel carregar os indicadores do dashboard.", e);
		}

		return snapshot;
	}

	private long queryLong(Connection connection, String sql) throws SQLException {
		try (PreparedStatement ps = connection.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				return rs.getLong(1);
			}
		}
		return 0L;
	}

	private Usuario recuperarUsuarioLogado(HttpServletRequest request) {
		Long idUsuario = (Long) request.getSession().getAttribute("idUsuarioLogado");
		if (idUsuario == null) {
			return null;
		}
		Usuario usuarioLogado = usuarioService.pesquisarPorId(idUsuario);
		if (usuarioLogado != null) {
			request.getSession().setAttribute("usuarioLogado", usuarioLogado);
		}
		return usuarioLogado;
	}

	private boolean isAdmin(Usuario usuario) {
		return usuario != null && usuario.isAdmin();
	}

	private ModelAndView forbidden() {
		ModelAndView modelErro403 = new ModelAndView();
		modelErro403.setViewName("error/403");
		return modelErro403;
	}

	private void normalizarNomesTipoCiclo(List<TipoCiclo> tiposCiclo) {
		if (tiposCiclo == null || tiposCiclo.isEmpty()) {
			return;
		}
		for (TipoCiclo tipoCiclo : tiposCiclo) {
			if (tipoCiclo == null) {
				continue;
			}
			tipoCiclo.setNome(mapearNomeJornada(tipoCiclo.getNome()));
		}
	}

	private String mapearNomeJornada(String nomeOriginal) {
		if (nomeOriginal == null || nomeOriginal.trim().isEmpty()) {
			return JORNADA_SEMENTE;
		}

		String nome = nomeOriginal.trim();
		String nomeLower = nome.toLowerCase(Locale.ROOT);
		if ("tabuleiro 1".equals(nomeLower) || "jornada da semente".equals(nomeLower)) {
			return JORNADA_SEMENTE;
		}
		if ("tabuleiro 2".equals(nomeLower) || "jornada do jardim".equals(nomeLower)) {
			return JORNADA_JARDIM;
		}
		if ("tabuleiro 3".equals(nomeLower) || "jornada da floresta".equals(nomeLower)) {
			return JORNADA_FLORESTA;
		}
		return nome;
	}

	private static final class DashboardSnapshot {
		private long totalCiclosCriados;
		private long ciclosAtivos;
		private long ativacoesPendentes;
		private long usuariosAtivos;
		private long usuariosPendentes;
		private long usuariosAdmins;
		private long doacoesConfirmadas;
		private final List<DashboardSerieItem> ciclosPorTipo = new ArrayList<>();
	}

	public static final class DashboardSerieItem {
		private final String nome;
		private final long total;

		public DashboardSerieItem(String nome, long total) {
			this.nome = nome;
			this.total = total;
		}

		public String getNome() {
			return nome;
		}

		public long getTotal() {
			return total;
		}
	}
}

