---
trigger: model_decision
description: "Consultar ao mudar contratos, modelo de domínio ou fronteiras entre serviços."
---

# Arquitetura

- A [especificação](../../docs/01_especificacao_requisitos_arquitetura.md) define
  os requisitos. Cruze as mudanças com [casos de uso](../../docs/02_user_stories_e_casos_de_uso.md)
  e [modelo de domínio](../../docs/04-diagrama-classes-dominio.puml).
- Next.js renderiza a web e faz o BFF. Quarkus valida contratos, aplica
  autorização, executa regras de negócio e persiste no PostgreSQL.
- Use as camadas e convenções dos [módulos](../../AGENTS.md) e preserve UUIDs,
  tipos numéricos de precisão definida e instantes com fuso conforme o modelo.
- Modele efeitos de retry, concorrência e autorização quando o fluxo exigir.
  Vincule decisões arquiteturais a uma issue e atualize os documentos afetados
  após aprovação do responsável.
