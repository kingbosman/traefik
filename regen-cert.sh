#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOMAINS_FILE="$SCRIPT_DIR/certs/domains.txt"
CERTS_DIR="$SCRIPT_DIR/certs"

mapfile -t DOMAINS < <(grep -v '^\s*#' "$DOMAINS_FILE" | grep -v '^\s*$')

if [[ ${#DOMAINS[@]} -eq 0 ]]; then
  echo "Error: no domains found in $DOMAINS_FILE"
  exit 1
fi

echo "Generating cert for: ${DOMAINS[*]}"
mkcert -cert-file "$CERTS_DIR/local.pem" -key-file "$CERTS_DIR/local-key.pem" "${DOMAINS[@]}"
