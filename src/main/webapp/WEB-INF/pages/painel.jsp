<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem Também - Painel</title>
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
  <spring:url value="/resources/css/vt-layout.css" var="vtlayoutcss" />
  <link href="${vtlayoutcss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-components.css" var="vtcomponentscss" />
  <link href="${vtcomponentscss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-tour.css" var="vttourcss" />
  <link href="${vttourcss}" rel="stylesheet"/>
  <spring:url value="/resources/vendor/introjs/introjs.min.css" var="introcss" />
  <link href="${introcss}" rel="stylesheet"/>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <!-- Content Wrapper -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">

      <!-- Topbar -->
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />
      <!-- /Topbar -->

      <!-- Conteúdo -->
      <div class="container-fluid">
        <c:set var="jornadaAtual" value="${empty nomeJornadaAtual ? 'Jornada da Semente' : nomeJornadaAtual}" />
        <div class="content-surface mb-4" data-tour-id="painel-intro">
          	<h1 class="h3 mb-0">Um por todos &amp; todos por um.</h1>
			<p class="mb-0" style="opacity:.9">Cada doação transforma histórias. Juntos, fazemos a generosidade chegar mais longe - de forma simples, justa e rápida.</p>
        </div>

        <c:if test="${!usuarioLogado.ativo}">
          <div class="card mb-4" data-tour-id="painel-pendente">
            <div class="card-body">
              <p class="mb-2"><b class="text-brand">Assinatura pendente</b></p>
              <p class="mb-3">
                Seu acesso ao portal está liberado, mas a ativação ainda depende da validação do comprovante.
                Envie ou acompanhe seu comprovante em <b>Minha Contribuição</b>.
              </p>
              <c:if test="${not empty usuarioLogado.motivoRecusaAtivacao}">
                <div class="alert alert-danger mb-3" role="alert">
                  <strong>Comprovante recusado.</strong> ${usuarioLogado.motivoRecusaAtivacao}
                </div>
              </c:if>
              <a href="/vemtambem/usuario/donatarios" class="btn btn-olive btn-sm px-3">
                Ir para Minha Contribuição <i class="fas fa-arrow-right ml-1"></i>
              </a>
            </div>
          </div>
        </c:if>

        <!-- Cards de progresso (gamificação) -->
        <c:if test="${usuarioLogado.ativo}">
          <div class="row">
            <!-- Card Meu Ciclo -->
            <div class="col-xl-4 col-md-6 mb-4" data-tour-id="painel-progress">
              <div class="card h-100">
                <div class="card-body">
                  <div class="d-flex align-items-center mb-3">
                    <i class="fas fa-trophy fa-2x mr-3 icon-gold"></i>
                    <div>
                      <h6 class="mb-0 font-weight-bold" style="color:var(--ink)">Meu Ciclo</h6>
                      <small class="text-muted">
                        <c:choose>
                          <c:when test="${not empty jornadaAtual}">${jornadaAtual}</c:when>
                          <c:otherwise>Jornada da Semente</c:otherwise>
                        </c:choose>
                      </small>
                    </div>
                  </div>
                  <div class="mb-2">
                    <div class="d-flex justify-content-between mb-1">
                      <small class="font-weight-bold">Doações recebidas</small>
                      <small class="font-weight-bold">${usuarioLogado.quantDoacoesRecebidas}/8</small>
                    </div>
                    <div class="progress" style="height:10px;">
                      <c:set var="progresso" value="${usuarioLogado.quantDoacoesRecebidas * 100 / 8}" />
                      <div class="progress-bar progress-bar-brand" role="progressbar" style="width:${progresso > 100 ? 100 : progresso}%;"></div>
                    </div>
                  </div>
                  <c:choose>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 8}">
                      <small class="text-success-brand"><i class="fas fa-star mr-1"></i>Parabéns! Ciclo completo. Hora do próximo Nível.</small>
                    </c:when>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 4}">
                      <small class="text-warn-brand"><i class="fas fa-fire mr-1"></i>${usuarioLogado.quantDoacoesRecebidas} de 8 — sua rede está crescendo</small>
                    </c:when>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 1}">
                      <small style="color:var(--muted)"><i class="fas fa-fire mr-1 text-warn-brand"></i>Já recebeu ${usuarioLogado.quantDoacoesRecebidas} — continue compartilhando</small>
                    </c:when>
                    <c:otherwise>
                      <small style="color:var(--muted)"><i class="fas fa-seedling mr-1 text-success-brand"></i>Convide pessoas — seu primeiro indicado é o passo mais importante</small>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>

            <!-- Card Nível -->
            <div class="col-xl-4 col-md-6 mb-4" data-tour-id="painel-next-step">
              <div class="card h-100">
                <div class="card-body">
                  <div class="d-flex align-items-center mb-3">
                    <c:choose>
                      <c:when test="${usuarioLogado.quantCiclos >= 3}">
                        <div class="d-flex align-items-center justify-content-center mr-3" style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#f59e0b,#f97316); color:#fff; font-size:1.1rem; font-weight:800;">
                          <i class="fas fa-crown"></i>
                        </div>
                      </c:when>
                      <c:when test="${usuarioLogado.quantCiclos >= 2}">
                        <div class="d-flex align-items-center justify-content-center mr-3" style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#a78bfa,#7c3aed); color:#fff; font-size:1.1rem; font-weight:800;">
                          <i class="fas fa-gem"></i>
                        </div>
                      </c:when>
                      <c:when test="${usuarioLogado.quantCiclos >= 1}">
                        <div class="d-flex align-items-center justify-content-center mr-3" style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#60a5fa,#3b82f6); color:#fff; font-size:1.1rem; font-weight:800;">
                          <i class="fas fa-medal"></i>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="d-flex align-items-center justify-content-center mr-3" style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#34d399,#10b981); color:#fff; font-size:1.1rem; font-weight:800;">
                          <i class="fas fa-seedling"></i>
                        </div>
                      </c:otherwise>
                    </c:choose>
                    <div>
                      <h6 class="mb-0 font-weight-bold" style="color:var(--ink)">
                        <c:choose>
                          <c:when test="${usuarioLogado.quantCiclos >= 3}">Mestre</c:when>
                          <c:when test="${usuarioLogado.quantCiclos >= 2}">Veterano</c:when>
                          <c:when test="${usuarioLogado.quantCiclos >= 1}">Colaborador</c:when>
                          <c:otherwise>Iniciante</c:otherwise>
                        </c:choose>
                      </h6>
                      <small class="text-muted">${usuarioLogado.quantCiclos} ciclo(s) completado(s)</small>
                    </div>
                  </div>
                  <a href="/vemtambem/usuario/minha-rede" class="btn btn-olive btn-sm px-3">Ver Rede <i class="fas fa-arrow-right ml-1"></i></a>
                </div>
              </div>
            </div>

            <!-- Card Próximo Passo -->
            <div class="col-xl-4 col-md-6 mb-4">
              <div class="card h-100">
                <div class="card-body">
                  <div class="d-flex align-items-center mb-3">
                    <i class="fas fa-gift fa-2x mr-3" style="color:#8b5cf6"></i>
                    <div>
                      <h6 class="mb-0 font-weight-bold" style="color:var(--ink)">Próximo Passo</h6>
                      <small class="text-muted">
                        <c:choose>
                          <c:when test="${!usuarioLogado.doacaoFeita}">Realize sua doação</c:when>
                          <c:when test="${usuarioLogado.quantDoacoesRecebidas < 8}">Convide mais pessoas</c:when>
                          <c:otherwise>Reativar para o próximo Nível</c:otherwise>
                        </c:choose>
                      </small>
                    </div>
                  </div>
                  <c:choose>
                    <c:when test="${!usuarioLogado.doacaoFeita}">
                      <a href="/vemtambem/usuario/donatarios" class="btn btn-olive btn-sm px-3">Minha Contribuição <i class="fas fa-arrow-right ml-1"></i></a>
                    </c:when>
                    <c:otherwise>
                      <a href="/vemtambem/usuario/doadores" class="btn btn-olive btn-sm px-3">Ver Doadores <i class="fas fa-arrow-right ml-1"></i></a>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>

          <!-- Copiar link de convite -->
          <div class="card mb-4" data-tour-id="painel-invite-link">
            <div class="card-body d-flex align-items-center justify-content-between flex-wrap">
              <div class="mr-3 mb-2">
                <h6 class="mb-1 font-weight-bold" style="color:var(--ink)"><i class="fas fa-link mr-2 icon-olive"></i>Convide pessoas para sua rede</h6>
                <small class="text-muted">Compartilhe seu link exclusivo de convite</small>
              </div>
              <button id="btnCopiarLink" class="btn btn-olive btn-sm px-4 mb-2" onclick="copiarLinkConvite()">
                <i class="fas fa-copy mr-1"></i> Copiar Link
              </button>
            </div>
          </div>
        </c:if>

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

<!-- Scroll Top -->
<a class="scroll-to-top rounded" href="#page-top"><i class="fas fa-angle-up"></i></a>

<!-- Global Modals -->
<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<!-- Session Timeout Modal -->
<div class="modal fade" id="sessionTimeoutModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom:1px solid #e5e7eb">
        <h5 class="modal-title"><i class="fas fa-clock mr-2 icon-gold"></i>Sessão expirando</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body text-center py-4">
        <p class="mb-1">Sua sessão vai expirar em</p>
        <h2 id="sessionCountdown" class="font-weight-bold" style="color:var(--olive)">1:00</h2>
        <small class="text-muted">Clique em qualquer lugar ou interaja com a página para renovar.</small>
      </div>
      <div class="modal-footer" style="border-top:1px solid #e5e7eb">
        <a class="btn btn-secondary btn-sm" href="/vemtambem/sair">Sair agora</a>
        <button class="btn btn-olive btn-sm px-4" data-dismiss="modal" onclick="renovarSessao()">Continuar</button>
      </div>
    </div>
  </div>
</div>

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>

<script>
// Copiar link de convite
function copiarLinkConvite() {
  var login = '${usuarioLogado.login}';
  var link = window.location.origin + '/vemtambem/usuario/convite?id=' + login;
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(link).then(function() { vtToast('Link copiado!', 'success'); });
  } else {
    var ta = document.createElement('textarea');
    ta.value = link; ta.style.position = 'fixed'; ta.style.opacity = '0';
    document.body.appendChild(ta); ta.select();
    document.execCommand('copy'); document.body.removeChild(ta);
    vtToast('Link copiado!', 'success');
  }
}

// Contador regressivo de sessão (5 min = 300s)
(function() {
  var SESSION_TOTAL = 5 * 60;
  var WARN_AT = 60;
  var remaining = SESSION_TOTAL;
  var warned = false;
  var countdownTimer = null;

  function resetTimer() {
    remaining = SESSION_TOTAL;
    warned = false;
    if (countdownTimer) { clearInterval(countdownTimer); countdownTimer = null; }
    $('#sessionTimeoutModal').modal('hide');
  }

  function startCountdown() {
    countdownTimer = setInterval(function() {
      remaining--;
      if (remaining <= 0) {
        clearInterval(countdownTimer);
        window.location.href = '/vemtambem/sair';
        return;
      }
      if (remaining <= WARN_AT && !warned) {
        warned = true;
        $('#sessionTimeoutModal').modal('show');
      }
      if (warned) {
        var m = Math.floor(remaining / 60);
        var s = remaining % 60;
        $('#sessionCountdown').text(m + ':' + (s < 10 ? '0' : '') + s);
      }
    }, 1000);
  }

  $(document).ready(function() {
    startCountdown();
    $(document).on('click keypress mousemove', function() {
      if (remaining > WARN_AT) { remaining = SESSION_TOTAL; }
    });
  });

  window.renovarSessao = function() {
    $.get('/vemtambem/painel', function() { resetTimer(); startCountdown(); });
  };
})();
</script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>





