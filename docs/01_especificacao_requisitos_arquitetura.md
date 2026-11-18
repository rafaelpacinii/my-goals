# Especificação de Requisitos e Arquitetura de Software
**Projeto**: Plataforma de Gestão de Metas, Objetivos e Estatísticas (Open Source)

**Stack Principal**: Next.js (TypeScript / Tailwind CSS / shadcn/ui) + Quarkus (Java 17) + Keycloak (OIDC) + PostgreSQL + Object Storage compatível com S3 (SeaweedFS no ambiente local)

## 1. Visão Geral e Escopo do Produto

A aplicação é uma plataforma centralizada e **Open Source** de planejamento de vida, hábitos, finanças e evolução pessoal/profissional. O objetivo central é permitir que o usuário cadastre metas de qualquer natureza ou prazo — utilizando modelos prontos (*templates*) ou criando estruturas **100% personalizadas com múltiplas métricas** — acompanhe seu histórico rico de execução (com textos, fotos e múltiplos indicadores por registro), interligue metas dependentes e visualize sua consistência ao longo do tempo por meio de estatísticas e um calendário *heatmap*.

### 1.1 Atores e Agentes do Domínio
1. **Usuário (Proprietário / Criador)**: Ator principal que gerencia suas metas individuais, cria grupos de metas, registra *logs* de progresso, analisa estatísticas e convida outros usuários para grupos compartilhados.
2. **Membro Convidado (`EDITOR` ou `VIEWER`)**: Usuário autenticado que participa de um Grupo de Metas compartilhado. De acordo com a permissão definida pelo criador do grupo (`OWNER`), pode apenas visualizar o progresso (`VIEWER`) ou também registrar *logs* e editar metas do grupo (`EDITOR`).
3. **Keycloak (Identity Provider - IdP)**: Sistema externo responsável pela gestão de identidades, credenciais, emissão/renovação de tokens JWT OIDC e controle de sessões.
4. **Motor de Ciclos / Scheduler (Quarkus Cron)**: Agente interno automatizado que processa a virada de períodos (diário, semanal, mensal, anual e personalizado), arquiva o resultado do ciclo encerrado (`GoalCycleSnapshot`) e inicializa o novo ciclo.
5. **Object Storage compatível com S3**: Serviço responsável por guardar as imagens anexadas aos *logs* de progresso via URLs pré-assinadas (*Presigned URLs*). O ambiente local usa SeaweedFS.

## 2. Decisões Arquiteturais (Stack & Autenticação)

### 2.1 Arquitetura Next.js (BFF) + Quarkus (Resource Server & Auth Proxy) + Keycloak (Caminho B)
Para atender ao requisito de manter o protocolo **OpenID Connect (OIDC)** sem utilizar a interface visual padrão do Keycloak, a aplicação adota o modelo **BFF (Backend for Frontend) com Proxy de Autenticação no Quarkus**:

1. **Interface Própria de Autenticação (Next.js + Tailwind + shadcn/ui)**:
   * As telas de Login (`/login`), Cadastro (`/register`) e Recuperação de Senha (`/forgot-password`) são construídas nativamente no Next.js.
2. **Autenticação Server-to-Server (Direct Access Grants + Admin API)**:
   * No login, uma *Server Action* do Next.js envia as credenciais (via rede interna/HTTPS) para o endpoint `/api/v1/auth/login` do Quarkus.
   * O Quarkus atua como cliente confidencial perante o Keycloak, requisitando o endpoint `/protocol/openid-connect/token` (`grant_type=password`, enviando `client_id` e `client_secret`) via `quarkus-rest-client-jackson`.
   * Para criação de conta e recuperação de senha, o Quarkus se comunica com a **Keycloak Admin REST API** usando uma conta de serviço interna (`service-account`), mantendo o Keycloak totalmente oculto do navegador do usuário.
3. **Armazenamento Seguro de Sessão (Cookies `HttpOnly`)**:
   * O Quarkus devolve o `access_token` (JWT de curta duração, ex.: 5 min) e o `refresh_token` para o servidor do Next.js.
   * O Next.js armazena ambos em cookies `HttpOnly`, `Secure` e `SameSite=Lax` criptografados. Nenhum token JWT fica exposto ao JavaScript do navegador (`localStorage`/`sessionStorage`), prevenindo ataques XSS.
4. **Validação de Rotas Protegidas e Renovação Transparente (Refresh Token)**:
   * Nas requisições de páginas (*Server Components*) ou mutações (*Server Actions*), o Next.js verifica a validade do `access_token`. Se estiver próximo de expirar ou expirado, o próprio servidor Next.js aciona `/api/v1/auth/refresh` no Quarkus com o `refresh_token`, atualiza o cookie e repassa o novo cabeçalho `Authorization: Bearer <access_token>` para a API do Quarkus.
   * O Quarkus utiliza a extensão `quarkus-oidc` configurada como `service` para validar a assinatura do JWT localmente em sub-milissegundos via chaves públicas (JWKS) do Keycloak.
5. **Preparação para o Futuro App Mobile**:
   * Como toda a lógica de autenticação (`/api/v1/auth/*`) e regras de negócio (`/api/v1/goals/*`, `/api/v1/groups/*`, `/api/v1/analytics/*`) está centralizada na API REST do Quarkus, o futuro aplicativo mobile consumirá exatamente os mesmos endpoints do Quarkus (guardando os tokens no *Secure Enclave / Keystore* do sistema operacional móvel).

## 3. Modelagem das Regras de Negócio e Motor de Metas

### 3.1 Motor Flexível: Templates Padrões vs. Metas 100% Personalizadas
Em vez de tabelas rígidas por tipo de meta, toda meta (`Goal`) é governada por um **Comportamento de Acompanhamento (`TrackingType`)** combinado com **1 a N Definições de Métricas (`GoalMetricDefinition`)**.
* **Templates Padrões do Sistema (`GoalTemplate`)**: A aplicação oferece modelos pré-configurados que preenchem automaticamente a estrutura da meta (podendo ser editados pelo usuário antes de salvar):
  1. **Meta Financeira**: `TrackingType = ACCUMULATIVE`, Métrica Principal = `Valor (R$)`, Alvo = ex. `R$ 10.000,00`.
  2. **Perda de Peso / Medidas Corporais**: `TrackingType = TARGET_VARIATION`, Métrica 1 = `Peso (kg)` (com `initialValue = 85.0`, `targetValue = 78.0`), permitindo adicionar métricas extras no mesmo registro (ex.: `% Gordura`, `Cintura (cm)`).
  3. **Hábito / To-Do ("Fiz isso hoje")**: `TrackingType = BINARY`, concluído ou não concluído no ciclo.
  4. **Meta de Leitura**: `TrackingType = ACCUMULATIVE`, Métrica 1 = `Páginas lidas (páginas)` (Alvo = total de páginas do livro, somando o que foi lido a cada dia), podendo incluir métrica opcional `Tempo de leitura (min)`.
* **Metas 100% Personalizadas e Múltiplas Métricas por Meta**:
  * O usuário pode criar uma meta do zero, escolher o `TrackingType` (`BINARY`, `ACCUMULATIVE`, `TARGET_VARIATION` ou `FREQUENCY`) e adicionar **quantos campos de métrica (`GoalMetricDefinition`) desejar**.
  * **Exemplo Prático ("Correr 3x na semana")**:
    * Configuração base da meta: `TrackingType = FREQUENCY`, `Recurrence = WEEKLY`, `targetExecutions = 3` (correr 3 vezes por semana).
    * **Métrica 1**: `Distância` (Unidade: `km`, Tipo: `DECIMAL`, Obrigatório: `Sim`, Possui Alvo Semanal Opcional: `Sim/Não`).
    * **Métrica 2**: `Tempo de Treino` (Unidade: `min` ou `hh:mm:ss`, Tipo: `DURATION`, Obrigatório: `Não`, Possui Alvo: `Não`).
    * Cada métrica possui um papel de avaliação (`MetricEvaluationRole`):
      * `CONDITION_REQUIRED`: Conta para o cálculo percentual de sucesso da meta no ciclo.
      * `INFORMATIONAL_ONLY`: Apenas coleta dados em cada *log* para alimentar gráficos de evolução (ex.: gráfico de pace/tempo ou km total), sem penalizar a porcentagem de conclusão da meta caso o usuário apenas cumpra as 3 corridas semanais.

### 3.2 Logs de Progresso Ricos (`GoalLog`)
Cada vez que o usuário registra um avanço ou *check-in* em uma meta, é criado um `GoalLog` contendo:
* **Valores das Métricas (`GoalLogMetricValue` 0..N)**: Os valores correspondentes a cada métrica configurada na meta (ex.: `5.4 km` e `31 min`).
* **Descrição / Diário (`description`)**: Texto livre (suportando Markdown básico) para o usuário relatar como foi a execução, observações ou reflexões do dia.
* **Imagens Anexadas (`GoalLogAttachment` 0..N)**: Fotos comprobatórias ou de registro visual (ex.: foto do painel da esteira, foto da refeição, *print* do aporte financeiro, evolução física), enviadas via *Presigned URL* para o Object Storage.

### 3.3 Metas Correlacionadas / Interligadas (`GoalLink`)
Uma meta-origem (`sourceGoal`) pode alimentar automaticamente uma ou mais metas-destino (`targetGoal`) por meio de dois modos de propagação (`LinkPropagationMode`):
1. **`SUM_VALUE` (Soma Matemática Direta)**: Quando ambas possuem métricas de mesma unidade (ex.: lançar `+R$ 600` na meta mensal *"Aporte de Novembro"* incrementa automaticamente `+R$ 600` na meta anual *"Investir R$ 10.000 no ano"*).
2. **`PERCENTAGE_WEIGHT` (Composição Percentual Ponderada)**: Quando uma meta maior é composta por submetas de naturezas ou unidades diferentes (ex.: meta *"Saúde em Dia"* composta por 40% *"Correr 3x/semana"*, 30% *"Beber 3L de água/dia"* e 30% *"Dormir 8h"*). O progresso da meta-pai é atualizado automaticamente pela média ponderada do progresso das metas-filhas.
* **Prevenção de Ciclos (DAG)**: O backend valida a criação de vínculos garantindo que o grafo de metas seja um **Grafo Acíclico Dirigido (DAG)**, impedindo loops infinitos (`Meta A -> Meta B -> Meta A`).

### 3.4 Recorrência, Arquivamento de Ciclos e Calendário Heatmap
* **Ciclos suportados**: `DAILY`, `WEEKLY`, `MONTHLY`, `YEARLY`, `CUSTOM_PERIOD` (a cada X dias) e `ONE_TIME` (prazo único com data inicial e final).
* **Arquivamento Automático (`GoalCycleSnapshot`)**: Ao término de cada ciclo recorrente, o sistema calcula o percentual final atingido (`0%` a `100%+`), salva um registro histórico imutável contendo os valores consolidados daquele período e reinicia a contagem para o novo ciclo.
* **Calendário Geral e por Grupo (Heatmap)**:
  * Calcula o índice de cumprimento das metas ativas em cada **Dia**, **Semana**, **Mês** ou **Ano**.
  * Classifica cada célula do calendário em faixas visuais de cor conforme a porcentagem de conclusão das metas previstas para aquele período:
    * **Faixa Crítica (`0% – 10%`)**: Não seguiu as metas estabelecidas.
    * **Faixa Baixa (`11% – 40%`)**: Adesão baixa.
    * **Faixa Moderada (`41% – 70%`)**: Adesão parcial.
    * **Faixa Alta (`71% – 99%`)**: Quase todas as metas cumpridas.
    * **Faixa Completa (`100%`)**: Todas as metas do período concluídas.

### 3.5 Grupos de Metas e Compartilhamento com Controle de Permissão
* Um **Grupo de Metas (`GoalGroup`)** reúne diversas metas escolhidas pelo usuário (ex.: grupo *"Saúde"* contendo meta de água, dieta e corrida) e gera um **painel estatístico consolidado do grupo**.
* **Compartilhamento e Permissões (`GoalGroupMember`)**:
  * O criador do grupo (`OWNER`) pode convidar outros usuários da plataforma para o grupo e definir individualmente a permissão de cada convidado:
    * **`VIEWER` (Somente Leitura)**: Pode visualizar as metas do grupo, os *logs* (descrições/fotos) e as estatísticas consolidadas, sem poder editar metas ou inserir *logs*.
    * **`EDITOR` (Edição e Contribuição)**: Pode registrar novos *logs* de progresso e editar metas dentro do grupo compartilhado, além de visualizar todas as estatísticas.

## 4. Catálogo de Requisitos Funcionais (RF)

| ID | Épico | Requisito Funcional | Prioridade |
| :--- | :--- | :--- | :--- |
| **RF01** | Autenticação e Conta | O sistema deve permitir o cadastro, login, logout e recuperação de senha de usuários através de interface própria no Next.js integrada via Quarkus ao Keycloak. | Essencial |
| **RF02** | Autenticação e Conta | O sistema deve renovar automaticamente a sessão do usuário via `refresh_token` armazenado em cookie `HttpOnly` sem interromper a navegação. | Essencial |
| **RF03** | Gestão de Metas | O sistema deve permitir a criação de metas a partir de *Templates Padrões* (Financeira, Peso/Medidas, Hábito/To-Do, Leitura) ou no modo *100% Personalizado*. | Essencial |
| **RF04** | Gestão de Metas | O sistema deve permitir configurar a categoria (Financeira, Pessoal, Profissional ou customizada) e a periodicidade da meta (Diária, Semanal, Mensal, Anual, Personalizada ou Prazo Único). | Essencial |
| **RF05** | Gestão de Metas | O sistema deve permitir que o usuário adicione uma ou mais métricas personalizadas (`GoalMetricDefinition`) a uma mesma meta (ex.: frequência semanal + distância em km + tempo em minutos), definindo quais métricas são obrigatórias no *log* e quais entram no cálculo de conclusão da meta. | Essencial |
| **RF06** | Metas Correlacionadas | O sistema deve permitir vincular metas correlacionadas/interligadas (`GoalLink`) escolhendo entre agregação por soma direta de valor (`SUM_VALUE`) ou peso percentual (`PERCENTAGE_WEIGHT`), bloqueando dependências circulares. | Essencial |
| **RF07** | Registro de Progresso (Logs) | O sistema deve permitir que o usuário registre *logs* de progresso em uma meta informando os valores das métricas configuradas, uma descrição em texto e o anexo de uma ou mais imagens. | Essencial |
| **RF08** | Registro de Progresso (Logs) | O sistema deve propagar automaticamente o progresso registrado em uma meta-filha para todas as metas-pai vinculadas a ela e recalcular seus percentuais em tempo real. | Essencial |
| **RF09** | Ciclos e Histórico | O sistema deve encerrar automaticamente os ciclos de metas recorrentes (diárias, semanais, mensais, anuais), arquivar o resultado consolidado (`GoalCycleSnapshot`) para consulta histórica e iniciar o próximo ciclo zerado. | Essencial |
| **RF10** | Grupos e Compartilhamento | O sistema deve permitir criar, editar e excluir Grupos de Metas para organizar objetivos afins e consolidar suas estatísticas. | Essencial |
| **RF11** | Grupos e Compartilhamento | O sistema deve permitir que o criador de um Grupo de Metas (`OWNER`) compartilhe o grupo com outros usuários definindo a permissão como Somente Visualização (`VIEWER`) ou Edição/Contribuição (`EDITOR`). | Secundário |
| **RF12** | Estatísticas e Heatmap | O sistema deve exibir um Calendário Geral e por Grupo (*Heatmap*) nas visões Diária, Semanal, Mensal e Anual, colorindo cada período conforme a faixa percentual de conclusão das metas (`0–10%`, `11–40%`, `41–70%`, `71–99%`, `100%`). | Essencial |
| **RF13** | Estatísticas e Heatmap | O sistema deve exibir painéis estatísticos específicos conforme as métricas da meta selecionada (evolução financeira, curva de peso/medidas, páginas lidas por dia, distância x tempo/pace, taxa de consistência e *streak* atual/máximo). | Essencial |
| **RF14** | Registro de Progresso (Logs) | O sistema deve exibir a linha do tempo (*timeline*) de *logs* de uma meta com galeria das imagens enviadas, descrições e métricas registradas em cada data. | Secundário |

## 5. Catálogo de Requisitos Não Funcionais (RNF)

| ID | Categoria | Requisito Não Funcional | Critério Técnico de Aceite |
| :--- | :--- | :--- | :--- |
| **RNF01** | Segurança | Os tokens OIDC (`access_token` e `refresh_token`) nunca devem ser expostos ao JavaScript do navegador. | Armazenamento exclusivo em cookies `HttpOnly`, `Secure`, `SameSite=Lax` gerenciados pela camada BFF do Next.js. |
| **RNF02** | Segurança | A API Quarkus deve validar todas as requisições protegidas de forma *stateless* via assinatura JWT e verificar permissões de propriedade/grupo (`OWNER`, `EDITOR`, `VIEWER`). | Uso de `quarkus-oidc` validando tokens via endpoint JWKS do Keycloak e verificação de RBAC/ACL no nível de serviço. |
| **RNF03** | Portabilidade / API-First | Toda regra de negócio, autenticação e cálculo estatístico deve residir no backend Quarkus via API REST padronizada (OpenAPI 3.0). | O Next.js atua estritamente como BFF/UI, permitindo que o futuro aplicativo mobile consuma a mesma API sem retrabalho no backend. |
| **RNF04** | Desempenho | O carregamento do Dashboard e do Calendário Heatmap deve responder em menos de 300ms no backend sob carga normal. | Uso de tabela pré-agregada de ciclos (`GoalCycleSnapshot`) e índices compostos por `(user_id, reference_date)` no PostgreSQL. |
| **RNF05** | Escalabilidade de Mídia | O upload de imagens nos *logs* não deve sobrecarregar a memória da API Quarkus nem o banco de dados relacional. | O Quarkus gera *Presigned URLs* para upload direto ao Object Storage compatível com S3, salvando os metadados e a chave do arquivo no PostgreSQL. A assinatura usa o endereço acessível ao navegador. |
| **RNF06** | Confiabilidade e Fuso Horário | O fechamento de ciclos diários/semanais/mensais deve respeitar o fuso horário configurado no perfil do usuário (ex.: `America/Araguaina`). | Armazenamento de timestamps em UTC (`TIMESTAMPTZ`) e avaliação de virada de ciclo baseada no `timezone` do usuário. |
| **RNF07** | Manutenibilidade | O banco de dados deve ter versionamento automatizado de schema e o código deve seguir tipagem estrita nas duas pontas. | Uso de Flyway no Quarkus e TypeScript (`strict: true`) + validação Zod no Next.js. |
| **RNF08** | Usabilidade | A interface web deve ser responsiva (Desktop e Mobile Web), suportar tema claro/escuro e seguir padrões de acessibilidade WAI-ARIA. | Construção com componentes `shadcn/ui` (Radix UI) + Tailwind CSS. |

## 6. Requisitos Organizacionais e Governança Open Source (GitHub Flow)

* **RO01 — Fluxo de Branches (GitHub Flow)**: O repositório adotará apenas a branch `main` como branch de longa duração, sempre em estado estável. Novas funcionalidades e correções devem ser desenvolvidas em branches curtas (`feat/*`, `fix/*`, `docs/*`, `chore/*`) e integradas via Pull Request com *Squash and Merge*.
* **RO02 — Padrão de Commits e Releases**: Todos os commits na `main` devem seguir o padrão *Conventional Commits* (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`), utilizando *Git Tags* com Versionamento Semântico (`vX.Y.Z`) para lançamentos oficiais.
* **RO03 — Segurança de Configuração e Contribuição**: Versione `application.properties` com referências a variáveis de ambiente e `.env.example` com valores públicos de demonstração. Mantenha credenciais reais fora do Git e das imagens. Qualquer contribuidor pode iniciar o ambiente pelo comando do [README](../README.md).
* **RO04 — Monorepo e Portabilidade**: API, web, infraestrutura, documentos, regras e skills são mantidos no mesmo Git. O `compose.yaml` orquestra a pilha de desenvolvimento com PostgreSQL, Keycloak, SeaweedFS, Quarkus e Next.js. A web acessa a API pela rede interna. O navegador usa a web como BFF e acessa o storage por URL pré-assinada quando o caso de uso exigir.
* **RO05 — Planejamento e Verificação**: Issues definem o escopo, a ordem e os critérios de aceite. Milestones agrupam entregas por data. PRs para `main` incluem o vínculo com a issue e as verificações. Consulte o [planejamento](07-planejamento-github.md).

## 7. Estado da fundação técnica

O Compose provisiona o PostgreSQL da aplicação, um realm local do Keycloak e um bucket S3 local. A API prepara validação de JWT via JWKS e configura o Flyway. O Next.js tem uma página inicial e um Route Handler que consultam a prontidão da API no servidor. O setup ainda não inclui clientes de login, conta de serviço, migrations de domínio nem fluxo de anexos. Os requisitos e diagramas descrevem a implementação planejada.
