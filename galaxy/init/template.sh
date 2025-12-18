#!/usr/bin/env bash
set -euo pipefail

for file in /work/*.template; do
  [ -f "$file" ] || continue
  out="/galaxy/server/config/$(basename "${file%.template}")"
  envsubst <"$file" >"$out"
  echo "Rendered $file → $out"
  cat "$out"
done

chown -R 10001:10001 /galaxy/server/database
