# Batch State

## Task 1 (T1+T6+T2) — DONE

**Summary:** Valores alterados, sidebar renomeada e reordenada em 6 JSPs.

**Notes:**
- painel.jsp: R$40→R$10 (2 locais), R$260→R$90 (dica pós-upload), "Donatário"→"Minha Contribuição"
- donatarios.jsp: R$260→R$90, título→"Minha Contribuição", subtítulo atualizado
- Todas 6 JSPs: ícone fa-hands-helping→fa-hand-holding-heart, label→"Minha Contribuição", sidebar reordenada: Painel→Minha Rede→Meus Dados→Minha Contribuição→Doadores→Sair
- Novos arquivos JÁ CRIADOS para T4: TipoCiclo.java (entity), TipoCicloDAO.java, TipoCicloDAOImpl.java, TipoCicloService.java, TipoCicloServiceImpl.java
- Hibernate packagesToScan aponta para br.com.vemtambem.model (auto-detect)
- Projeto usa: Java, Spring MVC, Hibernate 5 (Criteria API), JSP, Bootstrap 4, SB Admin 2, Lombok, jQuery

---
## Task 2 (T4): Wiring TipoCiclo
**Status:** PASS
**Files Changed:** src/main/java/br/com/vemtambem/service/UsuarioServiceImpl.java, src/main/webapp/WEB-INF/pages/painel.jsp
**Summary:** Wired TipoCiclo into UsuarioServiceImpl.ativar() so new ciclos get the first active TipoCiclo (ordem=1). Replaced hardcoded R$ values in painel.jsp with dynamic tipoCicloAtual values.
**Notes for Next Task:**
- UsuarioServiceImpl now injects TipoCicloDAO and sets tipoCiclo on new Ciclo creation
- painel.jsp uses ${tipoCicloAtual.valorTI} and ${tipoCicloAtual.valorDoacao} with fallbacks
- donatarios.jsp was already updated with dynamic values by a prior edit

---
## Task 3 (T5): Gamification
**Status:** PASS
**Files Changed:** src/main/webapp/WEB-INF/pages/painel.jsp, src/main/webapp/WEB-INF/pages/doadores.jsp, src/main/webapp/WEB-INF/pages/minha-rede.jsp
**Summary:** Enhanced gamification across 3 JSPs with Duolingo-style motivational messages, level badges (Iniciante/Colaborador/Veterano/Mestre based on quantCiclos), and progress indicators.
**Notes for Next Task:**
- painel.jsp: "Meu Ciclo" card has 5-tier motivational messages; new "Nível" card with colored icon badge replaces old "Minha Rede" card
- doadores.jsp: progress bar messages now have 6 tiers (0, 1-3, 4, 5-6, 7, 8) with varied Duolingo-style copy
- minha-rede.jsp: added mini progress bar, cycles badge, and tiered motivational message in content-surface header

---
## Task 4 (T7): Frontend Improvements (completed)
**Status:** PASS
**Files Changed:** vt-theme.css, painel.jsp, suporte-form.jsp, minha-rede.jsp, recrutador.jsp, error/403.jsp, error/404.jsp, error/erro.jsp
**Summary:** Enhanced vt-theme.css with micro-interactions (hover, fadeInUp, transitions, focus a11y), added link to painel.jsp and suporte-form.jsp. Updated footer to 2025-2026 in all remaining JSPs. Added mobile tree responsiveness to minha-rede.jsp with scroll hint, touch scrolling, and smaller nodes.
**Notes for Next Task:**
- vt-theme.css now linked in 8 admin-layout JSPs; standalone pages (index, cadastro, esqueci-senha, recrutador, onboarding) keep their own inline styles
- minha-rede.jsp tree wrapped in .tree-wrapper with right-edge gradient hint on mobile
- All footers across all JSPs now show "2025-2026"

---
## Task 5 (T3): Onboarding
**Status:** PASS
**Files Changed:** onboarding.jsp (created), UsuarioController.java, AutorizadorInterceptor.java
**Summary:** Created 3-step onboarding page with Lottie animations, demo tabuleiro, and CTA. Redirect from salvarExterno() to onboarding. Route whitelisted.

---
## Task 6 (T8): Top 3 Suggestions
**Status:** PASS
**Files Changed:** painel.jsp, faq.jsp (created), HomeController.java, AutorizadorInterceptor.java, all JSP sidebars
**Summary:** (1) Copy invite link button with toast on painel.jsp, (2) FAQ page with 7-item Bootstrap accordion, (3) Session countdown timer with 1min warning modal. FAQ link added to all sidebars.
