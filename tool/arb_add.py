"""Adds strings to lib/l10n/arb/app_en.arb and app_hi.arb, then regenerates
AppLocalizations. Safe to run from several shells at once (it takes a lock).

Usage: python3 tool/arb_add.py strings.json

strings.json maps a key to [english, hindi] or to
{"en": ..., "hi": ..., "placeholders": {"name": {"type": "String"}}}.
A key that already exists keeps its text (a different text is reported).
"""
import fcntl
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ARB = ROOT / 'lib' / 'l10n' / 'arb'


def main(path):
    new = json.loads(Path(path).read_text())
    with open(ROOT / '.dart_tool' / 'arb_add.lock', 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        files = {lang: ARB / f'app_{lang}.arb' for lang in ('en', 'hi')}
        data = {lang: json.loads(f.read_text()) for lang, f in files.items()}
        for key, value in new.items():
            if isinstance(value, list):
                value = {'en': value[0], 'hi': value[1]}
            if key in data['en']:
                if data['en'][key] != value['en']:
                    print(f'kept existing {key!r}: {data["en"][key]!r}')
                continue
            for lang in ('en', 'hi'):
                data[lang][key] = value[lang]
            if 'placeholders' in value:
                data['en'][f'@{key}'] = {'placeholders': value['placeholders']}
        for lang, f in files.items():
            f.write_text(json.dumps(data[lang], ensure_ascii=False, indent=2) + '\n')
        subprocess.run(['flutter', 'gen-l10n'], cwd=ROOT, check=True,
                       stdout=subprocess.DEVNULL)


if __name__ == '__main__':
    main(sys.argv[1])
