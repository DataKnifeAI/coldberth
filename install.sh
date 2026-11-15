#!/usr/bin/env bash
# Bootstrap coldberth — clone or refresh, then run coldberth install.
set -euo pipefail

REPO="${COLDBERTH_REPO:-https://github.com/DataKnifeAI/coldberth.git}"
DIR="${COLDBERTH_DIR:-$HOME/.local/share/coldberth/src}"

if [[ -d "$DIR/.git" ]]; then
  git -C "$DIR" pull --ff-only
else
  mkdir -p "$(dirname "$DIR")"
  git clone "$REPO" "$DIR"
fi

exec "$DIR/bin/coldberth" update
