---
name: padroes-componentes
description: "Implemente ou revise componentes Next.js ou código Quarkus com a estrutura e as convenções de escrita do My Goals."
---

# Padrões de código

Leia as regras do módulo afetado e examine arquivos vizinhos. A organização do
Next.js segue o Decor Fest. A da API segue o MouseTrap, com os tipos e contratos
do domínio do My Goals.

## Next.js

- Leia [goals-web/AGENTS.md](../../../goals-web/AGENTS.md). Use `app/` para
  entradas do App Router, `components/<rota>/` para UI de rota, `shared/` para
  componentes que atendem várias rotas e `ui/` para primitivas do design system.
  Exemplo de composição: `app/goals/page.tsx` → `components/goals/goals-page.tsx`.
- Use função nomeada e export nomeado para componentes do projeto. Deixe o
  export default para entradas do Next.js. Prefira props pequenas e tipadas,
  aliases `@/`, `import type` e imports relativos para partes do mesmo diretório.
- Limite cada `.tsx` em `src/` a **70 linhas físicas**, inclusive layout,
  loading, error e código gerado pelo shadcn. Separe UI com responsabilidade
  própria, lógica React em `hooks/`, serviços e contratos externos em `lib/`,
  funções puras em `utils/` e tipos reutilizados em `types/`. Preserve a
  formatação, os exports públicos e o comportamento ao dividir arquivos.
- Use Server Components para leituras e `'use client'` na menor fronteira
  que precisa de eventos, estado ou APIs do navegador. Em páginas, mantenha
  JSX de composição. Preserve semântica, estados e navegação por teclado.
  Confira lint, tipagem e build.

## Quarkus

- Leia [goals-api/AGENTS.md](../../../goals-api/AGENTS.md). Organize `resource`
  → interface e implementação em `service` → `repository` → `model` sob
  `br.com.pacini`. Use `dto`, `exception`, `config`, `client` e `job`
  quando houver código para esses papéis.
- Declare endpoints em recursos JAX-RS curtos, com media type, validação e
  política de acesso explícitas. Injete dependências via CDI e mantenha a
  implementação do serviço em `@ApplicationScoped`. Service concentra as
  regras e escreve em métodos `@Transactional`. Use queries parametrizadas
  em repositórios Panache e `PanacheRepositoryBase<T, UUID>` para entidades UUID.
- Use records de entrada com Bean Validation e records de saída com mapeamento
  explícito, como `valueOf`. Use entidades com campos privados e acessores,
  chaves e tipos definidos no PlantUML. Preserve o erro REST em
  `application/problem+json` quando o contrato do recurso o adotar.
- Escreva métodos legíveis, com imports explícitos, parâmetros descritivos e
  anotações separadas. Espelhe pacotes em `src/test/java` e valide o contrato
  na fronteira HTTP com JUnit/REST Assured quando aplicável.
