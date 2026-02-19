<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Vem Também - Administração</title>
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
          <h1 class="h3 mb-1">Administração de jornadas</h1>
          <p class="mb-0">Ajuste valores de jornada, taxa de manutenção e status de ativação.</p>
        </div>

        <c:if test="${sucesso == true}">
          <div class="alert alert-success" role="alert">
            <strong>Sucesso:</strong> ${mensagem}
          </div>
        </c:if>
        <c:if test="${sucesso == false}">
          <div class="alert alert-danger" role="alert">
            <strong>Atenção:</strong> ${mensagem}
          </div>
        </c:if>

        <div class="card shadow mb-4">
          <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-brand">Configuração das jornadas</h6>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered table-brand-stripe">
                <thead>
                  <tr>
                    <th>Jornada</th>
                    <th>Status</th>
                    <th>Valor da jornada (R$)</th>
                    <th>Taxa de manutenção (R$)</th>
                    <th style="width:280px">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="tipoCiclo" items="${tiposCiclo}">
                    <tr>
                      <td>${tipoCiclo.nome}</td>
                      <td>
                        <c:choose>
                          <c:when test="${tipoCiclo.ativo}">
                            <span class="badge badge-success">Ativa</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge badge-secondary">Inativa</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <form method="post" action="${cp}/admin/administracao/salvar" class="mb-0">
                          <input type="hidden" name="id" value="${tipoCiclo.id}" />
                          <input type="number"
                                 class="form-control"
                                 name="valorDoacao"
                                 min="0.01"
                                 step="0.01"
                                 value="${tipoCiclo.valorDoacao}"
                                 required />
                      </td>
                      <td>
                          <input type="number"
                                 class="form-control"
                                 name="valorTI"
                                 min="0.00"
                                 step="0.01"
                                 value="${tipoCiclo.valorTI}"
                                 required />
                      </td>
                      <td>
                        <div class="d-flex align-items-center" style="gap:.5rem">
                          <button type="submit" class="btn btn-olive btn-sm">Salvar valores</button>
                        </form>
                          <form method="post" action="${cp}/admin/administracao/status" class="mb-0">
                            <input type="hidden" name="id" value="${tipoCiclo.id}" />
                            <c:choose>
                              <c:when test="${tipoCiclo.ativo}">
                                <input type="hidden" name="ativo" value="false" />
                                <button type="submit" class="btn btn-outline-secondary btn-sm">Desativar</button>
                              </c:when>
                              <c:otherwise>
                                <input type="hidden" name="ativo" value="true" />
                                <button type="submit" class="btn btn-outline-success btn-sm">Ativar</button>
                              </c:otherwise>
                            </c:choose>
                          </form>
                        </div>
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
<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
</body>
</html>
