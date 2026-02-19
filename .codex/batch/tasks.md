1. [x] [analysis] Validar o estado atual dos 7 itens solicitados (login lottie, loading global, tipografia, acentuacao, tutorial, donatarios e dados-pessoais) e confirmar o que ja esta implementado no branch | deps: -
2. [~] [implement] Ajustar o Lottie de amigos no login (`src/main/webapp/WEB-INF/pages/index.jsp`) acima de "Bem-vindo de volta", com embed estavel e fallback acessivel | deps: 1
3. [ ] [implement] Implementar loading screen global com fundo desfocado + Lottie walking-pothos no centro (carregamento inicial), via CSS/JS compartilhado (`vt-theme.css`, `vt-core.js`, includes) | deps: 1
4. [ ] [implement] Padronizar fonte amigavel no app (Nunito/Poppins) e remover inconsistencias de tipografia entre paginas com estilo inline | deps: 1
5. [ ] [implement] Atualizar linguagem comercial dos cards em `src/main/webapp/WEB-INF/pages/donatarios.jsp` e remover/ocultar duplicidade de bloco de jornadas nessa tela | deps: 1
6. [ ] [implement] Reestilizar `src/main/webapp/WEB-INF/pages/pessoa-dados-pessoais.jsp` (hierarquia visual, agrupamento de campos, espacamentos e CTA) sem alterar regras de negocio | deps: 1,4
7. [ ] [implement] Corrigir acentuacao PT-BR (mojibake/strings sem acento) em JS/JSP relevantes (`vt-tour.js`, `donatarios.jsp`, `pessoa-dados-pessoais.jsp`, `jornadas.jsp`, `topbar.jsp`) garantindo UTF-8 | deps: 1
8. [ ] [implement] Corrigir tutorial (`src/main/webapp/resources/js/vt-tour.js`): textos PT-BR corretos, passo para `/usuario/jornadas`, revisao de seletores e mensagens de hint/toast | deps: 1,7
9. [ ] [implement] Validar comportamento final (responsivo + tutorial + login + loading + jornadas/donatarios), executar `docker compose build` e registrar checklist de validacao | deps: 2,3,4,5,6,7,8
