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

	<title>Vem Também — Doadores</title>
    <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <!-- Fontes / ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 + VT Theme -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>
  <spring:url value="/resources/css/vt-theme.css" var="vtthemecss" />
  <link href="${vtthemecss}" rel="stylesheet"/>

  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>
</head>
<body id="page-top">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

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
          <div class="d-flex align-items-center justify-content-between flex-wrap">
            <div>
              <h1 class="h3">Doadores</h1>
              <p>Acompanhe os comprovantes e ative os doadores do seu ciclo.</p>
            </div>
            <c:if test="${tipoCicloAtual != null}">
              <span class="badge badge-pill badge-cycle">
                <i class="fas fa-trophy mr-1"></i>${tipoCicloAtual.nome}
              </span>
            </c:if>
          </div>
          <!-- Barra de progresso -->
          <div class="mt-3">
            <div class="d-flex justify-content-between mb-1">
              <small class="font-weight-bold" style="color:var(--ink)">Progresso do ciclo</small>
              <small class="font-weight-bold" style="color:var(--ink)">${pessoa.quantDoacoesRecebidas}/8 doações</small>
            </div>
            <div class="progress" style="height:12px;">
              <c:set var="progresso" value="${pessoa.quantDoacoesRecebidas * 100 / 8}" />
              <div class="progress-bar progress-bar-brand" role="progressbar" style="width:${progresso > 100 ? 100 : progresso}%;"></div>
            </div>
            <c:choose>
              <c:when test="${pessoa.quantDoacoesRecebidas >= 8}">
                <small class="text-success-brand"><i class="fas fa-star mr-1"></i>Parabéns! Ciclo completo. Hora do próximo nível.</small>
              </c:when>
              <c:when test="${pessoa.quantDoacoesRecebidas >= 4}">
                <small class="text-warn-brand"><i class="fas fa-fire mr-1"></i>${pessoa.quantDoacoesRecebidas} de 8 — sua rede está crescendo</small>
              </c:when>
              <c:when test="${pessoa.quantDoacoesRecebidas >= 1}">
                <small style="color:var(--muted)"><i class="fas fa-fire mr-1 text-warn-brand"></i>Já recebeu ${pessoa.quantDoacoesRecebidas} — continue compartilhando</small>
              </c:when>
              <c:otherwise>
                <small style="color:var(--muted)"><i class="fas fa-seedling mr-1 text-success-brand"></i>Convide pessoas — seu primeiro indicado é o passo mais importante</small>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="card shadow mb-4">
          <!-- Título + Abas -->
          <div class="card-header">
            <h6 class="m-0 font-weight-bold text-brand">Painel de Doadores por ciclo</h6>
            <ul class="nav nav-tabs" id="doadoresTab" role="tablist">
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
            <div class="tab-content" id="doadoresTabContent">
              <c:forEach var="aba" items="${ciclos}" varStatus="status">
                <div class="tab-pane fade ${aba.ativo ? 'show active' : ''}"
                     id="tab${status.index + 1}" role="tabpanel" aria-labelledby="tab${status.index + 1}-tab">

                  <!-- Mensagem de fim de ciclo -->
                  <c:if test="${isCicloFinalizado == true}">
                    <div class="alert alert-success inline" role="alert">
                      <strong>Parabéns!</strong> Você concluiu o seu ciclo. Para receber novas doações, clique em <em>Continuar</em>.
                    </div>
                    <form:form class="user" id="reativar-form" action="${cp}/usuario/reativar" method="post" modelAttribute="pessoa">
                      <input type="hidden" id="pessoa" name="id" value="${pessoa.id}"/>
                      <button class="btn btn-olive btn-sm px-3" id="btnReativar">Continuar</button>
                    </form:form>
                    <hr/>
                  </c:if>

                  <c:if test="${sucesso == true}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                      <strong>Ativação realizada com sucesso.</strong>
                      <button type="button" class="close" data-dismiss="alert" aria-label="Fechar"><span aria-hidden="true">&times;</span></button>
                    </div>
                  </c:if>

                  <!-- Tabela -->
                  <div class="table-responsive">
                    <table class="table align-middle table-brand-stripe">
                      <thead>
                        <tr>
                          <th style="width:28%">Usuário</th>
                          <th style="width:22%">Contato</th>
                          <th style="width:18%">Documento</th>
                          <th style="width:25%">Ações</th>
                        </tr>
                      </thead>

                      <tbody>
					  <!-- Linha 1 -->
					  <tr>
					    <td>${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nome}"/>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.doacaoFeita == false
					                   and aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito != null}">
					        <button id="btnAtivar1" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.id}, 'btnAtivar1')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 2 -->
					  <tr>
					    <td>${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nome}"/>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.doacaoFeita == false
					                   and aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.comprovanteDeposito != null}">
					        <button id="btnAtivar2" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.id}, 'btnAtivar2')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 3 -->
					  <tr>
					    <td>${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nome}"/>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.doacaoFeita == false
					                   and aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.comprovanteDeposito != null}">
					        <button id="btnAtivar3" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.id}, 'btnAtivar3')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 4 -->
					  <tr>
					    <td>${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nome}"/>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.doacaoFeita == false
					                   and aba.indicadoEsquerda.indicadoDireita.indicadoDireita.comprovanteDeposito != null}">
					        <button id="btnAtivar4" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.id}, 'btnAtivar4')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 5 -->
					  <tr>
					    <td>${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nome}"/>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.doacaoFeita == false
					                   and aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.comprovanteDeposito != null}">
					        <button id="btnAtivar5" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.id}, 'btnAtivar5')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 6 -->
					  <tr>
					    <td>${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nome}"/>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.doacaoFeita == false
					                   and aba.indicadoDireita.indicadoEsquerda.indicadoDireita.comprovanteDeposito != null}">
					        <button id="btnAtivar6" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.id}, 'btnAtivar6')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 7 -->
					  <tr>
					    <td>${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nome}"/>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.doacaoFeita == false
					                   and aba.indicadoDireita.indicadoDireita.indicadoEsquerda.comprovanteDeposito != null}">
					        <button id="btnAtivar7" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.id}, 'btnAtivar7')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>

					  <!-- Linha 8 -->
					  <tr>
					    <td>${aba.indicadoDireita.indicadoDireita.indicadoDireita.nome}</td>
					    <td>
					      <c:set var="w" value="${aba.indicadoDireita.indicadoDireita.indicadoDireita.whatsapp}"/>
					      <c:set var="wf" value="${aba.indicadoDireita.indicadoDireita.indicadoDireita.whatsappFormat}"/>
					      <c:choose>
					        <c:when test="${not empty w and fn:length(fn:trim(w)) > 0}">
					          <a href="https://api.whatsapp.com/send?phone=${wf}" target="_blank" rel="noopener">
					            ${w}<i class="fab fa-whatsapp" style="margin-left:.25rem"></i>
					          </a>
					        </c:when>
					        <c:otherwise><span class="text-muted">—</span></c:otherwise>
					      </c:choose>
					    </td>
					    <td>${aba.indicadoDireita.indicadoDireita.indicadoDireita.documento}</td>
					    <td>
					      <c:set var="n" value="${aba.indicadoDireita.indicadoDireita.indicadoDireita.nome}"/>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoDireita.comprovanteDeposito != null}">
					        <button class="btn btn-olive-outline btn-sm" onclick="downloadComprovante(${aba.indicadoDireita.indicadoDireita.indicadoDireita.id})">Comprovante</button>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoDireita.comprovanteDeposito == null
					                   and not empty n and fn:length(fn:trim(n)) > 0}">
					        <span class="text-danger" title="Pendente"><i class="fas fa-clock"></i></span>
					      </c:if>
					      <c:if test="${aba.indicadoDireita.indicadoDireita.indicadoDireita.doacaoFeita == false
					                   and aba.indicadoDireita.indicadoDireita.indicadoDireita.comprovanteDeposito != null}">
					        <button id="btnAtivar8" class="btn btn-olive btn-sm" onclick="ativarPessoa(${aba.indicadoDireita.indicadoDireita.indicadoDireita.id}, 'btnAtivar8')">Ativar</button>
					      </c:if>
					    </td>
					  </tr>
					</tbody>
                    </table>
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
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/jquery.dataTables.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/dataTables.bootstrap4.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-toast.js'/>"></script>

<script>
  function downloadComprovante(pessoaId){
    window.location.href = '${cp}/usuario/comprovante/download-comprovante-doacao/' + pessoaId;
  }

  function ativarPessoa(pessoaId, btnId){
    var btn = document.getElementById(btnId);
    if(btn){ btn.disabled = true; btn.innerText = 'Ativando...'; }
    window.location.href = '${cp}/usuario/ativar-doador?id=' + pessoaId;
  }
</script>
</body>
</html>
