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

  <title>Vem Também — Meus Dados</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@500;700;800&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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
    .vt-profile-shell {
      display: grid;
      grid-template-columns: 1fr;
      gap: 1rem;
    }

    .vt-profile-note {
      border-radius: 16px;
      border: 1px dashed rgba(75, 84, 0, 0.26);
      background: rgba(244, 248, 232, 0.86);
      padding: 0.8rem 0.9rem;
      color: #334155;
      font-size: 0.9rem;
    }

    .vt-section-title {
      margin: 0;
      color: #2f3a07;
      font-weight: 800;
      font-size: 0.95rem;
      letter-spacing: 0.01em;
      text-transform: uppercase;
    }

    .vt-profile-block {
      margin-top: 0.8rem;
      padding: 0.95rem;
      border-radius: 16px;
      border: 1px solid rgba(75, 84, 0, 0.14);
      background: rgba(255, 255, 255, 0.32);
    }

    .vt-profile-block .form-group {
      margin-bottom: 0.82rem;
    }

    .vt-profile-block label {
      color: #334155;
      font-size: 0.82rem;
      font-weight: 700;
      margin-bottom: 0.28rem;
      text-transform: uppercase;
      letter-spacing: 0.02em;
    }

    .vt-profile-actions {
      margin-top: 0.4rem;
      display: flex;
      align-items: center;
      gap: 0.65rem;
      flex-wrap: wrap;
    }

    #url {
      font-size: 0.9rem;
    }

    @media (max-width: 767.98px) {
      .vt-profile-block {
        padding: 0.8rem;
      }
    }
  </style>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper">
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <div class="content-surface mb-4">
          <h1 class="h3 mb-1">Meus Dados</h1>
          <p class="mb-0">Atualize seus contatos e chave PIX para garantir uma operação fluida em todos os ciclos.</p>
        </div>

        <div class="card shadow mb-4">
          <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-brand">Perfil e contatos</h6>
          </div>

          <div class="card-body">
            <div class="vt-profile-shell">
              <div class="vt-profile-note">
                <i class="fas fa-info-circle mr-1"></i>
                Nome, documento, e-mail e endereço são dados de segurança e não podem ser editados por aqui.
              </div>

              <c:if test="${perfilIncompleto == true}">
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                  <strong>Cadastro incompleto.</strong> Identificação e endereço devem ser ajustados com a equipe de suporte.
                  <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
              </c:if>

              <c:if test="${sucesso == true}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                  <strong>Dados atualizados com sucesso.</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
              </c:if>

              <form:form id="cadastro-form" action="${cp}/usuario/dados-pessoais/salvar" method="post" modelAttribute="pessoa" data-tour-id="dados-form">
                <input type="hidden" id="id" name="id" value="${pessoa.id}" />

                <section class="vt-profile-block">
                  <h6 class="vt-section-title mb-3">Identificação</h6>
                  <div class="form-row">
                    <div class="form-group col-md-9">
                      <label for="nome"><c:out value="${pessoa.tipoConta ? 'Nome' : 'Razão Social'}"/></label>
                      <input type="text" class="form-control" id="nome" name="nome" value="${pessoa.nome}" placeholder="Não informado" disabled="disabled">
                    </div>
                    <div class="form-group col-md-3">
                      <label for="documento">CPF/CNPJ</label>
                      <input type="text" class="form-control" id="documento" name="documento" value="${pessoa.documento}" placeholder="Não informado" disabled="disabled">
                    </div>
                  </div>

                  <div class="form-row">
                    <div class="form-group col-md-5">
                      <label for="email">E-mail</label>
                      <input type="email" class="form-control" id="email" name="email" value="${pessoa.email}" placeholder="Não informado" disabled="disabled">
                    </div>
                    <div class="form-group col-md-2">
                      <label for="celular">Celular</label>
                      <input type="text" class="form-control" id="celular" name="celular" value="${pessoa.celular}" data-mask="(99) 99999-9999">
                    </div>
                    <div class="form-group col-md-2">
                      <label for="whatsapp">Whatsapp</label>
                      <input type="text" class="form-control" id="whatsapp" name="whatsapp" value="${pessoa.whatsapp}" data-mask="(99) 99999-9999">
                    </div>
                    <div class="form-group col-md-3">
                      <label for="chavePix">Chave PIX</label>
                      <input type="text" class="form-control" id="chavePix" name="chavePix" value="${pessoa.chavePix}">
                    </div>
                  </div>
                </section>

                <section class="vt-profile-block" data-tour-id="dados-convite">
                  <h6 class="vt-section-title mb-3">Acesso e convite</h6>
                  <div class="form-row">
                    <div class="form-group col-md-4">
                      <label for="login">Login</label>
                      <input type="text" class="form-control" id="login" name="login" value="${pessoa.login}" disabled="disabled">
                    </div>
                    <div class="form-group col-md-8">
                      <label for="url">URL de convite</label>
                      <div class="input-group">
                        <input type="text" class="form-control" id="url" name="url" readonly="readonly"
                               value="www.vemtambem.com.br${cp}/usuario/convite?id=${pessoa.login}">
                        <div class="input-group-append">
                          <button type="button" class="btn btn-olive" onclick="copyUrlToClipboard()">Copiar</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </section>

                <section class="vt-profile-block">
                  <h6 class="vt-section-title mb-3">Endereço</h6>

                  <div class="form-row">
                    <div class="form-group col-md-12">
                      <label for="logradouro">Logradouro</label>
                      <input type="text" class="form-control" id="logradouro" name="endereco.logradouro" value="${pessoa.endereco.logradouro}" placeholder="Não informado" disabled="disabled">
                    </div>
                  </div>

                  <div class="form-row">
                    <div class="form-group col-md-4">
                      <label for="bairro">Bairro</label>
                      <input type="text" class="form-control" id="bairro" name="endereco.bairro" value="${pessoa.endereco.bairro}" placeholder="Não informado" disabled="disabled">
                    </div>
                    <div class="form-group col-md-3">
                      <label for="municipio">Cidade</label>
                      <input type="text" class="form-control" id="municipio" name="endereco.municipio" value="${pessoa.endereco.municipio}" placeholder="Não informado" disabled="disabled">
                    </div>
                    <div class="form-group col-md-3">
                      <label for="estado">Estado</label>
                      <input type="text" class="form-control" id="estado" name="endereco.estado" value="${pessoa.endereco.estado}" placeholder="Não informado" disabled="disabled">
                    </div>
                    <div class="form-group col-md-2">
                      <label for="cep">CEP</label>
                      <input type="text" class="form-control" id="cep" name="endereco.cep" value="${pessoa.endereco.cep}" placeholder="Não informado" disabled="disabled">
                    </div>
                  </div>

                  <div class="form-row">
                    <div class="form-group col-md-12">
                      <label for="complemento">Complemento</label>
                      <input type="text" class="form-control" id="complemento" name="endereco.complemento" value="${pessoa.endereco.complemento}" placeholder="Não informado" disabled="disabled">
                    </div>
                  </div>
                </section>

                <div class="vt-profile-actions">
                  <button type="submit" class="btn btn-olive px-4">Atualizar dados</button>
                </div>
              </form:form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="sticky-footer">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>&copy; Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div>
</div>

<a class="scroll-to-top rounded" href="#page-top" aria-label="Voltar ao topo"><i class="fas fa-angle-up"></i></a>

<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/inputmask/min/jquery.inputmask.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>

<script type="text/javascript">
  $('[data-mask]').inputmask();

  function copyUrlToClipboard() {
    var url = document.getElementById("url").value;
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(url).then(function(){
        vtToast("URL copiada!", "success");
      }, function(){
        fallbackCopy();
      });
    } else {
      fallbackCopy();
    }
  }

  function fallbackCopy() {
    var field = document.getElementById("url");
    field.removeAttribute("readonly");
    field.select();
    field.setSelectionRange(0, 99999);
    document.execCommand("copy");
    field.setAttribute("readonly", "readonly");
    vtToast("URL copiada!", "success");
  }
</script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>
