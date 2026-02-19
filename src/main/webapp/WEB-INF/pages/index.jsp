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
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Poppins:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
<link href="${allmincss}" rel="stylesheet"/>
<spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
<link href="${vtthemecss}" rel="stylesheet"/>
<spring:url value="/resources/css/vt-layout.css" var="vtlayoutcss" />
<link href="${vtlayoutcss}" rel="stylesheet"/>
<spring:url value="/resources/css/vt-components.css" var="vtcomponentscss" />
<link href="${vtcomponentscss}" rel="stylesheet"/>

<style>
:root {
	--olive: #6f7a00;
	--olive-700: #5c6600;
	--gold: #f3c900;
	--shell: #e8ece0;
	--card: #edf1e6;
	--muted: #6b7280;
	--ring: rgba(111, 122, 0, .3);
	--radius: 22px;
	--neo-soft: 15px 15px 30px #ced3c3, -15px -15px 30px #ffffff;
	--neo-inset: inset 6px 6px 12px #d4dacb, inset -6px -6px 12px #ffffff;
}

* {
	box-sizing: border-box
}

html, body {
	height: 100%
}

body {
	margin: 0;
	font-family: Poppins, Nunito, system-ui, -apple-system, Segoe UI, Roboto, Arial,
		sans-serif;
	color: #111827;
	background: radial-gradient(900px 520px at -12% -12%, rgba(243, 201, 0, .2)
		0%, transparent 56%), linear-gradient(165deg, #eff3e8 0%, #e5eadc 100%);
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
	background: var(--card);
	box-shadow: var(--neo-soft);
	border: 1px solid rgba(255, 255, 255, .9);
	border-radius: var(--radius);
	padding: clamp(24px, 4vw, 40px);
	color: #111827;
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
	background: #e5ebd5;
	border: 1px solid rgba(111, 122, 0, .2);
	color: #485100;
	padding: 8px 12px;
	border-radius: 999px;
	font-weight: 600;
	font-size: 14px;
	margin-bottom: 18px
}

.brand h1 {
	margin: 0 0 10px;
	color: #25301a;
	font-weight: 800;
	letter-spacing: .2px;
	font-size: clamp(26px, 3vw, 34px)
}

.brand p {
	margin: 0;
	color: #4b5563;
	opacity: 1;
	line-height: 1.6
}

.welcome-icon {
	display: flex;
	align-items: center;
	justify-content: flex-start;
	margin-bottom: 10px;
}

.welcome-icon .lottie-box {
	width: clamp(250px, 30vw, 360px);
	height: clamp(250px, 30vw, 360px);
	background: transparent !important;
	border: 0;
}

.welcome-icon .lottie-box svg {
	width: 100% !important;
	height: 100% !important;
	background: transparent !important;
}

.welcome-icon .lottie-box,
.welcome-icon lord-icon {
	filter: drop-shadow(0 12px 20px rgba(95, 106, 0, .18));
}
.card {
	background: var(--card);
	border-radius: var(--radius);
	box-shadow: var(--neo-soft);
	padding: clamp(22px, 3.8vw, 38px);
	border: 1px solid rgba(255, 255, 255, .9);
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
	border: 0;
	background: #edf1e6;
	box-shadow: var(--neo-inset);
	outline: none;
	transition: border .2s, box-shadow .2s, background .2s;
	font-size: 15px;
}

input:focus {
	background: #f3f6ec;
	box-shadow: var(--neo-inset), 0 0 0 3px var(--ring)
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
	background: linear-gradient(90deg, var(--olive), #8f9816 70%, var(--gold));
	color: #202500;
	font-size: 16px;
	margin-top: 8px;
	box-shadow: 6px 6px 14px rgba(111, 122, 0, .28), -4px -4px 12px rgba(255, 255, 255, .8);
	transition: filter .15s, transform .04s, box-shadow .15s;
}

.primary:hover {
	filter: brightness(1.05)
}

.primary:active {
	transform: translateY(1px);
	box-shadow: inset 4px 4px 10px rgba(78, 86, 0, .35)
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
	border-top: 1px solid #dde4cd;
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
<body class="vt-auth-page">

	<div class="wrap vt-auth-shell">
		<!-- Lado da marca/mensagem -->
						<section class="brand vt-auth-brand">
			<div class="brand-inner">
				<div class="welcome-icon" style="justify-content:center;margin-bottom:4px;">
					<div id="loginFriendsLottie" class="lottie-box" role="img" aria-label="Animação de amigos"></div>
				</div>
				<div class="vt-kicker mb-2">Bem-vindo de volta</div>
				<h1>Rede de doadores com foco em simplicidade e transparência</h1>
				<p>Plataforma leve, segura e pronta para crescer. Entre no escritório para gerenciar sua rede, acompanhar ciclos e apoiar sua comunidade.</p>
			</div>
		</section>

		<!-- Cartão de login -->
		<section class="card vt-auth-card" aria-label="Acesso ao Escritório">
			<div class="logo" align="center">
				<img src="<c:url value='/resources/img/logo_horinzotal.png'/>" alt="Logo Vem Também" style="height: 188px; filter: drop-shadow(0 8px 16px rgba(75,84,0,.2));">
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
							onclick="togglePass()"><i class="fas fa-eye"></i></button>
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

		document.addEventListener('DOMContentLoaded', function() {
			if (!window.lottie || typeof window.lottie.loadAnimation !== 'function') {
				return;
			}

			const container = document.getElementById('loginFriendsLottie');
			if (!container) {
				return;
			}

			function recolorLoginPalette(animationData) {
				const palette = [
					[0.929, 0.722, 0.039], // #edb80a
					[0.569, 0.584, 0.176], // #91952d
					[0.929, 0.722, 0.039], // #edb80a
					[0.498, 0.514, 0.004]  // #7f8301
				];
				let paletteIndex = 0;

				function isColorArray(value) {
					return Array.isArray(value)
						&& value.length === 4
						&& value.every(function (n) { return typeof n === 'number' && n >= 0 && n <= 1; });
				}

				function shouldRecolor(rgb) {
					const r = rgb[0], g = rgb[1], b = rgb[2];
					const skinLike = r > 0.55 && g > 0.35 && b < 0.35;
					const greenLike = g >= r + 0.06 && g >= b - 0.02;
					const tealLike = g > 0.45 && b > 0.35 && r < 0.4;
					return !skinLike && (greenLike || tealLike);
				}

				function isNearWhite(rgb) {
					return rgb[0] > 0.94 && rgb[1] > 0.94 && rgb[2] > 0.94;
				}

				function walk(node) {
					if (!node) {
						return;
					}
					if (isColorArray(node)) {
						if (isNearWhite(node)) {
							node[3] = 0;
							return;
						}
						if (shouldRecolor(node)) {
							const next = palette[paletteIndex % palette.length];
							paletteIndex += 1;
							node[0] = next[0];
							node[1] = next[1];
							node[2] = next[2];
						}
						return;
					}
					if (Array.isArray(node)) {
						node.forEach(walk);
						return;
					}
					if (typeof node === 'object') {
						Object.keys(node).forEach(function (key) { walk(node[key]); });
					}
				}

				walk(animationData);
				return animationData;
			}

			const animationPath = '<c:url value="/resources/vendor/lottie/animations/watering-plants.json"/>';
			fetch(animationPath)
				.then(function (response) { return response.json(); })
				.then(function (animationData) {
					window.lottie.loadAnimation({
						container: container,
						renderer: 'svg',
						loop: true,
						autoplay: true,
						animationData: recolorLoginPalette(animationData),
						rendererSettings: { preserveAspectRatio: 'xMidYMid meet' }
					});
				})
				.catch(function () {
					window.lottie.loadAnimation({
						container: container,
						renderer: 'svg',
						loop: true,
						autoplay: true,
						path: animationPath,
						rendererSettings: { preserveAspectRatio: 'xMidYMid meet' }
					});
				});
		});
	</script>
	<script type="text/javascript" src="<c:url value='/resources/vendor/lottie/lottie.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
</body>
</html>




