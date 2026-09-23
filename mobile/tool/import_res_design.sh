#!/usr/bin/env bash
set -euo pipefail
ARCHIVE="${1:-res.zip}"
ROOT="assets/mt2"
TMP=".mt2_res_tmp"
[ -f "$ARCHIVE" ] || { echo "Archive not found: $ARCHIVE" >&2; exit 1; }
rm -rf "$TMP"
mkdir -p "$TMP" "$ROOT"
unzip -q -o "$ARCHIVE" 'res/*' -d "$TMP"
find "$TMP/res" -type f | while read -r file; do
  name="$(basename "$file" | tr '[:upper:]' '[:lower:]')"
  case "$name" in
    *room*|*mic*|*seat*|*capsule*) group="room" ;;
    *gift*|*present*|*flower*|*rocket*) group="gifts" ;;
    *rank*|*ranking*|*medal*) group="ranking" ;;
    *vip*|*svip*) group="vip" ;;
    *family*) group="family" ;;
    *cp*|*relation*) group="cp" ;;
    *nav*|*home*|*main*) group="home" ;;
    *login*|*splash*|*logo*) group="auth" ;;
    *) group="common" ;;
  esac
  mkdir -p "$ROOT/$group"
  cp -f "$file" "$ROOT/$group/"
done
rm -rf "$TMP"
echo "MT2 resources organized under $ROOT/{home,room,gifts,ranking,vip,family,cp,auth,common}"
