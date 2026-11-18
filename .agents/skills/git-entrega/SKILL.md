---
name: git-entrega
description: "Prepare ou revise os comandos Git e GitHub CLI e os textos de commit e PR em cada entrega do My Goals, inclusive após ajustes antes do commit."
---

# Entrega com GitHub Flow

1. Leia o [fluxo do projeto](../../../docs/07-planejamento-github.md) e confira a branch,
   o remoto configurado e a issue ou PR existente. Em toda entrega e após cada ajuste,
   consulte `git status --short --branch --untracked-files=all`, `git diff --cached`,
   `git diff` e leia os arquivos novos relevantes. Verifique todos os caminhos que
   aparecerem. Inspecione arquivos privados apenas pelo status/caminho e omita seus valores.
2. Cruze os diffs com o escopo solicitado. Para arquivos com alterações mistas,
   sugira `git add -p -- caminho` e cite os trechos da entrega. Inclua remoções e
   renomeações no staging seletivo. Se o índice já tiver material de outro trabalho,
   informe o conflito e prepare uma separação explícita antes de sugerir o commit.
3. Atualize resumo, título, corpo e comandos com todos os arquivos que entrarão na
   entrega atual. Verifique `git diff --check` e `git diff --cached --check` conforme a
   árvore. Cite os testes executados e seus resultados reais. Use Conventional Commits
   em inglês e título compatível com o squash em `main`.
4. Forneça comandos executáveis em blocos separados para base/branch quando necessário,
   seleção/conferência/commit, push e PR. Para atualizar a base, use
   `git switch main` e `git pull --ff-only origin main` com a árvore em estado adequado.
   Se for o primeiro commit com `main` sem histórico, explique o bootstrap antes de
   sugerir branches ou PRs. Use `git add -- <caminhos>`,
   `git diff --cached --name-status`, `git diff --cached --check` e `git diff --cached`
   antes de `git commit -m "type(scope): imperative description"`.
5. Para PR novo, proponha `git push -u origin <branch>` e
   `gh pr create --base main --head <branch> --title <título> --body-file <arquivo>`.
   Forneça o corpo Markdown com resultado, verificações e impacto, e
   `Closes #N` quando o PR conclui a issue. Para PR existente, use seu número e
   indique `gh pr edit` se título ou escopo mudou. `gh pr checkout` recupera um PR
   para revisão local quando pedido. Verifique se a branch já existe antes de sugerir
   criação ou troca. Se faltar remoto, indique o passo necessário com URL fornecida
   pelo usuário antes de comandos remotos.
6. A entrega desta skill é a preparação dos comandos. Execute staging, commit,
   push, criação/edição de PR e merge somente com autorização para a operação respectiva.
