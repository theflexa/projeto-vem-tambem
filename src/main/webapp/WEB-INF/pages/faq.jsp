<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem Também — Perguntas Frequentes</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>
</head>
<body id="page-top">

<div id="wrapper">
  <!-- Sidebar -->
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/vemtambem/painel">
      <div class="sidebar-brand-icon">
        <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também" style="height:85px">
      </div>
    </a>
    <hr class="sidebar-divider my-0"/>
    <li class="nav-item">
      <a class="nav-link" href="/vemtambem/painel"><i class="fas fa-home"></i><span>Painel</span></a>
    </li>
    <hr class="sidebar-divider"/>
    <div class="sidebar-heading">Operação</div>
    <c:if test="${usuarioLogado != null && usuarioLogado.ativo}">
      <li class="nav-item">
        <a class="nav-link" href="/vemtambem/usuario/minha-rede"><i class="fas fa-network-wired"></i><span>Minha Rede</span></a>
        <a class="nav-link" href="/vemtambem/usuario/dados-pessoais"><i class="fas fa-user"></i><span>Meus Dados</span></a>
        <a class="nav-link" href="/vemtambem/usuario/donatarios"><i class="fas fa-hand-holding-heart"></i><span>Minha Contribuição</span></a>
        <a class="nav-link" href="/vemtambem/usuario/doadores"><i class="fas fa-donate"></i><span>Doadores</span></a>
        <a class="nav-link" href="/vemtambem/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
      </li>
    </c:if>
    <c:if test="${usuarioLogado == null || !usuarioLogado.ativo}">
      <li class="nav-item">
        <a class="nav-link" href="/vemtambem/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a>
      </li>
    </c:if>
    <hr class="sidebar-divider d-none d-md-block"/>
    <div class="sidebar-heading">Atendimento</div>
    <li class="nav-item active">
      <a class="nav-link" href="/vemtambem/faq"><i class="fas fa-question-circle"></i><span>Perguntas Frequentes</span></a>
      <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank"><i class="fas fa-headset"></i><span>Suporte</span></a>
    </li>
    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>
  </ul>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow-sm">
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-2"><i class="fa fa-bars"></i></button>
        <ul class="navbar-nav ml-auto">
          <div class="topbar-divider d-none d-sm-block"></div>
          <li class="nav-item dropdown no-arrow">
            <a class="nav-link" href="#"><span class="mr-2 d-sm-inline text-gray-700 small"><i class="fas fa-user-circle"></i> ${usuarioLogado.nome}</span></a>
          </li>
        </ul>
      </nav>

      <div class="container-fluid">
        <div class="content-surface mb-4">
          <h1 class="h3 mb-0"><i class="fas fa-question-circle mr-2" style="color:var(--gold)"></i>Perguntas Frequentes</h1>
          <p class="mb-0">Tire suas dúvidas sobre a plataforma Vem Também.</p>
        </div>

        <div class="card mb-4">
          <div class="card-body p-0">
            <div id="faqAccordion">

              <!-- FAQ 1 -->
              <div class="border-bottom">
                <div class="p-3" id="faq1head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq1body" aria-expanded="true">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      O que é a plataforma Vem Também?
                    </a>
                  </h6>
                </div>
                <div id="faq1body" class="collapse show" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    A Vem Também é uma plataforma de doações colaborativas onde cada participante contribui e recebe doações em uma rede organizada em formato de tabuleiro (árvore binária). É uma forma simples, justa e rápida de praticar a generosidade.
                  </div>
                </div>
              </div>

              <!-- FAQ 2 -->
              <div class="border-bottom">
                <div class="p-3" id="faq2head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq2body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como funciona o Tabuleiro?
                    </a>
                  </h6>
                </div>
                <div id="faq2body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    O tabuleiro funciona como uma árvore binária: você entra na rede, faz sua doação de ativação e a doação ao seu donatário. Conforme novas pessoas entram na sua rede, elas fazem doações para você. Quando 8 doações são recebidas, seu ciclo se completa e você pode reativar para o próximo nível.
                  </div>
                </div>
              </div>

              <!-- FAQ 3 -->
              <div class="border-bottom">
                <div class="p-3" id="faq3head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq3body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Quais são os valores de doação?
                    </a>
                  </h6>
                </div>
                <div id="faq3body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    No Tabuleiro 1, a doação de ativação (T.I.) é de R$ 10,00 e a doação ao donatário é de R$ 90,00. Nos níveis seguintes, os valores aumentam proporcionalmente (Tabuleiro 2: R$ 50 + R$ 450, Tabuleiro 3: R$ 100 + R$ 900).
                  </div>
                </div>
              </div>

              <!-- FAQ 4 -->
              <div class="border-bottom">
                <div class="p-3" id="faq4head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq4body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como faço para convidar alguém?
                    </a>
                  </h6>
                </div>
                <div id="faq4body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    No seu Painel, há um botão "Copiar Link". Ao clicar, seu link exclusivo de convite será copiado para a área de transferência. Basta enviar esse link por WhatsApp, e-mail ou qualquer outra forma para a pessoa que deseja convidar.
                  </div>
                </div>
              </div>

              <!-- FAQ 5 -->
              <div class="border-bottom">
                <div class="p-3" id="faq5head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq5body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      O que acontece quando completo um ciclo?
                    </a>
                  </h6>
                </div>
                <div id="faq5body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    Quando você recebe 8 doações, seu ciclo se completa. Você pode então reativar sua conta para avançar ao próximo tabuleiro, com valores maiores e maior retorno. Cada ciclo completado aumenta seu nível na plataforma.
                  </div>
                </div>
              </div>

              <!-- FAQ 6 -->
              <div class="border-bottom">
                <div class="p-3" id="faq6head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq6body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como faço o pagamento?
                    </a>
                  </h6>
                </div>
                <div id="faq6body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    Os pagamentos são feitos via PIX. A chave e os valores são exibidos na tela de ativação (no Painel) e na tela de Minha Contribuição. Após realizar o PIX, envie o comprovante pela plataforma para validação.
                  </div>
                </div>
              </div>

              <!-- FAQ 7 -->
              <div>
                <div class="p-3" id="faq7head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq7body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Preciso de suporte. Como entro em contato?
                    </a>
                  </h6>
                </div>
                <div id="faq7body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    Clique em "Suporte" no menu lateral para ser redirecionado ao nosso WhatsApp de atendimento. Nossa equipe está disponível para ajudá-lo com qualquer dúvida ou problema.
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>

      </div><!-- /container-fluid -->
    </div><!-- /content -->

    <footer class="sticky-footer">
      <div class="container my-auto">
        <div class="copyright text-center my-auto text-white" style="opacity:.9">
          <span>&copy; Vem Também 2025-2026</span>
        </div>
      </div>
    </footer>
  </div>
</div>

<a class="scroll-to-top rounded" href="#page-top"><i class="fas fa-angle-up"></i></a>

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>

<style>
  /* Rotate chevron when expanded */
  [data-toggle="collapse"]:not(.collapsed) .fa-chevron-down {
    transform: rotate(180deg);
  }
</style>
</body>
</html>
