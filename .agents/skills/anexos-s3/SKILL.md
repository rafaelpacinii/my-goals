---
name: anexos-s3
description: "Implemente ou revise uploads e leitura privada de imagens anexadas a logs com storage compatível com S3."
---

# Anexos de logs

Leia o caso de uso UC04.1 e o [diagrama de sequência](../../../docs/05-diagrama-sequencia-autenticacao-e-logs.puml).
A API valida acesso à meta antes de emitir URLs de curta duração. Use o endereço
acessível ao navegador na assinatura e a rede interna nas operações do SDK.
Ao confirmar o log, confira se as chaves pertencem àquele upload e à meta.
Guarde metadados no PostgreSQL e imagens no bucket privado.

Teste o caminho pelo navegador com origem permitida, chaves válidas, falha de
upload e tentativa de uso de chave de outro usuário. SeaweedFS é o storage S3 de
desenvolvimento. Valide a compatibilidade do provedor usado ao alterar a integração.
