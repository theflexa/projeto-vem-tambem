<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Vem Também - Jornadas</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@500;700;800&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-layout.css" var="vtlayoutcss" />
  <link href="${vtlayoutcss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-components.css" var="vtcomponentscss" />
  <link href="${vtcomponentscss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-tour.css" var="vttourcss" />
  <link href="${vttourcss}" rel="stylesheet"/>
  <spring:url value="/resources/vendor/introjs/introjs.min.css" var="introcss" />
  <link href="${introcss}" rel="stylesheet"/>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<div id="wrapper">
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <c:set var="jornadaAtual" value="${empty nomeJornadaAtual ? 'Jornada da Semente' : nomeJornadaAtual}" />

        <div class="content-surface mb-4" data-tour-id="jornadas-intro">
          <h1 class="h3 mb-1">Jornadas</h1>
          <p class="mb-0">Cada etapa possui uma identidade visual e um objetivo. Conclua uma para avançar para a próxima.</p>
        </div>

        <div class="vt-journey-gallery" data-tour-id="jornadas-cards">
          <article class="vt-journey-media-card ${jornadaAtual eq 'Jornada da Semente' ? 'active' : ''}">
            <img src="<c:url value='/resources/img/jornadas/semente.svg'/>" alt="Jornada da Semente">
            <div class="vt-journey-media-body">
              <span class="vt-journey-badge">${jornadaAtual eq 'Jornada da Semente' ? 'Ativa' : 'Disponível'}</span>
              <h5>Jornada da Semente</h5>
              <p>Início da operação: foco em ativação da rede e conclusão das 8 doações do ciclo.</p>
              <a href="<c:url value='/usuario/donatarios'/>" class="btn btn-olive btn-sm px-3">Ir para Minha Contribuição</a>
            </div>
          </article>

          <article class="vt-journey-media-card ${jornadaAtual eq 'Jornada do Jardim' ? 'active' : 'coming'}">
            <img src="<c:url value='/resources/img/jornadas/jardim.svg'/>" alt="Jornada do Jardim">
            <div class="vt-journey-media-body">
              <span class="vt-journey-badge">${jornadaAtual eq 'Jornada do Jardim' ? 'Ativa' : 'Em breve'}</span>
              <h5>Jornada do Jardim</h5>
              <p>Evolução da estrutura com novos objetivos e maior potencial de crescimento na rede.</p>
              <button type="button" class="btn btn-olive-outline btn-sm px-3" disabled>Liberação em breve</button>
            </div>
          </article>

          <article class="vt-journey-media-card ${jornadaAtual eq 'Jornada da Floresta' ? 'active' : 'coming'}">
            <img src="<c:url value='/resources/img/jornadas/floresta.svg'/>" alt="Jornada da Floresta">
            <div class="vt-journey-media-body">
              <span class="vt-journey-badge">${jornadaAtual eq 'Jornada da Floresta' ? 'Ativa' : 'Em breve'}</span>
              <h5>Jornada da Floresta</h5>
              <p>Nível avançado para usuários que concluem as jornadas anteriores com consistência.</p>
              <button type="button" class="btn btn-olive-outline btn-sm px-3" disabled>Liberação em breve</button>
            </div>
          </article>
        </div>
      </div>
    </div>

    <footer class="sticky-footer">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>&copy; Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>
