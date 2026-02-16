-- Cria a tabela tipo_ciclo (MySQL)
CREATE TABLE IF NOT EXISTS tipo_ciclo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor_ti DECIMAL(10,2) NOT NULL,
    valor_doacao DECIMAL(10,2) NOT NULL,
    quant_doadores INTEGER NOT NULL DEFAULT 8,
    ordem INTEGER NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT true
);

-- Adiciona coluna tipo_ciclo_id na tabela ciclo (nullable para manter compatibilidade)
-- Execute manualmente se a coluna ainda não existir:
-- ALTER TABLE ciclo ADD COLUMN tipo_ciclo_id BIGINT, ADD CONSTRAINT fk_ciclo_tipo_ciclo FOREIGN KEY (tipo_ciclo_id) REFERENCES tipo_ciclo(id);

-- Seed: Tabuleiros iniciais
INSERT INTO tipo_ciclo (nome, valor_ti, valor_doacao, quant_doadores, ordem, ativo)
VALUES
  ('Tabuleiro 1', 10.00, 90.00, 8, 1, true),
  ('Tabuleiro 2', 50.00, 450.00, 8, 2, true),
  ('Tabuleiro 3', 100.00, 900.00, 8, 3, true);
