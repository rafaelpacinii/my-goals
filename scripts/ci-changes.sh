#!/usr/bin/env bash
set -euo pipefail

base_sha=$1
head_sha=$2

select_checks() {
  local path api=false web=false integration=false

  while IFS= read -r -d '' path; do
    case "$path" in
      .github/workflows/verify.yml|scripts/ci-changes.sh|.gitattributes)
        api=true
        web=true
        integration=true
        ;;
      compose.yaml|.env.example|infra/*|scripts/smoke-local.sh)
        integration=true
        ;;
      goals-api/README.md|goals-api/AGENTS.md|goals-web/README.md|goals-web/AGENTS.md)
        ;;
      goals-api/Dockerfile|goals-api/.dockerignore)
        api=true
        integration=true
        ;;
      goals-web/Dockerfile|goals-web/.dockerignore)
        web=true
        integration=true
        ;;
      goals-api/*)
        api=true
        ;;
      goals-web/*)
        web=true
        ;;
    esac
  done

  printf 'api=%s\nweb=%s\nintegration=%s\n' "$api" "$web" "$integration"
}

if git rev-parse --verify --quiet --end-of-options "$base_sha^{commit}" >/dev/null; then
  # Trata um arquivo movido como remoção e adição para avaliar os dois módulos.
  git diff --no-renames --name-only -z "$base_sha" "$head_sha" -- | select_checks
else
  printf '%s\n' 'Commit anterior indisponível. Todas as verificações foram selecionadas.' >&2
  printf 'api=true\nweb=true\nintegration=true\n'
fi
