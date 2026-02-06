<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">

	<meta http-equiv="Content-Security-Policy"
      content="default-src 'self';
               img-src 'self' data: https:;
               style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
               font-src 'self' https://fonts.gstatic.com data:;
               script-src 'self' https://cdnjs.cloudflare.com;">
	
  	<title>Vem Também — Criar conta</title>
	<link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>
	
  <!-- Fonts & Icons -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="fa" />
  <link href="${fa}" rel="stylesheet" type="text/css">

  <!-- SB Admin 2 -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet" />

  <style>
    :root{
      --olive:#6f7a00; --olive-700:#5b6400;
      --gold:#f3c900;  --gold-700:#d9b200;
      --ink:#1f2937;   --muted:#4b5563;
      --surface:#ffffff; --bg:#f5f7f3;
      --radius:18px; --pill:999px; --shadow:0 12px 28px rgba(0,0,0,.10);

      /* ajuste fino do “corte visual” da logo (se o PNG tiver bordas transparentes) */
      --logo-cut-top:  14px;   /* aumente/diminua conforme a arte */
      --logo-cut-bottom: 18px;
    }

    html,body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif}
    body{
      min-height:100vh;
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      display:flex; align-items:center;
    }

    .auth-shell{width:100%; max-width:980px; margin:24px auto; background:#fffffff0; border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden;}

    /* ---- Cabeçalho/Logo sem espaço ---- */
    .auth-header{
      padding: .25rem 1.25rem 0 !important;  /* sem espaço abaixo */
      display:flex; justify-content:center; align-items:center;
      line-height: 0;                         /* remove gap de baseline */
    }
    .auth-header img{
      display:block;                          /* elimina baseline de img inline */
      height: 220px;                          /* ajuste de tamanho */
      width:auto;
      margin:0 !important;
      /* “corte” visual para PNG com padding transparente */
      clip-path: inset(var(--logo-cut-top) 0 var(--logo-cut-bottom) 0);
    }

    /* encosta o texto na logo */
    .auth-body{ padding: .25rem 1.25rem 1.5rem; }
    @media (min-width: 992px){ .auth-body{ padding: .4rem 2rem 1.75rem; } }
    .auth-body .text-center.mb-4{
      margin-top: 0 !important;
      margin-bottom: .45rem !important;
    }

    .lead-title{ font-weight:800; color:var(--ink); }
    .lead-sub{ color:var(--muted); }

    .form-control, .custom-select, .custom-input {
      border-radius:var(--pill)!important; padding:.65rem 1rem; border:1px solid #d1d5db; color:#374151;
    }
    .form-control:focus, .custom-select:focus, .custom-input:focus{
      border-color:var(--gold-700); box-shadow:0 0 0 .2rem rgba(243,201,0,.25); outline:none;
    }
    .btn-olive{ background:linear-gradient(90deg,var(--olive) 0%,var(--gold) 100%); color:#141a00; border:0; border-radius:var(--pill); font-weight:700; }
    .btn-olive:hover{ filter:brightness(.95); }
    .toast-container{ position:fixed; top:1rem; right:1rem; z-index:1080; }
    .small-muted{ color:#6b7280; } .small-muted a{ font-weight:600; }
    a:focus, button:focus { outline:2px solid var(--gold); outline-offset:2px; }

    /* mobile ainda mais compacto */
    @media (max-width: 575.98px){
      .auth-header{ padding-top:.2rem; }
      .auth-header img{ height:150px; }
      .auth-body{ padding-top:.2rem; }
      .auth-body .text-center.mb-4{ margin-bottom:.35rem !important; }
    }
    
    /* FIX: evita que o label do <select> fique “cortado” */
	.custom-select{
	  height: auto !important;                 /* libera a altura */
	  min-height: calc(1.5em + 1.3rem + 2px);  /* altura mínima coerente com o padding */
	  padding-top: .65rem !important;
	  padding-bottom: .65rem !important;
	  line-height: 1.25;                       /* melhora o alinhamento vertical */
	  background-position: right .9rem center; /* reposiciona a setinha */
	}
	
	#single-select-field,
	#chavePix {
	  width: 100%;
	  border-radius: var(--pill) !important;
	  padding: .65rem 1rem;
	  height: calc(1.5em + 1.3rem + 2px); /* mesma altura */
	}
	
  </style>
</head>

<body>
  <main class="auth-shell" role="main">
    <div class="auth-header">
      <img src="<c:url value='/resources/img/logo_vertical.png'/>" alt="Vem Também">
    </div>

    <div class="auth-body">
      <div class="text-center mb-4">
        <div class="lead-sub">Crie sua conta para começar a transformar histórias.</div>
      </div>

      <!-- TOASTS -->
      <div class="toast-container" aria-live="polite" aria-atomic="true">
        <div class="toast" id="toastMsg" data-delay="5000">
          <div class="toast-header">
            <strong class="mr-auto">Vem Também</strong>
            <small>agora</small>
            <button type="button" class="ml-2 mb-1 close" data-dismiss="toast">&times;</button>
          </div>
          <div class="toast-body" id="toastBody">—</div>
        </div>
      </div>

      <div id="flags" data-erro="${erro}"></div>

      <c:if test="${erro == true}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <strong>Cadastro não realizado.</strong>
          <ul class="mb-0">
            <c:forEach var="erroVar" items="${erros}">
              <li><c:out value="${erroVar}"/></li>
            </c:forEach>
          </ul>
          <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </c:if>

      <!-- Formulário -->
      <form:form id="cadastro-form" action="salvar-externo" method="post" modelAttribute="pessoa" class="user">
        <input type="hidden" id="indicador" name="indicador.id" value="${indicador.id}" />
        <c:if test="${_csrf != null}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <hr>

        <!-- Indicação -->
        <c:if test="${indicador.id != null}">
          <h6 class="text-brand">Indicação</h6>
          <div class="form-group">
            <input type="text" class="form-control" id="indicadorNome" placeholder="Indicador"
                   value="${indicador.nome}" disabled>
          </div>
          <hr>
        </c:if>

        <!-- Identificação -->
        <div class="form-group">
          <input type="text" class="form-control" id="nome" name="nome" placeholder="Nome" value="${pessoa.nome}" required>
        </div>

        <div class="form-group row">
          <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" id="cpf_cnpj" name="documento" placeholder="CPF" value="${pessoa.documento}" required inputmode="numeric" 
            	autocomplete="off" data-inputmask="'mask': '999.999.999-99'">
          </div>
          
          <div class="col-sm-8">
            <input type="email" class="form-control" id="email" name="email" placeholder="E-mail" value="${pessoa.email}" required>
          </div>
        </div>

        <div class="form-group row">
          <div class="col-sm-6 mb-3">
            <input type="text" class="form-control" id="celular" name="celular" placeholder="Celular"
                   value="${pessoa.celular}" required data-inputmask="'mask': '(99) 99999-9999'">
          </div>
          <div class="col-sm-6">
            <input type="text" class="form-control" id="whatsapp" name="whatsapp" placeholder="WhatsApp"
                   value="${pessoa.whatsapp}" required data-inputmask="'mask': '(99) 99999-9999'">
          </div>
        </div>

        <hr>

        <!-- Endereço -->
        <div class="form-group">
          <input type="text" class="form-control" id="logradouro" name="endereco.logradouro" placeholder="Endereço" value="${pessoa.endereco.logradouro}" required>
        </div>

        <div class="form-group row">
          <div class="col-sm-6 mb-3">
            <input type="text" class="form-control" id="bairro" name="endereco.bairro" placeholder="Bairro" value="${pessoa.endereco.bairro}" required>
          </div>
          <div class="col-sm-6">
            <input type="text" class="form-control" id="cidade" name="endereco.municipio" placeholder="Cidade" value="${pessoa.endereco.municipio}" required>
          </div>
        </div>

        <div class="form-group row">
          <div class="col-sm-6 mb-3">
            <input type="text" class="form-control" id="estado" name="endereco.estado" placeholder="Estado" value="${pessoa.endereco.estado}" required>
          </div>
          <div class="col-sm-6">
            <input type="text" class="form-control" id="cep" name="endereco.cep" placeholder="CEP"
                   value="${pessoa.endereco.cep}" required data-inputmask="'mask': '99999-999'">
          </div>
        </div>

        <div class="form-group">
          <input type="text" class="form-control" id="complemento" name="endereco.complemento" placeholder="Complemento" value="${pessoa.endereco.complemento}">
        </div>

        <hr>

        <!-- Acesso -->
        <div class="form-group row">
          <div class="col-sm-6 mb-3">
            <input type="text" class="form-control" id="login" name="login" placeholder="Login" value="${pessoa.login}" required>
          </div>
          <div class="col-sm-6">
            <input type="password" class="form-control" id="senha" name="senha" placeholder="Senha" required>
          </div>
        </div>

        <hr>
        
        <!-- PIX -->
        <div class="form-group row">
          <div class="col-sm-6 mb-3">
            <select class="form-control custom-select" id="single-select-field" name="codigoTipoChavePix" required>
              <option selected value="">Informe o tipo do PIX</option>
              <c:forEach var="tipoVar" items="${tipoChavesPix}">
                <option value="${tipoVar.codigo}"><c:out value="${tipoVar.descricao}"/></option>
              </c:forEach>
            </select>
          </div>
          <div class="col-sm-6">
            <input type="text" class="form-control custom-input" id="chavePix" name="chavePix" placeholder="Chave PIX" required>
          </div>
        </div>

        <hr>

        <!-- Termo -->
        <div class="form-group">
          <div class="custom-control custom-checkbox">
            <input type="checkbox" class="custom-control-input" id="termoAceito" name="termoAceito" required>
            <label class="custom-control-label" for="termoAceito">
              Aceito o <a href="/vemtambem/termo/download" target="_blank">termo de adesão</a>.
            </label>
          </div>
        </div>

        <button type="submit" class="btn btn-olive btn-block">Salvar</button>
      </form:form>

      <hr>

      <div class="text-center small-muted">
        Já tem uma conta? <a href="/vemtambem/">Faça login</a>
      </div>

      <div class="mt-4 p-3 rounded" style="background:#f9fafb">
        <div class="d-flex align-items-center mb-1"><i class="fas fa-life-ring mr-2"></i><strong>Precisando de ajuda?</strong></div>
        <div class="small-muted">Nossa equipe de suporte está à sua disposição.</div>
        <div class="mt-2">
<!--           <a class="small" href="#">Perguntas e Respostas</a> · -->
          <a class="small" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank" rel="noopener"><i class="fas fa-headset"></i><span> Falar com o suporte</span></a>
          
        </div>
      </div>
    </div>
  </main>

  <!-- JS -->
  <script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
  <script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
  <script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
  <script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/3.3.4/jquery.inputmask.bundle.min.js"></script>
	
	<spring:url value="/resources/js/masks.js" var="masksjs"/>
	<script type="text/javascript" src="${masksjs}"></script>
	
</body>
</html>
