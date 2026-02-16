<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Vem Também — Bem-vindo!</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <c:set var="cp" value="${pageContext.request.contextPath}" />

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>

  <!-- Lottie Player -->
  <script src="https://unpkg.com/@lottiefiles/lottie-player@2.0.8/dist/lottie-player.js"></script>

  <style>
    :root {
      --olive: #6f7a00; --olive-700: #5b6400; --gold: #f3c900;
      --ink: #1f2937; --muted: #6b7280; --radius: 18px;
    }
    html, body {
      font-family: Inter, system-ui, -apple-system, sans-serif;
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      min-height: 100vh; margin: 0;
    }

    /* Container central */
    .onboarding-wrapper {
      display: flex; align-items: center; justify-content: center;
      min-height: 100vh; padding: 1rem;
    }
    .onboarding-card {
      background: #ffffffee; backdrop-filter: blur(10px);
      border-radius: var(--radius); box-shadow: 0 20px 60px rgba(0,0,0,.15);
      max-width: 640px; width: 100%; padding: 2.5rem 2rem;
      text-align: center; position: relative; overflow: hidden;
    }

    /* Steps */
    .step { display: none; }
    .step.active { display: block; animation: fadeInUp 0.5s ease both; }

    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .step h2 { color: var(--ink); font-weight: 800; font-size: 1.6rem; margin-bottom: .5rem; }
    .step p { color: var(--muted); font-size: 1rem; line-height: 1.6; }

    /* Botões */
    .btn-olive {
      background: linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%);
      border: 0; color: #141a00; font-weight: 700; border-radius: 999px;
      padding: .6rem 2rem; font-size: 1rem; cursor: pointer;
      transition: filter 0.2s ease;
    }
    .btn-olive:hover { filter: brightness(.92); }
    .btn-outline-olive {
      background: transparent; border: 2px solid var(--olive); color: var(--olive);
      font-weight: 700; border-radius: 999px; padding: .5rem 1.5rem;
      cursor: pointer; transition: all 0.2s ease;
    }
    .btn-outline-olive:hover { background: var(--olive); color: #fff; }

    /* Dots de progresso */
    .step-dots { display: flex; justify-content: center; gap: .5rem; margin-top: 1.5rem; }
    .step-dots .dot {
      width: 10px; height: 10px; border-radius: 50%;
      background: #d1d5db; transition: background 0.3s;
    }
    .step-dots .dot.active { background: var(--olive); }

    /* Tabuleiro demo */
    .demo-board {
      display: flex; flex-direction: column; align-items: center; gap: .5rem;
      margin: 1.5rem 0;
    }
    .demo-row { display: flex; gap: .75rem; justify-content: center; }
    .demo-node {
      background: #f3f4f6; border: 2px solid #e5e7eb;
      border-radius: 12px; padding: .4rem .8rem; font-size: .85rem;
      font-weight: 600; color: var(--ink); position: relative;
      transition: all 0.3s ease;
    }
    .demo-node.you {
      background: var(--olive); color: #fff; border-color: var(--olive);
      box-shadow: 0 0 0 4px rgba(111,122,0,.2);
    }
    .demo-node.donatario {
      background: #fef3c7; border-color: #f59e0b; color: #92400e;
    }
    .demo-node.doador {
      background: #d1fae5; border-color: #10b981; color: #065f46;
    }
    .demo-arrow { color: var(--muted); font-size: 1.2rem; }
    .demo-label {
      font-size: .75rem; font-weight: 700; color: var(--olive);
      margin-top: .25rem;
    }

    /* Lottie */
    lottie-player { margin: 0 auto; }

    /* Info box */
    .info-box {
      background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 14px;
      padding: 1rem 1.25rem; text-align: left; margin: 1rem 0;
    }
    .info-box strong { color: #166534; }
    .info-box p { color: #15803d; margin: 0; }

    @media (max-width: 575.98px) {
      .onboarding-card { padding: 1.5rem 1rem; }
      .step h2 { font-size: 1.3rem; }
    }
  </style>
</head>
<body>

<div class="onboarding-wrapper">
  <div class="onboarding-card">

    <!-- Step 1: Bem-vindo -->
    <div class="step active" data-step="1">
      <lottie-player
        src="https://assets2.lottiefiles.com/packages/lf20_u4yrau.json"
        background="transparent" speed="1" style="width:180px; height:180px;"
        autoplay loop>
      </lottie-player>
      <h2>Bem-vindo, ${usuarioLogado.nome}!</h2>
      <p>Sua conta foi criada com sucesso. A <b>Vem Também</b> é uma rede colaborativa de doações onde todos crescem juntos, de forma simples e transparente.</p>
      <div style="margin-top:1.5rem">
        <button class="btn-olive" onclick="goToStep(2)">Próximo <i class="fas fa-arrow-right ml-1"></i></button>
      </div>
    </div>

    <!-- Step 2: Como funciona -->
    <div class="step" data-step="2">
      <h2><i class="fas fa-sitemap mr-2" style="color:var(--olive)"></i>Como funciona o Tabuleiro</h2>
      <p>Cada participante faz parte de uma árvore binária. Veja o exemplo:</p>

      <div class="demo-board">
        <div class="demo-row">
          <div class="demo-node donatario">
            <i class="fas fa-crown mr-1" style="font-size:.7rem"></i>Carlos M.
            <div class="demo-label">Donatário</div>
          </div>
        </div>
        <div class="demo-arrow"><i class="fas fa-arrow-down"></i></div>
        <div class="demo-row">
          <div class="demo-node">Maria S.</div>
          <div class="demo-node">João P.</div>
        </div>
        <div class="demo-arrow"><i class="fas fa-arrow-down"></i></div>
        <div class="demo-row">
          <div class="demo-node">Ana C.</div>
          <div class="demo-node you">
            <i class="fas fa-star mr-1" style="font-size:.7rem"></i>Você
          </div>
          <div class="demo-node">Pedro L.</div>
          <div class="demo-node">Julia R.</div>
        </div>
        <div class="demo-arrow"><i class="fas fa-arrow-down"></i></div>
        <div class="demo-row">
          <div class="demo-node doador" style="font-size:.75rem">Novo 1</div>
          <div class="demo-node doador" style="font-size:.75rem">Novo 2</div>
          <div class="demo-node doador" style="font-size:.75rem">Novo 3</div>
          <div class="demo-node doador" style="font-size:.75rem">Novo 4</div>
        </div>
      </div>

      <div class="info-box">
        <strong><i class="fas fa-lightbulb mr-1"></i> Entendendo o fluxo:</strong>
        <p class="mt-1">
          <i class="fas fa-arrow-up mr-1" style="color:#f59e0b"></i>Você doa para o <b>donatário</b> (acima na árvore).<br>
          <i class="fas fa-arrow-down mr-1" style="color:#10b981"></i>Seus <b>doadores</b> (abaixo) doam para você.<br>
          Ao receber <b>8 doações</b>, seu ciclo se completa!
        </p>
      </div>

      <div style="margin-top:1rem">
        <button class="btn-outline-olive mr-2" onclick="goToStep(1)"><i class="fas fa-arrow-left mr-1"></i> Voltar</button>
        <button class="btn-olive" onclick="goToStep(3)">Próximo <i class="fas fa-arrow-right ml-1"></i></button>
      </div>
    </div>

    <!-- Step 3: Primeiro passo -->
    <div class="step" data-step="3">
      <h2><i class="fas fa-rocket mr-2" style="color:#8b5cf6"></i>Seu Primeiro Passo</h2>
      <p>Para ativar sua participação na rede, dois passos simples:</p>

      <div style="text-align:left; margin:1.5rem 0">
        <div style="display:flex; align-items:flex-start; gap:.75rem; margin-bottom:1rem">
          <span style="background:var(--olive); color:#fff; border-radius:50%; width:32px; height:32px; display:flex; align-items:center; justify-content:center; font-weight:800; flex-shrink:0">1</span>
          <div>
            <strong style="color:var(--ink)">Doação de Ativação (T.I.)</strong>
            <p style="color:var(--muted); margin:0">Valor: <b>R$ 10,00</b> — para manutenção da plataforma</p>
          </div>
        </div>
        <div style="display:flex; align-items:flex-start; gap:.75rem">
          <span style="background:var(--gold); color:#141a00; border-radius:50%; width:32px; height:32px; display:flex; align-items:center; justify-content:center; font-weight:800; flex-shrink:0">2</span>
          <div>
            <strong style="color:var(--ink)">Doação ao Donatário</strong>
            <p style="color:var(--muted); margin:0">Valor: <b>R$ 90,00</b> — sua contribuição ao participante acima na rede</p>
          </div>
        </div>
      </div>

      <div class="info-box">
        <strong><i class="fas fa-info-circle mr-1"></i> Próximos passos:</strong>
        <p class="mt-1">Na próxima tela, envie o comprovante da ativação (R$ 10). Após aprovação, acesse <b>Minha Contribuição</b> para enviar a doação de R$ 90.</p>
      </div>

      <div style="margin-top:1.5rem">
        <button class="btn-outline-olive mr-2" onclick="goToStep(2)"><i class="fas fa-arrow-left mr-1"></i> Voltar</button>
        <a href="${cp}/painel" class="btn-olive" style="display:inline-block; text-decoration:none; padding:.6rem 2rem">
          Vamos começar! <i class="fas fa-arrow-right ml-1"></i>
        </a>
      </div>
    </div>

    <!-- Step dots -->
    <div class="step-dots">
      <div class="dot active" data-dot="1"></div>
      <div class="dot" data-dot="2"></div>
      <div class="dot" data-dot="3"></div>
    </div>

  </div>
</div>

<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script>
  function goToStep(n) {
    $('.step').removeClass('active');
    $('.step[data-step="' + n + '"]').addClass('active');
    $('.step-dots .dot').removeClass('active');
    $('.step-dots .dot[data-dot="' + n + '"]').addClass('active');
  }
</script>
</body>
</html>
