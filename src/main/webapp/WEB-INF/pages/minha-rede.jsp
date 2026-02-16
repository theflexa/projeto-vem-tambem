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
  <title>Vem Também — Minha Rede</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <!-- Paths -->
  <c:set var="cp"  value="${pageContext.request.contextPath}" />
  <c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri'] != null 
                           ? requestScope['javax.servlet.forward.request_uri'] 
                           : pageContext.request.requestURI}" />

  <!-- Fontes / ícones -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <spring:url value="/resources/vendor/fontawesome-free/css/all.min.css" var="allmincss" />
  <link href="${allmincss}" rel="stylesheet"/>

  <!-- SB Admin 2 -->
  <spring:url value="/resources/css/sb-admin-2.min.css" var="sbadmin2mincss" />
  <link href="${sbadmin2mincss}" rel="stylesheet"/>

  <spring:url value="/resources/vendor/datatables/dataTables.bootstrap4.min.css" var="dtcss" />
  <link href="${dtcss}" rel="stylesheet"/>

  <style>
    :root{ --olive:#6f7a00; --gold:#f3c900; --ink:#1f2937; --muted:#6b7280; --radius:18px; }
    html,body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif;}
    body{
      background: radial-gradient(1200px 800px at 15% 10%, #d9cc4a 0%, #b7ad1a 30%, #8e8a0a 55%, #6f7a00 85%);
      min-height:100vh;
    }

    /* Sidebar */
    .bg-gradient-primary{ background: linear-gradient(180deg, var(--olive) 0%, #8e8a0a 60%, var(--gold) 120%) !important; }
    .sidebar .nav-item .nav-link{border-radius:12px; margin:2px 8px; font-weight:600;}
    .sidebar .nav-item.active>.nav-link,
    .sidebar .nav-item .nav-link.active,
    .sidebar .nav-item .nav-link:hover{background:rgba(255,255,255,.16);}
    .sidebar .sidebar-brand{height:4.5rem}

    /* Topbar */
    .topbar{border:0; border-bottom:1px solid rgba(0,0,0,.05)}
    .topbar .navbar-nav .nav-link{font-weight:600; color:#4b5563}

    /* Cards/botões */
    .card,.alert,.modal-content{border:0; border-radius:var(--radius); box-shadow:0 6px 24px rgba(0,0,0,.08)}
    .btn-olive{background:linear-gradient(90deg, var(--olive) 0%, var(--gold) 100%); border:0; color:#141a00; font-weight:700; border-radius:999px;}
    .btn-olive:hover{filter:brightness(.95)}
    .text-brand{color:#5b6400}

    /* Cabeçalho da página */
    .content-surface{ background:#ffffffd9; backdrop-filter:blur(6px); border-radius:var(--radius); padding:1rem 1.25rem; }
    .content-surface h1{color:var(--ink); font-weight:800; margin-bottom:.25rem}
    .content-surface p{color:#6b7280; margin-bottom:0}

    /* Abas coladas no header do card */
    .card-header{padding:.7rem 1rem .35rem;}
    .card-header .nav-tabs{border:0; margin:.35rem 0 0;}
    .card-header .nav-tabs .nav-link{
      border:0; border-radius:999px; padding:.33rem .75rem; margin-right:.35rem;
      background:#f3f4f6; color:#374151; font-weight:700; line-height:1.2;
    }
    .card-header .nav-tabs .nav-link.active{ background:#e5e7eb; color:#111827 }

    /* Tabela */
    .table thead th{border-top:0; color:#4b5563; font-weight:800; text-transform:uppercase; font-size:.78rem; letter-spacing:.02em;}
    .badge-pill{border-radius:999px; padding:.32rem .65rem; font-weight:700}
    .badge-level-1{background:#60a5fa; color:#0b2542} /* azul claro */
    .badge-level-2{background:#fde047; color:#473c00} /* amarelo */

    /* Ícone WhatsApp em links */
    .wa i{margin-left:.25rem}
    
    /* ====== ÁRVORE ====== */
	:root{
	  --branch: 16px;              /* altura dos conectores */
	}
	
	/* container */
	.tree{ width:100%; overflow-x:auto; padding:1rem 0; }
	.tree ul{
	  padding-top:1rem; position:relative;
	  display:flex; justify-content:center; gap:2rem; flex-wrap:nowrap;
	}
	.tree ul ul{ gap:1.25rem; }
	
	/* cada nó reserva espaço para conectores acima */
	.tree li{
	  list-style:none; text-align:center; position:relative;
	  padding: calc(var(--branch) * 2) .5rem 0 .5rem;  /* 2× para permitir as DUAS pernas do pai */
	  z-index:0;
	}
	
	/* ---------- CONECTORES ---------- */
	/* HORIZONTAL CONTÍNUA (uma só por grupo de filhos) */
	.tree ul > li > ul::after{
	  content:''; position:absolute;
	  top: var(--branch);             /* altura da horizontal */
	  left:0; right:0;
	  border-top:1px solid #d1d5db;
	  z-index:0;
	}
	
	/* NÃO queremos a perna central única do pai */
	.tree ul > li > ul::before{ content:none; }
	
	/* Perninha vertical padrão de TODO filho (da horizontal até o card) */
	.tree li > .node{ position:relative; z-index:1; }
	.tree li > .node::before{
	  content:''; position:absolute;
	  top: calc(-1 * var(--branch));  /* começa na horizontal */
	  left:50%; transform:translateX(-50%);
	  border-left:1px solid #d1d5db;
	  height: var(--branch);
	  z-index:0;                      /* atrás do card */
	}
	
	/* DUAS PERNAS do PAI: apenas no 1º e no último filho subimos até o nível do pai */
	.tree ul > li > ul > li:first-child > .node::before,
	.tree ul > li > ul > li:last-child  > .node::before{
	  top: calc(-2 * var(--branch));
	  height: calc(2 * var(--branch));
	}
	
	/* raiz não tem perninha */
	.tree > ul > li > .node::before{ display:none; }
	
	/* ---------- NÓS (cards) ---------- */
	.node{
	  display:inline-flex; align-items:center; gap:.5rem;
	  background:#fff; color:#111827; border:1px solid #e5e7eb;
	  border-radius:14px; padding:.5rem .75rem; font-weight:600;
	  box-shadow:0 6px 20px rgba(0,0,0,.06);
	  white-space:nowrap; position:relative; z-index:1;
	}
	.node .lvl{
	  font-size:.75rem; font-weight:800; line-height:1;
	  border-radius:999px; padding:.25rem .45rem; display:inline-block;
	}
	.node .lvl.l0{ background:#34d399; color:#052e16; }
	.node .lvl.l1{ background:#60a5fa; color:#0b2542; }
	.node .lvl.l2{ background:#fde047; color:#473c00; }
	.node .lvl.l3{ background:#ddd6fe; color:#1f1060; }
	.node i{ opacity:.75 }


	    
	    
  </style>
</head>
<body id="page-top">

<div id="wrapper">
  <!-- Sidebar -->
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${cp}/painel">
      <div class="sidebar-brand-icon">
        <img src="<c:url value='/resources/img/logo_vertical_2.png'/>" alt="Vem Também" style="height:85px">
      </div>
    </a>

    <hr class="sidebar-divider my-0"/>

    <li class="nav-item ${fn:startsWith(uri, cp.concat('/painel')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/painel"><i class="fas fa-home"></i><span>Painel</span></a>
    </li>

    <hr class="sidebar-divider"/>
    <div class="sidebar-heading">Operação</div>

    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/minha-rede')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/minha-rede"><i class="fas fa-network-wired"></i><span>Minha Rede</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/dados-pessoais')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/dados-pessoais"><i class="fas fa-user"></i><span>Meus Dados</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/donatarios')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/donatarios"><i class="fas fa-hand-holding-heart"></i><span>Minha Contribuição</span></a>
    </li>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/usuario/doadores')) ? 'active' : ''}">
      <a class="nav-link" href="${cp}/usuario/doadores"><i class="fas fa-donate"></i><span>Doadores</span></a>
    </li>
    <li class="nav-item"><a class="nav-link" href="${cp}/sair"><i class="fas fa-sign-out-alt"></i><span>Sair</span></a></li>

    <hr class="sidebar-divider d-none d-md-block"/>
    <div class="sidebar-heading">Atendimento</div>
    <li class="nav-item ${fn:startsWith(uri, cp.concat('/suporte')) ? 'active' : ''}">
      <a class="nav-link" href="https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Também" target="_blank"><i class="fas fa-headset"></i><span>Suporte</span></a>
    </li>

    <c:if test="${usuarioLogado.admin}">
      <hr class="sidebar-divider d-none d-md-block"/>
      <div class="sidebar-heading">Admin</div>
      <li class="nav-item ${fn:startsWith(uri, cp.concat('/admin/listar-pendentes')) ? 'active' : ''}">
        <a class="nav-link" href="${cp}/admin/listar-pendentes"><i class="fas fa-user-check"></i><span>Ativar Cadastrados</span></a>
      </li>
    </c:if>

    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle" aria-label="Alternar menu"></button>
    </div>
  </ul>
  <!-- /Sidebar -->

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
              <h1 class="h3">Minha Rede</h1>
              <p>Todas as pessoas da sua rede, organizadas por ciclo.</p>
            </div>
            <div class="d-flex align-items-center flex-wrap" style="gap:.5rem">
              <c:if test="${tipoCicloAtual != null}">
                <span class="badge badge-pill" style="background:var(--olive); color:#fff; font-size:.85rem; padding:.4rem .9rem;">
                  <i class="fas fa-trophy mr-1"></i>${tipoCicloAtual.nome}
                </span>
              </c:if>
              <span class="badge badge-pill" style="background:#e0e7ff; color:#3730a3; font-size:.85rem; padding:.4rem .9rem;">
                <i class="fas fa-star mr-1"></i>${pessoa.quantCiclos} ciclo(s)
              </span>
            </div>
          </div>
          <!-- Mini progresso -->
          <div class="mt-2 d-flex align-items-center" style="gap:.75rem">
            <div class="progress flex-grow-1" style="height:8px; border-radius:999px;">
              <c:set var="progRede" value="${pessoa.quantDoacoesRecebidas * 100 / 8}" />
              <div class="progress-bar" role="progressbar" style="width:${progRede > 100 ? 100 : progRede}%; background:linear-gradient(90deg, var(--olive), var(--gold)); border-radius:999px;"></div>
            </div>
            <small class="font-weight-bold" style="color:var(--ink); white-space:nowrap">${pessoa.quantDoacoesRecebidas}/8</small>
          </div>
          <c:choose>
            <c:when test="${pessoa.quantDoacoesRecebidas >= 8}">
              <small style="color:#16a34a; font-weight:700"><i class="fas fa-star mr-1"></i>Rede completa! Hora de subir de nível!</small>
            </c:when>
            <c:when test="${pessoa.quantDoacoesRecebidas >= 5}">
              <small style="color:#f59e0b; font-weight:700"><i class="fas fa-fire mr-1"></i>Sua rede está crescendo rápido!</small>
            </c:when>
            <c:when test="${pessoa.quantDoacoesRecebidas >= 1}">
              <small style="color:var(--muted)"><i class="fas fa-fire mr-1" style="color:#f59e0b"></i>Continue convidando para fortalecer sua rede!</small>
            </c:when>
            <c:otherwise>
              <small style="color:var(--muted)"><i class="fas fa-seedling mr-1" style="color:#16a34a"></i>Comece agora! Cada pessoa faz a diferença.</small>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="card shadow mb-4">
          <!-- Título + Abas -->
          <div class="card-header">
            <h6 class="m-0 font-weight-bold text-brand">Estrutura por ciclo</h6>
            <ul class="nav nav-tabs" id="redeTab" role="tablist">
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
            <div class="tab-content" id="redeTabContent">
              <c:forEach var="aba" items="${ciclos}" varStatus="status">
                <div class="tab-pane fade ${aba.ativo ? 'show active' : ''}" id="tab${status.index + 1}" role="tabpanel" aria-labelledby="tab${status.index + 1}-tab">
					
					<!-- Árvore da Rede -->
					<div class="tree">
					  <ul>
					    <li>
					      <!-- RAIZ: Usuário logado -->
					      <div class="node" data-toggle="tooltip" data-html="true"
					           title='<b>Usuário logado</b><br/>${usuarioLogado.nome}'>
					        <span class="lvl l0">Você</span>
					        <i class="fas fa-user-circle"></i>
					        <span>${usuarioLogado.nome}</span>
					      </div>
					
					      <!-- Filhos do usuário logado: esquerda e direita -->
					      <ul>
					        <!-- GALHO ESQUERDA -->
					        <li>
					          <c:if test="${not empty aba.indicadoEsquerda}">
					            <div class="node" data-toggle="tooltip" data-html="true" 
					            	title='<b>Nome:</b> ${aba.indicadoEsquerda.nome}<br/> 
					            		   <b>Contato:</b> ${aba.indicadoEsquerda.whatsapp}<br/>
					                       <b>Documento:</b> ${aba.indicadoEsquerda.documento}'>
					              <span class="lvl l1">1</span>
					              <i class="fas fa-user"></i>
					              <span>${aba.indicadoEsquerda.nomeCurto}</span>
					            </div>
					          </c:if>
					
					          <!-- filhos do nível 2 (E->E e E->D) -->
					          <ul>
					            <!-- E -> E -->
					            <li>
					              <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda}">
					                <div class="node" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
					                </div>
					              </c:if>
					
					              <!-- netos E->E->(E|D) -->
					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>
					
					            <!-- E -> D -->
					            <li>
					              <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita}">
					                <div class="node" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
					                </div>
					              </c:if>
					
					              <!-- netos E->D->(E|D) -->
					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoEsquerda.indicadoDireita.indicadoDireita}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoEsquerda.indicadoDireita.indicadoDireita.nomeCurto}</span>
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
					            <div class="node" data-toggle="tooltip" data-html="true"
					                 title='<b>Nome:</b> ${aba.indicadoDireita.nome}<br/>
					                 		<b>Contato:</b> ${aba.indicadoDireita.whatsapp}<br/>
					                        <b>Documento:</b> ${aba.indicadoDireita.documento}'>
					              <span class="lvl l1">1</span>
					              <i class="fas fa-user"></i>
					              <span>${aba.indicadoDireita.nomeCurto}</span>
					            </div>
					          </c:if>
					
					          <!-- filhos do nível 2 (D->E e D->D) -->
					          <ul>
					            <!-- D -> E -->
					            <li>
					              <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda}">
					                <div class="node" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
					                </div>
					              </c:if>
					
					              <!-- netos D->E->(E|D) -->
					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoEsquerda.indicadoDireita}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoEsquerda.indicadoDireita.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					              </ul>
					            </li>
					
					            <!-- D -> D -->
					            <li>
					              <c:if test="${not empty aba.indicadoDireita.indicadoDireita}">
					                <div class="node" data-toggle="tooltip" data-html="true"
					                     title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.nome}<br/>
					                     		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                            <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.documento}'>
					                  <span class="lvl l2">2</span>
					                  <i class="fas fa-user"></i>
					                  <span>${aba.indicadoDireita.indicadoDireita.nomeCurto}</span>
					                </div>
					              </c:if>
					
					              <!-- netos D->D->(E|D) -->
					              <ul>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoDireita.indicadoEsquerda}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoDireita.indicadoEsquerda.nomeCurto}</span>
					                    </div>
					                  </c:if>
					                </li>
					                <li>
					                  <c:if test="${not empty aba.indicadoDireita.indicadoDireita.indicadoDireita}">
					                    <div class="node" data-toggle="tooltip" data-html="true"
					                         title='<b>Nome:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.nome}<br/>
					                         		<b>Contato:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.whatsapp}<br/>
					                                <b>Documento:</b> ${aba.indicadoDireita.indicadoDireita.indicadoDireita.documento}'>
					                      <span class="lvl l3">3</span>
					                      <i class="fas fa-user"></i>
					                      <span>${aba.indicadoDireita.indicadoDireita.indicadoDireita.nomeCurto}</span>
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
					</div>

			
                  

                </div>
              </c:forEach>
            </div>
          </div>
        </div>

      </div><!-- /container-fluid -->
    </div><!-- /content -->

    <footer class="sticky-footer bg-white">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>© Vem Também 2025-2026</span>
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

<script>
  // DataTables (opcional)
  // $('.table').DataTable({ searching:false, lengthChange:false, pageLength:10, order: [] });
  
  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
  });

</script>
</body>
</html>
