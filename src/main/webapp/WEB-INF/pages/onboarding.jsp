<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Vem Também — Boas-vindas</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@600;700;800;900&display=swap" rel="stylesheet">
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

  <style>
    .vt-onboarding-shell {
      max-width: 980px;
      margin: 0 auto;
      padding: 1rem;
    }

    .vt-onboarding-hero {
      border-radius: 28px;
      border: 1px solid rgba(34, 84, 61, 0.12);
      box-shadow: 0 16px 32px rgba(31, 41, 55, 0.14);
      background: linear-gradient(170deg, #ffffff 0%, #f6faed 75%);
      padding: clamp(18px, 3vw, 32px);
    }

    .vt-step-grid {
      margin-top: 1rem;
      display: grid;
      grid-template-columns: repeat(12, minmax(0, 1fr));
      gap: 0.9rem;
    }

    .vt-step-card {
      grid-column: span 4 / span 4;
      padding: 1rem;
      border-radius: 20px;
      border: 1px solid rgba(34, 84, 61, 0.1);
      background: #ffffff;
      box-shadow: 0 8px 20px rgba(31, 41, 55, 0.08);
    }

    .vt-step-title {
      color: #1f2937;
      font-weight: 900;
      margin: 0.55rem 0 0.3rem;
      font-size: 1.05rem;
    }

    .vt-step-copy {
      color: #6b7280;
      margin-bottom: 0;
      font-size: 0.94rem;
    }

    .vt-action-row {
      margin-top: 1rem;
      display: flex;
      gap: 0.6rem;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
    }

    .vt-tip {
      border-radius: 16px;
      border: 1px solid rgba(34, 84, 61, 0.12);
      background: #ebf8df;
      color: #20573b;
      padding: 0.7rem 0.9rem;
      font-size: 0.9rem;
      font-weight: 700;
    }

    @media (max-width: 991.98px) {
      .vt-step-card {
        grid-column: span 12 / span 12;
      }
    }
  </style>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">
  <div class="container-fluid pt-2">
    <jsp:include page="/WEB-INF/includes/topbar.jsp" />

    <div class="vt-onboarding-shell" data-tour-id="onboarding-steps">
      <section class="vt-onboarding-hero">
        <div class="d-flex align-items-center justify-content-between flex-wrap">
          <div class="pr-2">
            <span class="vt-kicker">
              <lord-icon src="<c:url value='/resources/vendor/lordicon/icons/ujxzdfjx.json'/>" trigger="loop" delay="2500" colors="primary:#2f855a,secondary:#f6d23a" style="width:18px;height:18px"></lord-icon>
              Nova jornada
            </span>
            <h1 class="vt-title mt-2 mb-1">Bem-vindo, ${usuarioLogado.nome}!</h1>
            <p class="vt-subtitle mb-0">
              Você já está na plataforma. Em 3 passos rápidos, você entende como avançar com clareza.
            </p>
          </div>
        </div>

        <div class="vt-step-grid">
          <article class="vt-step-card">
            <span class="vt-chip vt-chip-success">Passo 1</span>
            <h2 class="vt-step-title">Ative sua conta</h2>
            <p class="vt-step-copy">
              Faça o envio do comprovante de ativação para liberar toda sua operação.
            </p>
          </article>
          <article class="vt-step-card">
            <span class="vt-chip vt-chip-warning">Passo 2</span>
            <h2 class="vt-step-title">Realize sua contribuição</h2>
            <p class="vt-step-copy">
              Acesse “Minha Contribuição”, confira os dados e envie seu comprovante.
            </p>
          </article>
          <article class="vt-step-card">
            <span class="vt-chip vt-chip-success">Passo 3</span>
            <h2 class="vt-step-title">Acompanhe sua rede</h2>
            <p class="vt-step-copy">
              Veja progresso em “Minha Rede” e “Doadores” para saber seu próximo movimento.
            </p>
          </article>
        </div>

        <div class="vt-action-row">
          <div class="vt-tip">
            Dica: use o botão <strong>Tutorial</strong> no topo para guia interativo com foco por tela.
          </div>
          <a href="<c:url value='/painel'/>" class="btn btn-olive px-4">
            Quero começar <i class="fas fa-arrow-right ml-1"></i>
          </a>
        </div>
      </section>
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
