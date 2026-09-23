#!/usr/bin/env bash
set -euo pipefail

MANIFEST="android/app/src/main/AndroidManifest.xml"

if [ ! -f "$MANIFEST" ]; then
  echo "AndroidManifest.xml not found. Run bootstrap_flutter.sh first." >&2
  exit 1
fi

python3 - "$MANIFEST" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()

permissions = [
    '    <uses-permission android:name="android.permission.INTERNET" />',
    '    <uses-permission android:name="android.permission.RECORD_AUDIO" />',
]

insert = [p for p in permissions if p not in text]
if insert:
    marker = '    <application'
    if marker not in text:
        raise SystemExit('Android application marker not found')
    text = text.replace(marker, '\n'.join(insert) + '\n' + marker, 1)
    path.write_text(text)
PY

echo "Android voice permissions configured."
