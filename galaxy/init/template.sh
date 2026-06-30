#!/usr/bin/env bash
set -euo pipefail

for file in /work/*.template; do
  [ -f "$file" ] || continue
  out="/galaxy/server/config/$(basename "${file%.template}")"
  envsubst <"$file" >"$out"
  echo "Rendered $file → $out"
  cat "$out"
done

mkdir -p /galaxy/server/database/config
mkdir -p /galaxy/server/database/dependencies

dynamic_config_files=(
  migrated_tools_conf.xml
  shed_data_manager_conf.xml
  shed_tool_conf.xml
  shed_tool_data_table_conf.xml
)
echo "Bootstrapping dynamic Galaxy config files..."
for file in "${dynamic_config_files[@]}"; do

  # Use custom files in ./galaxy/config,
  # fall back to galaxy image defaults
  src="/work/$file"
  if [ ! -f "$src" ]; then
    src="/galaxy/server/config/$file"
  fi
  dst="/galaxy/server/database/config/$file"
  if [ ! -f "$dst" ]; then
    echo "Copying $src to $dst"
    cp "$src" "$dst"
  else
    echo "Using existing $dst"
  fi
done

# Clear the integrated_tool_panel.xml to rebuild the tool index
rm -f /galaxy/server/database/config/integrated_tool_panel.xml

chown -R 10001:10001 /galaxy/server/database
