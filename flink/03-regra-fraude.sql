-- Camada 4b: 3 ou mais transações no mesmo cartão em 60 s => alerta.
-- Janela deslizante: 60 s de largura, avançando a cada 10 s.
CREATE TABLE alertas_fraude AS
SELECT
  cartao_id,
  window_start,
  window_end,
  COUNT(*)   AS qtd_transacoes,
  SUM(valor) AS valor_total
FROM TABLE(
  HOP(TABLE transacoes_enriquecidas, DESCRIPTOR(ts_transacao),
      INTERVAL '10' SECOND, INTERVAL '60' SECOND)
)
GROUP BY cartao_id, window_start, window_end
HAVING COUNT(*) >= 3;
