#!/usr/bin/env bash
set -euo pipefail

ARCHIVE=${1:-MT2.zip}
DEST="mobile/assets/mt2"

if [ ! -f "$ARCHIVE" ]; then
  echo "MT2 archive not found: $ARCHIVE"
  echo "Usage: ./mobile/tool/import_mt2_assets.sh /path/to/MT2.zip"
  exit 1
fi

mkdir -p "$DEST"
unzip -q -o "$ARCHIVE" 'assets/*' 'res/*' -d "$DEST"
echo "Imported MT2 assets into $DEST"
