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
  <title>Vem TambÃ©m â€” Minha Rede</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <!-- Fontes / Ã­cones -->
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

  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>

  <!-- Page-specific: Tree CSS -->
  <style>
    :root{ --branch: 16px; }

    .tree{ width:100%; overflow-x:auto; padding:1rem 0; -webkit-overflow-scrolling:touch; scrollbar-width:thin; scrollbar-color:rgba(111,122,0,.3) transparent; }
    .tree::-webkit-scrollbar{ height:6px; }
    .tree::-webkit-scrollbar-track{ background:transparent; }
    .tree::-webkit-scrollbar-thumb{ background:rgba(111,122,0,.3); border-radius:999px; }
    .tree ul{ padding-top:1rem; position:relative; display:flex; justify-content:center; gap:2rem; flex-wrap:nowrap; }
    .tree ul ul{ gap:1.25rem; }
    .tree li{ list-style:none; text-align:center; position:relative; padding:calc(var(--branch)*2) .5rem 0 .5rem; z-index:0; }
    .tree ul>li>ul::after{ content:''; position:absolute; top:var(--branch); left:0; right:0; border-top:1px solid #d1d5db; z-index:0; }
    .tree ul>li>ul::before{ content:none; }
    .tree li>.node{ position:relative; z-index:1; }
    .tree li>.node::before{ content:''; position:absolute; top:calc(-1*var(--branch)); left:50%; transform:translateX(-50%); border-left:1px solid #d1d5db; height:var(--branch); z-index:0; }
    .tree ul>li>ul>li:first-child>.node::before,
    .tree ul>li>ul>li:last-child>.node::before{ top:calc(-2*var(--branch)); height:calc(2*var(--branch)); }
    .tree>ul>li>.node::before{ display:none; }
    .node{ display:inline-flex; align-items:center; gap:.5rem; background:#fff; color:#111827; border:1px solid #e5e7eb; border-radius:14px; padding:.5rem .75rem; font-weight:600; box-shadow:0 6px 20px rgba(0,0,0,.06); white-space:nowrap; position:relative; z-index:1; }
    .node .lvl{ font-size:.75rem; font-weight:800; line-height:1; border-radius:999px; padding:.25rem .45rem; display:inline-block; }
    .node.node-paid{ background:#ffffff; border-color:#e5e7eb; color:#111827; }
    .node.node-pending{ background:#fff3e8; border-color:#f2b36d; color:#7c3d00; box-shadow:0 6px 20px rgba(242, 155, 72, .25); }
    .node .node-status{ font-size:.66rem; font-weight:800; border-radius:999px; padding:.18rem .45rem; line-height:1; }
    .node .node-status.paid{ background:#eef2f7; color:#475569; }
    .node .node-status.pending{ background:#ffd7ad; color:#8a4300; }
    .node .lvl.l0{ background:#34d399; color:#052e16; }
    .node .lvl.l1{ background:#60a5fa; color:#0b2542; }
    .node .lvl.l2{ background:#fde047; color:#473c00; }
    .node .lvl.l3{ background:#ddd6fe; color:#1f1060; }
    .node i{ opacity:.75; }

    .badge-level-1{background:#60a5fa;color:#0b2542}
    .badge-level-2{background:#fde047;color:#473c00}

    @media (max-width:767.98px){
      .tree{ padding:.75rem 0; }
      .tree ul{ gap:.75rem; min-width:max-content; padding-left:1rem; padding-right:1rem; }
      .tree ul ul{ gap:.5rem; }
      .tree li{ padding:calc(var(--branch)*1.5) .25rem 0 .25rem; }
      .node{ font-size:.8rem; padding:.35rem .55rem; border-radius:10px; gap:.35rem; }
      .node .lvl{ font-size:.65rem; padding:.2rem .35rem; }
    }

    .tree-wrapper{ position:relative; }
    .tree-wrapper::after{ content:''; position:absolute; top:0; right:0; bottom:0; width:24px; background:linear-gradient(90deg,transparent,rgba(255,255,255,.7)); pointer-events:none; opacity:1; transition:opacity .3s; }
    @media (min-width:768px){ .tree-wrapper::after{ display:none; } }

    .pending-mask .tree li li > .node span:not(.lvl):not(.node-status){
      filter: blur(1.2px);
      opacity:.92;
      user-select:none;
    }
    .pending-mask .tree li li > .node{
      border-style:dashed;
      background:#fff9f2;
    }
  </style>
</head>
<body id="page-top" data-user-id="${usuarioLogado.id}">

<c:set var="cp" value="${pageContext.request.contextPath}" />

<div id="wrapper" class="${ocultarDadosRede ? 'pending-mask' : ''}">
  <!-- Sidebar -->
  <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

  <!-- Content -->
  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/includes/topbar.jsp" />

      <div class="container-fluid">
        <div class="content-surface mb-3">
          <div class="d-flex align-items-center justify-content-between flex-wrap">
            <div>
              <h1 class="h3">Minha Rede</h1>
              <p>Todas as pessoas da sua rede, organizadas por ciclo.</p>
            </div>
            <div class="d-flex align-items-center flex-wrap" style="gap:.5rem">
              <c:if test="${tipoCicloAtual != null}">
                <span class="badge badge-pill badge-cycle">
                  <i class="fas fa-trophy mr-1"></i>${tipoCicloAtual.nome}
                </span>
              </c:if>
              <span class="badge badge-pill" style="background:#e0e7ff; color:#3730a3; font-size:.85rem; padding:.4rem .9rem;">
                <i class="fas fa-star mr-1"></i>${pessoa.quantCiclos} ciclo(s)
              </span>
            </div>
          </div>
        </div>

        <div class="card shadow mb-4">
          <!-- TÃ­tulo + Abas -->
          <div class="card-header" data-tour-id="rede-ciclos">
            <h6 class="m-0 font-weight-bold text-brand">Estrutura por ciclo</h6>
            <ul class="nav nav-tabs vt-vaadin-tabs" id="redeTab" role="tablist">
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
            <c:if test="${ocultarDadosRede}">
              <div class="alert alert-warning mb-3" role="alert">
                <strong>AtivaÃ§Ã£o pendente.</strong> VocÃª jÃ¡ possui posicionamento na rede, mas os dados dos outros participantes ficam protegidos atÃ© a aprovaÃ§Ã£o.
              </div>
            </c:if>
                <div class="tab-content" id="redeTabContent">
                  <c:forEach var="aba" items="${ciclos}" varStatus="status">
                    <div class="tab-pane fade ${aba.ativo ? 'show active' : ''}" id="tab${status.index + 1}" role="tabpanel" aria-labelledby="tab${status.index + 1}-tab">

                      <!-- Empty state when no network members -->
                      <c:if test="${empty aba.indicadoEsquerda and empty aba.indicadoDireita}">
                        <div class="empty-state">
                          <i class="fas fa-users empty-state-icon"></i>
                          <div class="empty-state-title">Sua rede estÃ¡ crescendo!</div>
                          <div class="empty-state-text">Convide pessoas â€” seu primeiro indicado Ã© o passo mais importante.</div>
                        </div>
                      </c:if>

                      <c:if test="${not empty aba.indicadoEsquerda or not empty aba.indicadoDireita}">
					<!-- Ãrvore da Rede -->
					<div class="tree-wrapper" data-tour-id="rede-arvore"><div class="tree">
					  <ul>
					    <li>
					      <div class="node ${usuarioLogado.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					           title='<b>UsuÃ¡rio logado</b><br/>${usuarioLogado.nome}'>
					        <span class="lvl l0">VocÃª</span>
					        <i class="fas fa-user-circle"></i>
					        <span>${usuarioLogado.nome}</span>
                            <span class="node-status ${usuarioLogado.ativo ? 'paid' : 'pending'}">${usuarioLogado.ativo ? 'Pago' : 'Pendente'}</span>
					      </div>

					      <ul>
					        <!-- GALHO ESQUERDA -->
					        <li>
					          <c:if test="${not empty aba.indicadoEsquerda}">
					            <div class="node ${aba.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					            	title='<b>Nome:</b> ${aba.indicadoEsquerda.nome}<br/>
					            		   <b>Contato:</b> ${aba.indicadoEsquerda.whatsapp}<br/>
					                       <b>Documento:</b> ${aba.indicadoEsquerda.documento}'>
					              <span class="lvl l1">1</span>
					              <i class="fas fa-user"></i>
					              <span>${aba.indicadoEsquerda.nomeCurto}</span>
                                  <span class="node-status ${aba.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					            </div>
					          </c:if>

					          <ul>
					            <li>
					              <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda}">
					                <div class="node ${aba.indicadoEsquerda.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
                                      <span class="node-status ${aba.indicadoEsquerda.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                </div>
					              </c:if>

					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda}">
					                    <div class="node ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita}">
					                    <div class="node ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>

					            <li>
					              <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita}">
					                <div class="node ${aba.indicadoEsquerda.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
                                      <span class="node-status ${aba.indicadoEsquerda.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                </div>
					              </c:if>

					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda}">
					                    <div class="node ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita.indicadoDireita}">
					                    <div class="node ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>
					          </ul>
					        </li>

					        <!-- GALHO DIREITA -->
					        <li>
					          <c:if test="${not empty aba.indicadoDireita}">
					            <div class="node ${aba.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                 title='<b>Nome:</b> ${aba.indicadoDireita.nome}<br/>
					                 		<b>Contato:</b> ${aba.indicadoDireita.whatsapp}<br/>
					                        <b>Documento:</b> ${aba.indicadoDireita.documento}'>
					              <span class="lvl l1">1</span>
					              <i class="fas fa-user"></i>
					              <span>${aba.indicadoDireita.nomeCurto}</span>
                                  <span class="node-status ${aba.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					            </div>
					          </c:if>

					          <ul>
					            <li>
					              <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda}">
					                <div class="node ${aba.indicadoDireita.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
                                      <span class="node-status ${aba.indicadoDireita.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                </div>
					              </c:if>

					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda}">
					                    <div class="node ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda.indicadoDireita}">
					                    <div class="node ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>

					            <li>
					              <c:if test="${not empty aba.indicadoDireita.indicadoDireita}">
					                <div class="node ${aba.indicadoDireita.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoDireita.indicadoDireita.nomeCurto}</span>
                                      <span class="node-status ${aba.indicadoDireita.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                </div>
					              </c:if>

					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoDireita.indicadoEsquerda}">
					                    <div class="node ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoDireita.indicadoDireita}">
					                    <div class="node ${aba.indicadoDireita.indicadoDireita.indicadoDireita.ativo ? 'node-paid' : 'node-pending'}" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoDireita.indicadoDireita.nomeCurto}</span>
                                          <span class="node-status ${aba.indicadoDireita.indicadoDireita.indicadoDireita.ativo ? 'paid' : 'pending'}">${aba.indicadoDireita.indicadoDireita.indicadoDireita.ativo ? 'Pago' : 'Pendente'}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>
					          </ul>
					        </li>
					      </ul>
					    </li>
					  </ul>
					</div></div><!-- /tree-wrapper -->
                      </c:if>

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
          <span>&copy; Vem TambÃ©m 2025-2026</span>
        </div>
      </div>
    </footer>
  </div><!-- /content-wrapper -->
</div><!-- /wrapper -->

<!-- Scroll to Top -->
<a class="scroll-to-top rounded" href="#page-top" aria-label="Voltar ao topo"><i class="fas fa-angle-up"></i></a>

<!-- Global Modals -->
<jsp:include page="/WEB-INF/includes/global-modals.jsp" />

<!-- JS -->
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/sb-admin-2.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/jquery.dataTables.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/datatables/dataTables.bootstrap4.min.js'/>"></script>

<script>
  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });
</script>
<script type="text/javascript" src="<c:url value='/resources/vendor/introjs/intro.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/vendor/lordicon/lordicon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-core.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-icons.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/vt-tour.js'/>"></script>
</body>
</html>





