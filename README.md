# My Goals

Plataforma de gestão de metas, hábitos e progresso pessoal. O repositório reúne
a interface Next.js, a API Quarkus, a infraestrutura local e a documentação do
produto.

## Subir o ambiente

Na raiz do projeto, com Docker Engine ou Docker Desktop e o plugin Compose V2:

```bash
docker compose --env-file .env.example up --build --wait
```

O primeiro build baixa imagens e dependências. As portas são publicadas apenas
em loopback. No Windows, execute no PowerShell ou habilite a integração do
Docker Desktop com a distribuição WSL em que o repositório está aberto.

| Serviço | Acesso local |
| --- | --- |
| Next.js | [localhost:3000](http://localhost:3000) |
| Quarkus | [Prontidão](http://localhost:8080/q/health/ready) e [Swagger UI](http://localhost:8080/q/swagger-ui/) |
| Keycloak | [Console](http://localhost:8180), com usuário e senha de demonstração em [`.env.example`](.env.example) |
| SeaweedFS | Endpoint S3 em `http://localhost:8333`, bucket `goals-log-attachments` |
| PostgreSQL | `db:5432` na rede interna do Compose |

Para verificar e encerrar a pilha:

```bash
bash scripts/smoke-local.sh
docker compose --env-file .env.example down
```

O smoke test usa Bash, Python 3 e curl com suporte a `--aws-sigv4`. Os volumes
nomeados preservam o PostgreSQL, o realm local e o bucket após o `down`.
Para trocar portas ou credenciais, copie `.env.example` para `.env`, edite a
cópia e execute `docker compose up --build --wait`. Exporte as mesmas variáveis
na sessão Bash para testar uma configuração personalizada.

O perfil documentado é local. O Keycloak usa `start-dev` e as credenciais do
exemplo são públicas. As imagens recebem segredos por configuração de runtime.
O realm de desenvolvimento, o bucket e o roteamento web/API já fazem parte do
setup. As features de identidade, metas e anexos estão no planejamento.

## Estrutura e contribuição

| Pasta | Conteúdo |
| --- | --- |
| [`goals-api/`](goals-api/) | API Quarkus, Java 17, Maven Wrapper e Flyway |
| [`goals-web/`](goals-web/) | Next.js App Router, Node 24, npm, Tailwind e shadcn/ui |
| [`infra/`](infra/) | Configuração dos serviços locais |
| [`docs/`](docs/) | Requisitos, casos de uso, PlantUML e planejamento |
| [`.agents/`](.agents/) | Skills, regras por assunto e perfis |

- [Especificação e arquitetura](docs/01_especificacao_requisitos_arquitetura.md)
- [Planejamento e GitHub Flow](docs/07-planejamento-github.md)
- [Guia de agentes](docs/08-governanca-ia.md)
- [Tarefa em andamento](TASK.md)
