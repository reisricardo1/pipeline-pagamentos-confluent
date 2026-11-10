-- Dados sintéticos mínimos. Se o desafio fornece o seed oficial, use-o no lugar deste.
INSERT INTO contas (id, titular, pais, limite) VALUES
  (1, 'Ana Souza',    'BR', 5000.00),
  (2, 'Bruno Lima',   'BR', 12000.00),
  (3, 'Carla Mendes', 'PT', 3000.00)
ON CONFLICT (id) DO NOTHING;

INSERT INTO transacoes (id, conta_id, cartao_id, valor, estabelecimento) VALUES
  (1001, 1, 'card-A', 89.90,  'Padaria Central'),
  (1002, 2, 'card-B', 450.00, 'Loja de Eletronicos'),
  (1003, 3, 'card-C', 32.50,  'Cafe do Porto')
ON CONFLICT (id) DO NOTHING;
