-- Pegadinha da Aula 2 (Curso 3): conector parado = WAL acumulando = disco cheio.
-- Monitore o atraso do slot:
SELECT slot_name,
       active,
       pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS wal_retido
FROM pg_replication_slots;

-- No teardown, apague o slot órfão (somente se o conector já foi removido):
-- SELECT pg_drop_replication_slot('pgpag_slot');
