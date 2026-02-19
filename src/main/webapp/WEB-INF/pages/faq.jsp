<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem TambÃ©m â€” Perguntas Frequentes</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
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
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <div class="content-surface mb-4">
          <h1 class="h3 mb-0"><i class="fas fa-question-circle mr-2 icon-gold"></i>Perguntas Frequentes</h1>
          <p class="mb-0">Tire suas dÃºvidas sobre a plataforma Vem TambÃ©m.</p>
        </div>

        <div class="card mb-4">
          <div class="card-body p-0">
            <div id="faqAccordion" data-tour-id="faq-accordion">

              <!-- FAQ 1 -->
              <div class="border-bottom">
                <div class="p-3" id="faq1head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq1body" aria-expanded="true">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      O que Ã© a plataforma Vem TambÃ©m?
                    </a>
                  </h6>
                </div>
                <div id="faq1body" class="collapse show" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    A Vem TambÃ©m Ã© uma plataforma de doaÃ§Ãµes colaborativas onde cada participante contribui e recebe doaÃ§Ãµes em uma rede organizada em formato de jornada (Ã¡rvore binÃ¡ria). Ã‰ uma forma simples, justa e rÃ¡pida de praticar a generosidade.
                  </div>
                </div>
              </div>

              <!-- FAQ 2 -->
              <div class="border-bottom">
                <div class="p-3" id="faq2head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq2body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como funciona a Jornada da Semente?
                    </a>
                  </h6>
                </div>
                <div id="faq2body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    A Jornada da Semente funciona como uma Ã¡rvore binÃ¡ria: vocÃª entra na rede, realiza a contribuiÃ§Ã£o da jornada para o seu donatÃ¡rio e acompanha os avanÃ§os. Conforme novas pessoas entram na sua rede, elas fazem doaÃ§Ãµes para vocÃª. Quando 8 doaÃ§Ãµes sÃ£o recebidas, seu ciclo se completa e vocÃª pode avanÃ§ar para a prÃ³xima jornada.
                  </div>
                </div>
              </div>

              <!-- FAQ 3 -->
              <div class="border-bottom">
                <div class="p-3" id="faq3head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq3body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Quais sÃ£o os valores de doaÃ§Ã£o?
                    </a>
                  </h6>
                </div>
                <div id="faq3body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    Na Jornada da Semente, a doaÃ§Ã£o da jornada Ã© de R$ 60,00 e hÃ¡ uma taxa de manutenção de 9,5% sobre o valor da jornada. A mesma regra percentual de manutenção se aplica nas demais jornadas.
                  </div>
                </div>
              </div>

              <!-- FAQ 4 -->
              <div class="border-bottom">
                <div class="p-3" id="faq4head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq4body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como faÃ§o para convidar alguÃ©m?
                    </a>
                  </h6>
                </div>
                <div id="faq4body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    No seu Painel, hÃ¡ um botÃ£o "Copiar Link". Ao clicar, seu link exclusivo de convite serÃ¡ copiado para a Ã¡rea de transferÃªncia. Basta enviar esse link por WhatsApp, e-mail ou qualquer outra forma para a pessoa que deseja convidar.
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
                    Quando vocÃª recebe 8 doaÃ§Ãµes, seu ciclo se completa. VocÃª pode entÃ£o avanÃ§ar para a prÃ³xima jornada, com novos objetivos e maior retorno. Cada ciclo completado aumenta seu nÃ­vel na plataforma.
                  </div>
                </div>
              </div>

              <!-- FAQ 6 -->
              <div class="border-bottom">
                <div class="p-3" id="faq6head">
                  <h6 class="mb-0">
                    <a class="d-flex align-items-center text-decoration-none collapsed" style="color:var(--ink);font-weight:700;cursor:pointer" data-toggle="collapse" data-target="#faq6body" aria-expanded="false">
                      <i class="fas fa-chevron-down mr-2 small" style="transition:transform .2s"></i>
                      Como faÃ§o o pagamento?
                    </a>
                  </h6>
                </div>
                <div id="faq6body" class="collapse" data-parent="#faqAccordion">
                  <div class="px-3 pb-3" style="color:var(--muted)">
                    Os pagamentos sÃ£o feitos via PIX. A chave e os valores sÃ£o exibidos na tela de ativaÃ§Ã£o (no Painel) e na tela de Minha ContribuiÃ§Ã£o. ApÃ³s realizar o PIX, envie o comprovante pela plataforma para validaÃ§Ã£o.
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
                    Clique em "Suporte" no menu lateral para ser redirecionado ao nosso WhatsApp de atendimento. Nossa equipe estÃ¡ disponÃ­vel para ajudÃ¡-lo com qualquer dÃºvida ou problema.
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
        <div class="copyright text-center my-auto">
          <span>&copy; Vem TambÃ©m 2025-2026</span>
        </div>
      </div>
    </footer>
  </div>
</div>

<a class="scroll-to-top rounded" href="#page-top"><i class="fas fa-angle-up"></i></a>

<!-- Global Modals -->
<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>

