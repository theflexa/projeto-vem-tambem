<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem Também — Ativar Cadastros</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <!-- Fontes / ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 + VT Theme -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>

  <!-- DataTables -->
  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>
</head>
<body id="page-top">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <!-- Content -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow-sm">
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-2" aria-label="Abrir menu"><i class="fa fa-bars"></i></button>
        <ul class="navbar-nav ml-auto">
          <div class="topbar-divider d-none d-sm-block"></div>
          <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <span class="mr-2 d-sm-inline text-gray-700 small"><i class="fas fa-user-circle"></i> ${usuarioLogado.nome}</span>
            </a>
          </li>
        </ul>
      </nav>

      <div class="container-fluid">
        <div class="content-surface mb-3">
          <h1 class="h3">Ativar Cadastros</h1>
          <p>Revise os dados e aprove os cadastros pendentes.</p>
        </div>

        <c:if test="${sucesso == true}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>Sucesso!</strong> Operação realizada com sucesso.
            <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
        </c:if>

        <div class="card shadow mb-4">
          <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-brand">Cadastrados pendentes de aprovação</h6>
          </div>

          <div class="card-body">
            <div class="table-responsive">
              <table id="tabela" class="table table-bordered table-brand-stripe" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>CPF</th>
                    <th>Whatsapp</th>
                    <th style="width:220px">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="pessoa" items="${listPessoa}">
                    <tr>
                      <td>${pessoa.nome}</td>
                      <td>${pessoa.documento}</td>
                      <td class="wa">
                        <a href="https://api.whatsapp.com/send?phone=${pessoa.whatsapp}" target="_blank" rel="noopener">
                          ${pessoa.whatsapp} <i class="fab fa-whatsapp"></i>
                        </a>
                      </td>
                      <td>
                        <button class="btn btn-olive-outline btn-sm"
                                onclick="downloadComprovante(${pessoa.id})">
                          Comprovante
                        </button>
                        <button id="btnAtivar-${pessoa.id}" class="btn btn-olive btn-sm"
                                onclick="ativarPessoa(${pessoa.id})">
                          Ativar
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>

      </div><!-- /container-fluid -->
    </div><!-- /content -->

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

<!-- DataTables -->
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/jquery.dataTables.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/dataTables.bootstrap4.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>

<script type="text/javascript">
  $(function () {
    $("#tabela").DataTable({
      responsive: true,
      autoWidth: false,
      language: {
        "sEmptyTable": "Nenhum registro encontrado",
        "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
        "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
        "sInfoFiltered": "(Filtrados de _MAX_ registros)",
        "sInfoThousands": ".",
        "sLengthMenu": "_MENU_ resultados por página",
        "sLoadingRecords": "Carregando...",
        "sProcessing": "Processando...",
        "sZeroRecords": "Nenhum registro encontrado",
        "sSearch": "Pesquisar",
        "oPaginate": {"sNext": "Próximo","sPrevious": "Anterior","sFirst": "Primeiro","sLast": "Último"},
        "oAria": {"sSortAscending": ": Ordenar colunas de forma ascendente","sSortDescending": ": Ordenar colunas de forma descendente"}
      },
      order: []
    });
  });

  function downloadComprovante(pessoaId){
    window.location.href = '${cp}/usuario/comprovante/download/' + pessoaId;
  }

  function ativarPessoa(pessoaId){
    var btn = document.getElementById('btnAtivar-' + pessoaId);
    if(btn){ btn.disabled = true; btn.innerText = 'Ativando...'; }
    window.location.href = '${cp}/admin/ativar?id=' + pessoaId;
  }
</script>
</body>
</html>
