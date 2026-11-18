# My Goals web

Use App Router, Server Components por padrão, TypeScript estrito e `@/` para
imports a partir de `src/`. Leia o guia da versão de Next.js instalada antes de
usar APIs específicas do framework.

- Em `src/app/`, mantenha roteamento e orquestração. A UI de cada rota fica
  em `src/components/<rota>/`, com `home/` para a raiz. Layouts mantêm a
  estrutura obrigatória do Next.js.
- Use `components/shared/` para UI de negócio com reutilização real e `components/ui/`
  para primitivas shadcn/ui. Use kebab-case em arquivos e PascalCase em componentes.
- Todo arquivo `.tsx` em `src/` tem até **70 linhas**, incluindo imports,
  comentários e linhas em branco. Divida por responsabilidade e mantenha props,
  exports e acessibilidade ao adaptar componentes gerados. O ESLint verifica
  esse limite e as tags intrínsecas em `page.tsx`.
- Separe hooks React, integrações em `lib/`, tipos compartilhados em `types/`
  e funções puras em `utils/`. Marque módulos de servidor com `server-only`.
  Use os tokens de `app/globals.css` e valide dados externos com Zod na fronteira.
- A API Quarkus decide permissões e regras de domínio. Mantenha credenciais,
  tokens e a URL interna da API na camada de servidor.

Consulte [padrões de componentes](../.agents/skills/padroes-componentes/SKILL.md)
e rode lint, tipagem e build para mudanças que afetam o módulo.
