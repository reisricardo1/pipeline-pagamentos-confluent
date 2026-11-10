-- Camada 4a: enriquecer a transação com os dados da conta (temporal join).
-- `contas` é a tabela versionada (PK = id); a transação enxerga a versão da conta
-- vigente no instante em que ocorreu.
CREATE TABLE transacoes_enriquecidas AS
SELECT
  t.id            AS transacao_id,
  t.cartao_id,
  t.valor,
  t.moeda,
  t.estabelecimento,
  t.conta_id,
  c.titular,
  c.pais,
  c.limite,
  t.`$rowtime`    AS ts_transacao
FROM `pgpag.public.transacoes` AS t
JOIN `pgpag.public.contas` FOR SYSTEM_TIME AS OF t.`$rowtime` AS c
  ON t.conta_id = c.id;
