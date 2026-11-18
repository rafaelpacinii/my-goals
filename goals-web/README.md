# My Goals Web

Next.js App Router com TypeScript estrito, Tailwind CSS e shadcn/ui.
O servidor Next.js atua como BFF. `/api/health` consulta a prontidão do Quarkus
por `API_INTERNAL_URL`, que no Compose vale `http://api:8080`.

## Desenvolvimento

Use a pilha do [README da raiz](../README.md) para executar a aplicação em Docker.
Para trabalhar com recarga rápida, rode os comandos abaixo nesta pasta com Node 24
e npm 11. Com a API publicada em `http://localhost:8080`, a configuração padrão
já a encontra. Para outra porta, defina `API_INTERNAL_URL` no ambiente do Next.js.

O `Card` inicial do shadcn/ui está em `src/components/ui/`. Para adicionar
outras primitivas, consulte `components.json` e os padrões em [AGENTS.md](AGENTS.md).

```bash
npm ci
npm run dev
```

Use outra porta para o servidor de desenvolvimento se o serviço `web` do Compose
já ocupar a porta 3000, por exemplo `npm run dev -- --port 3001`.

## Verificação

```bash
npm run lint
npm run typecheck
npm run build
```

Na raiz do monorepo, `docker build --target check ./goals-web` executa lint e
tipagem sem instalar Node na máquina. Consulte [AGENTS.md](AGENTS.md) para
componentes e organização por rota.
