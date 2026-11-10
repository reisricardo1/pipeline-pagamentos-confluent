-- Camada 3 (Ingestão): schema de origem para o CDC
-- Pré-requisito do servidor: wal_level = logical

CREATE TABLE IF NOT EXISTS contas (
  id         BIGINT PRIMARY KEY,
  titular    TEXT           NOT NULL,
  pais       CHAR(2)        NOT NULL,
  limite     NUMERIC(12,2)  NOT NULL,
  criado_em  TIMESTAMPTZ    NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS transacoes (
  id               BIGINT PRIMARY KEY,
  conta_id         BIGINT         NOT NULL REFERENCES contas(id),
  cartao_id        TEXT           NOT NULL,
  valor            NUMERIC(12,2)  NOT NULL,
  moeda            CHAR(3)        NOT NULL DEFAULT 'BRL',
  estabelecimento  TEXT           NOT NULL,
  criado_em        TIMESTAMPTZ    NOT NULL DEFAULT now()
);

-- Usuário do conector (Debezium) com o mínimo de privilégio
-- CREATE ROLE cdc_user WITH LOGIN REPLICATION PASSWORD '...';
-- GRANT SELECT ON contas, transacoes TO cdc_user;

-- Publication usada pelo plugin pgoutput
CREATE PUBLICATION pgpag_pub FOR TABLE contas, transacoes;

-- Opcional: before/after completos nos UPDATE/DELETE
ALTER TABLE contas      REPLICA IDENTITY FULL;
ALTER TABLE transacoes  REPLICA IDENTITY FULL;
