<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Vem Também - Convite</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700;800;900&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-layout.css" var="vtlayoutcss" />
  <link href="${vtlayoutcss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-components.css" var="vtcomponentscss" />
  <link href="${vtcomponentscss}" rel="stylesheet"/>

  <style>
    /* ─── Tokens ─────────────────────────────────────────── */
    :root {
      --olive:      #6f7a00;
      --olive-dark: #4b5400;
      --olive-700:  #5c6600;
      --gold:       #f3c900;
      --shell:      #e8ece0;
      --card:       #edf1e6;
      --muted:      #5b6370;
      --radius-lg:  24px;
      --radius-xl:  32px;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      font-family: Poppins, Nunito, system-ui, sans-serif;
      background: #f0f4e9;
      color: #1f2937;
      overflow-x: hidden;
    }

    /* ─── Topbar ─────────────────────────────────────────── */
    .vt-convite-topbar {
      position: sticky;
      top: 0;
      z-index: 50;
      backdrop-filter: blur(8px);
      background: rgba(240, 244, 233, .88);
      border-bottom: 1px solid rgba(111, 122, 0, .12);
      transition: box-shadow 0.3s ease, background 0.3s ease;
    }

    .vt-convite-topbar.scrolled {
      box-shadow: 0 4px 20px rgba(47, 58, 7, 0.13);
      background: rgba(240, 244, 233, .96);
    }

    .vt-topbar-inner {
      width: min(1160px, 94%);
      margin: 0 auto;
      min-height: 72px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
    }

    .vt-brand {
      display: flex;
      align-items: center;
      text-decoration: none;
      flex-shrink: 0;
    }

    .vt-brand img {
      height: 44px;
      width: auto;
    }

    .vt-nav-links {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .vt-link-btn {
      border: 1px solid rgba(111, 122, 0, .22);
      border-radius: 999px;
      text-decoration: none;
      color: #344014;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .85rem;
      font-weight: 600;
      transition: background 0.2s, color 0.2s;
      white-space: nowrap;
    }

    .vt-link-btn:hover {
      text-decoration: none;
      color: #28340f;
      background: rgba(111, 122, 0, .08);
    }

    .vt-cta-btn {
      display: inline-block;
      border: none;
      border-radius: 999px;
      cursor: pointer;
      background: linear-gradient(90deg, var(--olive-dark), var(--olive) 60%, #8a9410);
      color: #fff;
      padding: .6rem 1.25rem;
      font-size: .88rem;
      font-weight: 700;
      font-family: inherit;
      box-shadow: 0 6px 18px rgba(111, 122, 0, .28);
      text-decoration: none;
      transition: transform 0.2s, box-shadow 0.2s;
      white-space: nowrap;
    }

    .vt-cta-btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 10px 24px rgba(111, 122, 0, .35);
      text-decoration: none;
      color: #fff;
    }

    .vt-cta-btn.vt-cta-lg {
      padding: .9rem 2.2rem;
      font-size: 1.05rem;
      box-shadow: 0 12px 32px rgba(111, 122, 0, .3);
    }

    .vt-cta-btn.vt-cta-outline {
      background: transparent;
      border: 2px solid rgba(255,255,255,.7);
      color: #fff;
      box-shadow: none;
    }

    .vt-cta-btn.vt-cta-outline:hover {
      background: rgba(255,255,255,.12);
      color: #fff;
      box-shadow: none;
    }

    /* ─── Animations ─────────────────────────────────────── */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    .vt-anim-1 { animation: fadeUp .75s cubic-bezier(0.25, 0.46, 0.45, 0.94) both; }
    .vt-anim-2 { animation: fadeUp .75s .15s cubic-bezier(0.25, 0.46, 0.45, 0.94) both; }
    .vt-anim-3 { animation: fadeUp .75s .3s  cubic-bezier(0.25, 0.46, 0.45, 0.94) both; }
    .vt-anim-4 { animation: fadeUp .75s .45s cubic-bezier(0.25, 0.46, 0.45, 0.94) both; }

    /* Scroll Reveal */
    .vt-reveal {
      opacity: 0;
      transform: translateY(24px);
      transition: opacity 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94),
                  transform 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .vt-reveal.visible {
      opacity: 1;
      transform: translateY(0);
    }

    /* ─── Image Placeholders ─────────────────────────────── */
    .vt-img-placeholder {
      background: linear-gradient(135deg, #edf1e6, #d5dfc8);
      border: 2px dashed rgba(111, 122, 0, .3);
      border-radius: var(--radius-xl);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: rgba(111, 122, 0, .55);
      gap: .6rem;
      text-align: center;
      padding: 2rem;
    }

    .vt-img-placeholder i {
      font-size: 2rem;
      opacity: .6;
    }

    .vt-img-placeholder span {
      font-size: .82rem;
      font-weight: 600;
      line-height: 1.4;
      max-width: 180px;
    }

    /* ─── Hero Section ───────────────────────────────────── */
    .vt-hero-section {
      min-height: 90vh;
      display: flex;
      align-items: center;
      position: relative;
      overflow: hidden;
      padding: 5rem 0 4rem;
      background:
        radial-gradient(ellipse 900px 600px at -10% -20%, rgba(243, 201, 0, .22) 0%, transparent 55%),
        radial-gradient(ellipse 700px 500px at 110% 110%, rgba(111, 122, 0, .15) 0%, transparent 55%),
        linear-gradient(165deg, #eff3e8 0%, #e1e8d6 100%);
    }

    .vt-hero-inner {
      width: min(1160px, 94%);
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 4rem;
      align-items: center;
    }

    .vt-eyebrow {
      display: inline-flex;
      align-items: center;
      gap: .45rem;
      border-radius: 999px;
      background: rgba(111, 122, 0, .1);
      border: 1px solid rgba(111, 122, 0, .2);
      color: var(--olive-dark);
      font-size: .78rem;
      font-weight: 700;
      padding: .35rem .85rem;
      letter-spacing: .04em;
      text-transform: uppercase;
      margin-bottom: 1.25rem;
    }

    .vt-hero-title {
      margin: 0 0 1.2rem;
      color: #1e2a05;
      font-family: Nunito, sans-serif;
      font-size: clamp(2.2rem, 5vw, 3.8rem);
      font-weight: 900;
      line-height: 1.1;
      letter-spacing: -.02em;
    }

    .vt-hero-title em {
      font-style: normal;
      background: linear-gradient(90deg, var(--olive-dark), var(--olive) 50%, #8a9410);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .vt-hero-subtitle {
      margin: 0 0 2rem;
      color: #4b5563;
      font-size: clamp(1rem, 2vw, 1.15rem);
      line-height: 1.7;
    }

    .vt-hero-figure {
      aspect-ratio: 16 / 9;
      max-height: 360px;
    }

    /* ─── Section: Venha fazer parte ────────────────────── */
    .vt-split-section {
      padding: 6rem 0;
      background: #e8ece0;
    }

    .vt-split-inner {
      width: min(1160px, 94%);
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 4rem;
      align-items: center;
    }

    .vt-section-eyebrow {
      display: inline-block;
      color: var(--olive-dark);
      font-size: .78rem;
      font-weight: 700;
      letter-spacing: .06em;
      text-transform: uppercase;
      margin-bottom: 1rem;
    }

    .vt-section-title {
      margin: 0 0 1rem;
      color: #1e2a05;
      font-family: Nunito, sans-serif;
      font-size: clamp(1.7rem, 3.5vw, 2.6rem);
      font-weight: 900;
      line-height: 1.15;
    }

    .vt-section-body {
      color: #4b5563;
      font-size: 1rem;
      line-height: 1.7;
      margin: 0 0 1.8rem;
    }

    .vt-benefit-list {
      list-style: none;
      margin: 0 0 2rem;
      padding: 0;
      display: flex;
      flex-direction: column;
      gap: .75rem;
    }

    .vt-benefit-list li {
      display: flex;
      align-items: flex-start;
      gap: .75rem;
      font-size: .95rem;
      color: #374151;
    }

    .vt-benefit-list li .vt-check {
      flex-shrink: 0;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--olive-dark), var(--olive));
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: .7rem;
      margin-top: 1px;
    }

    .vt-split-figure {
      aspect-ratio: 4 / 5;
    }

    /* ─── Section: Jornada Ativa ────────────────────────── */
    .vt-journey-section {
      padding: 6rem 0;
      background: #f0f4e9;
    }

    .vt-journey-inner {
      width: min(1160px, 94%);
      margin: 0 auto;
    }

    .vt-section-header {
      text-align: center;
      margin-bottom: 3rem;
    }

    .vt-journey-card {
      max-width: 600px;
      margin: 0 auto;
      background: linear-gradient(160deg, rgba(255,255,255,.9) 0%, rgba(237,241,230,.95) 100%);
      border: 1px solid rgba(111, 122, 0, .3);
      border-radius: var(--radius-xl);
      box-shadow: 0 20px 60px rgba(111, 122, 0, .12), 0 4px 16px rgba(0,0,0,.06);
      padding: 2.5rem;
      backdrop-filter: blur(4px);
    }

    .vt-journey-card-name {
      font-family: Nunito, sans-serif;
      font-size: 1.5rem;
      font-weight: 900;
      color: #1e2a05;
      margin: 0 0 .5rem;
    }

    .vt-journey-badge {
      display: inline-flex;
      align-items: center;
      gap: .35rem;
      border-radius: 999px;
      background: #e4f5cb;
      color: #2f4f00;
      font-size: .75rem;
      font-weight: 700;
      padding: .28rem .7rem;
      margin-bottom: 1.5rem;
    }

    .vt-price-rows {
      display: flex;
      flex-direction: column;
      gap: 0;
    }

    .vt-price-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: .9rem 0;
      border-bottom: 1px solid rgba(111, 122, 0, .12);
      font-size: .95rem;
    }

    .vt-price-row:last-child {
      border-bottom: none;
      padding-top: 1.1rem;
    }

    .vt-price-row .vt-price-label {
      color: var(--muted);
    }

    .vt-price-row .vt-price-value {
      font-weight: 700;
      color: #1e2a05;
      font-size: 1.05rem;
      font-variant-numeric: tabular-nums;
    }

    .vt-price-row.vt-total .vt-price-value {
      font-family: Nunito, sans-serif;
      font-size: 1.4rem;
      font-weight: 900;
      color: var(--olive-dark);
    }

    .vt-empty-journey {
      text-align: center;
      padding: 3rem 2rem;
      background: rgba(111, 122, 0, .05);
      border: 1px dashed rgba(111, 122, 0, .22);
      border-radius: var(--radius-xl);
      max-width: 460px;
      margin: 0 auto;
    }

    .vt-empty-journey i {
      font-size: 2.5rem;
      color: rgba(111, 122, 0, .35);
      margin-bottom: 1rem;
    }

    .vt-empty-journey p {
      margin: 0;
      color: var(--muted);
      font-size: .95rem;
    }

    /* ─── Section: Como Funciona ─────────────────────────── */
    .vt-how-section {
      padding: 6rem 0;
      background: #e8ece0;
    }

    .vt-how-inner {
      width: min(1160px, 94%);
      margin: 0 auto;
    }

    .vt-steps-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1.5rem;
      margin-top: 3rem;
    }

    .vt-step-card {
      background: rgba(255,255,255,.75);
      border: 1px solid rgba(111, 122, 0, .12);
      border-radius: var(--radius-lg);
      padding: 2rem 1.5rem;
      transition: transform 0.3s, box-shadow 0.3s;
    }

    .vt-step-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 16px 40px rgba(111, 122, 0, .14);
    }

    .vt-step-number {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 48px;
      height: 48px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--olive-dark), var(--olive));
      color: #fff;
      font-family: Nunito, sans-serif;
      font-size: 1.1rem;
      font-weight: 900;
      margin-bottom: 1.1rem;
    }

    .vt-step-title {
      margin: 0 0 .5rem;
      color: #1e2a05;
      font-family: Nunito, sans-serif;
      font-size: 1.05rem;
      font-weight: 800;
    }

    .vt-step-desc {
      margin: 0;
      color: var(--muted);
      font-size: .88rem;
      line-height: 1.6;
    }

    /* ─── Section: CTA Final ─────────────────────────────── */
    .vt-cta-section {
      padding: 7rem 0;
      background: linear-gradient(135deg, #4b5400 0%, var(--olive) 50%, #f3c900 120%);
      text-align: center;
    }

    .vt-cta-inner {
      width: min(720px, 90%);
      margin: 0 auto;
    }

    .vt-cta-eyebrow {
      display: inline-block;
      color: rgba(255,255,255,.7);
      font-size: .78rem;
      font-weight: 700;
      letter-spacing: .06em;
      text-transform: uppercase;
      margin-bottom: 1.25rem;
    }

    .vt-cta-title {
      margin: 0 0 1.25rem;
      color: #fff;
      font-family: Nunito, sans-serif;
      font-size: clamp(1.9rem, 4vw, 2.9rem);
      font-weight: 900;
      line-height: 1.15;
    }

    .vt-cta-body {
      margin: 0 0 2.5rem;
      color: rgba(255,255,255,.85);
      font-size: 1.05rem;
      line-height: 1.7;
    }

    /* ─── Footer ─────────────────────────────────────────── */
    .vt-site-footer {
      background: #1e2a05;
      color: rgba(255,255,255,.55);
      text-align: center;
      padding: 2rem 1rem;
      font-size: .84rem;
    }

    .vt-site-footer a {
      color: rgba(255,255,255,.7);
      text-decoration: none;
      font-weight: 600;
    }

    .vt-site-footer a:hover {
      color: #fff;
    }

    .vt-footer-links {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 1.25rem;
      margin-top: .6rem;
    }

    /* ─── Focus styles ───────────────────────────────────── */
    .vt-cta-btn:focus-visible,
    .vt-link-btn:focus-visible {
      outline: 2px solid var(--olive);
      outline-offset: 3px;
    }

    /* ─── Reduced motion ─────────────────────────────────── */
    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
        animation-duration: 0.01ms !important;
        transition-duration: 0.01ms !important;
      }
    }

    /* ─── Responsive ─────────────────────────────────────── */
    @media (max-width: 900px) {
      .vt-hero-inner,
      .vt-split-inner {
        grid-template-columns: 1fr;
        gap: 2.5rem;
      }

      .vt-hero-figure {
        max-height: 280px;
      }

      .vt-steps-grid {
        grid-template-columns: 1fr 1fr;
      }

      .vt-split-figure {
        aspect-ratio: 16 / 9;
        order: -1;
      }
    }

    @media (max-width: 600px) {
      .vt-hero-section {
        padding: 4rem 0 3rem;
        min-height: auto;
      }

      .vt-link-btn {
        padding: .4rem .7rem;
        font-size: .78rem;
      }

      .vt-steps-grid {
        grid-template-columns: 1fr;
      }

      .vt-split-section,
      .vt-journey-section,
      .vt-how-section {
        padding: 4rem 0;
      }

      .vt-cta-section {
        padding: 5rem 0;
      }
    }
  </style>
</head>
<body>
<fmt:setLocale value="pt_BR" />
<c:set var="cp" value="${pageContext.request.contextPath}" />

<%-- ═══ TOPBAR ═══════════════════════════════════════════════════════════ --%>
<header class="vt-convite-topbar" id="topbar">
  <div class="vt-topbar-inner">
    <a class="vt-brand" href="${cp}/">
      <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também" />
    </a>

    <nav class="vt-nav-links" aria-label="Navegação principal">
      <a class="vt-link-btn" href="${cp}/">
        <i class="fas fa-sign-in-alt" aria-hidden="true" style="margin-right:.35rem;"></i>Entrar
      </a>
      <form:form action="cadastrar" method="get" cssStyle="margin:0;" aria-label="Formulário de cadastro">
        <input type="hidden" name="login" value="<c:out value='${login}'/>" />
        <button type="submit" class="vt-cta-btn">Quero me cadastrar</button>
      </form:form>
    </nav>
  </div>
</header>

<%-- ═══ HERO ═══════════════════════════════════════════════════════════ --%>
<main>
<section class="vt-hero-section">
  <div class="vt-hero-inner">
    <div class="vt-hero-text">
      <div class="vt-eyebrow vt-anim-1">
        <i class="fas fa-envelope-open-text" aria-hidden="true"></i>
        Você recebeu um convite
      </div>
      <h1 class="vt-hero-title vt-anim-2">
        Entre para uma rede que<br>
        <em>cresce junto com você</em>
      </h1>
      <p class="vt-hero-subtitle vt-anim-3">
        Você entra por uma jornada ativa, realiza a contribuição e a taxa de manutenção,
        e acompanha tudo no painel com transparência e simplicidade.
      </p>
      <div class="vt-anim-4">
        <form:form action="cadastrar" method="get" cssStyle="display:inline;" aria-label="Formulário de cadastro">
          <input type="hidden" name="login" value="<c:out value='${login}'/>" />
          <button type="submit" class="vt-cta-btn vt-cta-lg">
            <i class="fas fa-user-plus" aria-hidden="true" style="margin-right:.5rem;"></i>
            Quero me cadastrar
          </button>
        </form:form>
      </div>
    </div>

    <figure class="vt-hero-figure vt-img-placeholder vt-anim-3" role="img"
            aria-label="Espaço para foto da comunidade" style="margin:0;">
      <i class="fas fa-camera" aria-hidden="true"></i>
      <span>Espaço para foto da comunidade</span>
    </figure>
  </div>
</section>

<%-- ═══ VENHA FAZER PARTE ════════════════════════════════════════════════ --%>
<section class="vt-split-section">
  <div class="vt-split-inner">
    <div class="vt-reveal">
      <span class="vt-section-eyebrow">Por que entrar</span>
      <h2 class="vt-section-title">Venha fazer parte dessa rede</h2>
      <p class="vt-section-body">
        A Vem Também é uma rede colaborativa onde cada pessoa apoia quem chegou antes
        e recebe apoio de quem chega depois. Simples, transparente e humano.
      </p>
      <ul class="vt-benefit-list">
        <li>
          <span class="vt-check"><i class="fas fa-check" aria-hidden="true"></i></span>
          Acompanhe sua posição em tempo real pelo painel
        </li>
        <li>
          <span class="vt-check"><i class="fas fa-check" aria-hidden="true"></i></span>
          Histórico completo de ciclos e movimentações
        </li>
        <li>
          <span class="vt-check"><i class="fas fa-check" aria-hidden="true"></i></span>
          Suporte via WhatsApp com a equipe
        </li>
        <li>
          <span class="vt-check"><i class="fas fa-check" aria-hidden="true"></i></span>
          Ativação rápida após envio dos comprovantes
        </li>
      </ul>
      <form:form action="cadastrar" method="get" cssStyle="display:inline;" aria-label="Formulário de cadastro">
        <input type="hidden" name="login" value="<c:out value='${login}'/>" />
        <button type="submit" class="vt-cta-btn">
          Começar agora <i class="fas fa-arrow-right" aria-hidden="true" style="margin-left:.4rem;"></i>
        </button>
      </form:form>
    </div>

    <figure class="vt-split-figure vt-img-placeholder vt-reveal" role="img"
            aria-label="Espaço para foto da equipe ou comunidade" style="margin:0;">
      <i class="fas fa-users" aria-hidden="true"></i>
      <span>Espaço para foto da equipe ou comunidade</span>
    </figure>
  </div>
</section>

<%-- ═══ JORNADA ATIVA ═════════════════════════════════════════════════════ --%>
<section class="vt-journey-section">
  <div class="vt-journey-inner">
    <div class="vt-section-header vt-reveal">
      <span class="vt-section-eyebrow">Valores vigentes</span>
      <h2 class="vt-section-title">Jornada disponível para entrada</h2>
      <p class="vt-section-body" style="max-width:520px; margin: 0 auto;">
        Apenas jornadas ativas são exibidas aqui. Os valores refletem a configuração atual da plataforma.
      </p>
    </div>

    <c:if test="${not empty jornadaAtiva}">
      <div class="vt-journey-card vt-reveal">
        <span class="vt-journey-badge">
          <i class="fas fa-check-circle" aria-hidden="true"></i> Ativa agora
        </span>
        <h3 class="vt-journey-card-name"><c:out value="${jornadaAtiva.nome}"/></h3>
        <div class="vt-price-rows">
          <div class="vt-price-row">
            <span class="vt-price-label">Contribuição da jornada</span>
            <span class="vt-price-value">R$ <fmt:formatNumber value="${jornadaAtiva.valorDoacao}" minFractionDigits="2" maxFractionDigits="2"/></span>
          </div>
          <div class="vt-price-row">
            <span class="vt-price-label">Taxa de manutenção</span>
            <span class="vt-price-value">R$ <fmt:formatNumber value="${jornadaAtiva.valorTI}" minFractionDigits="2" maxFractionDigits="2"/></span>
          </div>
          <div class="vt-price-row vt-total">
            <span class="vt-price-label" style="font-weight:700; color:#1e2a05;">Total de entrada</span>
            <span class="vt-price-value">R$ <fmt:formatNumber value="${jornadaAtiva.valorDoacao + jornadaAtiva.valorTI}" minFractionDigits="2" maxFractionDigits="2"/></span>
          </div>
        </div>
      </div>
    </c:if>

    <c:if test="${empty jornadaAtiva}">
      <div class="vt-empty-journey vt-reveal">
        <i class="fas fa-clock" aria-hidden="true"></i>
        <p>Nenhuma jornada aberta no momento.</p>
        <p style="margin-top:.6rem;">
          <a href="https://wa.me/559184415184?text=Ol%C3%A1!%20Tenho%20d%C3%BAvidas%20sobre%20as%20jornadas%20vigentes"
             target="_blank" rel="noopener noreferrer"
             class="vt-cta-btn" style="display:inline-flex; align-items:center; gap:.4rem; margin-top:.5rem;">
            <i class="fab fa-whatsapp" aria-hidden="true"></i>Fale pelo WhatsApp
          </a>
        </p>
      </div>
    </c:if>
  </div>
</section>

<%-- ═══ COMO FUNCIONA ══════════════════════════════════════════════════════ --%>
<section class="vt-how-section">
  <div class="vt-how-inner">
    <div class="vt-section-header vt-reveal">
      <span class="vt-section-eyebrow">Passo a passo</span>
      <h2 class="vt-section-title">Como começar</h2>
    </div>

    <div class="vt-steps-grid">
      <article class="vt-step-card vt-reveal" style="transition-delay:.05s">
        <div class="vt-step-number" aria-label="Passo 1">1</div>
        <h3 class="vt-step-title">
          <i class="fas fa-user-plus" aria-hidden="true" style="margin-right:.4rem; color:var(--olive);"></i>
          Faça seu cadastro
        </h3>
        <p class="vt-step-desc">Use o link de convite para criar sua conta. Leva menos de 2 minutos.</p>
      </article>

      <article class="vt-step-card vt-reveal" style="transition-delay:.15s">
        <div class="vt-step-number" aria-label="Passo 2">2</div>
        <h3 class="vt-step-title">
          <i class="fas fa-file-upload" aria-hidden="true" style="margin-right:.4rem; color:var(--olive);"></i>
          Envie os comprovantes
        </h3>
        <p class="vt-step-desc">Envie a taxa de manutenção e a contribuição da jornada vigente.</p>
      </article>

      <article class="vt-step-card vt-reveal" style="transition-delay:.25s">
        <div class="vt-step-number" aria-label="Passo 3">3</div>
        <h3 class="vt-step-title">
          <i class="fas fa-chart-line" aria-hidden="true" style="margin-right:.4rem; color:var(--olive);"></i>
          Acompanhe sua posição
        </h3>
        <p class="vt-step-desc">Veja sua evolução por ciclo no painel com total transparência.</p>
      </article>

      <article class="vt-step-card vt-reveal" style="transition-delay:.35s">
        <div class="vt-step-number" aria-label="Passo 4">4</div>
        <h3 class="vt-step-title">
          <i class="fas fa-rocket" aria-hidden="true" style="margin-right:.4rem; color:var(--olive);"></i>
          Ative e avance
        </h3>
        <p class="vt-step-desc">Após a ativação, siga seus próximos passos direto na plataforma.</p>
      </article>
    </div>
  </div>
</section>

<%-- ═══ CTA FINAL ════════════════════════════════════════════════════════ --%>
<section class="vt-cta-section">
  <div class="vt-cta-inner vt-reveal">
    <span class="vt-cta-eyebrow">Pronto para começar?</span>
    <h2 class="vt-cta-title">Sua jornada começa com um cadastro</h2>
    <p class="vt-cta-body">
      Você foi convidado por alguém de confiança. Dê o próximo passo e entre para a rede.
    </p>
    <form:form action="cadastrar" method="get" cssStyle="display:inline;" aria-label="Formulário de cadastro">
      <input type="hidden" name="login" value="<c:out value='${login}'/>" />
      <button type="submit" class="vt-cta-btn vt-cta-outline vt-cta-lg">
        <i class="fas fa-user-plus" aria-hidden="true" style="margin-right:.5rem;"></i>
        Entrar para a rede
      </button>
    </form:form>
  </div>
</section>

</main>

<%-- ═══ FOOTER ════════════════════════════════════════════════════════════ --%>
<footer class="vt-site-footer">
  <div>Copyright &copy; Vem Também 2025&#8211;2026</div>
  <nav class="vt-footer-links" aria-label="Links do rodapé">
    <a href="${cp}/faq">FAQ</a>
    <a href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Tamb%C3%A9m"
       target="_blank" rel="noopener noreferrer"
       aria-label="Suporte via WhatsApp (abre em nova janela)">
      <i class="fab fa-whatsapp" aria-hidden="true" style="margin-right:.25rem;"></i>Suporte
    </a>
    <a href="${cp}/"><i class="fas fa-sign-in-alt" aria-hidden="true" style="margin-right:.25rem;"></i>Entrar</a>
  </nav>
</footer>

<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script>
  // ── Topbar scroll shadow ───────────────────────────────────────────────
  (function () {
    var topbar = document.getElementById('topbar');
    if (!topbar) return;
    window.addEventListener('scroll', function () {
      topbar.classList.toggle('scrolled', window.scrollY > 40);
    }, { passive: true });
  })();

  // ── Scroll Reveal (IntersectionObserver) ──────────────────────────────
  (function () {
    var elements = document.querySelectorAll('.vt-reveal');
    if (!elements.length) return;

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    elements.forEach(function (el) {
      observer.observe(el);
    });
  })();
</script>
</body>
</html>
