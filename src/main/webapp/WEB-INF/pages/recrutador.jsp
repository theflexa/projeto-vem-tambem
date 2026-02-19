<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Vem Também — Convite</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@600;700;800;900&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <style>
    :root{
      --olive:#6f7a00;
      --olive-soft:#91952d;
      --gold:#edb80a;
      --bg:#f5f7ef;
      --card:#ffffff;
      --text:#1f2937;
      --muted:#6b7280;
      --border:#e3e7d4;
      --radius:16px;
      --shadow:0 14px 30px rgba(29,35,17,.08);
    }

    *{box-sizing:border-box}
    body{margin:0;background:radial-gradient(circle at 5% 0%,#fbfbe8 0,#f5f7ef 46%,#eff3df 100%);color:var(--text);font:16px/1.55 "Poppins",sans-serif}
    .container{width:min(1140px,92%);margin:0 auto}

    .topbar{
      position:sticky;
      top:0;
      z-index:100;
      backdrop-filter:blur(8px);
      background:rgba(255,255,255,.82);
      border-bottom:1px solid rgba(111,122,0,.2);
    }
    .topbar .wrap{display:flex;align-items:center;justify-content:space-between;min-height:76px;gap:10px}
    .brand{display:flex;align-items:center;gap:12px}
    .brand img{height:48px;width:auto}
    .brand strong{font-family:"Nunito",sans-serif;font-size:1.1rem;color:#2f3a07}

    .btn{
      border:0;
      border-radius:12px;
      padding:.8rem 1.1rem;
      font-weight:700;
      cursor:pointer;
      font-family:"Poppins",sans-serif;
    }
    .btn-main{background:linear-gradient(140deg,var(--gold),#f2cb3b);color:#3f2f00}
    .btn-main:hover{filter:brightness(1.03)}
    .btn-outline{background:#fff;border:1px solid var(--border);color:#394112}

    .hero{padding:2.2rem 0 1.4rem}
    .hero-grid{display:grid;grid-template-columns:1.2fr .8fr;gap:1rem;align-items:stretch}
    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow)}
    .hero-copy{padding:1.4rem 1.5rem}
    .hero-copy h1{font-family:"Nunito",sans-serif;font-size:clamp(1.8rem,3.8vw,2.8rem);line-height:1.15;margin:0 0 .8rem;color:#2e370a}
    .hero-copy p{margin:0;color:var(--muted)}

    .hero-kpi{padding:1.4rem 1.5rem;display:grid;gap:.85rem}
    .kpi-line{padding:.72rem .8rem;border:1px solid var(--border);border-radius:12px;background:#fafcf3}
    .kpi-line b{display:block;font-size:1.15rem;color:#2f3a07}
    .kpi-line span{color:var(--muted);font-size:.9rem}

    section{padding:1rem 0 2rem}
    .section-title{font-family:"Nunito",sans-serif;font-size:1.5rem;color:#2f3a07;margin:0 0 .35rem}
    .section-sub{margin:0 0 1rem;color:var(--muted)}

    .jornadas-grid{display:grid;grid-template-columns:repeat(3,minmax(220px,1fr));gap:.85rem}
    .jornada-card{padding:1rem;border:1px solid var(--border);border-radius:14px;background:#fff;position:relative;overflow:hidden}
    .jornada-card.active{border-color:rgba(145,149,45,.5);background:linear-gradient(180deg,#fcffed 0%,#f8fbec 100%)}
    .jornada-card h3{margin:.2rem 0 .65rem;font-size:1.08rem;color:#2f3a07}
    .status-pill{display:inline-flex;align-items:center;gap:.35rem;border-radius:999px;padding:.18rem .55rem;font-size:.74rem;font-weight:700}
    .status-pill.active{background:#e3f5c8;color:#395402}
    .status-pill.inactive{background:#eceff5;color:#4b5563}
    .price-list{margin:.6rem 0 0;padding:0;list-style:none}
    .price-list li{display:flex;justify-content:space-between;gap:.5rem;padding:.2rem 0;border-bottom:1px dashed #e8ecd9}
    .price-list li:last-child{border-bottom:0}

    .steps{padding:1.1rem 1.2rem}
    .steps ol{margin:.2rem 0 0;padding-left:1.1rem}
    .steps li{margin:.35rem 0;color:#374151}

    footer{padding:1.4rem 0 1.8rem;color:var(--muted);text-align:center;font-size:.9rem}

    @media (max-width:980px){
      .hero-grid{grid-template-columns:1fr}
      .jornadas-grid{grid-template-columns:1fr 1fr}
    }
    @media (max-width:720px){
      .jornadas-grid{grid-template-columns:1fr}
      .topbar .wrap{min-height:68px}
      .brand img{height:40px}
      .btn{padding:.72rem .92rem}
    }
  </style>
</head>
<body>
<fmt:setLocale value="pt_BR" />

<div class="topbar">
  <div class="container wrap">
    <div class="brand">
      <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também"/>
      <strong>Vem Também</strong>
    </div>
    <form:form action="cadastrar" method="get">
      <input type="hidden" name="login" value="${login}"/>
      <button type="submit" class="btn btn-main">Entrar na rede</button>
    </form:form>
  </div>
</div>

<header class="hero">
  <div class="container hero-grid">
    <div class="card hero-copy">
      <h1>Rede colaborativa com jornadas configuráveis</h1>
      <p>
        Você entra por uma jornada, contribui com a taxa de manutenção e com a contribuição do ciclo,
        e acompanha sua evolução de forma transparente. Os valores abaixo são dinâmicos e atualizados pela administração.
      </p>
    </div>

    <div class="card hero-kpi">
      <c:if test="${not empty jornadaAtiva}">
        <div class="kpi-line">
          <b>${jornadaAtiva.nome}</b>
          <span>Jornada ativa no momento</span>
        </div>
        <div class="kpi-line">
          <b>R$ <fmt:formatNumber value="${jornadaAtiva.valorDoacao}" minFractionDigits="2" maxFractionDigits="2"/></b>
          <span>Contribuição da jornada</span>
        </div>
        <div class="kpi-line">
          <b>R$ <fmt:formatNumber value="${jornadaAtiva.valorTI}" minFractionDigits="2" maxFractionDigits="2"/></b>
          <span>Taxa de manutenção</span>
        </div>
      </c:if>
      <c:if test="${empty jornadaAtiva}">
        <div class="kpi-line">
          <b>Jornadas em atualização</b>
          <span>Consulte o suporte para os valores vigentes.</span>
        </div>
      </c:if>
    </div>
  </div>
</header>

<section>
  <div class="container">
    <h2 class="section-title">Jornadas disponíveis</h2>
    <p class="section-sub">As jornadas abaixo refletem exatamente a configuração atual do sistema.</p>

    <div class="jornadas-grid">
      <c:forEach var="tipoCiclo" items="${tiposCiclo}">
        <div class="jornada-card ${tipoCiclo.ativo ? 'active' : ''}">
          <span class="status-pill ${tipoCiclo.ativo ? 'active' : 'inactive'}">
            <i class="fas ${tipoCiclo.ativo ? 'fa-check-circle' : 'fa-pause-circle'}"></i>
            ${tipoCiclo.ativo ? 'Ativa' : 'Inativa'}
          </span>
          <h3>${tipoCiclo.nome}</h3>
          <ul class="price-list">
            <li>
              <span>Contribuição da jornada</span>
              <b>R$ <fmt:formatNumber value="${tipoCiclo.valorDoacao}" minFractionDigits="2" maxFractionDigits="2"/></b>
            </li>
            <li>
              <span>Taxa de manutenção</span>
              <b>R$ <fmt:formatNumber value="${tipoCiclo.valorTI}" minFractionDigits="2" maxFractionDigits="2"/></b>
            </li>
            <li>
              <span>Total de entrada</span>
              <b>R$ <fmt:formatNumber value="${tipoCiclo.valorDoacao + tipoCiclo.valorTI}" minFractionDigits="2" maxFractionDigits="2"/></b>
            </li>
          </ul>
        </div>
      </c:forEach>
    </div>
  </div>
</section>

<section>
  <div class="container card steps">
    <h2 class="section-title">Como começar</h2>
    <ol>
      <li>Faça seu cadastro pelo link de convite.</li>
      <li>Envie os comprovantes da taxa de manutenção e da contribuição da jornada vigente.</li>
      <li>Acompanhe sua posição na rede e a evolução por ciclo no painel.</li>
      <li>Após ativação, libere suas próximas contribuições dentro da própria plataforma.</li>
    </ol>

    <div style="margin-top:1rem;display:flex;gap:.6rem;flex-wrap:wrap">
      <form:form action="cadastrar" method="get">
        <input type="hidden" name="login" value="${login}"/>
        <button type="submit" class="btn btn-main">Quero me cadastrar</button>
      </form:form>
      <a href="<c:url value='/faq'/>" class="btn btn-outline">Tirar dúvidas</a>
    </div>
  </div>
</section>

<footer>
  <div class="container">Copyright © Vem Também 2025-2026</div>
</footer>

<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
</body>
</html>
