---
name: ambiente-docker
description: "Prepare ou diagnostique o Compose local, Dockerfiles, dependências e healthchecks da API e do frontend."
---

# Ambiente Docker

Use o [README](../../../README.md), o [Compose](../../../compose.yaml) e
[`.env.example`](../../../.env.example) para confirmar variáveis, portas e origem
de cada serviço. Endereços entre contêineres usam o nome do serviço. O navegador usa
a porta publicada em loopback. Separe o URL público de Keycloak/S3 de seu URL interno.

Valide a configuração com `docker compose --env-file .env.example config --quiet`.
Suba os serviços com `--build --wait`, confira `ps` e logs direcionados e rode
`bash scripts/smoke-local.sh`. Para teste isolado em máquina com serviços ativos,
escolha um nome de projeto e portas próprias. Preserve volumes e configuração privada.
