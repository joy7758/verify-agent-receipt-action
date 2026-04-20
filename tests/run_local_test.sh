#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/vtif-action.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

VENV_DIR="$TMP_ROOT/.venv"
OUTPUT_DIR="$TMP_ROOT/demo-output"
VALID_REPORT="$TMP_ROOT/verification_report.valid.json"
INVALID_REPORT_TRUE="$TMP_ROOT/verification_report.invalid.true.json"
INVALID_REPORT_FALSE="$TMP_ROOT/verification_report.invalid.false.json"
GITHUB_OUTPUT_FILE="$TMP_ROOT/github_output.txt"
TAMPERED_EVIDENCE="$TMP_ROOT/evidence_bundle.tampered.json"

python3.13 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install "verifiable-tool-invocation-flow==0.1.1"

export PATH="$VENV_DIR/bin:$PATH"
VTIF_OUTPUT_DIR="$OUTPUT_DIR" python -m verifiable_tool_invocation_flow.main >/dev/null

rm -f "$GITHUB_OUTPUT_FILE"
export GITHUB_OUTPUT="$GITHUB_OUTPUT_FILE"
export INPUT_RECEIPT="$OUTPUT_DIR/execution_receipt.json"
export INPUT_EVIDENCE="$OUTPUT_DIR/evidence_bundle.json"
export INPUT_PUBLIC_KEY="$OUTPUT_DIR/demo_public_key.pem"
export INPUT_AUDIENCE="demo-validator"
export INPUT_OUTPUT="$VALID_REPORT"
export INPUT_FAIL_ON_INVALID="true"
export TAMPERED_EVIDENCE

"$ROOT_DIR/scripts/verify_receipt.sh"

test -f "$VALID_REPORT"
grep -q '^verdict=valid$' "$GITHUB_OUTPUT_FILE"
grep -q "^report-path=$VALID_REPORT$" "$GITHUB_OUTPUT_FILE"

python <<'PY'
import json
import os
from pathlib import Path

source_path = Path(os.environ["INPUT_EVIDENCE"])
target_path = Path(os.environ["TAMPERED_EVIDENCE"])
payload = json.loads(source_path.read_text(encoding="utf-8"))
payload["tool_output"]["metadata"]["title"] = "Tampered Dataset Title"
target_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
PY

rm -f "$GITHUB_OUTPUT_FILE"
touch "$GITHUB_OUTPUT_FILE"
export INPUT_EVIDENCE="$TAMPERED_EVIDENCE"
export INPUT_OUTPUT="$INVALID_REPORT_TRUE"

set +e
"$ROOT_DIR/scripts/verify_receipt.sh"
status_true=$?
set -e

if [[ "$status_true" -eq 0 ]]; then
  echo "expected fail-on-invalid=true to exit nonzero" >&2
  exit 1
fi

test -f "$INVALID_REPORT_TRUE"
grep -q '^verdict=invalid$' "$GITHUB_OUTPUT_FILE"

rm -f "$GITHUB_OUTPUT_FILE"
touch "$GITHUB_OUTPUT_FILE"
export INPUT_OUTPUT="$INVALID_REPORT_FALSE"
export INPUT_FAIL_ON_INVALID="false"

"$ROOT_DIR/scripts/verify_receipt.sh"

test -f "$INVALID_REPORT_FALSE"
grep -q '^verdict=invalid$' "$GITHUB_OUTPUT_FILE"
grep -q "^report-path=$INVALID_REPORT_FALSE$" "$GITHUB_OUTPUT_FILE"

echo "local action test passed"
