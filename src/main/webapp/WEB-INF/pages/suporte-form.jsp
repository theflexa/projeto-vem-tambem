<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem Também — Suporte</title>

  <!-- Paths -->
  <c:set var="cp"  value="${pageContext.request.contextPath}" />
  <c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri'] != null 
                           ? requestScope['javax.servlet.forward.request_uri'] 
                           : pageContext.request.requestURI}" />

  <!-- Fontes / ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 -->
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
    :root{
      --olive:#6f7a00; --olive-700:#5b6400; --gold:#f3c900; --ink:#1f2937; --muted:#6b7280; --radius:18px;
    }
    html,body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif;}
    body{
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      min-height:100vh;
    }

    /* Sidebar */
    .bg-gradient-primary{background:linear-gradient(180deg, var(--olive) 0%, #8e8a0a 60%, var(--gold) 120%) !important;}
    .sidebar .nav-item .nav-link{border-radius:12px; margin:2px 8px; font-weight:600;}
    .sidebar .nav-item.active>.nav-link,
    .sidebar .nav-item .nav-link.active,
    .sidebar .nav-item .nav-link:hover{background:rgba(255,255,255,.16);}
    .sidebar .sidebar-brand{height:4.5rem}

    /* Topbar */
    .topbar{border:0; border-bottom:1px solid rgba(0,0,0,.05)}
    .topbar .navbar-nav .nav-link{font-weight:600; color:#4b5563}

    /* Cards/botões */
    .card,.alert,.modal-content{border:0; border-radius:var(--radius); box-shadow:0 6px 24px rgba(0,0,0,.08)}
    .btn-olive{background:linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%); border:0; color:#141a00; font-weight:700; border-radius:999px;}
    .btn-olive:hover{filter:brightness(.95)}
    .text-brand{color:#5b6400}

    /* Cabeçalho da página */
    .content-surface{ background:#ffffffd9; backdrop-filter:blur(6px); border-radius:var(--radius); padding:1rem 1.25rem; }
    .content-surface h1{color:var(--ink); font-weight:800; margin-bottom:.25rem}
    .content-surface p{color:#6b7280; margin-bottom:0}

    /* Form */
    label{font-weight:600; color:#374151}
    .form-control{border-radius:12px}
    .help-text{font-size:.85rem; color:var(--muted)}
    .counter{font-size:.82rem; color:#6b7280}
  </style>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <!-- Content -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <div class="content-surface mb-3">
          <h1 class="h3">Suporte</h1>
          <p>Envie sua mensagem para nossa equipe. Responderemos por e-mail ou WhatsApp.</p>
        </div>

        <div class="card shadow mb-4">
          <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-brand">Formulário de contato</h6>
          </div>

          <div class="card-body">
            <c:if test="${sucesso == true}">
              <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Mensagem enviada com sucesso.</strong>
                <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
            </c:if>

            <form:form id="cadastro-form" action="${cp}/suporte/formulario/salvar" method="post" modelAttribute="formulario">
              <div class="form-row">
                <div class="form-group col-md-6">
                  <label for="nome">Nome</label>
                  <input type="text" class="form-control" id="nome" name="nome" value="${pessoa.nome}" readonly="readonly" aria-readonly="true">
                </div>
                <div class="form-group col-md-6">
                  <label for="login">Login</label>
                  <input type="text" class="form-control" id="login" name="login" value="${pessoa.login}" readonly="readonly" aria-readonly="true">
                </div>
              </div>

              <div class="form-row">
                <div class="form-group col-md-12">
                  <label for="mensagem">Mensagem</label>
                  <textarea class="form-control" rows="6" id="mensagem" name="mensagem" required maxlength="1000"
                            aria-describedby="mensagemHelp contadorMsg" placeholder="Descreva sua dúvida, problema ou sugestão..."></textarea>
                  <small id="mensagemHelp" class="help-text">Até 1000 caracteres. Evite incluir dados sensíveis.</small>
                  <div class="d-flex justify-content-end"><span id="contadorMsg" class="counter">0 / 1000</span></div>
                </div>
              </div>

              <hr>
              <div class="form-row">
                <div class="form-group col-md-12">
                  <button type="submit" class="btn btn-olive px-4">Enviar</button>
                </div>
              </div>
            </form:form>
          </div>
        </div>
      </div><!-- /container-fluid -->
    </div><!-- /content -->

    <footer class="sticky-footer bg-white">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>Copyright &copy; Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div><!-- /content-wrapper -->
</div><!-- /wrapper -->

<!-- Scroll to Top -->
<a class="scroll-to-top rounded" href="#page-top" aria-label="Voltar ao topo"><i class="fas fa-angle-up"></i></a>

<!-- Global Modals -->
<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>

<!-- Inputmask (se precisar em outras telas) -->
<script type="text/javascript" src="<c:url value='/resources/vendor/inputmask/min/jquery.inputmask.bundle.min.js'/>"></script>

<script>
  // contador de caracteres
  (function(){
    var el = document.getElementById('mensagem');
    var counter = document.getElementById('contadorMsg');
    if(el && counter){
      var update = function(){
        var max = el.getAttribute('maxlength') || 1000;
        counter.textContent = (el.value || '').length + ' / ' + max;
      };
      el.addEventListener('input', update);
      update();
    }
  })();
</script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>
