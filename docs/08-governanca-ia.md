# Guia de trabalho com agentes

Comece por [AGENTS.md](../AGENTS.md) e pelo arquivo do módulo em que vai trabalhar.
Use [TASK.md](../TASK.md) para registrar o contexto da tarefa em execução. Identifique
as regras do domínio pelos IDs da [especificação](01_especificacao_requisitos_arquitetura.md),
pelos [casos de uso](02_user_stories_e_casos_de_uso.md) e pelos diagramas em `docs/`.

## Artefatos

| Caminho | Uso |
| --- | --- |
| [AGENTS.md da web](../goals-web/AGENTS.md) e [da API](../goals-api/AGENTS.md) | Convenções de cada aplicação |
| [Rules](../.agents/rules) | Instruções por assunto referenciadas na política da raiz |
| [Skills](../.agents/skills) | Procedimentos reutilizáveis do projeto |
| [Perfis em .agents](../.agents) | Contexto de arquitetura, revisão e QA para uso por referência |
| [Agentes do Codex](../.codex/agents) | Perfis nativos para arquitetura, revisão, QA e entrega Git |
| [Agentes do GitHub](../.github/agents) | Perfis de agentes personalizados do Copilot |

## Skills disponíveis

| Skill | Quando usar |
| --- | --- |
| [git-entrega](../.agents/skills/git-entrega/SKILL.md) | Preparar Git, GH CLI e textos com base em todas as mudanças a entregar, inclusive após ajustes |
| [padroes-componentes](../.agents/skills/padroes-componentes/SKILL.md) | Criar ou revisar código Next.js e Quarkus |
| [entrega-de-issue](../.agents/skills/entrega-de-issue/SKILL.md) | Detalhar ou implementar uma issue |
| [ambiente-docker](../.agents/skills/ambiente-docker/SKILL.md) | Subir, verificar ou alterar a pilha local |
| [migracoes-postgresql](../.agents/skills/migracoes-postgresql/SKILL.md) | Implementar ou revisar migrations e persistência |
| [oidc-bff](../.agents/skills/oidc-bff/SKILL.md) | Trabalhar na identidade, sessão ou autorização |
| [anexos-s3](../.agents/skills/anexos-s3/SKILL.md) | Trabalhar em uploads e anexos de logs |
| [modelagem-uml](../.agents/skills/modelagem-uml/SKILL.md) | Conferir artefatos de domínio e diagramas |

No Codex, abra o monorepo e selecione a skill ou use o nome com `$`, como
`$padroes-componentes`. Se o cliente estiver aberto desde antes da instalação das
skills, inicie outra sessão. Também é possível indicar o caminho da skill ou de um
perfil no pedido. As regras Markdown orientam a sessão conforme os links de
`AGENTS.md` e as permissões efetivas vêm do cliente.

Para delegação explícita em um cliente Codex compatível, peça o agente pelo nome
do arquivo, como `goals-revisor`. Os agentes herdam o modelo e as permissões
da sessão. [Documentação de agentes do Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents).
