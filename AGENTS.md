# My Goals

Monorepo da plataforma de metas. O Next.js em `goals-web/` serve a interface e o BFF. A
API em `goals-api/` concentra regras de negócio e autorização. `infra/` reúne
configurações versionáveis dos serviços do Compose.

## Contexto de trabalho

- Consulte [TASK.md](TASK.md) em entregas de várias etapas e atualize o objetivo, os
  critérios, a evidência e os bloqueios. O backlog e as datas de entrega ficam nas issues e
  milestones, conforme o [planejamento](docs/07-planejamento-github.md).
- Antes de editar o domínio, leia a [especificação](docs/01_especificacao_requisitos_arquitetura.md)
  e os casos de uso ou diagramas afetados. Solicite autorização explícita para alterar
  requisitos e decisões de domínio já aprovados em tarefas futuras.
- Consulte as [regras de arquitetura](.agents/rules/architecture.md),
  [documentação](.agents/rules/docs.md) e [ambiente](.agents/rules/setup.md) conforme a
  tarefa. O [guia de agentes](docs/08-governanca-ia.md) indica as skills e os perfis.
- Leia o `AGENTS.md` do módulo que estiver editando. Preserve alterações da árvore de
  trabalho que não pertençam à tarefa. Use português para documentação e interface.
- Leia apenas arquivos de configuração públicos. Redija valores de segredos em logs,
  resumos e comandos. Deixe `.env*` privados, artefatos e dependências fora do contexto
  de leitura em massa. Use a ferramenta do gerenciador para atualizar lockfiles.

## Comandos

```bash
docker compose --env-file .env.example up --build --wait
docker build --target test ./goals-api
docker build --target check ./goals-web
```

Para validação fora do Docker, use `./mvnw -B verify` dentro de `goals-api/` e
`npm ci`, `npm run lint`, `npm run typecheck` e `npm run build` dentro de `goals-web/`.
Consulte o [README](README.md) para o ambiente e os serviços exigidos.

## Entrega

`main` é a base de PRs e recebe *Squash and Merge*. Use Conventional Commits
em inglês e vincule a issue no PR. Em cada entrega ou revisão, use
[`git-entrega`](.agents/skills/git-entrega/SKILL.md) para conferir o diff atual
completo e preparar comandos seletivos de Git e GitHub CLI.
