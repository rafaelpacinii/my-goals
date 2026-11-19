# CI por arquivos alterados

Limitar as verificações de PR e push aos módulos afetados e corrigir a falha
de inicialização do Maven Wrapper no GitHub Actions.

- [x] Corrigir o download do Maven em imagens de build com cache vazio.
- [x] Selecionar verificações de API, web e integração pelo diff completo.
- [x] Validar seleção, workflow e os estágios Docker afetados.
- [ ] Confirmar a execução completa no primeiro PR com o workflow atualizado.

## Evidências da CI

- O seletor passou em 14 cenários de diff, incluindo PR, push com múltiplos
  commits, movimentação entre módulos, documentação e base indisponível.
- `actionlint` validou o workflow. O Docker da API passou em `mvnw verify`
  com cache do Maven vazio e um teste bem-sucedido.
- Os estágios Docker `check` e `build` da web passaram. O smoke test em um
  projeto Compose isolado confirmou a web, a API, o realm OIDC e o bucket S3.

## Fundação do monorepo

Início em 17/11/2026. Consolidar a base local da API e da web, o ambiente
reproduzível e a estrutura de trabalho com agentes e GitHub.

- [x] Revisar requisitos, casos de uso, diagramas e referências Decor Fest e MouseTrap.
- [x] Preparar Next.js, Quarkus, PostgreSQL, Keycloak e storage S3 no Compose.
- [x] Aplicar o limite de 70 linhas TSX e documentar a organização Next.js e Quarkus.
- [x] Adicionar regras, oito skills, perfis de agentes e convenções do monorepo.
- [x] Preparar formulários de issue, template de PR, planejamento e workflow de verificação.
- [x] Publicar a fundação na `main`.
- [ ] Criar as issues e milestones do planejamento.

## Evidências

- Quarkus via Maven Wrapper e estágio Docker `test`. Um teste da rota HTTP passou.
  O teste do artefato empacotado segue opt-in no POM. O Compose usa o artefato JVM.
- Next.js com lint, tipagem e build de produção. As regras do lint mantêm as páginas
  como entradas de composição. O teste da regra aceitou 70 linhas e rejeitou 71.
  Com a API indisponível, a página exibiu o estado e o Route Handler respondeu 503.
- Compose em Docker Desktop com os cinco serviços saudáveis nas portas padrão.
  Prontidão, OpenAPI 3.0.4, comunicação web/API, realm OIDC e acesso assinado ao
  bucket verificados. O bucket recusou acesso anônimo.
- PlantUML, actionlint e validador oficial das oito skills passaram localmente.

## Decisões e próximo passo

SeaweedFS é o provedor S3 local. Configuração da API é versionada com referências
a variáveis e o Compose publica portas em loopback. O Git local foi inicializado
em `main` e a fundação foi publicada. O primeiro CI parou no download do Maven.
Depois de validar o CI atualizado, siga o [planejamento](docs/07-planejamento-github.md)
para abrir a issue de revisão do fluxo OIDC.
