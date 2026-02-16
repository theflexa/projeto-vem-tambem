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

  <!-- SB Admin 2 -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>

  <!-- Tema VT (override) -->
  <style>
    :root{
      --olive:#6f7a00; --olive-700:#5b6400; --gold:#f3c900; --gold-700:#d9b200;
      --ink:#1f2937; --muted:#6b7280; --surface:#ffffff; --bg:#f7f7f5;
      --radius:18px;
    }
    html,body{font-family:Inter, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif;}
    body{
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      min-height:100vh;
    }

    /* Sidebar com o gradiente da marca */
    .bg-gradient-primary{
      background: linear-gradient(180deg, var(--olive) 0%, #8e8a0a 60%, var(--gold) 120%) !important;
    }
    .sidebar .nav-item .nav-link{
      border-radius: 12px; margin: 2px 8px; font-weight:600; letter-spacing:.1px;
    }
    .sidebar .nav-item .nav-link i{opacity:.9; margin-right:.35rem;}
    .sidebar .nav-item.active > .nav-link,
    .sidebar .nav-item .nav-link:hover{
      background: rgba(255,255,255,.16);
    }
    .sidebar .sidebar-brand{height:4.5rem}
    .sidebar .sidebar-brand .sidebar-brand-icon{transform: translateY(2px);}

    /* Topbar */
    .topbar{border:0; border-bottom:1px solid rgba(0,0,0,.05)}
    .topbar .navbar-nav .nav-link{font-weight:600; color:#4b5563}

    /* Brand do topbar: APENAS no mobile */
    .brand-mini{ display:none; }     /* desktop: escondido */
    .brand-mini img{height:28px; width:auto}
    @media (max-width: 991.98px){
      .brand-mini{ display:flex; align-items:center; gap:.7rem; font-weight:800; color:var(--olive-700); }
      .sidebar .sidebar-brand{ height:3.5rem; }
    }

    /* Cartões, alerts e botões */
    .card,.alert,.modal-content{border:0; border-radius:var(--radius); box-shadow: 0 6px 24px rgba(0,0,0,.08)}
    .btn-olive{
      background: linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%);
      border:0; color:#141a00; font-weight:700; border-radius:999px;
    }
    .btn-olive:hover{filter:brightness(.95)}
    .btn-linkVT{color:var(--olive-700); font-weight:600}
    .text-brand{color:var(--olive-700)}

    /* Conteúdo */
    #content-wrapper{background: transparent;}
    .container-fluid{padding-left:1rem; padding-right:1rem}

    /* Título fora da superfície clara (não usado aqui, mas mantido) */
    h1.h3{font-weight:800; color:#fff}

    /* Superfície clara do conteúdo */
    .content-surface{
      background: #ffffffd9; backdrop-filter: blur(6px);
      border-radius: var(--radius); padding: 1.25rem;
    }
    /* Cores dentro da superfície clara */
    .content-surface h1,
    .content-surface h1.h3{ color: var(--ink); }
    .content-surface p{ color: var(--muted); }
    .content-surface .text-white-75{ color: var(--muted) !important; }

    /* Tabelas/scroll responsivo se usar grids depois */
    .table-responsive{border-radius:var(--radius); overflow:hidden; background:#fff}

    /* Footer transparente */
    .sticky-footer{background:#fff0}

    /* Responsividade fina */
    @media (max-width: 575.98px){
      .content-surface{padding: .9rem}
      .alert{padding:.9rem}
    }
  </style>
</head>
<body id="page-top">

<div id="wrapper">
  <!-- Sidebar -->
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/vemtambem/painel">
      <div class="sidebar-brand-icon">
        <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também" style="height:85px">
      </div>
      <!-- <div class="sidebar-brand-text mx-3">VEM TAMBÉM</div> -->
    </a>

    <hr class="sidebar-divider my-0"/>

    <!-- Painel -->
    <li class="nav-item active">
      <a class="nav-link" href="/vemtambem/painel">
        <i class="fas fa-home"></i><span>Painel</span>
      </a>
    </li>

    <hr class="sidebar-divider"/>

    <!-- Operação -->
    <div class="sidebar-heading">Operação</div>

    <c:choose>
      <c:when test="${usuarioLogado.ativo}">
        <li class="nav-item">
          <a class="nav-link" href="/vemtambem/usuario/minha-rede"><i class="fas fa-network-wired"></i><span>Minha Rede</span></a>
          <a class="nav-link" href="/vemtambem/usuario/dados-pessoais"><i class="fas fa-user"></i><span>Meus Dados</span></a>
          <a class="nav-link" href="/vemtambem/usuario/donatarios"><i class="fas fa-hand-holding-heart"></i><span>Minha Contribuição</span></a>
          <a class="nav-link" href="/vemtambem/usuario/doadores"><i class="fas fa-donate"></i><span>Doadores</span></a>
          <a class="nav-link" href="/vemtambem/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
        </li>
      </c:when>
      <c:otherwise>
        <li class="nav-item">
          <a class="nav-link" href="/vemtambem/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
        </li>
      </c:otherwise>
    </c:choose>

    <hr class="sidebar-divider d-none d-md-block"/>

    <!-- Atendimento -->
    <div class="sidebar-heading">Atendimento</div>
    <li class="nav-item">
      <a class="nav-link" href="/vemtambem/faq"><i class="fas fa-question-circle"></i><span>Perguntas Frequentes</span></a>
      <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank"><i class="fas fa-headset"></i><span>Suporte</span></a>
    </li>

    <c:if test="${usuarioLogado.admin}">
      <hr class="sidebar-divider d-none d-md-block"/>
      <div class="sidebar-heading">Admin</div>
      <li class="nav-item">
        <a class="nav-link" href="/vemtambem/admin/listar-pendentes"><i class="fas fa-user-check"></i><span>Ativar Cadastrados</span></a>
      </li>
    </c:if>

    <!-- Toggler -->
    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>
  </ul>
  <!-- /Sidebar -->

  <!-- Content Wrapper -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">

      <!-- Topbar -->
      <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow-sm">
        <!-- Mobile: abre sidebar -->
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-2"><i class="fa fa-bars"></i></button>

        <ul class="navbar-nav ml-auto">
          <div class="topbar-divider d-none d-sm-block"></div>
          <!-- Usuário -->
          <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <span class="mr-2 d-sm-inline text-gray-700 small"><i class="fas fa-user-circle"></i> ${usuarioLogado.nome}</span>
            </a>
            <!-- dropdown futuramente -->
          </li>
        </ul>
      </nav>
      <!-- /Topbar -->

      <!-- Conteúdo -->
      <div class="container-fluid">
        <div class="content-surface mb-4">
          	<h1 class="h3 mb-0">Um por todos &amp; todos por um.</h1>
			<p class="mb-0 text-gray-600" style="opacity:.9">Cada doação transforma histórias. Juntos, fazemos a generosidade chegar mais longe - de forma simples, justa e rápida. </p>
        </div>

        <c:if test="${!usuarioLogado.ativo}">
          <c:if test="${sucessoUpload == true}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <strong>Seu comprovante foi enviado com sucesso!</strong> Nossa equipe está processando a solicitação.
              <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
              <strong>Dica:</strong> Após a ativação, acesse <b>Minha Contribuição</b> e realize a doação de R$ <c:choose><c:when test="${tipoCicloAtual != null}">${tipoCicloAtual.valorDoacao}</c:when><c:otherwise>90,00</c:otherwise></c:choose> para liberar a conta.
              <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
            </div>
          </c:if>

          <c:if test="${sucessoUpload == false}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <strong>Erro ao enviar o arquivo!</strong> Tente novamente.
              <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
            </div>
          </c:if>

          <!-- Bloco de ativação -->
          <div class="card mb-4">
            <div class="card-body">
              <p class="mb-2"><b class="text-brand">Ativação pendente</b></p>
              <p class="mb-3">Faça a doação de ativação de <b>R$ <c:choose><c:when test="${tipoCicloAtual != null}">${tipoCicloAtual.valorTI}</c:when><c:otherwise>10,00</c:otherwise></c:choose></b> para manutenção do sistema (T.I.) e, em seguida, a doação de <b>R$ <c:choose><c:when test="${tipoCicloAtual != null}">${tipoCicloAtual.valorDoacao}</c:when><c:otherwise>90,00</c:otherwise></c:choose></b> ao seu donatário.</p>
              <hr/>
              <div class="row">
                <div class="col-md-6">
                  <div class="mb-2"><b>PIX (telefone)</b></div>
                  <p class="mb-1">Chave: <b>85997151515</b></p>
                  <p class="mb-1">Valor: <b>R$ <c:choose><c:when test="${tipoCicloAtual != null}">${tipoCicloAtual.valorTI}</c:when><c:otherwise>10,00</c:otherwise></c:choose></b></p>
                  <p class="mb-3">Descrição: <i>Doação inicial de ativação - T.I.</i></p>
                </div>
                <div class="col-md-6">
                  <form:form method="post" action="/vemtambem/usuario/upload" enctype="multipart/form-data" class="d-flex align-items-end gap-2">
                    <div class="form-group mr-2 mb-2">
                      <label for="file"><b>Comprovante de pagamento</b></label><br/>
                      <input id="file" type="file" name="file" class="form-control-file"/>
                    </div>
                    <button type="submit" class="btn btn-olive mb-2 px-4">Enviar Comprovante</button>
                  </form:form>
                </div>
              </div>
            </div>
          </div>
        </c:if>

        <!-- Cards de progresso (gamificação) -->
        <c:if test="${usuarioLogado.ativo}">
          <div class="row">
            <!-- Card Meu Ciclo -->
            <div class="col-xl-4 col-md-6 mb-4">
              <div class="card h-100">
                <div class="card-body">
                  <div class="d-flex align-items-center mb-3">
                    <i class="fas fa-trophy fa-2x mr-3" style="color:var(--gold)"></i>
                    <div>
                      <h6 class="mb-0 font-weight-bold" style="color:var(--ink)">Meu Ciclo</h6>
                      <small class="text-muted">
                        <c:choose>
                          <c:when test="${tipoCicloAtual != null}">${tipoCicloAtual.nome}</c:when>
                          <c:otherwise>Tabuleiro 1</c:otherwise>
                        </c:choose>
                      </small>
                    </div>
                  </div>
                  <div class="mb-2">
                    <div class="d-flex justify-content-between mb-1">
                      <small class="font-weight-bold">Doações recebidas</small>
                      <small class="font-weight-bold">${usuarioLogado.quantDoacoesRecebidas}/8</small>
                    </div>
                    <div class="progress" style="height:10px; border-radius:999px;">
                      <c:set var="progresso" value="${usuarioLogado.quantDoacoesRecebidas * 100 / 8}" />
                      <div class="progress-bar" role="progressbar" style="width:${progresso > 100 ? 100 : progresso}%; background:linear-gradient(90deg, var(--olive), var(--gold)); border-radius:999px;"></div>
                    </div>
                  </div>
                  <c:choose>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 8}">
                      <small style="color:#16a34a; font-weight:700"><i class="fas fa-star mr-1"></i>Ciclo completo! Você arrasou!</small>
                    </c:when>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 6}">
                      <small style="color:#f59e0b; font-weight:700"><i class="fas fa-fire mr-1"></i>Quase lá! Só mais ${8 - usuarioLogado.quantDoacoesRecebidas}!</small>
                    </c:when>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 4}">
                      <small style="color:var(--muted)"><i class="fas fa-fire mr-1" style="color:#f59e0b"></i>Metade do caminho! Continue assim!</small>
                    </c:when>
                    <c:when test="${usuarioLogado.quantDoacoesRecebidas >= 1}">
                      <small style="color:var(--muted)"><i class="fas fa-fire mr-1" style="color:#f59e0b"></i>Boa! Faltam ${8 - usuarioLogado.quantDoacoesRecebidas} doações!</small>
                    </c:when>
                    <c:otherwise>
                      <small style="color:var(--muted)"><i class="fas fa-seedling mr-1" style="color:#16a34a"></i>Convide pessoas para começar!</small>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>

            <!-- Card Nível -->
            <div class="col-xl-4 col-md-6 mb-4">
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
                          <c:otherwise>Reativar para o próximo nível</c:otherwise>
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
          <div class="card mb-4">
            <div class="card-body d-flex align-items-center justify-content-between flex-wrap">
              <div class="mr-3 mb-2">
                <h6 class="mb-1 font-weight-bold" style="color:var(--ink)"><i class="fas fa-link mr-2" style="color:var(--olive)"></i>Convide pessoas para sua rede</h6>
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
        <div class="copyright text-center my-auto text-white" style="opacity:.9">
          <span>© Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div><!-- /content-wrapper -->
</div><!-- /wrapper -->

<!-- Scroll Top -->
<a class="scroll-to-top rounded" href="#page-top"><i class="fas fa-angle-up"></i></a>

<!-- Logout Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Sair</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Fechar"><span aria-hidden="true">×</span></button>
      </div>
      <div class="modal-body">Deseja encerrar a sessão atual?</div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancelar</button>
        <a class="btn btn-primary" href="/vemtambem/sair">Sair</a>
      </div>
    </div>
  </div>
</div>

<!-- Session Timeout Modal -->
<div class="modal fade" id="sessionTimeoutModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom:1px solid #e5e7eb">
        <h5 class="modal-title"><i class="fas fa-clock mr-2" style="color:var(--gold)"></i>Sessão expirando</h5>
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

<!-- Toast de feedback -->
<div id="toastCopiar" style="position:fixed;bottom:24px;left:50%;transform:translateX(-50%);background:var(--olive);color:#fff;padding:10px 24px;border-radius:999px;font-weight:600;font-size:.9rem;z-index:10000;opacity:0;transition:opacity .3s;pointer-events:none;">
  <i class="fas fa-check mr-1"></i> Link copiado!
</div>

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>

<script>
// Copiar link de convite
function copiarLinkConvite() {
  var login = '${usuarioLogado.login}';
  var link = window.location.origin + '/vemtambem/usuario/convite?id=' + login;
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(link).then(function() { mostrarToast(); });
  } else {
    var ta = document.createElement('textarea');
    ta.value = link; ta.style.position = 'fixed'; ta.style.opacity = '0';
    document.body.appendChild(ta); ta.select();
    document.execCommand('copy'); document.body.removeChild(ta);
    mostrarToast();
  }
}
function mostrarToast() {
  var t = document.getElementById('toastCopiar');
  t.style.opacity = '1';
  setTimeout(function(){ t.style.opacity = '0'; }, 2500);
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
</body>
</html>
