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
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <span class="mr-2 d-sm-inline text-gray-700 small"><i class="fas fa-user-circle"></i> ${usuarioLogado.nome}</span>
            </a>
          </li>
        </ul>
      </nav>

      <div class="container-fluid">
        <div class="content-surface mb-3">
          <h1 class="h3">Minha Contribuição</h1>
          <p>Acompanhe e realize suas doações em cada ciclo.</p>
        </div>

        <div class="card shadow mb-4">
          <!-- Título + Abas coladas -->
          <div class="card-header">
            <div class="title-row">
              <h6 class="m-0 font-weight-bold text-brand">Suas doações por ciclo</h6>
            </div>
            <ul class="nav nav-tabs" id="donatariosTab" role="tablist">
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

                  <!-- ALERTAS -->
                  <c:if test="${pessoa.comprovanteDeposito != null && pessoa.doacaoFeita == false}">
                    <div class="alert alert-success inline-full" role="alert">
                      <strong>Seu comprovante foi enviado!</strong> Aguarde a liberação.
                    </div>
                  </c:if>
                  <c:if test="${sucessoUpload == false}">
                    <div class="alert alert-danger inline-full" role="alert">
                      <strong>Erro ao enviar o arquivo!</strong> Tente novamente.
                    </div>
                  </c:if>
                  <c:if test="${pessoa.doacaoFeita == true}">
                    <div class="alert alert-success inline-full mb-3" role="alert">
                      Você já realizou a doação deste ciclo. Obrigado!
                    </div>
                  </c:if>

                  <!-- Card do ciclo -->
                  <div class="card border-0 donatario">
                    <div class="card-body">
                      <div class="d-flex align-items-center mb-2">
                        <h5 class="mb-0 mr-2" style="color:#4b5563;font-weight:800;">Doação Inicial:</h5>
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
                        <!-- Dados do donatário -->
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
                            <li><strong>Outro Telefone:</strong> ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.celular}</li>
                            <li><strong>Valor da Doação:</strong>
                              <c:choose>
                                <c:when test="${tipoCicloAtual != null}">R$ ${tipoCicloAtual.valorDoacao}</c:when>
                                <c:otherwise>R$ 90,00</c:otherwise>
                              </c:choose>
                            </li>
                            <c:if test="${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.doacaoFeita == true}">
                              <li><strong>Chave PIX:</strong>
                                ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.tipoChavePix.descricao}
                                — ${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.chavePix}
                              </li>
                            </c:if>
                          </ul>
                        </div>

                        <!-- Ação / Upload -->
                        <div class="col-lg-5 col-border-left mt-3 mt-lg-0">
                          <c:choose>
                            <c:when test="${aba.indicadoPrincipal.cicloAtivo.indicadoPrincipal.cicloAtivo.indicadoPrincipal.doacaoFeita == true}">
                              <c:if test="${aba.usuario.doacaoFeita == false}">
                                <div class="alert alert-warning mb-3">
                                  Após efetuar o pagamento, faça o upload do comprovante de pagamento.
                                </div>
                                <form:form method="post" action="${cp}/usuario/upload-comprovante-doacao" enctype="multipart/form-data">
                                  <div class="form-group">
                                    <label for="file"><b>Comprovante de pagamento</b></label>
                                    <input type="file" id="file" name="file" class="form-control-file" accept="image/*,application/pdf">
                                  </div>
                                  <button type="submit" class="btn btn-olive">Enviar Comprovante</button>
                                </form:form>
                              </c:if>
                            </c:when>
                            <c:otherwise>
                              <div class="alert alert-warning mb-0" role="alert">
                                <p class="mb-0" style="text-align:justify">
                                  Seu donatário está bloqueado para receber doações no momento.
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
<script type="text/javascript" src="<c:url value='/resources/vendor/inputmask/min/jquery.inputmask.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>
<script> $('[data-mask]').inputmask(); </script>
</body>
</html>
