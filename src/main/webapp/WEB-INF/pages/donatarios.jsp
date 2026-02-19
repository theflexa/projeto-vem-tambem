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
  <title>Vem Também — Minha Contribuição</title>
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
    .entry-dual-card {
      border: 1px solid rgba(145, 149, 45, .28);
      background: linear-gradient(145deg, rgba(249, 251, 241, .98), rgba(238, 243, 223, .95));
    }

    .entry-stepper {
      margin-bottom: 1rem;
    }

    .entry-stepper-track {
      width: 100%;
      height: 8px;
      border-radius: 999px;
      background: #e4e8d1;
      overflow: hidden;
      margin-bottom: .75rem;
    }

    .entry-stepper-progress {
      height: 100%;
      width: 0%;
      background: linear-gradient(90deg, #91952d, #edb80a);
      transition: width .24s ease;
    }

    .entry-stepper-list {
      display: flex;
      justify-content: space-between;
      gap: .5rem;
    }

    .entry-step-item {
      flex: 1;
      border-radius: 12px;
      border: 1px solid #d8debf;
      background: #f8faef;
      padding: .6rem .7rem;
      display: flex;
      align-items: center;
      gap: .5rem;
      color: #4b5563;
      font-weight: 700;
      font-size: .85rem;
    }

    .entry-step-item .step-badge {
      width: 26px;
      height: 26px;
      border-radius: 50%;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: .75rem;
      font-weight: 800;
      background: #e9eedd;
      color: #697244;
      border: 1px solid #d6ddb9;
    }

    .entry-step-item.is-done {
      border-color: rgba(145, 149, 45, .45);
      color: #334304;
      background: #eef4d4;
    }

    .entry-step-item.is-done .step-badge {
      background: #edb80a;
      color: #533f00;
      border-color: #d4a100;
    }

    .entry-checkline {
      margin-top: .75rem;
      margin-bottom: .9rem;
      font-size: .88rem;
      color: #4b5563;
    }

    .entry-submit-lottie {
      width: 88px;
      height: 88px;
      margin: .5rem auto 0;
      display: none;
    }

    .entry-submit-lottie.show {
      display: block;
    }

    .entry-success-lottie {
      width: 140px;
      height: 140px;
      margin: 0 auto;
      background: transparent;
    }

    .verified-upload-card {
      border: 1px solid rgba(237, 183, 10, .35);
      background: linear-gradient(135deg, rgba(237, 183, 10, .12), rgba(255, 255, 255, .96));
    }

    .verified-upload-title {
      color: #7f8301;
      font-weight: 800;
      margin-bottom: .3rem;
    }

    .verified-upload-copy {
      margin-bottom: 0;
      color: #495057;
    }

    .verified-upload-lottie {
      width: 130px;
      height: 130px;
      margin: 0 auto;
      background: transparent;
    }

    .pix-copy-field .input-group-text {
      min-width: 84px;
      font-weight: 700;
      color: #495057;
      background: #f8faef;
      border-color: #d8debf;
    }

    .pix-copy-field .form-control {
      font-size: .9rem;
      font-weight: 700;
      color: #2f3a07;
      border-color: #d8debf;
      background: #fff;
    }

    .pix-copy-field .btn {
      min-width: 90px;
      font-weight: 700;
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
        <c:set var="jornadaAtual" value="${empty nomeJornadaAtual ? 'Jornada da Semente' : nomeJornadaAtual}" />

        <div class="content-surface mb-3">
          <h1 class="h3">Minha Contribuição</h1>
          <p>Conclua sua etapa com segurança: confira os dados do ciclo, realize o pagamento e envie o comprovante.</p>
          <a href="<c:url value='/usuario/jornadas'/>" class="btn btn-olive-outline btn-sm mt-2 px-3">Ver Jornadas</a>
        </div>

        <c:if test="${sucessoUpload == false}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Erro ao enviar o arquivo.</strong> Tente novamente.
            <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
          </div>
        </c:if>

        <c:if test="${!usuarioLogado.ativo}">
          <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <strong>Assinatura pendente.</strong> Seu acesso está liberado, mas a ativação depende da validação do comprovante.
            <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
          </div>
          <c:if test="${not empty usuarioLogado.motivoRecusaAtivacao}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <strong>Comprovante recusado.</strong> Motivo informado pela administração: ${usuarioLogado.motivoRecusaAtivacao}
              <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
            </div>
          </c:if>

          <c:if test="${sucessoUploadEntrada == true || sucessoUpload == true}">
            <div class="card shadow-sm mb-3 border-0 verified-upload-card" role="status" aria-live="polite">
              <div class="card-body py-3">
                <div class="row align-items-center">
                  <div class="col-md-9">
                    <h6 class="verified-upload-title">Entrada no tabuleiro confirmada</h6>
                    <p class="verified-upload-copy">As duas doações foram anexadas. Nosso time fará a validação e liberará sua jornada.</p>
                  </div>
                  <div class="col-md-3 mt-3 mt-md-0 text-md-right">
                    <div id="entryDualDonationLottie" class="entry-success-lottie" role="img" aria-label="Entrada confirmada"></div>
                  </div>
                </div>
              </div>
            </div>
          </c:if>

          <div class="card shadow mb-4 entry-dual-card" data-tour-id="donatarios-ativacao">
            <div class="card-header">
              <h6 class="m-0 font-weight-bold text-brand">Entrada no tabuleiro</h6>
            </div>
            <div class="card-body">
              <p class="mb-3">
                Para concluir sua entrada na <b>${jornadaAtual}</b>, realize as duas doações obrigatórias e anexe ambos os comprovantes.
              </p>
              <hr/>
              <div class="row">
                <div class="col-lg-7 mb-3 mb-lg-0">
                  <div class="vt-contribution-card">
                    <p class="mb-2"><b>Resumo financeiro da entrada</b></p>
                    <p class="mb-1">1. Taxa de manutenção (${percentualTaxaTi}% da jornada): <b>R$ ${valorTaxaTiFormatado}</b></p>
                    <p class="mb-1">2. Jornada (recebedor do ciclo): <b>R$ ${valorJornadaFormatado}</b></p>
                    <p class="mb-1">Total da entrada: <b>R$ ${valorContribuicaoTotalFormatado}</b></p>

                    <div class="pix-copy-field mt-3">
                      <label for="pix-ti-input" class="mb-1"><b>Pix da taxa de manutenção</b></label>
                      <div class="input-group input-group-sm">
                        <div class="input-group-prepend">
                          <span class="input-group-text">${pixTiTipo}</span>
                        </div>
                        <input type="text" id="pix-ti-input" class="form-control" readonly="readonly" value="${pixTiChave}">
                        <div class="input-group-append">
                          <button type="button" class="btn btn-olive-outline" data-copy-target="pix-ti-input">Copiar</button>
                        </div>
                      </div>
                    </div>

                    <div class="pix-copy-field mt-3">
                      <label for="pix-recebedor-input" class="mb-1">
                        <b>PIX do recebedor do ciclo</b>
                      </label>
                      <div class="input-group input-group-sm">
                        <div class="input-group-prepend">
                          <span class="input-group-text">
                            <c:choose>
                              <c:when test="${not empty recebedorAtualTipoChavePix}">${recebedorAtualTipoChavePix}</c:when>
                              <c:otherwise>Chave</c:otherwise>
                            </c:choose>
                          </span>
                        </div>
                        <input type="text" id="pix-recebedor-input" class="form-control" readonly="readonly" value="${recebedorAtualChavePix}">
                        <div class="input-group-append">
                          <c:choose>
                            <c:when test="${empty recebedorAtualChavePix}">
                              <button type="button" class="btn btn-olive-outline" data-copy-target="pix-recebedor-input" disabled="disabled">Copiar</button>
                            </c:when>
                            <c:otherwise>
                              <button type="button" class="btn btn-olive-outline" data-copy-target="pix-recebedor-input">Copiar</button>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                      <c:if test="${empty recebedorAtualChavePix}">
                        <small class="text-muted d-block mt-1">Chave PIX do recebedor ainda não disponível.</small>
                      </c:if>
                    </div>
                  </div>
                </div>
                <div class="col-lg-5 col-border-left" data-tour-id="donatarios-upload-ativacao">
                  <div id="entryStepper" class="entry-stepper">
                    <div class="entry-stepper-track">
                      <div id="entryStepperProgress" class="entry-stepper-progress"></div>
                    </div>
                    <div class="entry-stepper-list">
                      <div id="entryStepTi" class="entry-step-item">
                        <span class="step-badge">1</span>
                        <span>Taxa de manutenção</span>
                      </div>
                      <div id="entryStepJornada" class="entry-step-item">
                        <span class="step-badge">2</span>
                        <span>Jornada</span>
                      </div>
                    </div>
                  </div>

                  <form:form id="entryDualDonationForm" method="post" action="${cp}/usuario/upload-comprovantes-entrada" enctype="multipart/form-data">
                    <div class="form-group">
                      <label for="file-ti"><b>Comprovante 1 — Taxa de manutenção</b></label>
                      <input type="file" id="file-ti" name="fileTi" class="form-control-file" accept="image/*,application/pdf" required="required">
                    </div>

                    <div class="form-group">
                      <label for="file-jornada"><b>Comprovante 2 — Jornada</b></label>
                      <input type="file" id="file-jornada" name="fileJornada" class="form-control-file" accept="image/*,application/pdf" required="required">
                    </div>

                    <div class="entry-checkline">
                      <input type="checkbox" id="entry-confirm-check">
                      <label for="entry-confirm-check" class="mb-0">Confirmo que realizei as duas doações e os comprovantes estão corretos.</label>
                    </div>

                    <button type="submit" id="entry-confirm-btn" class="btn btn-olive btn-block" disabled>Confirmar entrada no tabuleiro</button>
                    <div id="entrySubmitCheckLottie" class="entry-submit-lottie" aria-hidden="true"></div>
                  </form:form>
                </div>
              </div>
            </div>
          </div>
        </c:if>

        <c:if test="${usuarioLogado.ativo}">
          <c:if test="${sucessoUpload == true}">
            <div class="card shadow-sm mb-3 border-0 verified-upload-card" role="status" aria-live="polite">
              <div class="card-body py-3">
                <div class="row align-items-center">
                  <div class="col-md-9">
                    <h6 class="verified-upload-title">Comprovante recebido com sucesso</h6>
                    <p class="verified-upload-copy">Seu envio foi registrado. Nosso time fará a validação e atualizará sua etapa em breve.</p>
                  </div>
                  <div class="col-md-3 mt-3 mt-md-0 text-md-right">
                    <div id="donationProofVerifiedLottie" class="verified-upload-lottie" role="img" aria-label="Envio verificado"></div>
                  </div>
                </div>
              </div>
            </div>
          </c:if>

          <div class="card shadow mb-4">
            <div class="card-header">
              <div class="title-row">
                <h6 class="m-0 font-weight-bold text-brand">Suas doações por ciclo</h6>
              </div>
              <ul class="nav nav-tabs vt-vaadin-tabs" id="donatariosTab" role="tablist" data-tour-id="donatarios-tabs">
                <c:forEach var="aba" items="${ciclos}" varStatus="status">
                  <li class="nav-item">
                    <a class="nav-link ${aba.ativo ? 'active' : ''}"
                       id="tab${status.index + 1}-tab"
                       data-toggle="tab"
                       href="#tab${status.index + 1}"
                       role="tab"
                       aria-controls="tab${status.index + 1}"
                       aria-selected="${aba.ativo}">
                      ${aba.nome}
                    </a>
                  </li>
                </c:forEach>
              </ul>
            </div>

            <div class="card-body">
              <div class="tab-content" id="donatariosTabContent">
                <c:forEach var="aba" items="${ciclos}" varStatus="status">
                  <div class="tab-pane fade ${aba.ativo ? 'show active' : ''}"
                       id="tab${status.index + 1}"
                       role="tabpanel"
                       aria-labelledby="tab${status.index + 1}-tab">

                    <c:if test="${pessoa.comprovanteDeposito != null && pessoa.doacaoFeita == false}">
                      <div class="alert alert-success inline-full" role="alert">
                        <strong>Comprovante enviado!</strong> Aguarde a validação.
                      </div>
                    </c:if>
                    <c:if test="${pessoa.doacaoFeita == true}">
                      <div class="alert alert-success inline-full mb-3" role="alert">
                        Você já concluiu a contribuição deste ciclo. Obrigado!
                      </div>
                    </c:if>

                    <div class="card border-0 donatario" data-tour-id="donatarios-card">
                      <div class="card-body">
                        <div class="d-flex align-items-center mb-2">
                          <h5 class="mb-0 mr-2" style="color:#2f3a07;font-weight:800;">Contribuição da jornada:</h5>
                          <c:choose>
                            <c:when test="${aba.usuario.doacaoFeita == true}">
                              <span class="chip chip-green">Ativo</span>
                            </c:when>
                            <c:otherwise>
                              <span class="chip chip-red">Pendente</span>
                            </c:otherwise>
                          </c:choose>
                        </div>

                        <div class="row">
                          <div class="col-lg-7">
                            <ul class="list-unstyled list-donatario">
                              <li><strong>Donatário:</strong> ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.nome}</li>
                              <li><strong>Whatsapp:</strong>
                                <a href="https://api.whatsapp.com/send?phone=${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.whatsappFormat}"
                                   target="_blank" rel="noopener">
                                  ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.whatsapp}
                                  <i class="fab fa-whatsapp" aria-hidden="true" style="margin-left:.35rem"></i>
                                  <span class="sr-only">Abrir WhatsApp</span>
                                </a>
                              </li>
                              <li><strong>Outro telefone:</strong> ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.celular}</li>
                              <li><strong>Valor da contribuição:</strong>
                                <c:choose>
                                  <c:when test="${not empty valorJornadaFormatado}">R$ ${valorJornadaFormatado}</c:when>
                                  <c:otherwise>R$ 60,00</c:otherwise>
                                </c:choose>
                              </li>
                              <li>
                                <strong>Chave PIX:</strong>
                                <c:choose>
                                  <c:when test="${not empty aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.chavePix}">
                                    ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.tipoChavePix.descricao}
                                    — ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.chavePix}
                                  </c:when>
                                  <c:otherwise>Não informado</c:otherwise>
                                </c:choose>
                              </li>
                            </ul>

                            <c:if test="${not empty aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.chavePix}">
                              <div class="pix-copy-field mt-2">
                                <div class="input-group input-group-sm">
                                  <input type="text"
                                         id="pix-donatario-${status.index + 1}"
                                         class="form-control"
                                         readonly="readonly"
                                         value="${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.chavePix}">
                                  <div class="input-group-append">
                                    <button type="button"
                                            class="btn btn-olive-outline"
                                            data-copy-target="pix-donatario-${status.index + 1}">Copiar PIX</button>
                                  </div>
                                </div>
                              </div>
                            </c:if>
                          </div>

                          <div class="col-lg-5 col-border-left mt-3 mt-lg-0" data-tour-id="donatarios-upload">
                            <c:choose>
                              <c:when test="${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.doacaoFeita == true}">
                                <c:if test="${aba.usuario.doacaoFeita == false}">
                                  <div class="alert alert-warning mb-3">
                                    Após efetuar o pagamento, envie o comprovante para validação da sua etapa.
                                  </div>
                                  <form:form method="post" action="${cp}/usuario/upload-comprovante-doacao" enctype="multipart/form-data">
                                    <div class="form-group">
                                      <label for="file-doacao-${status.index + 1}"><b>Comprovante de pagamento</b></label>
                                      <input type="file" id="file-doacao-${status.index + 1}" name="file" class="form-control-file" accept="image/*,application/pdf">
                                    </div>
                                    <button type="submit" class="btn btn-olive">Enviar comprovante</button>
                                  </form:form>
                                </c:if>
                              </c:when>
                              <c:otherwise>
                                <div class="alert alert-warning mb-0" role="alert">
                                  <p class="mb-0" style="text-align:justify">
                                    Seu donatário está temporariamente indisponível para receber doações.
                                    Entre em contato com o donatário ou acione o suporte da Vem Também.
                                  </p>
                                </div>
                              </c:otherwise>
                            </c:choose>
                          </div>

                        </div>
                      </div>
                    </div>

                  </div>
                </c:forEach>

              </div>
            </div>
          </div>
        </c:if>

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
<script> $('[data-mask]').inputmask(); </script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lottie/lottie.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var verifiedPath = '<c:url value="/resources/vendor/lottie/animations/verified.json"/>';
    var checkOrangePath = '<c:url value="/resources/vendor/lottie/animations/check-orange.json"/>';

    function recolorVerifiedPalette(animationData) {
      var gold = [0.929, 0.718, 0.039]; // #edb70a
      var olive = [0.498, 0.514, 0.004]; // #7f8301

      function isColorArray(value) {
        return Array.isArray(value)
          && value.length === 4
          && value.every(function (n) { return typeof n === 'number' && n >= 0 && n <= 1; });
      }

      function walk(node) {
        if (!node) {
          return;
        }
        if (isColorArray(node)) {
          var r = node[0], g = node[1], b = node[2];
          var isGreenFamily = g >= r + 0.06 && g >= b;
          if (isGreenFamily) {
            var luminance = (0.2126 * r) + (0.7152 * g) + (0.0722 * b);
            var target = luminance > 0.48 ? gold : olive;
            node[0] = target[0];
            node[1] = target[1];
            node[2] = target[2];
          }
          return;
        }
        if (Array.isArray(node)) {
          node.forEach(walk);
          return;
        }
        if (typeof node === 'object') {
          Object.keys(node).forEach(function (key) { walk(node[key]); });
        }
      }

      walk(animationData);
      return animationData;
    }

    function loadLottieByPath(container, path, loop) {
      if (!container || !window.lottie || typeof window.lottie.loadAnimation !== 'function') {
        return;
      }
      window.lottie.loadAnimation({
        container: container,
        renderer: 'svg',
        loop: loop,
        autoplay: true,
        path: path,
        rendererSettings: { preserveAspectRatio: 'xMidYMid meet' }
      });
    }

    var verifiedContainer = document.getElementById('donationProofVerifiedLottie');
    if (verifiedContainer && window.lottie && typeof window.lottie.loadAnimation === 'function') {
      fetch(verifiedPath)
        .then(function (response) { return response.json(); })
        .then(function (animationData) {
          window.lottie.loadAnimation({
            container: verifiedContainer,
            renderer: 'svg',
            loop: false,
            autoplay: true,
            animationData: recolorVerifiedPalette(animationData),
            rendererSettings: { preserveAspectRatio: 'xMidYMid meet' }
          });
        })
        .catch(function () {
          loadLottieByPath(verifiedContainer, verifiedPath, false);
        });
    }

    var entrySuccessContainer = document.getElementById('entryDualDonationLottie');
    if (entrySuccessContainer) {
      loadLottieByPath(entrySuccessContainer, checkOrangePath, false);
    }

    var stepperRoot = document.getElementById('entryStepper');
    var stepTi = document.getElementById('entryStepTi');
    var stepJornada = document.getElementById('entryStepJornada');
    var progressBar = document.getElementById('entryStepperProgress');
    var fileTi = document.getElementById('file-ti');
    var fileJornada = document.getElementById('file-jornada');
    var confirmCheck = document.getElementById('entry-confirm-check');
    var confirmBtn = document.getElementById('entry-confirm-btn');
    var entryForm = document.getElementById('entryDualDonationForm');
    var submitLottieContainer = document.getElementById('entrySubmitCheckLottie');

    if (stepperRoot && stepTi && stepJornada && progressBar && fileTi && fileJornada && confirmCheck && confirmBtn && entryForm) {
      var initialTiDone = false;
      var initialJornadaDone = false;

      function refreshEntryStepper() {
        var tiDone = initialTiDone || (fileTi.files && fileTi.files.length > 0);
        var jornadaDone = initialJornadaDone || (fileJornada.files && fileJornada.files.length > 0);
        var doneCount = (tiDone ? 1 : 0) + (jornadaDone ? 1 : 0);

        stepTi.classList.toggle('is-done', tiDone);
        stepJornada.classList.toggle('is-done', jornadaDone);
        progressBar.style.width = (doneCount * 50) + '%';

        confirmBtn.disabled = !(tiDone && jornadaDone && confirmCheck.checked);
      }

      fileTi.addEventListener('change', refreshEntryStepper);
      fileJornada.addEventListener('change', refreshEntryStepper);
      confirmCheck.addEventListener('change', refreshEntryStepper);
      refreshEntryStepper();

      entryForm.addEventListener('submit', function (event) {
        if (confirmBtn.disabled) {
          event.preventDefault();
          return;
        }
        if (!submitLottieContainer || !window.lottie || typeof window.lottie.loadAnimation !== 'function') {
          return;
        }
        if (entryForm.dataset.submitting === '1') {
          event.preventDefault();
          return;
        }

        event.preventDefault();
        entryForm.dataset.submitting = '1';
        submitLottieContainer.classList.add('show');
        window.lottie.loadAnimation({
          container: submitLottieContainer,
          renderer: 'svg',
          loop: false,
          autoplay: true,
          path: checkOrangePath,
          rendererSettings: { preserveAspectRatio: 'xMidYMid meet' }
        });

        setTimeout(function () {
          entryForm.submit();
        }, 900);
      });
    }

    function copyTextFromInput(inputId) {
      var input = document.getElementById(inputId);
      if (!input || !input.value) {
        return;
      }
      var text = input.value;
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function () {
          if (window.vtToast) {
            window.vtToast('PIX copiado!', 'success');
          }
        }).catch(function () {
          input.removeAttribute('readonly');
          input.select();
          input.setSelectionRange(0, 99999);
          document.execCommand('copy');
          input.setAttribute('readonly', 'readonly');
          if (window.vtToast) {
            window.vtToast('PIX copiado!', 'success');
          }
        });
        return;
      }
      input.removeAttribute('readonly');
      input.select();
      input.setSelectionRange(0, 99999);
      document.execCommand('copy');
      input.setAttribute('readonly', 'readonly');
      if (window.vtToast) {
        window.vtToast('PIX copiado!', 'success');
      }
    }

    document.querySelectorAll('[data-copy-target]').forEach(function (button) {
      button.addEventListener('click', function () {
        copyTextFromInput(button.getAttribute('data-copy-target'));
      });
    });
  });
</script>
</body>
</html>

