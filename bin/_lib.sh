#!/usr/bin/env bash
# bin/_lib.sh

set -euo pipefail

BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$BIN_DIR/.." && pwd)"
MISE_BIN="${MISE_BIN:-mise}"

export ROOT_DIR

if [[ "$MISE_BIN" == */* ]]; then
  PATH="$(dirname "$MISE_BIN"):$PATH"
  export PATH
fi

cd "$ROOT_DIR"

if ! command -v "$MISE_BIN" >/dev/null 2>&1; then
  printf 'Seedbank development requires mise. Set MISE_BIN to its executable path.\n' >&2
  exit 1
fi
