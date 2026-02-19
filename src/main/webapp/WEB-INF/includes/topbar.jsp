<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow-sm vt-topbar" data-tour-id="topbar">
  <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-2" aria-label="Abrir menu">
    <i class="fa fa-bars"></i>
  </button>

  <ul class="navbar-nav ml-auto align-items-center">
    <li class="nav-item mr-2">
      <button
        id="vtTutorialAction"
        class="btn btn-olive btn-sm px-3 vt-tutorial-trigger"
        type="button"
        data-vt-action="start-tour"
        data-tour-id="tutorial-button"
        aria-label="Abrir tutorial guiado desta página"
      >
        <span
          class="mr-1"
          data-vt-lordicon="${cp}/resources/vendor/lordicon/icons/wzrwaorf.json"
          data-trigger="hover"
          data-width="18"
          data-height="18"
          data-colors="primary:#ffffff,secondary:#f3c900"
          data-fallback-fa="fas fa-map-signs"
        ></span>
        Tutorial
      </button>
    </li>

    <c:if test="${usuarioLogado != null && !usuarioLogado.ativo}">
      <li class="nav-item mr-2">
        <span class="vt-topbar-pending-badge">
          <i class="fas fa-hourglass-half mr-1" aria-hidden="true"></i>
          Assinatura pendente
        </span>
      </li>
    </c:if>

    <div class="topbar-divider d-none d-sm-block"></div>

    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-tour-id="user-menu">
        <span class="mr-2 d-sm-inline text-gray-700 small">
          <i class="fas fa-user-circle"></i>
          ${usuarioLogado.nome}
        </span>
      </a>
    </li>
  </ul>
</nav>
