<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="cp"  value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri'] != null
                         ? requestScope['javax.servlet.forward.request_uri']
                         : pageContext.request.requestURI}" />

<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

  <!-- Brand -->
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${cp}/painel">
    <div class="sidebar-brand-icon">
      <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também">
    </div>
  </a>

  <hr class="sidebar-divider my-0"/>

  <!-- Painel -->
  <li class="nav-item ${fn:contains(uri, '/painel') ? 'active' : ''}">
    <a class="nav-link" href="${cp}/painel"><i class="fas fa-home"></i><span>Painel</span></a>
  </li>

  <hr class="sidebar-divider"/>
  <div class="sidebar-heading">Opera&#231;&#227;o</div>

  <c:choose>
    <c:when test="${usuarioLogado != null && usuarioLogado.ativo}">
      <li class="nav-item ${fn:contains(uri, '/usuario/minha-rede') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/minha-rede"><i class="fas fa-network-wired"></i><span>Minha Rede</span></a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/dados-pessoais') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/dados-pessoais"><i class="fas fa-user"></i><span>Meus Dados</span></a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/donatarios') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/donatarios"><i class="fas fa-hand-holding-heart"></i><span>Minha Contribui&#231;&#227;o</span></a>
      </li>
      <li class="nav-item ${fn:contains(uri, '/usuario/doadores') ? 'active' : ''}">
        <a class="nav-link" href="${cp}/usuario/doadores"><i class="fas fa-donate"></i><span>Doadores</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${cp}/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
      </li>
    </c:when>
    <c:otherwise>
      <li class="nav-item">
        <a class="nav-link" href="${cp}/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
      </li>
    </c:otherwise>
  </c:choose>

  <hr class="sidebar-divider d-none d-md-block"/>
  <div class="sidebar-heading">Atendimento</div>

  <li class="nav-item ${fn:contains(uri, '/faq') ? 'active' : ''}">
    <a class="nav-link" href="${cp}/faq"><i class="fas fa-question-circle"></i><span>Perguntas Frequentes</span></a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Tambem" target="_blank"><i class="fas fa-headset"></i><span>Suporte</span></a>
  </li>

  <c:if test="${usuarioLogado.admin}">
    <hr class="sidebar-divider d-none d-md-block"/>
    <div class="sidebar-heading">Admin</div>
    <li class="nav-item ${fn:contains(uri, '/admin/listar-pendentes') ? 'active' : ''}">
      <a class="nav-link" href="${cp}/admin/listar-pendentes"><i class="fas fa-user-check"></i><span>Ativar Cadastrados</span></a>
    </li>
  </c:if>

  <!-- Toggler -->
  <div class="text-center d-none d-md-inline">
    <button class="rounded-circle border-0" id="sidebarToggle" aria-label="Alternar menu"></button>
  </div>
</ul>
