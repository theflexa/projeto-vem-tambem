<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!doctype html>
<html lang="pt-BR">
<head>

<meta charset="UTF-8" />

<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Vem Também - Recuperar acesso</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

<style>
:root{
  --olive:#6f7a00; --olive-700:#5b6400; --gold:#f3c900;
  --bg-1:#6f7a00; --bg-2:#a39c00; --bg-3:#f3c900;
  --card:#ffffff; --muted:#6b7280; --ring:rgba(111,122,0,.25);
  --shadow:0 20px 45px rgba(0,0,0,.12); --radius:18px;
}
*{box-sizing:border-box}
html,body{height:100%}
body{
  margin:0; font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; color:#111827;
  background:
    radial-gradient(80rem 80rem at 20% -10%, var(--bg-3) 0%, transparent 40%),
    radial-gradient(80rem 80rem at 120% 120%, var(--bg-2) 0%, transparent 35%),
    linear-gradient(160deg, var(--bg-1), #7d7a00 60%, #8b8300 100%);
  display:grid; place-items:center; padding:32px;
}
.wrap{width:min(1040px,100%); display:grid; grid-template-columns:1.2fr 1fr; gap:42px;}
@media(max-width:960px){.wrap{grid-template-columns:1fr}}
.brand{
  background:rgba(255,255,255,.12); backdrop-filter:blur(6px);
  border:1px solid rgba(255,255,255,.25); border-radius:var(--radius);
  padding:clamp(24px,4vw,40px); color:#fff; min-height:420px;
  display:flex; align-items:center; justify-content:center;
}
.brand-inner{max-width:520px}
.brand h1{margin:0 0 10px; color:#fff; font-weight:800; letter-spacing:.2px; font-size:clamp(26px,3vw,34px)}
.brand p{margin:0; color:#fefce8; opacity:.95; line-height:1.6}

.card{
  background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow);
  padding:clamp(22px,3.8vw,38px); border:1px solid #eef0f2;
}
.logo{display:flex; flex-direction:column; align-items:center; justify-content:center; gap:10px; margin-bottom:10px; text-align:center;}
.logo b{font-size:20px; color:var(--olive-700)}
h2{margin:4px 0 8px; font-size:22px; color:#1f2937}
.sub{margin:0 0 16px; color:#6b7280; font-size:14px}

.alert{padding:12px 14px; border-radius:12px; margin:10px 0 16px; font-size:14px;}
.alert-err{background:#fee2e2; border:1px solid #fecaca; color:#991b1b;}
.alert-ok{background:#dcfce7; border:1px solid #bbf7d0; color:#14532d;}

.field{margin-bottom:14px}
.label{display:block; font-size:13px; color:#374151; margin-bottom:6px; font-weight:600}
.control{position:relative}
input[type="text"], input[type="email"]{
  width:100%; padding:14px; border-radius:14px; border:1px solid #e5e7eb;
  background:#f8fafc; outline:none; transition:border .2s, box-shadow .2s, background .2s; font-size:15px;
}
input:focus{background:#fff; border-color:var(--olive); box-shadow:0 0 0 4px var(--ring)}

.primary{
  width:100%; border:none; cursor:pointer; font-weight:700; padding:14px 18px;
  border-radius:999px; background:linear-gradient(90deg, var(--olive), var(--gold));
  color:#0b0f00; font-size:16px; margin-top:8px; transition:filter .15s, transform .04s;
}
.primary:hover{filter:brightness(1.05)} .primary:active{transform:translateY(1px)}

.links{display:flex; justify-content:space-between; gap:10px; margin-top:12px; font-size:13px}
.links a{color:var(--olive-700); text-decoration:none; font-weight:600}
.links a:hover{text-decoration:underline}

.help{margin-top:24px; border-top:1px solid #eef0f2; padding-top:18px; text-align:center; color:var(--muted); font-size:14px}
.help a{color:var(--olive-700); text-decoration:none; font-weight:600}
.help a:hover{text-decoration:underline}
.small{font-size:12px; color:#6b7280; margin-top:6px}
</style>
</head>
<body>

<div class="wrap">
  <!-- Lado da marca/mensagem -->
  <section class="brand">
    <div class="brand-inner">
      <h1>Recupere o acesso com segurança</h1>
      <p>Informe seu e-mail cadastrado. Se houver correspondência, enviaremos um código para redefinir a senha.</p>
    </div>
  </section>

  <!-- Cartão de recuperação -->
  <section class="card" aria-label="Recuperar acesso">
    <div class="logo" align="center">
      <img src="<c:url value='/resources/img/logo_horinzotal.png'/>" alt="Logo Vem Também" style="height: 150px;">
    </div>

    <h2 align="center">Esqueci minha senha</h2>
    <p class="sub" align="center">Digite seu <b>e-mail</b> para receber o código de redefinição.</p>

    <!-- mensagens do servidor -->
    <c:if test="${not empty erro}">
      <div class="alert alert-err">${erro}</div>
    </c:if>
    <c:if test="${not empty sucesso}">
      <div class="alert alert-ok"><strong>Pronto:</strong> ${sucesso}</div>
    </c:if>
    <c:if test="${not empty mensagem}">
      <div class="alert ${sucesso ne null ? 'alert-ok' : 'alert-err'}">${mensagem}</div>
    </c:if>

    <!-- Formulário -->
    <form:form id="forgot-form" action="enviar-codigo-senha" method="post" modelAttribute="usuario">
      <div class="field">
        <label class="label" for="email">E-mail</label>
        <div class="control">
          <input id="email" type="email" name="email" placeholder="seuemail@exemplo.com" autocomplete="email" required="required"/>
        </div>
      </div>

      <button class="primary" type="submit" id="enviar" name="enviar">Enviar código de redefinição</button>

      <div class="links">
        <a href="<c:url value='/'/>">&larr; Voltar ao login</a>
        <a href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank" rel="noopener"><span> Falar com o suporte</span></a>
      </div>

      <div class="help">
        <div>Não recebeu o e-mail? Verifique a caixa de spam e aguarde alguns minutos.</div>
        <div><a href="<c:url value='/esqueci-senha'/>">Reenviar código</a></div>
      </div>
    </form:form>
  </section>
</div>

</body>
</html>
