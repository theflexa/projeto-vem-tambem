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

  <!-- Fontes e ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 + VT Theme -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>
</head>
<body id="page-top">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <!-- Content Wrapper -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">

      <!-- Topbar -->
      <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow-sm">
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-2" aria-label="Abrir menu"><i class="fa fa-bars"></i></button>
        <ul class="navbar-nav ml-auto">
          <div class="topbar-divider d-none d-sm-block"></div>
          <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown"
               aria-haspopup="true" aria-expanded="false">
              <span class="mr-2 d-sm-inline text-gray-700 small"><i class="fas fa-user-circle"></i> ${usuarioLogado.nome}</span>
            </a>
          </li>
        </ul>
      </nav>

      <!-- Conteúdo -->
      <div class="container-fluid">
        <div class="content-surface mb-4">
          <h1 class="h3 mb-1">Meus Dados</h1>
        </div>

        <div class="card shadow mb-4">
          <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-brand">Dados cadastrais</h6>
          </div>

          <div class="card-body">
            <c:if test="${sucesso == true}">
              <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Dados atualizados com sucesso.</strong>
                <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
            </c:if>

            <form:form id="cadastro-form" action="${cp}/usuario/dados-pessoais/salvar" method="post" modelAttribute="pessoa">
              <input type="hidden" id="id" name="id" value="${pessoa.id}" />

              <!-- Linha 1: Nome/Razão + Documento -->
              <div class="form-row">
                <div class="form-group col-md-9">
                  <label for="nome"><c:out value="${pessoa.tipoConta ? 'Nome' : 'Razão Social'}"/></label>
                  <input type="text" class="form-control" id="nome" name="nome" value="${pessoa.nome}" disabled="disabled">
                </div>
                <div class="form-group col-md-3">
                  <label for="documento">CPF/CNPJ</label>
                  <input type="text" class="form-control" id="documento" name="documento" value="${pessoa.documento}" disabled="disabled">
                </div>
              </div>

              <!-- Linha 2: Contatos e PIX -->
              <div class="form-row">
                <div class="form-group col-md-5">
                  <label for="email">E-mail</label>
                  <input type="email" class="form-control" id="email" name="email" value="${pessoa.email}" disabled="disabled">
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

              <!-- Linha 3: Acesso + Convite -->
              <div class="form-row">
                <div class="form-group col-md-4">
                  <label for="login">Login</label>
                  <input type="text" class="form-control" id="login" name="login" value="${pessoa.login}" disabled="disabled">
                </div>
                <div class="form-group col-md-8">
                  <label for="url">URL de Convite</label>
                  <div class="input-group">
                    <input type="text" class="form-control" id="url" name="url" readonly="readonly"
                           value="www.vemtambem.com.br${cp}/usuario/convite?id=${pessoa.login}">
                    <div class="input-group-append">
                      <button type="button" class="btn btn-olive" onclick="copyUrlToClipboard()">Copiar</button>
                    </div>
                  </div>
                </div>
              </div>

              <hr>
              <h6 class="section-title">Endereço</h6>

              <div class="form-row">
                <div class="form-group col-md-12">
                  <label for="logradouro">Logradouro</label>
                  <input type="text" class="form-control" id="logradouro" name="endereco.logradouro" value="${pessoa.endereco.logradouro}" disabled="disabled">
                </div>
              </div>

              <div class="form-row">
                <div class="form-group col-md-4">
                  <label for="bairro">Bairro</label>
                  <input type="text" class="form-control" id="bairro" name="endereco.bairro" value="${pessoa.endereco.bairro}" disabled="disabled">
                </div>
                <div class="form-group col-md-3">
                  <label for="municipio">Cidade</label>
                  <input type="text" class="form-control" id="municipio" name="endereco.municipio" value="${pessoa.endereco.municipio}" disabled="disabled">
                </div>
                <div class="form-group col-md-3">
                  <label for="estado">Estado</label>
                  <input type="text" class="form-control" id="estado" name="endereco.estado" value="${pessoa.endereco.estado}" disabled="disabled">
                </div>
                <div class="form-group col-md-2">
                  <label for="cep">CEP</label>
                  <input type="text" class="form-control" id="cep" name="endereco.cep" value="${pessoa.endereco.cep}" disabled="disabled">
                </div>
              </div>

              <div class="form-row">
                <div class="form-group col-md-12">
                  <label for="complemento">Complemento</label>
                  <input type="text" class="form-control" id="complemento" name="endereco.complemento" value="${pessoa.endereco.complemento}" disabled="disabled">
                </div>
              </div>

              <div class="form-row">
                <div class="form-group col-md-12">
                  <button type="submit" class="btn btn-olive px-4">Atualizar Dados</button>
                </div>
              </div>
            </form:form>
          </div>
        </div>
      </div><!-- /container-fluid -->
    </div><!-- /content -->

    <!-- Footer -->
    <footer class="sticky-footer">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>&copy; Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div><!-- /content-wrapper -->
</div><!-- /wrapper -->

<!-- Scroll to Top -->
<a class="scroll-to-top rounded" href="#page-top" aria-label="Voltar ao topo"><i class="fas fa-angle-up"></i></a>

<!-- Logout Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="logoutTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="logoutTitle">Sair</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">Deseja encerrar a sessão atual?</div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancelar</button>
        <a class="btn btn-primary" href="${cp}/sair">Sair</a>
      </div>
    </div>
  </div>
</div>

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>

<!-- Inputmask -->
<script type="text/javascript" src="<c:url value='/resources/vendor/inputmask/min/jquery.inputmask.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>

<script type="text/javascript">
  // máscaras
  $('[data-mask]').inputmask();

  // copiar URL — using toast instead of alert()
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
  function fallbackCopy(){
    var field = document.getElementById("url");
    field.removeAttribute('readonly'); field.select(); field.setSelectionRange(0, 99999);
    document.execCommand("copy");
    field.setAttribute('readonly', 'readonly');
    vtToast("URL copiada!", "success");
  }
</script>
</body>
</html>
