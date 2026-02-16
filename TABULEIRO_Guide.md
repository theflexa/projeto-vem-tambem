# Guia do Tabuleiro de Doacoes - VemTambem

## O que e o "tabuleiro"

O tabuleiro e o modelo de rede de doacoes do sistema. Ele define:
- Quantas pessoas participam de cada ciclo
- Quem doa para quem
- Quando um ciclo e considerado completo
- O que acontece apos completar um ciclo

O tabuleiro atual e baseado em uma **arvore binaria de 4 niveis**.

---

## Tabuleiro Atual: Arvore Binaria 4 Niveis (8 doadores)

### Estrutura Visual

```
                    VOCE (nivel 0)
                   /              \
             Filho-E            Filho-D          (nivel 1 — 2 pessoas)
            /       \          /       \
        Neto-EE   Neto-ED  Neto-DE   Neto-DD    (nivel 2 — 4 pessoas)
        /   \     /   \     /   \     /   \
       D1   D2   D3   D4  D5   D6   D7   D8     (nivel 3 — 8 doadores)
```

**Legenda:**
- **Nivel 0:** Voce (o recebedor das doacoes)
- **Nivel 1:** Seus 2 indicados diretos (esquerda e direita)
- **Nivel 2:** 4 indicados dos seus indicados (netos)
- **Nivel 3:** 8 pessoas que doam diretamente para voce (bisnetos = DOADORES)

### Parametros do tabuleiro atual

| Parametro | Valor |
|-----------|-------|
| Tipo de arvore | Binaria (cada no tem 2 filhos) |
| Profundidade total | 4 niveis (0 a 3) |
| Nivel dos doadores | 3 (bisnetos) |
| Quantidade de doadores por ciclo | 8 (2^3) |
| Total de pessoas na arvore | 15 (2^4 - 1) |
| Condicao de ciclo completo | `quantDoacoesRecebidas >= 8` |
| Valor da doacao | Nao definido no codigo (combinado fora do sistema) |

### Como funciona na pratica

1. **Voce entra na rede** e e posicionado na arvore do seu indicador
2. **Voce identifica seu donatario** (a pessoa ACIMA de voce na arvore, o `indicadoPrincipal` do seu ciclo)
3. **Voce doa** para essa pessoa e sobe comprovante
4. **A medida que pessoas entram abaixo de voce**, a arvore vai enchendo:
   - Primeiro nivel 1 (2 indicados diretos)
   - Depois nivel 2 (4 netos)
   - Depois nivel 3 (8 bisnetos — seus doadores)
5. **Cada bisneto doa para voce** quando entra
6. **Quando voce recebe 8 doacoes**, seu ciclo esta completo
7. **Voce pode "reativar"** — entra na rede novamente como um novo participante

---

## Implementacao no Codigo

### Onde cada parametro esta definido

#### 1. Tipo de arvore (binaria)

Definido pela estrutura da entidade `Usuario.java`:
```java
// Cada usuario tem EXATAMENTE 2 filhos (esquerda e direita)
@ManyToOne @JoinColumn(name = "indicado_esquerda_id")
private Usuario indicadoEsquerda;

@ManyToOne @JoinColumn(name = "indicado_direita_id")
private Usuario indicadoDireita;
```

A insercao BFS em `UsuarioServiceImpl.inserirIndicado()` sempre procura o primeiro slot vazio (esquerda tem prioridade):
```java
if (pessoaAtual.getIndicadoEsquerda() == null) {
    pessoaAtual.setIndicadoEsquerda(novaPessoa);
} else if (pessoaAtual.getIndicadoDireita() == null) {
    pessoaAtual.setIndicadoDireita(novaPessoa);
}
```

**Para mudar:** Para arvore ternaria (3 filhos), seria necessario adicionar um campo `indicadoCentro` (ou similar) e alterar o BFS.

#### 2. Quantidade de doadores (8) e condicao de ciclo completo

Definido em `UsuarioController.java` (linha 99):
```java
if (usuario.getQuantDoacoesRecebidas() >= 8)
    isCicloFinalizado = true;
```

**Para mudar:** Alterar o `8` para o novo numero. Idealmente extrair para uma constante ou configuracao.

#### 3. Nivel dos doadores (bisnetos = nivel 3)

Definido na JSP `doadores.jsp`. Cada linha da tabela acessa 3 niveis de profundidade a partir do ciclo:

```
Linha 1: aba.indicadoEsquerda.indicadoEsquerda.indicadoEsquerda
Linha 2: aba.indicadoEsquerda.indicadoEsquerda.indicadoDireita
Linha 3: aba.indicadoEsquerda.indicadoDireita.indicadoEsquerda
Linha 4: aba.indicadoEsquerda.indicadoDireita.indicadoDireita
Linha 5: aba.indicadoDireita.indicadoEsquerda.indicadoEsquerda
Linha 6: aba.indicadoDireita.indicadoEsquerda.indicadoDireita
Linha 7: aba.indicadoDireita.indicadoDireita.indicadoEsquerda
Linha 8: aba.indicadoDireita.indicadoDireita.indicadoDireita
```

Isso gera todas as 8 combinacoes de esquerda/direita em 3 niveis (2^3 = 8).

**Para mudar:** Se alterar para 2 niveis, seriam 4 doadores (netos). Se alterar para 4 niveis, seriam 16 doadores (tataranetos). A JSP precisaria ser reescrita.

#### 4. Rede visivel (tela "Minha Rede")

`UsuarioServiceImpl.recuperarRede()` retorna nivel 1 + nivel 2 (filhos + netos = 6 pessoas):

```java
// Filhos (nivel 1)
rede.add(usuario.getIndicadoEsquerda());
rede.add(usuario.getIndicadoDireita());
// Netos (nivel 2)
rede.add(usuario.getIndicadoEsquerda().getIndicadoEsquerda());
rede.add(usuario.getIndicadoEsquerda().getIndicadoDireita());
rede.add(usuario.getIndicadoDireita().getIndicadoEsquerda());
rede.add(usuario.getIndicadoDireita().getIndicadoDireita());
```

#### 5. Doadores retornados pelo service (usado internamente)

`UsuarioServiceImpl.recuperarDoadores()` retorna nivel 2 (netos = 4 pessoas):

```java
// Netos apenas (nivel 2)
doadores.add(usuario.getIndicadoEsquerda().getIndicadoEsquerda());
doadores.add(usuario.getIndicadoEsquerda().getIndicadoDireita());
doadores.add(usuario.getIndicadoDireita().getIndicadoEsquerda());
doadores.add(usuario.getIndicadoDireita().getIndicadoDireita());
```

**ATENCAO - Inconsistencia:** O metodo `recuperarDoadores()` retorna 4 netos (nivel 2), mas a JSP `doadores.jsp` mostra 8 bisnetos (nivel 3). O metodo no service NAO e usado pela tela de doadores — a JSP acessa diretamente os dados do Ciclo via expression language. O metodo `recuperarDoadores()` pode ser codigo legado de uma versao anterior do tabuleiro.

---

## Como o Ciclo se Conecta ao Tabuleiro

### Entidade Ciclo (`ciclo`)

Cada ciclo guarda um "snapshot" da posicao do usuario na arvore:

```
Ciclo:
  - usuario:            o dono do ciclo (VOCE)
  - indicador:          quem te indicou na rede
  - indicadoPrincipal:  para quem VOCE deve doar (seu pai direto na arvore)
  - indicadoEsquerda:   seu filho esquerdo neste ciclo
  - indicadoDireita:    seu filho direito neste ciclo
```

A partir de `indicadoEsquerda` e `indicadoDireita`, o sistema navega recursivamente via Hibernate lazy loading ate o nivel 3 para encontrar os 8 doadores.

### Fluxo de Ativacao

Quando o admin ativa um usuario (`UsuarioServiceImpl.ativar()`):

```
1. usuario.ativo = true
2. usuario.quantCiclos++
3. Insere na arvore via BFS -> encontra o "pai" (indicadorDireto)
4. Atualiza o ciclo do pai (coloca o novo usuario como esquerda ou direita)
5. Cria novo Ciclo:
   - ciclo.usuario = novoUsuario
   - ciclo.indicadoPrincipal = indicadorDireto (para quem doar)
   - ciclo.indicador = quem indicou originalmente
   - ciclo.ativo = true
6. usuario.cicloAtivo = ciclo
```

### Fluxo de Reativacao

Quando um usuario completa 8 doacoes e clica "Continuar" (`UsuarioServiceImpl.reativar()`):

```
1. Cria NOVO registro de Usuario (copia dados do antigo)
2. Antigo usuario: login=null, senha=null (arquivado)
3. Antigo ciclo: ativo=false
4. Novo usuario: ativo=false, quantDoacoesRecebidas=0, cicloAtivo=null
5. O novo usuario precisa repetir o fluxo: upload comprovante -> admin ativa -> entra na arvore
```

---

## Para Criar um Novo Tabuleiro

### O que precisa mudar (checklist)

Se voce quiser alterar o tabuleiro (ex: mudar de 8 para 4 doadores, ou de binario para ternario), estas sao todas as pecas que precisam ser alteradas:

#### Mudanca de PROFUNDIDADE (ex: de 3 niveis para 2 niveis = 4 doadores)

| Arquivo | O que mudar |
|---------|-------------|
| `UsuarioController.java` | Alterar `>= 8` para `>= 4` na verificacao de ciclo completo |
| `doadores.jsp` | Reescrever a tabela para mostrar 4 linhas (nivel 2) em vez de 8 (nivel 3) |
| `UsuarioServiceImpl.recuperarDoadores()` | Ajustar para o novo nivel (ja esta em nivel 2 atualmente) |
| `UsuarioServiceImpl.recuperarRede()` | Ajustar para mostrar a quantidade correta de niveis |

#### Mudanca de TIPO DE ARVORE (ex: de binaria para ternaria = 3 filhos)

| Arquivo | O que mudar |
|---------|-------------|
| `Usuario.java` | Adicionar `indicadoCentro` (novo campo, nova coluna no banco) |
| `Ciclo.java` | Adicionar `indicadoCentro` (novo campo, nova coluna no banco) |
| Banco de dados | `ALTER TABLE usuario ADD indicado_centro_id BIGINT` + FK |
| Banco de dados | `ALTER TABLE ciclo ADD indicado_centro_id BIGINT` + FK |
| `UsuarioServiceImpl.inserirIndicado()` | Alterar BFS para verificar esquerda -> centro -> direita |
| `UsuarioServiceImpl.ativar()` | Atualizar logica do ciclo para incluir centro |
| `UsuarioServiceImpl.recuperarDoadores()` | Recalcular niveis (ternaria nivel 2 = 9 doadores) |
| `UsuarioServiceImpl.recuperarRede()` | Incluir filhos centrais |
| `doadores.jsp` | Reescrever tabela para 3^N linhas |
| `minha-rede.jsp` | Redesenhar visualizacao da arvore |
| `UsuarioController.java` | Alterar threshold de ciclo completo |

#### Mudanca de VALOR de doacao

O valor da doacao NAO e definido no codigo. Nao existe campo de valor monetario em nenhuma entidade. O valor e combinado externamente (WhatsApp, regras do grupo, etc.). Para adicionar controle de valor no sistema:

| Arquivo | O que adicionar |
|---------|-----------------|
| `Ciclo.java` ou nova entidade | Campo `valorDoacao` (BigDecimal) |
| `Usuario.java` ou nova entidade | Campo para registrar valor pago/recebido |
| Banco de dados | Novas colunas ou tabela de transacoes |
| `donatarios.jsp` | Exibir valor a pagar |
| `doadores.jsp` | Exibir valor recebido |
| `UsuarioController.java` | Logica de validacao de valores |

---

## Tabela Comparativa: Exemplos de Tabuleiros

| Tabuleiro | Tipo arvore | Niveis doadores | Doadores/ciclo | Total na arvore | Alteracoes necessarias |
|-----------|-------------|-----------------|----------------|-----------------|----------------------|
| **Atual** | Binaria (2) | 3 | 8 | 15 | Nenhuma |
| Binaria rasa | Binaria (2) | 2 | 4 | 7 | Profundidade |
| Binaria funda | Binaria (2) | 4 | 16 | 31 | Profundidade |
| Ternaria | Ternaria (3) | 2 | 9 | 13 | Tipo + profundidade |
| Ternaria funda | Ternaria (3) | 3 | 27 | 40 | Tipo + profundidade |
| Quaternaria | Quaternaria (4) | 2 | 16 | 21 | Tipo + profundidade |

Formula: doadores = filhos^nivel_doadores. Total na arvore = (filhos^(niveis+1) - 1) / (filhos - 1).

---

## Resumo Tecnico para Prompts

Ao criar um prompt para gerar novos tabuleiros, forneça:

1. **Tipo de arvore:** Binaria (2 filhos), ternaria (3), quaternaria (4)
2. **Nivel dos doadores:** Em que nivel da arvore estao as pessoas que doam para voce
3. **Quantidade de doadores por ciclo:** filhos^nivel (8 no atual)
4. **Valor da doacao:** Se deseja que o sistema controle valores
5. **Regras de reativacao:** O que acontece quando o ciclo completa
6. **Regras de insercao:** BFS (preenche nivel a nivel) ou outra estrategia

### Exemplo de prompt para alterar o tabuleiro atual

```
Alterar o tabuleiro de doacoes do sistema VemTambem.

TABULEIRO ATUAL:
- Arvore binaria (2 filhos por no)
- 4 niveis (0 a 3)
- Doadores no nivel 3 (bisnetos)
- 8 doadores por ciclo
- Condicao de fim: quantDoacoesRecebidas >= 8

NOVO TABULEIRO:
- [Tipo de arvore]
- [Quantidade de niveis]
- [Nivel dos doadores]
- [Doadores por ciclo]
- [Condicao de fim]
- [Valor da doacao se aplicavel]

Arquivos que precisam ser alterados:
- Usuario.java (entidade - campos de filhos)
- Ciclo.java (entidade - campos de filhos do ciclo)
- UsuarioServiceImpl.java (logica de insercao BFS, ativacao, reativacao, recuperarDoadores, recuperarRede)
- UsuarioController.java (condicao de ciclo completo: >= N)
- doadores.jsp (tabela com N linhas de doadores)
- minha-rede.jsp (visualizacao da arvore)
- Banco de dados (ALTER TABLE se mudar tipo de arvore)
```
