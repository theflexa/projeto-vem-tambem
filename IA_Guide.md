# VemTambem - Guia para IA / Desenvolvedores

## Visao Geral

Aplicacao web Java que gerencia uma **rede de doacoes em arvore binaria**. Cada usuario pode indicar outros, formando uma hierarquia. Quando um usuario recebe 8 doacoes, seu ciclo e concluido e ele pode reativar para iniciar um novo ciclo.

**Stack:** Java 21, Spring MVC 5.3.39, Hibernate 5.6.15, MySQL 8, JSP/JSTL, Bootstrap 4 (SB Admin 2), Maven, Tomcat 9.

**Context path em producao:** `/vemtambem`

---

## Estrutura de Pastas

```
src/
  main/
    java/br/com/vemtambem/
      controller/          # Controllers Spring MVC
        LoginController.java
        HomeController.java
        AdminController.java
        UsuarioController.java
        AutorizadorInterceptor.java
      dao/                 # Data Access Objects
        UsuarioDAO.java / UsuarioDAOImpl.java
        CicloDAO.java / CicloDAOImpl.java
        TipoCicloDAO.java / TipoCicloDAOImpl.java
        UsuarioTokenDAO.java / UsuarioTokenDAOImpl.java
      model/               # Entidades JPA + Enums
        Usuario.java       # Entidade principal (usuario + no da arvore)
        Ciclo.java         # Ciclo de doacoes
        TipoCiclo.java     # Tipos de ciclo (tabuleiros) com valores de doacao
        Conexao.java       # Credenciais JDBC hardcoded (ver "Problemas Conhecidos")
        Endereco.java
        UsuarioToken.java  # Token de redefinicao de senha
        TipoChavePix.java  # Enum: CPF, CNPJ, EMAIL, TELEFONE, ALEATORIA
        TipoConta.java     # Enum: PF, PJ (nao utilizado na entidade)
      service/             # Logica de negocio
        LoginService.java / LoginServiceImpl.java
        UsuarioService.java / UsuarioServiceImpl.java
        CicloService.java / CicloServiceImpl.java
        TipoCicloService.java / TipoCicloServiceImpl.java
        UsuarioTokenService.java / UsuarioTokenServiceImpl.java
      utils/               # Utilitarios
        SenhaUtils.java           # Hash MD5 de senhas
        EmailSender.java          # Envio de email SMTP (redefinicao de senha)
        DocumentValidator.java    # Validacao de CPF/CNPJ
        DataUtils.java            # Formatacao de datas
        NomeHelper.java           # Abreviacao de nomes
        LocalDateTimeConverter.java  # JPA Converter LocalDateTime <-> Timestamp
    webapp/
      WEB-INF/
        web.xml                   # Config do servlet (encoding, session timeout 5min, error pages)
        spring-servlet.xml        # Config do Spring (DataSource, Hibernate, interceptor, views)
        includes/                 # JSP fragments reutilizaveis
          sidebar.jsp             # Sidebar compartilhada com active state dinamico
        pages/                    # JSPs (ver secao "Paginas")
      resources/
        css/
          sb-admin-2.min.css      # SB Admin 2 base
          vt-theme.css            # Tema customizado VemTambem (source of truth para estilos)
        js/
          sb-admin-2.min.js       # SB Admin 2 JS
          vt-toast.js             # Componente global de toast notifications
        img/                      # Logos
        vendor/                   # jQuery, Bootstrap 4, FontAwesome 5, Chart.js, DataTables, Inputmask
        arquivos/                 # Uploads de comprovantes de ativacao
          doacao/                 # Uploads de comprovantes de doacao
        termo/                    # termo.pdf (termos de uso)
    resources/
      application.properties      # Config do banco (Spring DataSource)
      application-docker.properties  # Config do banco para Docker
```

---

## Arquitetura Frontend

### Design System (vt-theme.css)

Todas as paginas autenticadas compartilham um unico arquivo de tema: `vt-theme.css`. Este e o **single source of truth** para estilos visuais. Nenhuma JSP deve ter blocos `<style>` inline duplicando estilos do tema (exceto CSS especifico de pagina como a arvore em `minha-rede.jsp`).

**CSS Variables definidas:**
```css
--olive: #6f7a00;          /* Cor primaria da marca */
--olive-700: #5a6300;      /* Variante escura */
--gold: #d4a017;           /* Cor de destaque/acento */
--ink: #1f2937;            /* Texto principal */
--muted: #6b7280;          /* Texto secundario */
--surface: #f8f9fa;        /* Fundo de superficie */
```

**Componentes CSS disponíveis:**
- `.btn-olive` / `.btn-olive-outline` — Botoes da marca (substituem `btn-primary`/`btn-success`)
- `.content-surface` — Header de pagina com fundo branco e sombra
- `.progress-bar-brand` — Barra de progresso com gradiente olive→gold
- `.badge-cycle` — Badge para nome do tabuleiro/ciclo
- `.table-brand-stripe` — Tabela com zebra striping olive
- `.icon-gold` / `.icon-olive` — Cores de icone utilitarias
- `.text-success-brand` / `.text-warn-brand` — Texto com cores de status
- `.empty-state` — Estado vazio centralizado com icone grande
- `.vt-toast` — Toast notification (success/error/info/warning)
- `.card-header .nav-tabs` — Abas coladas no header do card

### Sidebar Compartilhada (sidebar.jsp)

A sidebar e um JSP fragment em `WEB-INF/includes/sidebar.jsp`, incluido via `<jsp:include>` em todas as paginas autenticadas. Possui:
- Active state dinamico via `fn:contains(uri, '/path')` pattern
- Secao "Operacao" (links autenticados): Minha Rede, Meus Dados, Minha Contribuicao, Doadores
- Secao "Atendimento": FAQ, Suporte (WhatsApp)
- Secao "Admin" (condicional): Ativar Cadastrados
- Condicional `<c:choose>` para usuario ativo vs inativo

### Toast Notifications (vt-toast.js)

Componente JS reutilizavel que substitui `alert()` nativo:
```javascript
vtToast('Mensagem', 'success');  // variantes: success, error, info, warning
```
Posicionado no topo-direita, auto-dismiss em 4s, com stacking vertical.

---

## Entidades Principais

### Usuario (`usuario`)

Funciona como **entidade de usuario E no da arvore binaria**.

| Campo | Coluna | Tipo | Descricao |
|-------|--------|------|-----------|
| id | id | Long | PK auto-gerada |
| nome | nome | String | Nome completo |
| email | email | String | Email |
| login | login | String | Username para autenticacao |
| senha | senha | String | Hash MD5 da senha |
| tipoConta | tipo_conta | boolean | true=PF(CPF), false=PJ(CNPJ) |
| documento | documento | String | CPF ou CNPJ |
| celular | celular | String | Telefone |
| whatsapp | whatsapp | String | WhatsApp |
| tipoChavePix | tipo_chave_pix | TipoChavePix | Enum: CPF, CNPJ, EMAIL, TELEFONE, ALEATORIA |
| chavePix | chave_pix | String | Valor da chave PIX |
| ativo | ativo | boolean | Se foi ativado pelo admin |
| doacaoFeita | doacao_feita | boolean | Se fez a doacao de ativacao |
| admin | admin | boolean | Flag de administrador |
| comprovanteAtivacao | comprovante_ativacao | String | Nome do arquivo de comprovante |
| comprovanteDeposito | comprovante_deposito | String | Nome do arquivo de comprovante de doacao |
| indicador | indicador_id | Usuario (FK) | Quem indicou este usuario |
| indicadoEsquerda | indicado_esquerda_id | Usuario (FK) | Filho esquerdo na arvore |
| indicadoDireita | indicado_direita_id | Usuario (FK) | Filho direito na arvore |
| quantCiclos | quant_ciclos | int | Quantidade de ciclos completados |
| quantDoacoesRecebidas | quant_doacoes_recebidas | int | Doacoes recebidas no ciclo atual |
| cicloAtivo | ciclo_ativo_id | Ciclo (FK) | Ciclo ativo atual |
| endereco | endereco_id | Endereco (FK) | OneToOne com cascade |
| dataCadastro | data_cadastro | LocalDateTime | Data de registro |
| termoAceito | termo_aceito | boolean | Se aceitou os termos |

**Campos transientes:** `codigoTipoChavePix` (int do form), `whatsappFormat` (computed: "55" + whatsapp), `nomeCurto` (abreviacao do nome via NomeHelper).

**Constante:** `ID_USUARIO_ADMIN = new Usuario(2L)` - indicador padrao quando nenhum e fornecido.

### Ciclo (`ciclo`)

Cada ciclo e um snapshot da posicao do usuario na arvore.

| Campo | Coluna | Tipo | Descricao |
|-------|--------|------|-----------|
| id | id | Long | PK |
| nome | nome | String | Ex: "CICLO 1", "CICLO 2" |
| ativo | ativo | boolean | Se e o ciclo vigente |
| login | login | String | Login do dono (desnormalizado) |
| usuario | usuario_id | Usuario (FK) | Dono do ciclo |
| indicador | indicador_id | Usuario (FK) | Quem indicou |
| indicadoPrincipal | indicado_principal_id | Usuario (FK) | No pai na arvore (para quem doar) |
| indicadoEsquerda | indicado_esquerda_id | Usuario (FK) | Filho esquerdo no ciclo |
| indicadoDireita | indicado_direita_id | Usuario (FK) | Filho direito no ciclo |

### TipoCiclo (`tipo_ciclo`)

Define os tipos de tabuleiro com seus valores monetarios. Introduzido para permitir multiplos niveis de doacao sem hardcode.

| Campo | Coluna | Tipo | Descricao |
|-------|--------|------|-----------|
| id | id | Long | PK auto-gerada |
| nome | nome | String | Ex: "Tabuleiro 1", "Tabuleiro 2" |
| valorTI | valor_ti | BigDecimal | Valor da taxa de ativacao (T.I.) |
| valorDoacao | valor_doacao | BigDecimal | Valor da doacao ao donatario |
| quantDoadores | quant_doadores | int | Quantidade de doadores por ciclo |
| ordem | ordem | int | Ordem de exibicao/progressao |
| ativo | ativo | boolean | Se este tipo de ciclo esta ativo |

**Valores tipicos no banco:**
| nome | valorTI | valorDoacao | quantDoadores | ordem |
|------|---------|-------------|---------------|-------|
| Tabuleiro 1 | 10.00 | 90.00 | 8 | 1 |
| Tabuleiro 2 | 50.00 | 450.00 | 8 | 2 |
| Tabuleiro 3 | 100.00 | 900.00 | 8 | 3 |

**DAO:** `TipoCicloDAO` / `TipoCicloDAOImpl` — metodos: `pesquisarPorId()`, `listarAtivos()`, `pesquisarPorOrdem()`, `salvar()`

**Service:** `TipoCicloService` / `TipoCicloServiceImpl` — mesmos metodos expostos via interface

**Uso nas JSPs:** O controller injeta `tipoCicloAtual` no model. As JSPs usam `${tipoCicloAtual.valorDoacao}`, `${tipoCicloAtual.valorTI}`, `${tipoCicloAtual.nome}` com fallback `<c:otherwise>` para valores hardcoded caso `tipoCicloAtual` seja null.

### UsuarioToken (`usuario_token`)

Tokens de redefinicao de senha (codigo numerico de 6 digitos, validade 15 minutos).

### Endereco (`endereco`)

Campos: logradouro, complemento, bairro, municipio, estado, cep.

---

## Fluxo de Negocios (Ciclos e Doacoes)

### 1. Cadastro
- Usuario acessa `/usuario/convite?id={login}` (pagina publica de convite)
- Clica em registrar -> `/usuario/cadastrar?login={login}` (formulario publico)
- Submete -> `POST /usuario/salvar-externo`
- Validacoes: unicidade de CPF/CNPJ, login, email; formato do documento
- Senha e convertida para MD5; `dataCadastro` = agora
- Se nenhum indicador, usa admin (id=2) como padrao

### 2. Ativacao
- Usuario faz upload do comprovante de ativacao -> `POST /usuario/upload`
- Arquivo salvo como `{login}_{id}.{ext}` em `resources/arquivos/`
- Admin ve o usuario na lista de pendentes -> `GET /admin/listar-pendentes`
- Admin ativa -> `GET /admin/ativar?id={id}`
- `UsuarioServiceImpl.ativar()` executa:
  - Seta `ativo=true`, incrementa `quantCiclos`
  - Insere o usuario na arvore binaria via BFS (`inserirIndicado`)
  - Cria um novo `Ciclo` ("CICLO N") com `ativo=true`
  - Seta `cicloAtivo` no usuario

### 3. Doacao
- Usuario logado ve para quem deve doar em `/usuario/donatarios`
- O donatario e o `ciclo.indicadoPrincipal` (no pai na arvore)
- Usuario faz upload do comprovante de doacao -> `POST /usuario/upload-comprovante-doacao`
- Arquivo salvo como `{login}_{id}_doacao.{ext}` em `resources/arquivos/doacao/`

### 4. Confirmacao de Recebimento
- Donatario ve seus doadores em `/usuario/doadores`
- Confirma recebimento -> `GET /usuario/ativar-doador?id={doador}`
- Seta `doacaoFeita=true` no doador
- Incrementa `quantDoacoesRecebidas` no donatario

### 5. Ciclo Completo
- Quando `quantDoacoesRecebidas >= 8`, o ciclo e considerado finalizado
- Flag `isCicloFinalizado=true` e exibida na tela de doadores
- Usuario pode reativar -> `POST /usuario/reativar`
- `UsuarioServiceImpl.reativar()` cria um novo registro de Usuario (copia dados), desativa o ciclo antigo, e limpa o registro anterior (login=null, senha=null)

### Arvore Binaria
- Cada usuario tem `indicadoEsquerda` e `indicadoDireita`
- Insercao via BFS: percorre a arvore nivel a nivel, encontra o primeiro slot vazio (esquerda tem prioridade)
- Os **doadores** de um usuario sao seus **bisnetos** na arvore (nivel 3): 8 combinacoes de esq/dir em 3 niveis
- A **rede** de um usuario mostra filhos + netos + bisnetos (14 nos, todos os 3 niveis abaixo)

---

## Endpoints (Todos os Controllers)

### LoginController

| Rota | Metodo | Autenticado | Descricao |
|------|--------|-------------|-----------|
| POST /login | POST | Nao | Autentica usuario |
| /sair | GET | Sim | Invalida sessao, volta ao login |

### HomeController

| Rota | Metodo | Autenticado | Descricao |
|------|--------|-------------|-----------|
| / | GET | Nao | Pagina de login |
| /painel | GET | Sim | Dashboard principal |
| /faq | GET | Sim | Perguntas frequentes |
| /esqueci-senha | GET | Nao | Pagina de esqueci senha |
| /enviar-codigo-senha | GET | Nao | Envia codigo de redefinicao por email |
| /termo/download | GET | Nao | Download do PDF de termos |

### AdminController (base: /admin)

| Rota | Metodo | Autenticado | Admin | Descricao |
|------|--------|-------------|-------|-----------|
| /admin/listar-pendentes | GET | Sim | Sim | Lista usuarios pendentes de ativacao |
| /admin/ativar?id={id} | GET | Sim | Sim | Ativa um usuario |

### UsuarioController (base: /usuario)

| Rota | Metodo | Autenticado | Descricao |
|------|--------|-------------|-----------|
| /usuario/dados-pessoais | GET | Sim | Meus dados pessoais |
| /usuario/donatarios | GET | Sim | Para quem devo doar |
| /usuario/doadores | GET | Sim | Quem deve doar para mim |
| /usuario/minha-rede | GET | Sim | Minha arvore de rede |
| /usuario/convite?id={login} | GET | Nao | Pagina de convite/indicacao |
| /usuario/cadastrar?login={login} | GET | Nao | Formulario de cadastro |
| POST /usuario/salvar | POST | Sim | Atualiza dados pessoais |
| POST /usuario/salvar-externo | POST | Nao | Registra novo usuario |
| POST /usuario/upload | POST | Sim | Upload comprovante de ativacao |
| POST /usuario/upload-comprovante-doacao | POST | Sim | Upload comprovante de doacao |
| /usuario/comprovante/download/{id} | GET | Sim | Download comprovante ativacao |
| /usuario/comprovante/download-comprovante-doacao/{id} | GET | Sim | Download comprovante doacao |
| POST /usuario/reativar | POST | Sim | Reativa usuario (novo ciclo) |
| /usuario/ativar-doador?id={id} | GET | Sim | Confirma doacao recebida |

---

## Autenticacao e Sessao

### AutorizadorInterceptor
Roda antes de toda requisicao. Rotas publicas (sem login):
- Termina com: `login`, `/`, `cadastrar`, `convite`, `salvar-externo`
- Contem: `resources`, `esqueci-senha`, `enviar-codigo-senha`, `/vemtambem/termo/download`

Se nao autenticado, redireciona para `/vemtambem` (hardcoded).

### Sessao
- `usuarioLogado` (objeto Usuario) e `idUsuarioLogado` (Long) sao setados no login
- Timeout: 5 minutos (web.xml)
- Modal de aviso de sessao expirando aparece com 1 minuto restante (painel.jsp)
- Verificacao de admin: feita inline nos controllers (nao ha interceptor de role)

---

## Paginas JSP

| Arquivo | View Name | Descricao |
|---------|-----------|-----------|
| index.jsp | index | Login (acesso ao escritorio) |
| painel.jsp | painel | Dashboard com gamificacao (ciclo, nivel, proximo passo) |
| cadastro-form.jsp | cadastro-form | Formulario de registro (publico) |
| doadores.jsp | doadores | Tabela de 8 doadores com acoes (comprovante/ativar) |
| donatarios.jsp | donatarios | Donatario por ciclo com upload de comprovante |
| minha-rede.jsp | minha-rede | Arvore binaria visual (3 niveis) com tooltips |
| pessoa-dados-pessoais.jsp | pessoa-dados-pessoais | Dados pessoais (edicao WhatsApp, celular, PIX) |
| pessoa-lista-pendentes.jsp | pessoa-lista-pendentes | Admin: ativar cadastros pendentes |
| faq.jsp | faq | Perguntas frequentes (accordion) |
| recrutador.jsp | recrutador | Pagina de convite/indicacao (publica, standalone) |
| onboarding.jsp | onboarding | Formulario de cadastro estilizado (publico, standalone) |
| esqueci-senha.jsp | esqueci-senha | Redefinicao de senha |
| suporte-form.jsp | suporte-form | Formulario de suporte |
| error/403.jsp | error/403 | Erro de acesso negado |
| error/404.jsp | error/404 | Pagina nao encontrada |
| error/erro.jsp | error/erro | Erro generico |

**Sidebar:** Todas as paginas autenticadas usam `<jsp:include page="/WEB-INF/includes/sidebar.jsp" />`.

**Paginas standalone (sem sidebar):** `recrutador.jsp`, `onboarding.jsp`, `index.jsp`, `esqueci-senha.jsp`.

Todas usam `${cp}` = `${pageContext.request.contextPath}` para montar URLs.

---

## Acesso a Dados (DAO) - Padrao Misto

**ATENCAO:** O projeto usa DOIS mecanismos de acesso ao banco:

### 1. Hibernate (via Spring DataSource)
Usa `SessionFactory` injetado pelo Spring. Respeita `application.properties`.
- `salvar()`, `pesquisarPorId()`, `pesquisarPorLogin()`, `pesquisarPorEmail()`, `pesquisarPorDocumento()`
- Ciclo: `salvar()`, `pesquisarPorId()`, `pesquisarCiclosUsuarios()`, `getCicloAtivoPorLogin()`
- TipoCiclo: `pesquisarPorId()`, `listarAtivos()`, `pesquisarPorOrdem()`, `salvar()`

### 2. JDBC puro (via Conexao.java)
Usa `DriverManager.getConnection(Conexao.URL, Conexao.USUARIO, Conexao.SENHA)`. Credenciais hardcoded.
- `pesquisarPorLoginSenha()` (LOGIN! - metodo critico)
- `pesquisarDesativadas()`
- `pesquisarUsuarioParaDoadores()`, `pesquisarUsuarioParaDonatarios()`
- `pesquisarUsuarioParaConvite()`, `pesquisarUsuarioParaDownloadArquivo()`
- Ciclo: `pesquisarCiclosUsuariosDonatarios()`

**Consequencia:** Ao trocar de ambiente (local vs producao), e necessario alterar AMBOS:
1. `application.properties` (ou `application-docker.properties`)
2. `Conexao.java` (constantes hardcoded)

---

## Configuracao por Ambiente

### Producao (servidor)
- `Conexao.java`: URL = `jdbc:mysql://localhost:3306/sergi6131_banco_dados_prod`
- `application.properties`: URL = `jdbc:mysql://localhost:3306/sergi6131_banco_dados_dev` (ou prod)
- Deploy: `vemtambem.war` em `/home/sergi6131/appservers/apache-tomcat-9.0.4/webapps/`

### Docker (local)
- `Conexao.java`: URL = `jdbc:mysql://sergi6131.c44.integrator.host:3306/sergi6131_banco_dados_prod`
- `application-docker.properties`: URL = mesma URL remota
- O Dockerfile sobrescreve `application.properties` com `application-docker.properties` no build
- Docker Compose: apenas o servico `app` (sem MySQL local — sempre usa banco remoto)
- Acesso: `http://localhost:8080/vemtambem/`
- Comandos:
  ```
  docker compose up --build    # subir (com rebuild)
  docker compose up -d         # subir em background
  docker compose down          # parar
  ```

### Alternando entre ambientes
Em `Conexao.java`, alternar os comentarios:
```java
// === PRODUCAO (descomentar para deploy no servidor) ===
// public static final String URL = "jdbc:mysql://localhost:3306/sergi6131_banco_dados_dev";

// === LOCAL/DOCKER (descomentar para desenvolvimento) ===
public static final String URL = "jdbc:mysql://sergi6131.c44.integrator.host:3306/sergi6131_banco_dados_prod";
```

---

## Utilitarios

| Classe | Funcao |
|--------|--------|
| SenhaUtils | `convertStringToMd5(valor)` - hash MD5 para senhas |
| EmailSender | Envio de email SMTP (SSL porta 465) para redefinicao de senha. Gera codigo numerico de 6 digitos com `SecureRandom` |
| DocumentValidator | Validacao de CPF e CNPJ brasileiros (check digits) |
| DataUtils | Formatacao/parse de datas (dd/MM/yyyy) |
| NomeHelper | `curto(nome)` - abreviacao de nomes (ex: "Joao da Silva" -> "JOSI") |
| LocalDateTimeConverter | JPA Converter: LocalDateTime <-> java.sql.Timestamp |

---

## Problemas Conhecidos

1. **Conexao.java com credenciais hardcoded** - Credenciais do banco estao em codigo-fonte versionado. Ideal: usar apenas o DataSource do Spring e eliminar a classe Conexao.
2. **Senhas com MD5 sem salt** - MD5 nao e seguro para senhas. Ideal: migrar para BCrypt.
3. **Credenciais SMTP hardcoded em EmailSender** - Senha do email esta no codigo. Ideal: usar variaveis de ambiente.
4. **Metodos quebrados** - `pesquisarCiclos()` e `pesquisarUsuarios()` usam `"from Pessoa"` mas a entidade se chama `Usuario`.
5. **Redirect hardcoded no interceptor** - `response.sendRedirect("/vemtambem")` nao funciona quando deployado como ROOT.
6. **Session timeout curto** - 5 minutos pode ser inconveniente para usuarios (modal de aviso implementado no painel).
7. **Sem controle de acesso por role** - Verificacao de admin e inline nos controllers, nao ha interceptor especifico.
8. **Upload de arquivos em resources/** - Arquivos ficam dentro do WAR, podem ser perdidos no redeploy.
9. **Inconsistencia recuperarDoadores()** - O metodo `UsuarioServiceImpl.recuperarDoadores()` retorna 4 netos (nivel 2), mas a JSP `doadores.jsp` mostra 8 bisnetos (nivel 3). O metodo no service NAO e usado pela tela de doadores — pode ser codigo legado.

---

## Para Fazer Alteracoes

### Frontend (CSS, JS, imagens)
- Editar em `src/main/webapp/resources/`
- **CSS:** Editar `vt-theme.css` para mudancas de tema global. NUNCA duplicar estilos inline nas JSPs.
- **Toast:** Usar `vtToast('mensagem', 'variante')` em vez de `alert()`.
- No Docker: rebuild com `docker compose up --build`
- No servidor: editar diretamente em `webapps/vemtambem/resources/` (efeito imediato)

### Layout das paginas (JSP)
- Editar em `src/main/webapp/WEB-INF/pages/`
- **Sidebar:** Editar `WEB-INF/includes/sidebar.jsp` (unico arquivo, reflete em todas as paginas)
- No Docker: rebuild necessario
- No servidor: editar diretamente em `webapps/vemtambem/WEB-INF/pages/` (Tomcat recompila automaticamente)

### Logica Java (controllers, services, DAOs, models)
- Editar em `src/main/java/br/com/vemtambem/`
- Sempre requer rebuild: `docker compose up --build` (local) ou `mvn clean package` + deploy do WAR (producao)

### Configuracoes
- Spring/Hibernate: `src/main/webapp/WEB-INF/spring-servlet.xml`
- Banco de dados: `src/main/resources/application.properties`
- Servlet: `src/main/webapp/WEB-INF/web.xml`
- Requer restart do Tomcat

### Deploy em producao

O servidor de producao e uma hospedagem cPanel com Tomcat instalado manualmente.
O caminho do Tomcat no servidor e:
```
/home/sergi6131/appservers/apache-tomcat-<VERSAO>/
```
No momento da escrita deste guia, a versao era `9.0.4`, mas pode mudar com atualizacoes.
O caminho de deploy e a pasta `webapps/` dentro desse diretorio.

#### Passo 1 - Preparar o codigo para producao (LOCAL - no seu computador)

Estes passos sao feitos no codigo-fonte antes de compilar:

1. **Reverter `Conexao.java`** para apontar para localhost:
   ```java
   // Descomentar esta linha:
   public static final String URL = "jdbc:mysql://localhost:3306/sergi6131_banco_dados_dev";
   // Comentar esta linha:
   // public static final String URL = "jdbc:mysql://sergi6131.c44.integrator.host:3306/sergi6131_banco_dados_prod";
   ```
   **Por que:** No servidor, o MySQL roda na mesma maquina que o Tomcat, entao `localhost` e correto.

2. **Verificar `application.properties`** - deve apontar para o banco de producao:
   ```properties
   database.url=jdbc:mysql://localhost:3306/sergi6131_banco_dados_prod?...
   ```

3. **Verificar `hibernate.hbm2ddl.auto`** - deve ser `validate` (nunca `update` ou `create` em producao).

#### Passo 2 - Compilar o WAR (LOCAL - no seu computador)

Requer Maven e JDK 21 instalados localmente. Se voce usa Docker, pode compilar assim:

**Opcao A: Maven instalado localmente**
```bash
mvn clean package -DskipTests
```

**Opcao B: Sem Maven local (usando Docker para compilar)**
```bash
docker run --rm -v "%cd%":/app -w /app maven:3.9-eclipse-temurin-21 mvn clean package -DskipTests
```

Ambos geram: `target/vemtambem.war`

#### Passo 3 - Upload do WAR para o servidor (MANUAL - via navegador)

1. Acesse o **cPanel** do servidor: `https://server44.integrator.com.br`
2. Abra o **Gerenciador de Arquivos** (File Manager)
3. Navegue ate: `/home/sergi6131/appservers/apache-tomcat-<VERSAO>/webapps/`
4. **ANTES de subir o novo WAR:**
   - Faca backup da pasta `vemtambem/` existente (comprima via cPanel se quiser)
   - **Importante:** A pasta `vemtambem/resources/arquivos/` contem uploads de usuarios que NAO estao no Git. Se voce subir um WAR novo, o Tomcat vai extrair e substituir a pasta, perdendo esses arquivos. Copie `arquivos/` para um local seguro antes.
5. Delete o arquivo `vemtambem.war` antigo (se existir)
6. Delete a pasta `vemtambem/` antiga
7. Clique em **Carregar** (Upload) e suba o novo `vemtambem.war`
8. O Tomcat detecta o novo WAR e extrai automaticamente para `vemtambem/`

#### Passo 4 - Restaurar arquivos de upload (MANUAL - via cPanel)

Apos o deploy:
1. Copie de volta a pasta `arquivos/` (com subpasta `doacao/`) para:
   ```
   webapps/vemtambem/resources/arquivos/
   ```
2. Verifique que os comprovantes existentes estao acessiveis

#### Passo 5 - Verificar (MANUAL - via navegador)

1. Acesse `https://vemtambem.com.br/`
2. Tente logar com um usuario de teste
3. Navegue pelas paginas principais (painel, doadores, donatarios, minha-rede)
4. Verifique que os uploads antigos (comprovantes) carregam corretamente

#### Se algo der errado

- Restaure o backup da pasta `vemtambem/` que voce fez no Passo 3
- Ou faca upload do WAR anterior
- O Tomcat faz redeploy automatico ao detectar mudancas na pasta `webapps/`

#### Restart do Tomcat (se necessario)

Via SSH (se tiver acesso):
```bash
/home/sergi6131/appservers/apache-tomcat-<VERSAO>/bin/shutdown.sh
/home/sergi6131/appservers/apache-tomcat-<VERSAO>/bin/startup.sh
```

Via cPanel: procure por "Restart Services" ou entre em contato com o suporte da hospedagem.

#### Resumo do deploy

| Etapa | Onde | Tipo | O que fazer |
|-------|------|------|-------------|
| 1. Preparar codigo | Local | Automatizavel | Reverter Conexao.java, verificar properties |
| 2. Compilar WAR | Local | Comando | `mvn clean package -DskipTests` |
| 3. Upload WAR | cPanel | **MANUAL** | Gerenciador de Arquivos -> Upload |
| 4. Restaurar uploads | cPanel | **MANUAL** | Copiar pasta arquivos/ de volta |
| 5. Verificar | Navegador | **MANUAL** | Testar login e navegacao |
