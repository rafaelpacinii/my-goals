# Fundação do monorepo

Início em 17/11/2026. Consolidar a base local da API e da web, o ambiente
reproduzível e a estrutura de trabalho com agentes e GitHub.

- [x] Revisar requisitos, casos de uso, diagramas e referências Decor Fest e MouseTrap.
- [x] Preparar Next.js, Quarkus, PostgreSQL, Keycloak e storage S3 no Compose.
- [x] Aplicar o limite de 70 linhas TSX e documentar a organização Next.js e Quarkus.
- [x] Adicionar regras, oito skills, perfis de agentes e convenções do monorepo.
- [x] Preparar formulários de issue, template de PR, planejamento e workflow de verificação.
- [ ] Após disponibilizar o remoto, publicar a base e criar as issues e milestones.

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
em `main`. Assim que houver `origin`, siga o [planejamento](docs/07-planejamento-github.md)
para publicar a fundação e abrir a issue de revisão do fluxo OIDC.
