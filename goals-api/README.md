# My Goals API

API Java 17 com Quarkus, PostgreSQL e Flyway. Consulte o
[README da raiz](../README.md) para subir o Compose com os serviços locais,
incluindo Keycloak e o storage S3.

## Configuração de runtime

[application.properties](src/main/resources/application.properties) define
chaves públicas e referências a variáveis. O Compose fornece as variáveis de
runtime abaixo. Forneça endereços e credenciais do seu ambiente para rodar a
API fora do Compose.

| Finalidade | Variáveis |
| --- | --- |
| JDBC PostgreSQL | `DB_URL`, `DB_USER`, `DB_PASSWORD` |
| Validação OIDC | `KEYCLOAK_URL` para JWKS, `OIDC_ISSUER` para o claim `iss` e `OIDC_AUDIENCE` para `aud` |
| Futuro REST client de identidade | `KEYCLOAK_BASE_URL` |
| Futura integração S3 | `S3_ENDPOINT`, `S3_PUBLIC_ENDPOINT`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_BUCKET`, `S3_PATH_STYLE` |

As migrações versionadas vão em `src/main/resources/db/migration/`. O Hibernate
valida o schema e o Flyway o atualiza na inicialização. O banco inicial ainda
aguarda as migrações das entidades do domínio.

## Verificação

Na raiz, `docker build --target test ./goals-api` executa a suíte inicial no
contêiner. Como alternativa, rode `./mvnw -B verify` nesta pasta com Java 17.
A suíte inicial verifica a rota de exemplo com PostgreSQL e OIDC desativados no
perfil de teste. O smoke test da raiz usa os serviços reais do Compose.

A prontidão está em `/q/health/ready` e o OpenAPI em `/q/openapi`. Consulte
[AGENTS.md](AGENTS.md) para a estrutura das classes.
