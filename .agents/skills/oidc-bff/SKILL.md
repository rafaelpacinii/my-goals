---
name: oidc-bff
description: "Implemente ou revise identidade, sessão BFF, confiança OIDC e autorização por meta ou grupo no My Goals."
---

# OIDC e autorização

Leia a [especificação](../../../docs/01_especificacao_requisitos_arquitetura.md)
e o [diagrama de sequência](../../../docs/05-diagrama-sequencia-autenticacao-e-logs.puml).
Confirme o estado da issue de identidade para escolher o fluxo aprovado.
Use o emissor público para validar `iss`, o endpoint interno para descobrir chaves
e a audiência da API para validar `aud`. Vincule registros ao `sub` verificado.

Sessões permanecem na fronteira de servidor do BFF. Mantenha cookies de proteção
e valide autorização no Quarkus para cada operação de domínio. Ao testar, inclua o
caminho autenticado e os casos rejeitados por sessão, audiência, propriedade ou
papel de grupo aplicável. O realm inicial foi provisionado para infraestrutura.
