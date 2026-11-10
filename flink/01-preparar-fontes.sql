-- Os tópicos de CDC são changelogs (insert/update/delete). Para janelas, a entrada
-- precisa ser append-only. As transações só entram (insert), então tratamos como append.
-- VALIDAR na execução: se o ALTER for rejeitado no seu ambiente, derive um stream
-- append-only extraindo o campo `after` do envelope Debezium.
ALTER TABLE `pgpag.public.transacoes` SET ('changelog.mode' = 'append');
