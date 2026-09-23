#!/usr/bin/env bash
set -euo pipefail
ARCHIVE="${1:-MT2.zip}"
ROOT="assets/mt2"
TMP=".mt2_archive_tmp"
[ -f "$ARCHIVE" ] || { echo "Archive not found: $ARCHIVE" >&2; exit 1; }
rm -rf "$TMP"
mkdir -p "$TMP" "$ROOT"
unzip -q -o "$ARCHIVE" 'assets/*' -d "$TMP"
find "$TMP/assets" -type f | while read -r file; do
  name="$(basename "$file" | tr '[:upper:]' '[:lower:]')"
  case "$name" in
    *kroom*|*room*|*mic*|*gift*|*pk*|*rocket*|*firework*) group="room" ;;
    *rank*) group="ranking" ;;
    *vip*|*svip*) group="vip" ;;
    *family*) group="family" ;;
    *cp*) group="cp" ;;
    *diamond*) group="wallet" ;;
    *signin*) group="signin" ;;
    *dynamic*) group="moments" ;;
    *home*|*party*|*message*|*discover*|*my*) group="home" ;;
    *) group="common" ;;
  esac
  mkdir -p "$ROOT/$group"
  cp -f "$file" "$ROOT/$group/"
done
rm -rf "$TMP"
echo "MT2 animation assets organized by feature."
