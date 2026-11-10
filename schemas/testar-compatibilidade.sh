#!/usr/bin/env bash
# Camada 2 (Contrato): o Schema Registry aguenta uma mudança de campo?
# Uso: ./schemas/testar-compatibilidade.sh [subject]
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/../.env"
SUBJECT="${1:-contrato-transacao-value}"
AUTH="$SR_API_KEY:$SR_API_SECRET"
H='Content-Type: application/vnd.schemaregistry.v1+json'

reg() { jq -Rs '{schemaType:"AVRO", schema: .}' < "$1"; }

echo "== 1. Registrar v1 =="
reg "$DIR/transacao-v1.avsc" | curl -s -u "$AUTH" -H "$H" -X POST \
  -d @- "$SR_URL/subjects/$SUBJECT/versions"; echo

echo "== 2. Modo de compatibilidade BACKWARD =="
curl -s -u "$AUTH" -H "$H" -X PUT -d '{"compatibility":"BACKWARD"}' \
  "$SR_URL/config/$SUBJECT"; echo

echo "== 3. v2 (campo opcional com default) -> esperado: is_compatible=true =="
reg "$DIR/transacao-v2-compativel.avsc" | curl -s -u "$AUTH" -H "$H" -X POST \
  -d @- "$SR_URL/compatibility/subjects/$SUBJECT/versions/latest"; echo

echo "== 4. v3 (campo obrigatório sem default) -> esperado: is_compatible=false =="
reg "$DIR/transacao-v3-incompativel.avsc" | curl -s -u "$AUTH" -H "$H" -X POST \
  -d @- "$SR_URL/compatibility/subjects/$SUBJECT/versions/latest"; echo
