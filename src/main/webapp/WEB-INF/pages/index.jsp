<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!doctype html>
<html lang="pt-BR">
<head>

<meta charset="UTF-8" />

<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Vem Também - Login</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--olive: #6f7a00;
	--olive-700: #5b6400;
	--gold: #f3c900;
	--bg-1: #6f7a00;
	--bg-2: #a39c00;
	--bg-3: #f3c900;
	--card: #ffffff;
	--muted: #6b7280;
	--ring: rgba(111, 122, 0, .25);
	--shadow: 0 20px 45px rgba(0, 0, 0, .12);
	--radius: 18px;
}

* {
	box-sizing: border-box
}

html, body {
	height: 100%
}

body {
	margin: 0;
	font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial,
		sans-serif;
	color: #111827;
	background: radial-gradient(80rem 80rem at 20% -10%, var(--bg-3) 0%,
		transparent 40%),
		radial-gradient(80rem 80rem at 120% 120%, var(--bg-2) 0%, transparent
		35%), linear-gradient(160deg, var(--bg-1), #7d7a00 60%, #8b8300 100%);
	display: grid;
	place-items: center;
	padding: 32px;
}

.wrap {
	width: min(1040px, 100%);
	display: grid;
	grid-template-columns: 1.2fr 1fr;
	gap: 42px;
	background: transparent;
}

@media ( max-width :960px) {
	.wrap {
		grid-template-columns: 1fr
	}
}

.brand {
	background: rgba(255, 255, 255, .12);
	backdrop-filter: blur(6px);
	border: 1px solid rgba(255, 255, 255, .25);
	border-radius: var(--radius);
	padding: clamp(24px, 4vw, 40px);
	color: #fff;
	min-height: 420px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.brand-inner {
	max-width: 520px
}

.badge {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	background: rgba(255, 255, 255, .18);
	border: 1px solid rgba(255, 255, 255, .35);
	color: #fff;
	padding: 8px 12px;
	border-radius: 999px;
	font-weight: 600;
	font-size: 14px;
	margin-bottom: 18px
}

.brand h1 {
	margin: 0 0 10px;
	color: #fff;
	font-weight: 800;
	letter-spacing: .2px;
	font-size: clamp(26px, 3vw, 34px)
}

.brand p {
	margin: 0;
	color: #fefce8;
	opacity: .95;
	line-height: 1.6
}

.card {
	background: var(--card);
	border-radius: var(--radius);
	box-shadow: var(--shadow);
	padding: clamp(22px, 3.8vw, 38px);
	border: 1px solid #eef0f2;
}

.logo {
	display: flex; 
	flex-direction: column; 
	align-items: center; 
	justify-content: center;
	gap: 10px; 
	margin-bottom: 10px; 
	text-align: center;
}

.logo svg {
	width: 42px;
	height: 42px
}

.logo b {
	font-size: 20px;
	color: var(--olive-700)
}

h2 {
	margin: 4px 0 22px;
	font-size: 22px;
	color: #1f2937
}

.alert {
	background: #fee2e2;
	border: 1px solid #fecaca;
	color: #991b1b;
	padding: 12px 14px;
	border-radius: 12px;
	margin: 8px 0 16px;
	font-size: 14px;
}

.field {
	margin-bottom: 14px
}

.label {
	display: block;
	font-size: 13px;
	color: #374151;
	margin-bottom: 6px;
	font-weight: 600
}

.control {
	position: relative
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 14px 44px 14px 14px;
	border-radius: 14px;
	border: 1px solid #e5e7eb;
	background: #f8fafc;
	outline: none;
	transition: border .2s, box-shadow .2s, background .2s;
	font-size: 15px;
}

input:focus {
	background: #fff;
	border-color: var(--olive);
	box-shadow: 0 0 0 4px var(--ring)
}

.toggle {
	position: absolute;
	right: 8px;
	top: 50%;
	translate: 0 -50%;
	border: none;
	background: transparent;
	cursor: pointer;
	padding: 8px;
	border-radius: 10px;
	color: #6b7280
}

.toggle:focus-visible {
	outline: 2px solid var(--olive)
}

.primary {
	width: 100%;
	border: none;
	cursor: pointer;
	font-weight: 700;
	padding: 14px 18px;
	border-radius: 999px;
	background: linear-gradient(90deg, var(--olive), var(--gold));
	color: #0b0f00;
	font-size: 16px;
	margin-top: 8px;
	transition: filter .15s, transform .04s;
}

.primary:hover {
	filter: brightness(1.05)
}

.primary:active {
	transform: translateY(1px)
}

.links {
	display: flex;
	justify-content: space-between;
	gap: 10px;
	margin-top: 12px;
	font-size: 13px
}

.links a {
	color: var(--olive-700);
	text-decoration: none;
	font-weight: 600
}

.links a:hover {
	text-decoration: underline
}

.help {
	margin-top: 24px;
	border-top: 1px solid #eef0f2;
	padding-top: 18px;
	text-align: center;
	color: var(--muted);
	font-size: 14px
}

.help a {
	color: var(--olive-700);
	text-decoration: none;
	font-weight: 600
}

.help a:hover {
	text-decoration: underline
}
</style>
</head>
<body>

	<div class="wrap">
		<!-- Lado da marca/mensagem -->
		<section class="brand">
			<div class="brand-inner">
				<h1>Rede de doadores com foco em simplicidade e transparência</h1>
				<p>Plataforma leve, segura e pronta para crescer. Entre no escritório para gerenciar sua rede, acompanhar ciclos e apoiar sua comunidade.</p>
			</div>
		</section>

		<!-- Cartão de login -->
		<section class="card" aria-label="Acesso ao Escritório">
			<div class="logo" align="center">
				<img src="<c:url value='/resources/img/logo_horinzotal.png'/>" alt="Logo Vem Também" style="height: 150px;">
			</div>
			
			<h2 align="center">Acesso ao Escritório</h2>

			<!-- alerta de erro (opcional) -->
			<c:if test="${sucesso == false}">
				<div class="alert">
					<strong>Erro:</strong> Login ou senha inválidos.
				</div>
			</c:if>

			<!-- Spring Form -->
			<form:form id="login-form" action="login" method="post" cssClass="user">
				<div class="field">
					<label class="label" for="user">Usuário</label>
					<div class="control">
						<input id="user" type="text" name="login"
							placeholder="seu usuário" autocomplete="username"
							required="required" />
					</div>
				</div>

				<div class="field">
					<label class="label" for="pass">Senha</label>
					<div class="control">
						<input id="pass" type="password" name="senha"
							placeholder="sua senha" autocomplete="current-password"
							required="required" />
						<button class="toggle" type="button" aria-label="Mostrar senha"
							onclick="togglePass()"></button>
					</div>
				</div>

				<button class="primary" type="submit" id="entrar" name="entrar">Entrar</button>

				<div class="links">
					<a href="/vemtambem/esqueci-senha">Esqueci minha senha</a>
				</div>

				<div class="help">
					<div>Precisando de ajuda? Nossa equipe está à disposição.</div>
					<div>
						<a href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank" ><i class="fas fa-headset"></i><span> Falar com o suporte</span></a>
					</div>
				</div>
			</form:form>
		</section>
	</div>

	<script>
		function togglePass() {
			const p = document.getElementById('pass');
			p.type = p.type === 'password' ? 'text' : 'password';
		}
	</script>
</body>
</html>
