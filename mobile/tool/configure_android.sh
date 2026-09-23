#!/usr/bin/env bash
set -euo pipefail
MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ ! -f "$MANIFEST" ]; then
  echo "AndroidManifest.xml not found. Run bootstrap_flutter.sh first." >&2
  exit 1
fi
python3 - "$MANIFEST" <<'PY'
from pathlib import Path
p=Path(__import__('sys').argv[1])
s=p.read_text()
perms=[
    '    <uses-permission android:name="android.permission.INTERNET" />',
    '    <uses-permission android:name="android.permission.RECORD_AUDIO" />',
]
for perm in perms:
    if perm not in s:
        s=s.replace('<manifest ', '<manifest ', 1)
        marker='\n    <uses-permission'
        insert='\n'.join(perms)+'\n'
        s=s.replace('\n    <application', '\n'+insert+'    <application', 1)
        break
p.write_text(s)
PY
echo "Android voice permissions configured."
