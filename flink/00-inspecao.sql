-- Confluent Cloud expõe cada topic como tabela Flink automaticamente.
-- Os nomes têm ponto, então use crase.
SHOW TABLES;
DESCRIBE EXTENDED `pgpag.public.transacoes`;
DESCRIBE EXTENDED `pgpag.public.contas`;
SELECT * FROM `pgpag.public.transacoes` LIMIT 5;
