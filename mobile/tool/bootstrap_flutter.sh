#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter create --platforms=android --project-name=mt2_voice_party .
bash tool/configure_android.sh
echo "Flutter Android platform bootstrapped."
