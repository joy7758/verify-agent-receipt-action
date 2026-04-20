#!/usr/bin/env python3
"""Read the verification verdict from a JSON report file."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main(argv: list[str] | None = None) -> int:
    args = list(sys.argv[1:] if argv is None else argv)
    if len(args) != 1:
        raise SystemExit("usage: read_verdict.py <verification_report.json>")

    report_path = Path(args[0])
    if not report_path.is_file():
        raise SystemExit(f"verification report not found: {report_path}")

    try:
        payload = json.loads(report_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise SystemExit(f"invalid JSON in {report_path}: {exc}") from exc

    verdict = payload.get("verdict")
    if not isinstance(verdict, str) or not verdict:
        raise SystemExit(f"missing verdict in {report_path}")

    print(verdict)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
