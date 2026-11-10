-- Evidência da camada 3: insert, update e delete devem chegar como eventos (op = c, u, d)
INSERT INTO transacoes (id, conta_id, cartao_id, valor, estabelecimento)
VALUES (2001, 1, 'card-A', 10.00, 'Teste CDC');

UPDATE transacoes SET valor = 12.00 WHERE id = 2001;

DELETE FROM transacoes WHERE id = 2001;
