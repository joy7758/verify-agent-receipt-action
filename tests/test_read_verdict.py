from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'scripts' / 'read_verdict.py'


def load_module():
    spec = importlib.util.spec_from_file_location('read_verdict', SCRIPT)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class ReadVerdictTests(unittest.TestCase):
    def test_prints_valid_verdict(self) -> None:
        module = load_module()
        with tempfile.TemporaryDirectory() as tmp:
            report = Path(tmp) / 'report.json'
            report.write_text('{"verdict": "valid"}', encoding='utf-8')
            self.assertEqual(module.main([str(report)]), 0)

    def test_rejects_missing_verdict(self) -> None:
        module = load_module()
        with tempfile.TemporaryDirectory() as tmp:
            report = Path(tmp) / 'report.json'
            report.write_text('{}', encoding='utf-8')
            with self.assertRaises(SystemExit) as ctx:
                module.main([str(report)])
            self.assertIn('missing verdict', str(ctx.exception))

    def test_rejects_malformed_json(self) -> None:
        module = load_module()
        with tempfile.TemporaryDirectory() as tmp:
            report = Path(tmp) / 'report.json'
            report.write_text('{not-json', encoding='utf-8')
            with self.assertRaises(SystemExit) as ctx:
                module.main([str(report)])
            self.assertIn('invalid JSON', str(ctx.exception))


if __name__ == '__main__':
    unittest.main()
