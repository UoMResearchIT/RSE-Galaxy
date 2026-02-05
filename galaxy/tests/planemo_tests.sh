#!/usr/bin/env bash
# Light wrapper around planemo to inject variables from compose environment

shopt -s globstar nullglob

uv tool run planemo test \
  --polling_backoff 5 \
  --skip_venv \
  --engine external_galaxy \
  --galaxy_url ${GALAXY_URL} \
  --galaxy_admin_key ${GALAXY_API_KEY} \
  --database_type postgres \
  --postgres_database_user planemo \
  --postgres_database_host localhost \
  --postgres_database_port 5432 \
  ${GALAXY_TOOL_PATHS}
