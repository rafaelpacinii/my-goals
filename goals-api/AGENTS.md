# My Goals API

Java 17 e Quarkus. Use o Maven Wrapper e as versões gerenciadas no `pom.xml`.

- Sob `br.com.pacini`, organize por camadas. `resource` cuida de HTTP,
  `service` de interfaces e implementações CDI, `repository` de consultas Panache,
  `model` de entidades, `dto` de contratos REST e `exception` de erros e mapeadores.
- Modele IDs, relações e tipos pelo diagrama de domínio. Use campos privados,
  acessores explícitos, records validados para DTOs e mapeamento explícito de saídas.
  As respostas REST usam DTOs.
- Aplique autorização por sujeito e pela relação com a meta ou grupo, de acordo
  com os casos de uso. As mutações e propagação pertencem a serviços transacionais.
- Migrações incrementais ficam em `src/main/resources/db/migration/`.
  Mantenha o Flyway como responsável pela evolução do schema e o Hibernate em validação.

Consulte [padrões de componentes](../.agents/skills/padroes-componentes/SKILL.md)
e [arquitetura](../.agents/rules/architecture.md). Para validar, use
`./mvnw -B verify` ou o estágio Docker `test`.
