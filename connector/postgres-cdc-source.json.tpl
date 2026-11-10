{
  "name": "pagamentos-postgres-cdc",
  "connector.class": "PostgresCdcSourceV2",
  "kafka.auth.mode": "SERVICE_ACCOUNT",
  "kafka.service.account.id": "${SA_WRITER_ID}",
  "database.hostname": "${PG_HOST}",
  "database.port": "${PG_PORT}",
  "database.user": "${PG_USER}",
  "database.password": "${PG_PASSWORD}",
  "database.dbname": "${PG_DB}",
  "topic.prefix": "${TOPIC_PREFIX}",
  "table.include.list": "public.contas,public.transacoes",
  "plugin.name": "pgoutput",
  "slot.name": "${SLOT_NAME}",
  "publication.name": "${PUBLICATION_NAME}",
  "output.data.format": "AVRO",
  "decimal.handling.mode": "precise",
  "tasks.max": "1"
}
