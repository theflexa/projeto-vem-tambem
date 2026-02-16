# Guia do Tabuleiro de Doacoes - VemTambem

## O que e o "tabuleiro"

O tabuleiro e o modelo de rede de doacoes do sistema. Ele define:
- Quantas pessoas participam de cada ciclo
- Quem doa para quem
- Quando um ciclo e considerado completo
- O que acontece apos completar um ciclo
- **Quanto cada participante doa** (via entidade `TipoCiclo`)

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

### Valores de Doacao (TipoCiclo)

Os valores sao definidos pela entidade `TipoCiclo` no banco de dados:

| Tabuleiro | Valor T.I. (ativacao) | Valor Doacao | Total pago pelo participante |
|-----------|-----------------------|--------------|------------------------------|
| Tabuleiro 1 | R$ 10,00 | R$ 90,00 | R$ 100,00 |
| Tabuleiro 2 | R$ 50,00 | R$ 450,00 | R$ 500,00 |
| Tabuleiro 3 | R$ 100,00 | R$ 900,00 | R$ 1.000,00 |

**T.I. (Taxa de Investimento):** Doacao de ativacao paga ao sistema para manutencao.
**Doacao:** Valor pago diretamente ao donatario (pessoa acima na arvore).

### Como funciona na pratica

1. **Voce entra na rede** e e posicionado na arvore do seu indicador
2. **Voce identifica seu donatario** (a pessoa ACIMA de voce na arvore, o `indicadoPrincipal` do seu ciclo)
3. **Voce paga a T.I.** (R$ 10,00 no Tabuleiro 1) e envia comprovante
4. **Admin ativa sua conta** apos verificar o comprovante
5. **Voce doa** o valor principal (R$ 90,00 no Tabuleiro 1) para o donatario e sobe comprovante
6. **A medida que pessoas entram abaixo de voce**, a arvore vai enchendo:
   - Primeiro nivel 1 (2 indicados diretos)
   - Depois nivel 2 (4 netos)
   - Depois nivel 3 (8 bisnetos — seus doadores)
7. **Cada bisneto doa para voce** quando entra
8. **Quando voce recebe 8 doacoes**, seu ciclo esta completo
9. **Voce pode "reativar"** — entra na rede novamente, potencialmente no proximo tabuleiro com valores maiores

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

#### 2. Valores de doacao (TipoCiclo)

Definidos pela entidade `TipoCiclo` no banco de dados:
```java
@Entity
@Table(name = "tipo_ciclo")
public class TipoCiclo {
    private Long id;
    private String nome;           // "Tabuleiro 1", "Tabuleiro 2", etc.
    private BigDecimal valorTI;    // Valor da taxa de ativacao
    private BigDecimal valorDoacao; // Valor da doacao ao donatario
    private int quantDoadores;     // Quantidade de doadores por ciclo
    private int ordem;             // Ordem de progressao
    private boolean ativo;         // Se este tabuleiro esta ativo
}
```

O controller (`HomeController`, `UsuarioController`) injeta `tipoCicloAtual` no model. As JSPs exibem valores dinamicos com fallback:
```jsp
<c:choose>
  <c:when test="${tipoCicloAtual != null}">R$ ${tipoCicloAtual.valorDoacao}</c:when>
  <c:otherwise>R$ 90,00</c:otherwise>
</c:choose>
```

**Para mudar valores:** Atualizar os registros na tabela `tipo_ciclo` no banco. Nenhuma mudanca de codigo necessaria.

**Para adicionar novo tabuleiro:** Inserir novo registro no banco com `ordem` sequencial e `ativo=true`.

#### 3. Quantidade de doadores (8) e condicao de ciclo completo

Definido em `UsuarioController.java`:
```java
if (usuario.getQuantDoacoesRecebidas() >= 8)
    isCicloFinalizado = true;
```

Tambem definido em `TipoCiclo.quantDoadores` para referencia, mas a validacao real usa o hardcode `>= 8`.

**Para mudar:** Alterar o `8` para `tipoCicloAtual.getQuantDoadores()` para tornar dinamico. Idealmente usar o valor do TipoCiclo.

#### 4. Nivel dos doadores (bisnetos = nivel 3)

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

#### 5. Rede visivel (tela "Minha Rede")

`minha-rede.jsp` renderiza uma arvore visual HTML/CSS mostrando todos os 3 niveis (filhos + netos + bisnetos = 14 nos). Cada no exibe:
- Badge de nivel colorido (l0=verde, l1=azul, l2=amarelo, l3=roxo)
- Nome abreviado (`nomeCurto`)
- Tooltip com nome completo, contato e documento

Empty state e exibido quando o usuario nao tem indicados ainda.

#### 6. Doadores retornados pelo service (usado internamente)

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

### Entidade TipoCiclo (`tipo_ciclo`)

Define a "categoria" do tabuleiro (valores, nome):

```
TipoCiclo:
  - nome:            "Tabuleiro 1", "Tabuleiro 2", etc.
  - valorTI:         Valor da taxa de ativacao (BigDecimal)
  - valorDoacao:     Valor da doacao ao donatario (BigDecimal)
  - quantDoadores:   Quantidade de doadores esperados no ciclo
  - ordem:           Sequencia de progressao (1, 2, 3...)
  - ativo:           Se este tipo de ciclo esta disponivel
```

O `tipoCicloAtual` e injetado pelo controller com base no ciclo ativo do usuario.

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

## Gamificacao no Painel

O dashboard (`painel.jsp`) exibe 3 cards de gamificacao para usuarios ativos:

### Card "Meu Ciclo"
- Barra de progresso (0-8 doacoes) com gradiente olive→gold
- Nome do tabuleiro via `${tipoCicloAtual.nome}` (fallback: "Tabuleiro 1")
- Mensagens contextuais:
  - 0 doacoes: "Convide pessoas — seu primeiro indicado e o passo mais importante"
  - 1-3 doacoes: "Ja recebeu X — continue compartilhando"
  - 4-7 doacoes: "X de 8 — sua rede esta crescendo"
  - 8+ doacoes: "Parabens! Ciclo completo. Hora do proximo nivel."

### Card "Nivel"
- Avatar com icone e gradiente por nivel:
  - 0 ciclos: Iniciante (verde, seedling)
  - 1 ciclo: Colaborador (azul, medal)
  - 2 ciclos: Veterano (roxo, gem)
  - 3+ ciclos: Mestre (dourado, crown)
- Link "Ver Rede"

### Card "Proximo Passo"
- CTA dinamico baseado no estado do usuario:
  - Doacao nao feita → "Minha Contribuicao"
  - Doacao feita, ciclo em andamento → "Ver Doadores"
  - Ciclo completo → "Reativar para o proximo nivel"

---

## Para Criar um Novo Tabuleiro

### O que precisa mudar (checklist)

Se voce quiser alterar o tabuleiro (ex: mudar de 8 para 4 doadores, ou de binario para ternario), estas sao todas as pecas que precisam ser alteradas:

#### Mudanca de PROFUNDIDADE (ex: de 3 niveis para 2 niveis = 4 doadores)

| Arquivo | O que mudar |
|---------|-------------|
| `UsuarioController.java` | Alterar `>= 8` para `>= 4` (ou usar `tipoCicloAtual.getQuantDoadores()`) |
| `doadores.jsp` | Reescrever a tabela para mostrar 4 linhas (nivel 2) em vez de 8 (nivel 3) |
| `minha-rede.jsp` | Ajustar arvore visual para o novo numero de niveis |
| `UsuarioServiceImpl.recuperarDoadores()` | Ajustar para o novo nivel |
| `tipo_ciclo` (banco) | Atualizar `quant_doadores` para 4 |

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
| `doadores.jsp` | Reescrever tabela para 3^N linhas |
| `minha-rede.jsp` | Redesenhar visualizacao da arvore (3 galhos por no) |
| `UsuarioController.java` | Alterar threshold de ciclo completo |
| `tipo_ciclo` (banco) | Atualizar `quant_doadores` |

#### Mudanca de VALOR de doacao

| Local | O que fazer |
|-------|-------------|
| Banco de dados | Atualizar `valor_ti` e `valor_doacao` nos registros de `tipo_ciclo` |
| Nenhum codigo | Os valores sao lidos dinamicamente do banco via `TipoCiclo` |

**Nota:** Se `tipoCicloAtual` for null (usuario sem ciclo associado), as JSPs usam valores hardcoded como fallback (R$ 10,00 / R$ 90,00). Para evitar isso, garanta que todo usuario tenha um `tipoCicloAtual` definido.

#### Adicionar novo nivel de tabuleiro

| Local | O que fazer |
|-------|-------------|
| Banco de dados | `INSERT INTO tipo_ciclo (nome, valor_ti, valor_doacao, quant_doadores, ordem, ativo) VALUES ('Tabuleiro 4', 200.00, 1800.00, 8, 4, true)` |
| Controller | Garantir que a logica de reativacao associe o usuario ao proximo `TipoCiclo` por ordem |

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

Ao criar um prompt para gerar novos tabuleiros, forneca:

1. **Tipo de arvore:** Binaria (2 filhos), ternaria (3), quaternaria (4)
2. **Nivel dos doadores:** Em que nivel da arvore estao as pessoas que doam para voce
3. **Quantidade de doadores por ciclo:** filhos^nivel (8 no atual)
4. **Valores de doacao:** Definidos na tabela `tipo_ciclo` (valorTI + valorDoacao por tabuleiro)
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
- Valores definidos na tabela tipo_ciclo (Tabuleiro 1: TI=R$10, Doacao=R$90)

NOVO TABULEIRO:
- [Tipo de arvore]
- [Quantidade de niveis]
- [Nivel dos doadores]
- [Doadores por ciclo]
- [Condicao de fim]
- [Valores de doacao por nivel]

Arquivos que precisam ser alterados:
- Usuario.java (entidade - campos de filhos)
- Ciclo.java (entidade - campos de filhos do ciclo)
- TipoCiclo (banco - valores de doacao, quantDoadores)
- UsuarioServiceImpl.java (logica de insercao BFS, ativacao, reativacao, recuperarDoadores)
- UsuarioController.java (condicao de ciclo completo: >= N)
- doadores.jsp (tabela com N linhas de doadores)
- minha-rede.jsp (visualizacao da arvore)
- Banco de dados (ALTER TABLE se mudar tipo de arvore)
```
