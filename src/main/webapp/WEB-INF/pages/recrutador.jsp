<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Vem Também — Convite</title>
  <link rel="icon" type="image/png" href="<c:url value='/resources/img/logo_vertical_2.png'/>"/>

  <style>
    :root{
      --olive:#6f7a00;
      --olive-700:#5b6400;
      --gold:#f3c900;
      --ink:#111;
      --muted:#6b7280;
      --bg:#f5f7f3;
      --card:#ffffff;
      --border:#e7e7db;
      --radius:16px;
      --shadow:0 12px 24px rgba(0,0,0,.08);

      /* topbar */
      --topbar-h:72px;
      --topbar-bg:rgba(255,255,255,.85);
      --topbar-border:rgba(111,122,0,.18);
    }

    *{box-sizing:border-box}
    html,body{margin:0;padding:0;background:var(--bg);color:var(--ink);font:16px/1.55 "Inter", system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Arial}
    img{max-width:100%;height:auto;display:block}
    a{color:inherit;text-decoration:none}
    .container{width:min(1140px,92%);margin-inline:auto}

    /* === TOPBAR FIXA (logo + CTA) === */
    .topbar{
      position:fixed; inset:0 0 auto 0; height:var(--topbar-h); z-index:1000;
      background:var(--topbar-bg);
      border-bottom:1px solid var(--topbar-border);
      backdrop-filter:saturate(160%) blur(8px);
    }
    .topbar .wrap{
      height:100%; display:flex; align-items:center; justify-content:space-between; gap:14px;
    }
    .brand-inline{display:flex; align-items:center; gap:10px; min-width:0}
    .brand-inline img{height:160px; width:auto; filter:drop-shadow(0 2px 6px rgba(0,0,0,.12))}
    .brand-inline .txt{display:flex; flex-direction:column; line-height:1.05}
    .brand-inline .name{font-weight:800; letter-spacing:.3px; text-transform:uppercase; font-size:14px}
    .brand-inline .sub{font-size:12px; color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis}

    .top-cta{
      appearance:none; border:0; padding:12px 16px; border-radius:12px; cursor:pointer;
      background:linear-gradient(180deg,var(--gold),#e5b900);
      color:#000; font-weight:800; letter-spacing:.2px; box-shadow:0 1px 0 rgba(0,0,0,.08) inset;
      display:inline-flex; align-items:center; gap:8px;
    }
    .top-cta:hover{filter:brightness(1.03)}
    .top-cta .dot{width:8px;height:8px;border-radius:50%;background:var(--olive)}

    /* encolhe ao rolar */
    .topbar.scrolled{--topbar-h:60px}
    .topbar.scrolled .brand-inline img{height:135px}
    .topbar.scrolled .brand-inline .sub{display:none}

    /* === HERO === */
    .hero{
      position:relative; isolation:isolate; overflow:hidden;
      padding:calc(var(--topbar-h) + 34px) 0 56px;
      border-bottom:1px solid var(--border);
    }
    .hero::before{
      content:""; position:absolute; inset:0;
      background:linear-gradient(90deg, rgba(111,122,0,.92) 0%, rgba(111,122,0,.72) 52%, rgba(255,255,255,.82) 100%);
      z-index:-1;
    }
    .hero__wrap{display:grid;gap:28px;align-items:center;grid-template-columns:1.2fr .8fr}
    .hero h1{color:#fff;font-size:clamp(28px,3.2vw,44px);line-height:1.15;margin:0 0 10px}
    .hero p{color:#f9f9f2;margin:0 0 20px}
    .note{background:rgba(255,255,255,.12);color:#fefefe;border:1px solid rgba(255,255,255,.35);border-radius:14px;padding:14px 16px;backdrop-filter: blur(3px)}

    .hero__card{
      background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);
      padding:22px
    }
    .cta{
      appearance:none;border:0;border-radius:12px;cursor:pointer;
      background:var(--gold);color:#000;padding:16px 22px;font-weight:800;letter-spacing:.3px;
      transition:.18s transform,.18s filter; width:100%; box-shadow:0 6px 0 rgba(0,0,0,.12) inset;
    }
    .cta:hover{transform:translateY(-1px);filter:brightness(1.03)}
    .cta--olive{background:var(--olive);color:#fff}
    .cta--olive:hover{background:var(--olive-700)}
    .cta-row{display:grid;gap:10px;grid-template-columns:1fr 1fr}

    /* KPIs */
    .kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-top:18px}
    .kpi{background:rgba(255,255,255,.92);border:1px solid var(--border);border-radius:14px;padding:12px 14px;text-align:center}
    .kpi b{display:block;font-size:18px}
    .kpi span{color:var(--muted);font-size:12px}

    /* Seções */
    section{padding:48px 0}
    h2{font-size:clamp(22px,2.2vw,30px);margin:0 0 12px}
    .sub{color:var(--muted);margin-top:-6px}
    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:22px}

    /* AJUSTE: mesma altura entre os 2 cards */
    .split{
      display:grid;
      gap:22px;
      grid-template-columns:1fr 1fr;
      align-items:stretch;                  /* força mesma altura */
    }
    .split > .card,
    .split > .video.card{
      height:100%;
      display:flex;
      flex-direction:column;
    }

    .steps{display:grid;gap:14px}
    .step{display:grid;grid-template-columns:auto 1fr;gap:12px;align-items:flex-start}
    .bullet{width:34px;height:34px;border-radius:50%;display:grid;place-items:center;background:var(--olive);color:#fff;font-weight:800}

    details{margin-top:10px;border-top:1px dashed var(--border);padding-top:10px}
    details>summary{cursor:pointer;list-style:none;color:var(--olive);font-weight:700}
    details>summary::-webkit-details-marker{display:none}

    /* vídeo “comum” (mantém para thumbs e outras áreas) */
    .video{position:relative;width:100%;aspect-ratio:16/9;border-radius:14px;overflow:hidden;box-shadow:var(--shadow)}
    .video iframe{position:absolute;inset:0;width:100%;height:100%;border:0}

    .video-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:14px}
    .vthumb{display:block;background:var(--card);border:1px solid var(--border);border-radius:12px;box-shadow:var(--shadow);overflow:hidden}
    .vthumb img{width:100%}
    .vthumb .vtxt{padding:10px 12px;font-size:14px;color:var(--muted)}

    .check{margin:0;padding:0 0 0 20px}
    .check li{margin:6px 0}
    .check li::marker{content:"✔  ";color:var(--olive)}

	/* garante que itens ocultos realmente sumam */
	.faq .answer[hidden]{ display:none !important; }
    .faq .item{border:1px solid var(--border);border-radius:12px;background:var(--card);box-shadow:var(--shadow);margin-bottom:10px}
    .faq button{width:100%;text-align:left;padding:16px 18px;border:0;background:transparent;font-weight:700;cursor:pointer}
    .faq button:focus{outline:3px solid rgba(111,122,0,.35)}
    .faq .answer{display:none;padding:0 18px 16px;color:#333}
    .faq .item.open .answer{display:block}
    .faq .item.open button{border-bottom:1px solid var(--border)}

    /* CTA fixo mobile */
    .mobile-cta{position:fixed;left:0;right:0;bottom:0;display:none;padding:10px;background:rgba(255,255,255,.94);backdrop-filter:saturate(160%) blur(6px);border-top:1px solid var(--border);z-index:999}
    .mobile-cta .container{display:flex;gap:10px}
    .mobile-cta .cta{padding:14px 18px}

    footer{padding:30px 0;border-top:1px solid var(--border);color:var(--muted);text-align:center}

    @media (max-width:980px){
      .hero__wrap{grid-template-columns:1fr}
      .kpis{grid-template-columns:repeat(2,1fr)}
      .split{grid-template-columns:1fr}
      .brand-inline .sub{display:none}
    }
    @media (max-width:680px){
      .mobile-cta{display:block}
      body{padding-bottom:80px}
      .cta-row{grid-template-columns:1fr}
      .brand-inline img{height:135px}
    }
    
    /* ---- Summary/Details clicável ---- */
	.details-cta { 
	  cursor:pointer; list-style:none; 
	  display:flex; align-items:center; gap:10px;
	  padding:12px 14px; border-radius:12px;
	  color:var(--olive); font-weight:800;
	  background:rgba(111,122,0,.06);
	  border:1px dashed var(--olive);
	  transition:.18s transform,.18s background,.18s box-shadow;
	  outline:0;
	}
	.details-cta:hover{ background:rgba(111,122,0,.10) }
	details:has(.details-cta):focus-within .details-cta{
	  box-shadow:0 0 0 3px rgba(111,122,0,.25);
	}
	.details-cta .ico{
	  width:22px;height:22px;border-radius:50%;
	  display:grid;place-items:center;flex:0 0 22px;
	  background:var(--olive); color:#fff; font-weight:800; font-size:13px;
	}
	.details-cta::after{
	  content:""; margin-left:auto; width:10px; height:10px;
	  border-right:2px solid currentColor; border-bottom:2px solid currentColor;
	  transform:rotate(-45deg); transition:.2s;
	}
	details[open] .details-cta::after{ transform:rotate(45deg) }
	details .check{ border-top:1px dashed var(--border); margin-top:10px; padding-top:10px }
	    
	/* AJUSTE: painel branco do vídeo preenchendo a altura */
	.video.card{
	  background:var(--card);
	  border:1px solid var(--border);
	  border-radius:var(--radius);
	  box-shadow:var(--shadow);
	  padding:14px;
	  display:flex;
	  flex-direction:column;
	}
	.video.card .video-wrap{
	  position:relative;
	  width:100%;
	  height:100%;               /* ocupa toda a altura do card */
	  border-radius:12px;
	  overflow:hidden;
	}
	.video.card .video-wrap iframe{
	  position:absolute; inset:0;
	  width:100%; height:100%;
	  border:0;
	}
  </style>
</head>
<body>

  <!-- TOPBAR FIXA -->
  <div class="topbar" id="topbar">
    <div class="container wrap">
      <div class="brand-inline">
        <img src="<c:url value='/resources/img/logo_vertical.png'/>" alt="Vem Também"/>
      </div>
      
      <form:form action="cadastrar" method="get">
        <input type="hidden" name="login" value="${login}"/>
        <button type="submit" class="top-cta" aria-label="Cadastrar agora">
          <span aria-hidden="true"></span> Faça Seu Cadastro
        </button>
      </form:form>
    
    </div>
  </div>

  <!-- HERO -->
  <header class="hero">
    <div class="container hero__wrap">
      <div>
        <h1>Bem-vindo à Vem Também</h1>
        <p>Uma plataforma descentralizada de ajuda mútua: nenhum dinheiro passa pela plataforma; as doações acontecem diretamente entre os participantes.</p>
        <div class="note">Quer fazer parte da nossa rede? Faça o seu cadastro e inicie seu ciclo de doações.</div>

        <!-- KPIs -->
        <div class="kpis">
          <div class="kpi"><b>R$ 300,00</b><span>Doação de entrada</span></div>
          <div class="kpi"><b>R$ 2.080,00</b><span>Recebidos por ciclo concluído</span></div>
          <div class="kpi"><b>PIX direto</b><span>Entre participantes</span></div>
          <div class="kpi"><b>Sem intermediar</b><span>Plataforma não recebe</span></div>
        </div>
      </div>

      <div class="hero__card">
        <div class="cta-row">
          <form:form id="cadastro-form" action="cadastrar" method="get">
            <input type="hidden" name="login" value="${login}"/>
            <button type="submit" class="cta">CADASTRE-SE AGORA</button>
          </form:form>
          <form:form action="cadastrar" method="get">
            <input type="hidden" name="login" value="${login}"/>
            <button type="submit" class="cta cta--olive"><b>FAÇA SEU CADASTRO</b></button>
          </form:form>
        </div>
        <small style="display:block;margin-top:10px;color:var(--muted)">Você poderá sair quando quiser.</small>
      </div>
    </div>
  </header>

  <!-- Como funciona + vídeo -->
  <section>
    <div class="container split">
      <div class="card">
        <h2>Como funciona</h2>
        <div class="steps">
          <div class="step"><div class="bullet">1</div><div><b>Ativação:</b> doe <b>R$ 40,00</b> (manutenção) + <b>R$ 260,00</b> (para a pessoa indicada pelo sistema).</div></div>
          <div class="step"><div class="bullet">2</div><div><b>Recebimento:</b> quando 8 pessoas doarem R$ 260,00 para você, você recebe <b>R$ 2.080,00</b> e encerra o <b>ciclo</b>.</div></div>
          <div class="step"><div class="bullet">3</div><div><b>Depois do ciclo:</b> escolha <b>parar</b> ou <b>continuar</b> (reentrada seguindo seu patrocinador).</div></div>
        </div>
        <details>
		  <summary class="details-cta" aria-label="Abrir regras e observações">
		    <span class="ico">i</span>
		    Regras e observações
		  </summary>
		  <ul class="check">
		    <li>Indicar 2 pessoas acelera o ciclo; quando a regra estiver desabilitada, o derramamento pode completar sua rede.</li>
		    <li>Comprovantes precisam ser liberados para você ciclar e seguir recebendo.</li>
		    <li>Sem “reserva de posição” por fora do sistema.</li>
		  </ul>
		</details>

      </div>

      <!-- AJUSTE: wrapper para o iframe preencher todo o card -->
      <div class="video card" aria-label="Vídeo de apresentação">
        <div class="video-wrap">
<!--           <iframe src="https://www.youtube.com/embed/iSBUQ-TRyxc?rel=0" -->
<!--                   title="Apresentação — Rede de Doadores do Brasil" -->
<!--                   loading="lazy" -->
<!--                   allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" -->
<!--                   allowfullscreen></iframe> -->
        </div>
      </div>
      
    </div>
  </section>

  <!-- Diferença vs pirâmide + Para quem vai -->
  <section>
    <div class="container split">
      <div class="card">
        <h2>Qual a diferença para pirâmide financeira?</h2>
        <ul class="check">
          <li><b>Doação voluntária:</b> não é investimento nem promessa de rendimento fixo.</li>
          <li><b>PIX direto entre pessoas:</b> a plataforma não recebe valores.</li>
          <li><b>Ciclo claro:</b> ativa, recebe 8× R$ 260,00, decide parar ou continuar.</li>
          <li><b>Segurança</b>Aqui as doações são diretas e rastreáveis entre participantes.</li>
        </ul>
      </div>

      <div class="card">
        <h2>Você pode doar e pode receber</h2>
        <p class="sub">Aqui é possível construir uma grande rede de doadores para você.</p>
        <details open>
          <summary></summary>
          <img loading="lazy" src="<c:url value='/resources/img/recrutador/exemplo_doacoes.png'/>" alt="Exemplos de doações"/>
        </details>
      </div>
    </div>
  </section>

  <!-- Guia de convite -->
<!--   <section> -->
<!--     <div class="container"> -->
<!--       <h2>Aprenda a convidar de forma profissional</h2> -->
<!--       <p class="sub">Clique e assista no YouTube (abre em nova aba).</p> -->
<!--       <div class="video-grid"> -->
<!--         <a class="vthumb" href="https://www.youtube.com/watch?v=Il-2JB-iRiU" target="_blank" rel="noopener"> -->
<!--           <img src="https://i.ytimg.com/vi/Il-2JB-iRiU/hqdefault.jpg" alt="Como abordar e convidar"/> -->
<!--           <div class="vtxt">Como abordar e convidar</div> -->
<!--         </a> -->
<!--         <a class="vthumb" href="https://www.youtube.com/watch?v=CES1Cy37i9I" target="_blank" rel="noopener"> -->
<!--           <img src="https://i.ytimg.com/vi/CES1Cy37i9I/hqdefault.jpg" alt="Passo a passo de convite"/> -->
<!--           <div class="vtxt">Passo a passo de convite</div> -->
<!--         </a> -->
<!--         <a class="vthumb" href="https://www.youtube.com/watch?v=FPrJ9E1Gwa8" target="_blank" rel="noopener"> -->
<!--           <img src="https://i.ytimg.com/vi/FPrJ9E1Gwa8/hqdefault.jpg" alt="Mensagens que funcionam"/> -->
<!--           <div class="vtxt">Mensagens que funcionam</div> -->
<!--         </a> -->
<!--       </div> -->
<!--     </div> -->
<!--   </section> -->

  <!-- Imagens + CTA -->
  <section>
    <div class="container card">
      <h2>Venha fazer parte dessa rede</h2>
      <p class="sub">Preparamos um material para você.</p>
      <details>
        <summary class="details-cta" aria-label="Abrir regras e observações">
		    <span class="ico">i</span>
		    Exibir material
		</summary>
		  
        <img loading="lazy" src="<c:url value='/resources/img/recrutador/porque_doar.png'/>" alt="">
        <img loading="lazy" src="<c:url value='/resources/img/recrutador/diferenca_piramide.png'/>" alt="">
      </details>

      <div style="margin-top:18px;display:flex;gap:10px;justify-content:center;flex-wrap:wrap">
        <form:form action="cadastrar" method="get">
          <input type="hidden" name="login" value="${login}"/>
          <button type="submit" class="cta">QUERO ME CADASTRAR</button>
        </form:form>
        <form:form action="cadastrar" method="get">
          <input type="hidden" name="login" value="${login}"/>
          <button type="submit" class="cta cta--olive"><b>ENTRAR AGORA</b></button>
        </form:form>
      </div>
    </div>
  </section>

  <!-- Regras + Dúvidas -->
  <section>
    <div class="container split">
      <div class="card">
        <h2>Regras essenciais</h2>
        <ul class="check">
          <li>Faça sua doação seguindo as regras do sistema. Nada por fora.</li>
          <li>Nunca doe para quem não aparece no sistema (chave PIX visível).</li>
          <li>Sem “reservar posição” ou grupos externos.</li>
          <li>Ative em até 24h após o cadastro (senão o cadastro é removido).</li>
        </ul>
      </div>
      <div class="card">
        <h2>Dúvidas rápidas</h2>
        <ul class="check">
          <li><b>Indicações:</b> quando a regra estiver ativa, são até 2 diretas.</li>
          <li><b>Ciclar:</b> 8× R$ 260,00 = R$ 2.080,00. Libere todos os comprovantes.</li>
          <li><b>Imposto de renda:</b> doações são “Rendimentos isentos – código 14”.</li>
          <li><b>Menores de idade:</b> não participam.</li>
        </ul>
      </div>
    </div>
  </section>

  	<!-- FAQ -->
	<section class="faq">
	  <div class="container">
	    <h2>Perguntas Frequentes</h2>
	
	    <div class="item">
	      <button type="button" aria-expanded="false" aria-controls="faq-a1">Quais cuidados para não perder meus R$ 300,00?</button>
	      <div id="faq-a1" class="answer" hidden>
	        <p>1) Doe pelo sistema; 2) Não doe para terceiros fora da tela; 3) Não “reserve posição”; 4) Doe após o cadastro oficial.</p>
	      </div>
	    </div>
	
	    <div class="item">
	      <button type="button" aria-expanded="false" aria-controls="faq-a2">Preciso indicar pessoas?</button>
	      <div id="faq-a2" class="answer" hidden>
	        <p><b>No momento, não.</b> Quando a regra voltar, serão até 2 diretas via seu link.</p>
	      </div>
	    </div>
	
	    <div class="item">
	      <button type="button" aria-expanded="false" aria-controls="faq-a3">Posso receber sem indicar?</button>
	      <div id="faq-a3" class="answer" hidden>
	        <p>Sim, quando a regra estiver desativada. Recebimentos podem vir por derramamento da sua linha ascendente.</p>
	      </div>
	    </div>
	
	    <div class="item">
	      <button type="button" aria-expanded="false" aria-controls="faq-a4">O que acontece ao ciclar?</button>
	      <div id="faq-a4" class="answer" hidden>
	        <p>Recebe R$ 2.080,00 e escolhe <b>parar</b> (login encerra e equipe segue upline ativo/qualificado) ou <b>continuar</b> (reentrada seguindo seu patrocinador).</p>
	      </div>
	    </div>
	  </div>
	</section>


  <footer>
    <div class="container">Copyright © Vem Também 2025</div>
  </footer>

  <!-- CTA fixo no mobile -->
  <div class="mobile-cta" aria-hidden="true">
    <div class="container">
      <form:form action="cadastrar" method="get" style="flex:1">
        <input type="hidden" name="login" value="${login}"/>
        <button type="submit" class="cta cta--olive">CADASTRAR AGORA</button>
      </form:form>
    </div>
  </div>

  <script>
document.addEventListener('DOMContentLoaded', () => {
  // FAQ: abre/fecha e fecha os outros (acessível)
  const faqItems = document.querySelectorAll('.faq .item');
  faqItems.forEach(item => {
    const btn = item.querySelector('button');
    const panel = item.querySelector('.answer');
    btn.addEventListener('click', () => {
      const isOpen = !panel.hasAttribute('hidden');

      // fecha todos
      faqItems.forEach(i => {
        const b = i.querySelector('button');
        const p = i.querySelector('.answer');
        p.setAttribute('hidden', '');
        i.classList.remove('open');
        b.setAttribute('aria-expanded', 'false');
      });

      // abre o clicado se estava fechado
      if (!isOpen) {
        panel.removeAttribute('hidden');
        item.classList.add('open');
        btn.setAttribute('aria-expanded', 'true');
        item.scrollIntoView({behavior:'smooth', block:'start'});
      }
    });
  });

  // Topbar: encolhe ao rolar
  const top = document.getElementById('topbar');
  const onScroll = () => {
    if (window.scrollY > 10) top.classList.add('scrolled');
    else top.classList.remove('scrolled');
  };
  onScroll();
  document.addEventListener('scroll', onScroll, {passive:true});
});
</script>

</body>
</html>
