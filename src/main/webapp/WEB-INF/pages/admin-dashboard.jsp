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

  <title>Vem Tambem - Dashboard Admin</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

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
          <h1 class="h3 mb-1">Dashboard Administrativo</h1>
          <p class="mb-0">Visão geral da operação, ciclos e status da base.</p>
        </div>

        <div class="row">
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card h-100">
              <div class="card-body">
                <div class="text-xs font-weight-bold text-uppercase text-muted mb-1">Ciclos Criados</div>
                <div class="h4 mb-0 font-weight-bold">${totalCiclosCriados}</div>
              </div>
            </div>
          </div>
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card h-100">
              <div class="card-body">
                <div class="text-xs font-weight-bold text-uppercase text-muted mb-1">Ciclos Ativos</div>
                <div class="h4 mb-0 font-weight-bold">${ciclosAtivos}</div>
              </div>
            </div>
          </div>
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card h-100">
              <div class="card-body">
                <div class="text-xs font-weight-bold text-uppercase text-muted mb-1">Ativações Pendentes</div>
                <div class="h4 mb-0 font-weight-bold">${ativacoesPendentes}</div>
              </div>
            </div>
          </div>
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card h-100">
              <div class="card-body">
                <div class="text-xs font-weight-bold text-uppercase text-muted mb-1">Doações Confirmadas</div>
                <div class="h4 mb-0 font-weight-bold">${doacoesConfirmadas}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-xl-6 mb-4">
            <div class="card h-100">
              <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-brand">Status de Usuários</h6>
              </div>
              <div class="card-body">
                <canvas id="chartStatusUsuarios"></canvas>
              </div>
            </div>
          </div>
          <div class="col-xl-6 mb-4">
            <div class="card h-100">
              <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-brand">Ciclos por Jornada</h6>
              </div>
              <div class="card-body">
                <canvas id="chartCiclosPorTipo"></canvas>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="sticky-footer">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>&copy; Vem Tambem 2025-2026</span>
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
<script type="text/javascript" src="<c:url value='/resources/vendor/chart.js/Chart.min.js'/>"></script>

<script type="text/javascript">
  (function renderAdminCharts() {
    var statusCtx = document.getElementById('chartStatusUsuarios');
    if (statusCtx) {
      new Chart(statusCtx, {
        type: 'doughnut',
        data: {
          labels: ['Ativos', 'Pendentes', 'Admins'],
          datasets: [{
            data: [${usuariosAtivos}, ${usuariosPendentes}, ${usuariosAdmins}],
            backgroundColor: ['#7f8301', '#edb80a', '#4b5563'],
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          legend: { position: 'bottom' }
        }
      });
    }

    var cicloLabels = [];
    var cicloTotais = [];
    <c:forEach var="item" items="${ciclosPorTipo}">
      cicloLabels.push('<c:out value="${item.nome}" />');
      cicloTotais.push(${item.total});
    </c:forEach>

    var ciclosCtx = document.getElementById('chartCiclosPorTipo');
    if (ciclosCtx) {
      new Chart(ciclosCtx, {
        type: 'bar',
        data: {
          labels: cicloLabels,
          datasets: [{
            label: 'Ciclos',
            data: cicloTotais,
            backgroundColor: '#91952d'
          }]
        },
        options: {
          responsive: true,
          legend: { display: false },
          scales: {
            yAxes: [{
              ticks: { beginAtZero: true, precision: 0 }
            }]
          }
        }
      });
    }
  })();
</script>
</body>
</html>
