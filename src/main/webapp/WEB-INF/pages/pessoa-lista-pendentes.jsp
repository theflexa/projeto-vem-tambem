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

  <title>Vem Também — Ativações Pendentes</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>">

  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
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

  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper">
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <div class="content-surface mb-3">
          <h1 class="h3">Ativações Pendentes</h1>
          <p>Revise os dados, aprove ou recuse os cadastros pendentes.</p>
        </div>

        <c:if test="${sucesso == true}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>Sucesso!</strong> ${empty mensagem ? 'Operação realizada com sucesso.' : mensagem}
            <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
        </c:if>

        <c:if test="${sucesso == false}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Atenção:</strong> ${empty mensagem ? 'Não foi possível concluir a operação.' : mensagem}
            <button type="button" class="close" data-dismiss="alert" aria-label="Fechar">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
        </c:if>

        <div class="card shadow mb-4">
          <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-brand">Cadastros pendentes de validação</h6>
          </div>

          <div class="card-body">
            <div class="table-responsive">
              <table id="tabela" class="table table-bordered table-brand-stripe" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>CPF</th>
                    <th>Whatsapp</th>
                    <th style="width:280px">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="pessoa" items="${listPessoa}">
                    <tr>
                      <td>${pessoa.nome}</td>
                      <td>${pessoa.documento}</td>
                      <td class="wa">
                        <c:choose>
                          <c:when test="${not empty pessoa.whatsapp}">
                            <a href="https://api.whatsapp.com/send?phone=${pessoa.whatsappFormat}" target="_blank" rel="noopener">
                              ${pessoa.whatsapp} <i class="fab fa-whatsapp"></i>
                            </a>
                          </c:when>
                          <c:otherwise>
                            <span class="text-muted">—</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a class="btn btn-olive-outline btn-sm"
                           href="${cp}/usuario/comprovante/download/${pessoa.id}"
                           target="_blank"
                           rel="noopener">
                          Comprovante
                        </a>
                        <button id="btnAtivar-${pessoa.id}" class="btn btn-olive btn-sm" onclick="ativarPessoa(${pessoa.id})">
                          Ativar
                        </button>
                        <button type="button" class="btn btn-danger btn-sm" onclick="abrirRecusa(${pessoa.id}, '${fn:escapeXml(pessoa.nome)}')">
                          Recusar
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
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

<div class="modal fade" id="recusaModal" tabindex="-1" role="dialog" aria-labelledby="recusaModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <form method="post" action="${cp}/admin/recusar" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="recusaModalLabel">Recusar ativação</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Fechar">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="recusa-id" name="id">
        <p class="mb-2">Informe o motivo da recusa para o usuário <b id="recusa-nome"></b>.</p>
        <textarea id="motivoRecusa" name="motivoRecusa" class="form-control" rows="4" maxlength="600"
                  placeholder="Ex.: comprovante ilegível, valor divergente ou dados inconsistentes." required></textarea>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancelar</button>
        <button class="btn btn-danger" type="submit">Confirmar recusa</button>
      </div>
    </form>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
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
        "oPaginate": {"sNext": "Próximo", "sPrevious": "Anterior", "sFirst": "Primeiro", "sLast": "Último"},
        "oAria": {"sSortAscending": ": Ordenar colunas de forma ascendente", "sSortDescending": ": Ordenar colunas de forma descendente"}
      },
      order: []
    });
  });

  function ativarPessoa(pessoaId) {
    var btn = document.getElementById('btnAtivar-' + pessoaId);
    if (btn) {
      btn.disabled = true;
      btn.innerText = 'Ativando...';
    }
    window.location.href = '${cp}/admin/ativar?id=' + pessoaId;
  }

  function abrirRecusa(pessoaId, nomePessoa) {
    document.getElementById('recusa-id').value = pessoaId;
    document.getElementById('recusa-nome').textContent = nomePessoa || '';
    document.getElementById('motivoRecusa').value = '';
    $('#recusaModal').modal('show');
  }
</script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>
