#!/usr/bin/env bash
set -euo pipefail

ARCHIVE="$1"
if [ -z "$ARCHIVE" ]; then ARCHIVE="res.zip"; fi
DEST="assets/mt2"

if [ ! -f "$ARCHIVE" ]; then
  echo "Archive not found: $ARCHIVE" >&2
  exit 1
fi

mkdir -p "$DEST"
unzip -q -o "$ARCHIVE" 'res/*' -d "$DEST"

echo "Imported MT2 Android visual resources into $DEST/res"
