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
