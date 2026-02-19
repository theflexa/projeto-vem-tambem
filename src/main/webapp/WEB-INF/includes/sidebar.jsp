<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="cp"  value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri'] != null
                         ? requestScope['javax.servlet.forward.request_uri']
                         : pageContext.request.requestURI}" />

<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar" data-tour-id="sidebar-main">

  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${cp}/painel">
    <div class="sidebar-brand-icon">
      <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Tambem">
    </div>
  </a>

  <hr class="sidebar-divider my-0"/>

  <c:if test="${usuarioLogado != null && !usuarioLogado.ativo}">
    <li class="nav-item px-3 pt-3 pb-1">
      <span class="vt-pending-status">
        <i class="fas fa-hourglass-half" aria-hidden="true"></i>
        Assinatura pendente
      </span>
    </li>
    <hr class="sidebar-divider"/>
  </c:if>

  <li class="nav-item ${fn:contains(uri, '/painel') ? 'active' : ''}">
    <a class="nav-link" href="${cp}/painel">
      <i class="vt-fa-icon fas fa-home" aria-hidden="true"></i>
      <span>Painel</span>
    </a>
  </li>

  <hr class="sidebar-divider"/>
  <div class="sidebar-heading">Opera&#231;&#227;o</div>

  <c:choose>
    <c:when test="${usuarioLogado != null && usuarioLogado.admin}">
      <li class="nav-item ${fn:contains(uri, '/admin/listar-pendentes') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/admin/listar-pendentes">
          <i class="vt-fa-icon fas fa-user-check" aria-hidden="true"></i>
          <span>Ativa&#231;&#245;es Pendentes</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/admin/dashboard') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/admin/dashboard">
          <i class="vt-fa-icon fas fa-chart-line" aria-hidden="true"></i>
          <span>Dashboard</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/admin/administracao') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/admin/administracao">
          <i class="vt-fa-icon fas fa-sliders-h" aria-hidden="true"></i>
          <span>Administra&#231;&#227;o</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/dados-pessoais') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/dados-pessoais">
          <i class="vt-fa-icon fas fa-id-card" aria-hidden="true"></i>
          <span>Meus Dados</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${cp}/sair">
          <i class="vt-fa-icon fas fa-sign-out-alt" aria-hidden="true"></i>
          <span>Sair</span>
        </a>
      </li>
    </c:when>
    <c:otherwise>
      <li class="nav-item ${fn:contains(uri, '/usuario/minha-rede') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/minha-rede">
          <i class="vt-fa-icon fas fa-project-diagram" aria-hidden="true"></i>
          <span>Minha Rede</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/jornadas') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/jornadas">
          <i class="vt-fa-icon fas fa-map-marked-alt" aria-hidden="true"></i>
          <span>Jornadas</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/dados-pessoais') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/dados-pessoais">
          <i class="vt-fa-icon fas fa-id-card" aria-hidden="true"></i>
          <span>Meus Dados</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/donatarios') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/donatarios">
          <i class="vt-fa-icon fas fa-hand-holding-heart" aria-hidden="true"></i>
          <span>Minha Contribui&#231;&#227;o</span>
        </a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/doadores') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/doadores">
          <i class="vt-fa-icon fas fa-users" aria-hidden="true"></i>
          <span>Doadores</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${cp}/sair">
          <i class="vt-fa-icon fas fa-sign-out-alt" aria-hidden="true"></i>
          <span>Sair</span>
        </a>
      </li>

      <hr class="sidebar-divider d-none d-md-block"/>
      <div class="sidebar-heading">Atendimento</div>

      <li class="nav-item ${fn:contains(uri, '/faq') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/faq">
          <i class="vt-fa-icon fas fa-question-circle" aria-hidden="true"></i>
          <span>Perguntas Frequentes</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Tambem" target="_blank">
          <i class="vt-fa-icon fas fa-headset" aria-hidden="true"></i>
          <span>Suporte</span>
        </a>
      </li>
    </c:otherwise>
  </c:choose>

  <div class="text-center d-none d-md-inline">
    <button class="rounded-circle border-0" id="sidebarToggle" aria-label="Alternar menu"></button>
  </div>
</ul>
