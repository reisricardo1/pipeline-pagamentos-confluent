#!/usr/bin/env bash
# Camadas 1 e 3: ambiente, cluster, identidades, compute pool do Flink e conector.
# Pré-requisitos: confluent CLI logado (confluent login), jq, envsubst.
# Confira cada comando com `confluent <cmd> --help`: flags podem variar entre versões do CLI.
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

echo "== Ambiente (com Schema Registry via Stream Governance) =="
confluent environment create "$ENV_NAME" --governance-package essentials
ENV_ID=$(confluent environment list -o json | jq -r ".[] | select(.name==\"$ENV_NAME\") | .id")
confluent environment use "$ENV_ID"

echo "== Cluster Kafka =="
confluent kafka cluster create "$CLUSTER_NAME" --cloud "$CLOUD" --region "$REGION" --type basic
CLUSTER_ID=$(confluent kafka cluster list -o json | jq -r ".[] | select(.name==\"$CLUSTER_NAME\") | .id")
confluent kafka cluster use "$CLUSTER_ID"

echo "== Identidades: uma escreve, outra lê =="
confluent iam service-account create "$SA_WRITER" --description "Conector CDC (escrita)"
confluent iam service-account create "$SA_READER" --description "Consumidor dos alertas (leitura)"
SA_WRITER_ID=$(confluent iam service-account list -o json | jq -r ".[] | select(.name==\"$SA_WRITER\") | .id")
SA_READER_ID=$(confluent iam service-account list -o json | jq -r ".[] | select(.name==\"$SA_READER\") | .id")

echo "== ACLs (mínimo privilégio) =="
confluent kafka acl create --allow --service-account "$SA_WRITER_ID" \
  --operations create,write,describe --topic "$TOPIC_PREFIX" --prefix
confluent kafka acl create --allow --service-account "$SA_READER_ID" \
  --operations read,describe --topic "alertas_fraude"
confluent kafka acl create --allow --service-account "$SA_READER_ID" \
  --operations read --consumer-group "alertas-" --prefix

echo "== API keys (guarde em local seguro, nunca no Git) =="
confluent api-key create --resource "$CLUSTER_ID" --service-account "$SA_WRITER_ID" --description "writer"
confluent api-key create --resource "$CLUSTER_ID" --service-account "$SA_READER_ID" --description "reader"

echo "== Compute pool do Flink =="
confluent flink compute-pool create "$POOL_NAME" --cloud "$CLOUD" --region "$REGION" --max-cfu 5

echo "== Conector CDC (renderiza o template com envsubst) =="
export SA_WRITER_ID PG_HOST PG_PORT PG_USER PG_PASSWORD PG_DB TOPIC_PREFIX SLOT_NAME PUBLICATION_NAME
envsubst < connector/postgres-cdc-source.json.tpl > connector/postgres-cdc-source.rendered.json
confluent connect cluster create --config-file connector/postgres-cdc-source.rendered.json

echo "Pronto. Próximos passos: rodar postgres/03-simular-cdc.sql e os scripts em flink/."
