#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/scripts/verify_receipt.sh"
bash -n "$ROOT_DIR/tests/run_local_test.sh"

echo "shell_syntax_status=pass"
