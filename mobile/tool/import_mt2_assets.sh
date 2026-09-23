#!/usr/bin/env bash
set -euo pipefail

ARCHIVE="$1"
if [ -z "$ARCHIVE" ]; then ARCHIVE="MT2.zip"; fi
DEST="assets/mt2"

if [ ! -f "$ARCHIVE" ]; then
  echo "Archive not found: $ARCHIVE" >&2
  exit 1
fi

mkdir -p "$DEST"
unzip -q -o "$ARCHIVE" 'assets/*' 'res/*' -d "$DEST"

echo "Imported MT2 visual resources into $DEST"
