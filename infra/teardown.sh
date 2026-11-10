#!/usr/bin/env bash
# Derruba TUDO para parar de gastar. Ordem importa: conector, Flink, cluster, ambiente.
# Depois, apague o slot de replicação no Postgres (postgres/05-monitorar-slot.sql).
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

ENV_ID=$(confluent environment list -o json | jq -r ".[] | select(.name==\"$ENV_NAME\") | .id")
confluent environment use "$ENV_ID"

echo "== Conector =="
CONN_ID=$(confluent connect cluster list -o json | jq -r '.[] | select(.name=="pagamentos-postgres-cdc") | .id')
[ -n "$CONN_ID" ] && confluent connect cluster delete "$CONN_ID" --force

echo "== Statements e compute pool do Flink =="
for s in $(confluent flink statement list -o json | jq -r '.[].name'); do
  confluent flink statement delete "$s" --force
done
POOL_ID=$(confluent flink compute-pool list -o json | jq -r ".[] | select(.name==\"$POOL_NAME\") | .id")
[ -n "$POOL_ID" ] && confluent flink compute-pool delete "$POOL_ID" --force

echo "== Cluster e ambiente =="
CLUSTER_ID=$(confluent kafka cluster list -o json | jq -r ".[] | select(.name==\"$CLUSTER_NAME\") | .id")
[ -n "$CLUSTER_ID" ] && confluent kafka cluster delete "$CLUSTER_ID" --force
confluent environment delete "$ENV_ID" --force

echo "Lembrete: SELECT pg_drop_replication_slot('$SLOT_NAME'); no Postgres."
