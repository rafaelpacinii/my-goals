---
name: migracoes-postgresql
description: "Implemente ou revise migrations Flyway, entidades, consultas e concorrência no PostgreSQL do My Goals."
---

# Persistência e migrações

Leia o [modelo de domínio](../../../docs/04-diagrama-classes-dominio.puml) e o caso
de uso relevante. Adicione a próxima migration versionada em
`goals-api/src/main/resources/db/migration/`. Mantenha a cadeia já aplicada e
considere a atualização de banco com dados em uso. Mapeie constraints, incrementos
exatos, unicidade, chaves e instantes com fuso de acordo com o domínio.

Teste em PostgreSQL isolado tanto a criação do schema quanto o upgrade quando houver
versão anterior. Valide concorrência e isolamento por proprietário/grupo quando fizerem
parte do contrato. Documente a transição de dados e os checks realmente executados.
