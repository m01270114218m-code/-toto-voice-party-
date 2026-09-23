#!/usr/bin/env bash
set -euo pipefail
ARCHIVE="${1:-MT2.zip}"
DEST="assets/mt2"
mkdir -p "$DEST"
unzip -q -o "$ARCHIVE" 'assets/*' 'res/*' -d "$DEST"
echo "MT2 assets imported into $DEST"
