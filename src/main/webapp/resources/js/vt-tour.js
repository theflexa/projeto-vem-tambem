(function () {
  "use strict";

  function currentPath() {
    return (window.location.pathname || "").toLowerCase();
  }

  function resolvePageKey(path) {
    if (path.indexOf("/usuario/minha-rede") >= 0) return "minha-rede";
    if (path.indexOf("/usuario/dados-pessoais") >= 0) return "dados-pessoais";
    if (path.indexOf("/usuario/donatarios") >= 0) return "donatarios";
    if (path.indexOf("/usuario/doadores") >= 0) return "doadores";
    if (path.indexOf("/usuario/jornadas") >= 0) return "jornadas";
    if (path.indexOf("/painel") >= 0) return "painel";
    if (path.indexOf("/faq") >= 0) return "faq";
    if (path.indexOf("/onboarding") >= 0) return "onboarding";
    if (path.indexOf("/login") >= 0 || path === "/vemtambem/" || path === "/") return "login";
    return "default";
  }

  function getUserId() {
    if (!window.VTCore) return "anon";
    return window.VTCore.getUserId();
  }

  function lsKeyCompleted(pageKey) {
    return "vt.tour.completed." + pageKey + "." + getUserId();
  }

  function lsKeyHintSeen() {
    return "vt.tour.button_hint_seen." + getUserId();
  }

  var activeTourInstance = null;

  function getTourConfig(pageKey) {
    var commonLast = {
      element: '[data-tour-id="tutorial-button"]',
      title: "Tutorial",
      intro: "Clique aqui sempre que quiser rever o guia desta tela."
    };

    var map = {
      painel: [
        {
          element: '[data-tour-id="topbar"]',
          title: "Barra superior",
          intro: "Aqui você acessa o tutorial, seu status de conta e os atalhos da sessão."
        },
        {
          element: '[data-tour-id="sidebar-main"]',
          title: "Menu principal",
          intro: "Use este menu para navegar em Minha Rede, Jornadas, Minha Contribuição, Doadores, FAQ e suporte."
        },
        {
          element: '[data-tour-id="painel-intro"]',
          title: "Visão geral",
          intro: "Seu objetivo na Jornada da Semente é receber 8 doações para fechar o ciclo."
        },
        {
          element: '[data-tour-id="painel-pendente"]',
          title: "Conta pendente",
          intro: "Com assinatura pendente, você segue com acesso ao portal e envia o comprovante em Minha Contribuição."
        },
        {
          element: '[data-tour-id="painel-progress"]',
          title: "Meta do ciclo",
          intro: "Esse card mostra seu progresso de 0 a 8 doações recebidas no ciclo atual."
        },
        {
          element: '[data-tour-id="painel-next-step"]',
          title: "Próximo passo",
          intro: "Aqui você vê a ação recomendada para avançar no momento: doar, convidar ou reativar."
        },
        {
          element: '[data-tour-id="painel-invite-link"]',
          title: "Convite",
          intro: "Compartilhe seu link exclusivo para preencher a rede com qualidade e acelerar o ciclo."
        },
        commonLast
      ],
      "minha-rede": [
        {
          element: '[data-tour-id="rede-ciclos"]',
          title: "Ciclos",
          intro: "Alterne os ciclos para entender o histórico da sua árvore."
        },
        {
          element: '[data-tour-id="rede-jornada"]',
          title: "Jornada do ciclo",
          intro: "A trilha mostra sua evolução no ciclo: cada etapa concluída aproxima você das 8 doações."
        },
        {
          element: '[data-tour-id="rede-arvore"]',
          title: "Árvore da rede",
          intro: "A visualização segue o guia da jornada: você no nível 0, depois filhos, netos e os 8 doadores do nível final."
        },
        commonLast
      ],
      "dados-pessoais": [
        {
          element: '[data-tour-id="dados-form"]',
          title: "Dados da conta",
          intro: "Mantenha telefone, endereço e chave PIX atualizados para evitar bloqueios."
        },
        {
          element: '[data-tour-id="dados-convite"]',
          title: "Link exclusivo",
          intro: "Copie seu link e envie para pessoas que você quer trazer para a rede."
        },
        commonLast
      ],
      donatarios: [
        {
          element: '[data-tour-id="donatarios-ativacao"]',
          title: "Ativação pendente",
          intro: "Enquanto a assinatura estiver pendente, esta área centraliza orientações e status de aprovação."
        },
        {
          element: '[data-tour-id="donatarios-upload-ativacao"]',
          title: "Envio de comprovante",
          intro: "Envie o comprovante da contribuição para validação. Depois da aprovação, você avança nos ciclos."
        },
        {
          element: '[data-tour-id="donatarios-tabs"]',
          title: "Abas por ciclo",
          intro: "Cada aba representa um ciclo. Revise o ciclo correto antes de efetuar qualquer pagamento."
        },
        {
          element: '[data-tour-id="donatarios-card"]',
          title: "Dados da contribuição",
          intro: "Confira donatário, valor total da contribuição e status da sua etapa."
        },
        {
          element: '[data-tour-id="donatarios-upload"]',
          title: "Comprovante",
          intro: "Depois do pagamento, envie o comprovante para validação. Com a aprovação, sua etapa é concluída."
        },
        commonLast
      ],
      doadores: [
        {
          element: '[data-tour-id="doadores-progress"]',
          title: "Progresso",
          intro: "Sua meta é completar 8 doações recebidas para encerrar o ciclo atual."
        },
        {
          element: '[data-tour-id="doadores-tabs"]',
          title: "Ciclos",
          intro: "Troque de ciclo para acompanhar quem já doou em cada etapa."
        },
        {
          element: '[data-tour-id="doadores-table"]',
          title: "Painel de doadores",
          intro: "Aqui estão os doadores do nível final. Baixe comprovantes e ative quando necessário."
        },
        {
          element: "#btnReativar",
          title: "Reativação",
          intro: "Quando completar 8 doações recebidas, use Continuar para iniciar o próximo ciclo."
        },
        commonLast
      ],
      jornadas: [
        {
          element: '[data-tour-id="jornadas-intro"]',
          title: "Mapa de jornadas",
          intro: "Aqui você visualiza as três jornadas da plataforma e identifica sua etapa atual."
        },
        {
          element: '[data-tour-id="jornadas-cards"]',
          title: "Cards de evolução",
          intro: "Cada card mostra objetivo, status e próximo movimento para avançar de jornada."
        },
        commonLast
      ],
      faq: [
        {
          element: '[data-tour-id="faq-accordion"]',
          title: "Perguntas frequentes",
          intro: "Abra os tópicos para tirar dúvidas sobre cadastro, ciclos, pagamentos e suporte."
        },
        commonLast
      ],
      onboarding: [
        {
          element: '[data-tour-id="onboarding-steps"]',
          title: "Onboarding",
          intro: "Siga esta sequência para entrar, contribuir e acompanhar seu crescimento na rede."
        },
        commonLast
      ]
    };

    return map[pageKey] || [commonLast];
  }

  function buildSteps(pageKey) {
    var configured = getTourConfig(pageKey);
    var steps = [];
    configured.forEach(function (item) {
      if (!item.element) return;
      var target = document.querySelector(item.element);
      if (!target) return;
      steps.push({
        element: target,
        title: item.title,
        intro: item.intro
      });
    });
    return steps;
  }

  function markCompleted(pageKey) {
    try {
      localStorage.setItem(lsKeyCompleted(pageKey), "1");
    } catch (e) {
      // ignore
    }
  }

  function markHintSeen() {
    try {
      localStorage.setItem(lsKeyHintSeen(), "1");
    } catch (e) {
      // ignore
    }
  }

  function isHintSeen() {
    try {
      return localStorage.getItem(lsKeyHintSeen()) === "1";
    } catch (e) {
      return false;
    }
  }

  function removeHint() {
    document.body.classList.remove("vt-tour-hint-active");
    var overlay = document.querySelector(".vt-tour-hint-overlay");
    var bubble = document.querySelector(".vt-tour-hint-bubble");
    if (overlay) overlay.remove();
    if (bubble) bubble.remove();
  }

  function showHint() {
    var trigger = document.getElementById("vtTutorialAction");
    if (!trigger || isHintSeen() || getUserId() === "anon") {
      return;
    }

    var reducedMotion = window.VTCore && window.VTCore.prefersReducedMotion && window.VTCore.prefersReducedMotion();
    document.body.classList.add("vt-tour-hint-active");

    var overlay = document.createElement("div");
    overlay.className = "vt-tour-hint-overlay";

    var bubble = document.createElement("div");
    bubble.className = "vt-tour-hint-bubble";
    bubble.innerHTML = "<strong>Tutorial disponível</strong>Use este botão para abrir um passo a passo guiado desta tela.";

    document.body.appendChild(overlay);
    document.body.appendChild(bubble);

    var rect = trigger.getBoundingClientRect();
    bubble.style.top = Math.max(14, rect.bottom + 10) + "px";
    bubble.style.left = Math.max(10, rect.right - 250) + "px";

    var clear = function () {
      markHintSeen();
      removeHint();
      document.removeEventListener("click", onClickAway, true);
      document.removeEventListener("keydown", onEsc);
    };

    var onClickAway = function (ev) {
      if (trigger.contains(ev.target) || bubble.contains(ev.target)) return;
      clear();
    };

    var onEsc = function (ev) {
      if (ev.key === "Escape") clear();
    };

    overlay.addEventListener("click", clear);
    document.addEventListener("click", onClickAway, true);
    document.addEventListener("keydown", onEsc);

    if (!reducedMotion) {
      window.setTimeout(clear, 7000);
    }
  }

  function startTour() {
    if (typeof window.introJs !== "function") {
      if (typeof window.vtToast === "function") {
        window.vtToast("Tutorial indisponível no momento.", "warning");
      }
      return;
    }

    if (activeTourInstance && typeof activeTourInstance.exit === "function") {
      try {
        activeTourInstance.exit();
      } catch (e) {
        // ignore
      }
      activeTourInstance = null;
    }

    var pageKey = resolvePageKey(currentPath());
    var steps = buildSteps(pageKey);
    if (!steps.length) {
      if (typeof window.vtToast === "function") {
        window.vtToast("Nenhum passo de tutorial disponível nesta tela.", "info");
      }
      return;
    }

    removeHint();
    markHintSeen();

    var intro = window.introJs();
    activeTourInstance = intro;
    intro.setOptions({
      showBullets: true,
      showProgress: true,
      exitOnOverlayClick: true,
      disableInteraction: false,
      steps: steps,
      nextLabel: "Próximo",
      prevLabel: "Voltar",
      doneLabel: "Concluir",
      skipLabel: "Fechar"
    });

    intro.oncomplete(function () {
      markCompleted(pageKey);
      activeTourInstance = null;
    });

    intro.onexit(function () {
      markCompleted(pageKey);
      activeTourInstance = null;
    });

    intro.start();
  }

  function bindTrigger() {
    var all = document.querySelectorAll('[data-vt-action="start-tour"]');
    if (!all.length) return;
    all.forEach(function (btn) {
      btn.addEventListener("click", function () {
        startTour();
      });
    });
  }

  function init() {
    bindTrigger();
    showHint();
    window.VTTour = {
      start: startTour
    };
  }

  if (window.VTCore && window.VTCore.onReady) {
    window.VTCore.onReady(init);
  } else {
    document.addEventListener("DOMContentLoaded", init);
  }
})();
