-- Evidência da camada 4: 3 transações no MESMO cartão em menos de 60 s => alerta
-- Rode as três linhas em sequência rápida.
INSERT INTO transacoes (id, conta_id, cartao_id, valor, estabelecimento) VALUES (3001, 2, 'card-FRAUDE', 199.90, 'Loja X');
INSERT INTO transacoes (id, conta_id, cartao_id, valor, estabelecimento) VALUES (3002, 2, 'card-FRAUDE', 299.90, 'Loja Y');
INSERT INTO transacoes (id, conta_id, cartao_id, valor, estabelecimento) VALUES (3003, 2, 'card-FRAUDE', 399.90, 'Loja Z');
