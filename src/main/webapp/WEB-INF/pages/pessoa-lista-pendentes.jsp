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

  <!-- Paths -->
  <c:set var="cp"  value="${pageContext.request.contextPath}" />
  <c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri'] != null 
                           ? requestScope['javax.servlet.forward.request_uri'] 
                           : pageContext.request.requestURI}" />

  <!-- Fontes / ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>

  <!-- DataTables -->
  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>

  <style>
    :root{ --olive:#6f7a00; --gold:#f3c900; --ink:#1f2937; --muted:#6b7280; --radius:18px; }
    html,body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif;}
    body{
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      min-height:100vh;
    }

    /* Sidebar */
    .bg-gradient-primary{ background: linear-gradient(180deg, var(--olive) 0%, #8e8a0a 60%, var(--gold) 120%) !important; }
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

    /* Tabela */
    .table thead th{border-top:0; color:#4b5563; font-weight:800; text-transform:uppercase; font-size:.78rem; letter-spacing:.02em;}
    .table td, .table th{vertical-align:middle}
    .wa i{margin-left:.25rem}
  </style>
</head>
<body id="page-top">

<div id="wrapper">
  <!-- Sidebar -->
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${cp}/painel">
      <div class="sidebar-brand-icon">
        <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também" style="height:85px">
      </div>
    </a>

    <hr class="sidebar-divider my-0"/>

    <li class="nav-item ${fn:startsWith(uri, cp.concat('/painel')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/painel"><i class="fas fa-home"></i><span>Painel</span></a>
    </li>

    <hr class="sidebar-divider"/>
    <div class="sidebar-heading">Operação</div>

    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/minha-rede')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/minha-rede"><i class="fas fa-network-wired"></i><span>Minha Rede</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/dados-pessoais')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/dados-pessoais"><i class="fas fa-user"></i><span>Meus Dados</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/donatarios')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/donatarios"><i class="fas fa-hand-holding-heart"></i><span>Minha Contribuição</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/doadores')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/doadores"><i class="fas fa-donate"></i><span>Doadores</span></a>
    </li>
    <li class="nav-item"><a class="nav-link" href="${cp}/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a></li>

    <hr class="sidebar-divider d-none d-md-block"/>
    <div class="sidebar-heading">Atendimento</div>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/suporte')) ? 'active' : ''}">
      <a class="nav-link" href="/vemtambem/faq"><i class="fas fa-question-circle"></i><span>Perguntas Frequentes</span></a>
      <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank"><i class="fas fa-headset"></i><span>Suporte</span></a>
    </li>

    <c:if test="${usuarioLogado.admin}">
      <hr class="sidebar-divider d-none d-md-block"/>
      <div class="sidebar-heading">Admin</div>
      <li class="nav-item ${fn:startsWith(uri, cp.concat('/admin/listar-pendentes')) ? 'active' : ''}">
        <a class="nav-link" href="${cp}/admin/listar-pendentes"><i class="fas fa-user-check"></i><span>Ativar Cadastrados</span></a>
      </li>
    </c:if>

    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle" aria-label="Alternar menu"></button>
    </div>
  </ul>
  <!-- /Sidebar -->

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
              <table id="tabela" class="table table-bordered" width="100%" cellspacing="0">
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
                        <button class="btn btn-primary btn-sm"
                                onclick="downloadComprovante(${pessoa.id})">
                          Comprovante
                        </button>
                        <button id="btnAtivar-${pessoa.id}" class="btn btn-success btn-sm"
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

    <footer class="sticky-footer bg-white">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>© Vem Também 2025-2026</span>
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
      order: [] // sem ordenação inicial
    });
  });

  function downloadComprovante(pessoaId){
    // ajuste de rota com contextPath
    window.location.href = '${cp}/usuario/comprovante/download/' + pessoaId;
  }

  function ativarPessoa(pessoaId){
    var btn = document.getElementById('btnAtivar-' + pessoaId);
    if(btn){ btn.disabled = true; btn.innerText = 'Ativando...'; }
    // ajuste de rota com contextPath
    window.location.href = '${cp}/admin/ativar?id=' + pessoaId;
  }
</script>
</body>
</html>
