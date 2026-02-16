<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Captura atributos-padrão de erro expostos pelo container
    Throwable ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
    Integer status = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String message = (String) request.getAttribute("javax.servlet.error.message");
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
    String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");

    // Gera stack trace em String (se houver exceção)
    String stack = null;
    if (ex != null) {
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        ex.printStackTrace(pw);
        stack = sw.toString();
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>

  <title>Vem Também — Ocorreu um erro</title>

  <!-- Fonts & Icons -->
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <link href="<c:url value='/resources/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet"/>

  <!-- SB Admin 2 -->
  <link href="<c:url value='/resources/css/sb-admin-2.min.css'/>" rel="stylesheet"/>

  <style>
    :root{
      --olive:#6f7a00; --olive-700:#5b6400; --gold:#f3c900; --gold-700:#d9b200;
      --ink:#1f2937; --muted:#6b7280; --surface:#ffffff; --bg:#f7f7f5; --radius:20px;
    }
    html,body{font-family:Inter, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif;}
    body{
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, var(--olive) 85%);
      min-height:100vh; display:flex; align-items:center; justify-content:center;
      padding: 24px;
    }
    .wrap{ width:100%; max-width:1040px; padding:0 8px; }
    .surface{
      background:#ffffffd9; backdrop-filter: blur(6px);
      border-radius: var(--radius); padding:2.25rem 2rem;
      box-shadow:0 8px 28px rgba(0,0,0,.10);
    }

    .brand{ display:flex; justify-content:center; margin-bottom:1.25rem; }
    .logo{ height:clamp(160px, 8vw, 96px); width:auto; filter: drop-shadow(0 8px 24px rgba(0,0,0,.12)); }

    .hero{ display:grid; grid-template-columns: 1fr; gap:1.25rem; align-items:center; }
    @media (min-width: 992px){ .hero{ grid-template-columns: .9fr 1.1fr; gap:2rem; } }

    .code{
      font-size: clamp(64px, 10vw, 128px);
      line-height: .9; font-weight: 800; margin: 0;
      background: linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%);
      -webkit-background-clip:text; background-clip:text; color:transparent;
      text-shadow: 0 14px 32px rgba(111,122,0,.18);
      letter-spacing: -1px;
    }

    .lead{color:var(--ink); font-weight:800; margin-bottom:.25rem}
    .muted{color:var(--muted)}
    .cta{ display:flex; align-items:center; flex-wrap:wrap; gap:.75rem; margin-top:1rem }

    .btn-olive{
      background: linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%);
      border:0; color:#141a00; font-weight:700; border-radius:999px; padding:.7rem 1.25rem;
    }
    .btn-olive:hover{ filter:brightness(.95) }
    .btn-link-dark{ color:#374151; font-weight:600; border-radius:999px; padding:.7rem 1rem; }
    .btn-link-dark:hover{ text-decoration:none; background:#f3f4f6; }

    .divider{height:1px; background:rgba(0,0,0,.06); margin:1.5rem 0}
    details{ background:#fff; border-radius:14px; border:1px solid #eae9e0; padding:1rem; }
    summary{ cursor:pointer; font-weight:700; color:var(--olive-700); }
    pre.trace{
      white-space:pre-wrap; background:#fafaf6; padding:12px; border-radius:12px;
      border:1px solid #eee; max-height:360px; overflow:auto; font-size:.9rem;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }
  </style>
</head>
<body>

<div class="wrap">
  <div class="surface">
    <div class="brand">
      <img class="logo" src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também"/>
    </div>

    <div class="hero">
      <div>
        <h1 class="code"><i class="fas fa-exclamation-triangle"></i></h1>
      </div>

      <div>
        <p class="lead">Ocorreu um erro inesperado</p>
        <p class="muted">
          Algo deu errado ao processar sua solicitação. Já registramos esse evento. Você pode tentar novamente, voltar ou ir para o painel.
        </p>

        <div class="cta">
          <a href="<c:url value='/painel'/>" class="btn btn-olive">
            <i class="fas fa-home mr-1"></i> Ir para o Painel
          </a>
          <button class="btn btn-link-dark" type="button" onclick="location.reload()">
            <i class="fas fa-sync-alt mr-1"></i> Tentar novamente
          </button>
          <button class="btn btn-link-dark" type="button" onclick="history.back()">
            <i class="fas fa-arrow-left mr-1"></i> Voltar
          </button>
<%--           <a href="<c:url value='/suporte/formulario'/>" class="btn btn-link-dark"> --%>
<!--             <i class="fas fa-headset mr-1"></i> Suporte -->
<!--           </a> -->
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <!-- Detalhes técnicos (aparecem só se existirem) -->
    <details <c:if test="${ex != null}">open</c:if>>
      <summary>Detalhes técnicos</summary>
      <div class="mt-2" style="font-family: ui-monospace, Menlo, Consolas, monospace; font-size:.95rem;">
        <div><b>Status:</b> <%= status != null ? status : "-" %></div>
        <div><b>Mensagem:</b> <%= message != null ? org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(message) : "-" %></div>
        <div><b>Path:</b> <%= requestUri != null ? org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(requestUri) : "-" %></div>
        <div><b>Servlet:</b> <%= servletName != null ? org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(servletName) : "-" %></div>
        <c:if test="<%= ex != null %>">
          <div><b>Exceção:</b> <%= ex.getClass().getName() %></div>
        </c:if>
      </div>

      <c:if test="<%= stack != null %>">
        <pre class="trace"><%= org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(stack) %></pre>
      </c:if>
    </details>
  </div>

  <p class="text-center text-white mt-3" style="opacity:.9">© Vem Também 2025-2026</p>
</div>

<!-- JS -->
<script src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>
