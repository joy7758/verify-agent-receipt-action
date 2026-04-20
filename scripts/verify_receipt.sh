#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

required_vars=(
  INPUT_RECEIPT
  INPUT_EVIDENCE
  INPUT_PUBLIC_KEY
  INPUT_AUDIENCE
  INPUT_OUTPUT
  INPUT_FAIL_ON_INVALID
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    echo "missing required environment variable: ${var_name}" >&2
    exit 2
  fi
done

validator_exit=0
python -m verifiable_tool_invocation_flow.validator \
  --receipt "$INPUT_RECEIPT" \
  --evidence "$INPUT_EVIDENCE" \
  --public-key "$INPUT_PUBLIC_KEY" \
  --audience "$INPUT_AUDIENCE" \
  --out "$INPUT_OUTPUT" || validator_exit=$?

if [[ ! -f "$INPUT_OUTPUT" ]]; then
  echo "verification report was not produced: $INPUT_OUTPUT" >&2
  exit "${validator_exit:-1}"
fi

verdict="$(python "$SCRIPT_DIR/read_verdict.py" "$INPUT_OUTPUT")" || exit $?

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    printf 'verdict=%s\n' "$verdict"
    printf 'report-path=%s\n' "$INPUT_OUTPUT"
  } >> "$GITHUB_OUTPUT"
fi

if [[ "$verdict" == "valid" ]]; then
  exit 0
fi

if [[ "$INPUT_FAIL_ON_INVALID" == "true" ]]; then
  exit 1
fi

exit 0
