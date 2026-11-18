# Planejamento no GitHub

Issues são a fonte do backlog. Registre na issue o objetivo, os critérios de aceite,
as dependências, as referências de requisitos e a pessoa responsável. Agrupe entregas
em milestones com vencimento e use o estado e as dependências para ordenar o trabalho.
Use [TASK.md](../TASK.md) para acompanhar apenas a entrega em andamento.

## Backlog inicial

As janelas abaixo são propostas em relação à publicação do repositório. Converta
cada janela em data de milestone quando confirmar a disponibilidade da equipe.

| Ordem | Milestone e janela proposta | Issues a abrir | Dependências |
| --- | --- | --- | --- |
| 0 | Fundação · dia da publicação | Definir a licença, publicar a base, associar o Git remoto, habilitar Issues e squash, exigir a verificação do PR em `main` | Repositório acessível no GitHub |
| 1 | Identidade · primeira semana | Validar a decisão de OIDC; implementar login, conta, logout e renovação de sessão (RF01–RF02); vincular o perfil por `sub` | Fundação |
| 2 | Primeiras metas · segunda semana | Migrar o núcleo de metas e métricas; implementar criação personalizada e templates iniciais (RF03–RF05) | Identidade |
| 3 | Progresso e ciclos · terceira e quarta semanas | Registrar logs e timeline (RF07, RF14); aceitar anexos via S3 (RF07); fechar ciclos e persistir histórico (RF09) | Primeiras metas |
| 4 | Correlação e grupos · quinta semana | Vincular metas e propagar sem ciclos (RF06, RF08); criar grupos e validar papéis (RF10–RF11) | Progresso |
| 5 | Estatísticas · sexta semana | Calcular heatmap, consistência e gráficos por meta ou grupo (RF12–RF13) | Histórico e grupos |

### Primeira issue de produto

**Título sugerido**  Revisar a arquitetura da autenticação OIDC

- Comparar o fluxo documentado de Direct Access Grants com Authorization Code + PKCE e
  tela do Keycloak com tema próprio, incluindo o impacto no visual do login e no futuro app móvel.
- Registrar o fluxo aprovado e atualizar RF01–RF02, casos de uso e diagrama de sequência.
- Especificar configuração de client, audiência, autorização inicial, sessão e seus cenários de teste.

O grant de senha aparece na especificação original e fica para revisão antes da
implementação de identidade. A referência de segurança é a
[RFC 9700, seção 2.4](https://www.rfc-editor.org/rfc/rfc9700.html#section-2.4).

## Fluxo de entrega

1. Escolha a issue pendente de maior prioridade com dependências atendidas. Defina
   milestone, pessoa responsável e critérios verificáveis.
2. Com `main` atualizada, abra uma branch curta como `feat/42-goal-templates`,
   `fix/43-cycle-timezone`, `docs/*` ou `chore/*`.
3. Abra PR para `main` e informe o resultado, as verificações e mudanças de
   ambiente, contrato ou dados. Use `Closes #42` ao concluir a issue e
   `Refs #42` para entregas parciais.
4. Faça *Squash and Merge* após revisão e verificação. O título do PR deve formar um
   Conventional Commit em inglês. Use tags `vX.Y.Z` para releases.

Use os formulários [Entrega](../.github/ISSUE_TEMPLATE/entrega.yml) e
[Erro](../.github/ISSUE_TEMPLATE/bug.yml) e o [template de PR](../.github/pull_request_template.md).
No primeiro envio, publique o commit inicial em `main` para criar a base dos PRs futuros.
Configure a verificação obrigatória e as opções de merge quando houver um repositório remoto.

Referências do GitHub sobre [milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/creating-and-editing-milestones-for-issues-and-pull-requests)
e [fechamento de issues por PR](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue).
