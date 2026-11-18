# User Stories (INVEST) e Casos de Uso (Alto Nível e Expandidos)
**Projeto**: Plataforma de Gestão de Metas, Objetivos e Estatísticas

**Metodologia**: Hierarquia de Quebra de Requisitos (Épico → RF → Caso de Uso → User Story → Critérios de Aceite)

O [planejamento das issues](07-planejamento-github.md) vincula estas histórias aos marcos de entrega.

## 1. Mapa da Hierarquia de Requisitos

1. **Épico 1: Identidade, Autenticação BFF e Segurança (Keycloak + Quarkus + Next.js)**
   - `RF01`, `RF02` → `UC01.1 Autenticar Usuário`, `UC01.2 Cadastrar Conta`, `UC01.3 Renovar Sessão (Refresh Token)`
2. **Épico 2: Motor de Metas (Templates Padrões, 100% Personalizadas e Múltiplas Métricas)**
   - `RF03`, `RF04`, `RF05` → `UC02.1 Criar Meta via Template`, `UC02.2 Criar Meta Personalizada Multi-Métrica`, `UC02.3 Editar/Arquivar Meta`
3. **Épico 3: Correlação de Metas e Propagação de Progresso**
   - `RF06`, `RF08` → `UC03.1 Vincular Metas Correlacionadas`, `UC03.2 Propagar Progresso em Cascata`
4. **Épico 4: Diário de Progresso (Logs com Múltiplas Métricas, Texto e Imagens) e Ciclos**
   - `RF07`, `RF09`, `RF14` → `UC04.1 Registrar Log de Progresso`, `UC04.2 Anexar Imagens ao Log`, `UC04.3 Encerrar e Arquivar Ciclo Recorrente`
5. **Épico 5: Grupos de Metas e Compartilhamento Colaborativo**
   - `RF10`, `RF11` → `UC05.1 Gerenciar Grupo de Metas`, `UC05.2 Compartilhar Grupo e Definir Permissões (Viewer/Editor)`
6. **Épico 6: Estatísticas Dinâmicas e Calendário Heatmap**
   - `RF12`, `RF13` → `UC06.1 Consultar Calendário Heatmap de Consistência`, `UC06.2 Visualizar Estatísticas Específicas por Meta/Grupo`

## 2. User Stories (Padrão INVEST) e Critérios de Aceite (Gherkin)

### Épico 1 — Autenticação e Sessão
* **US01 — Login Nativo via BFF e Quarkus (RF01)**
  * **História**: Como **usuário**, eu quero **realizar login diretamente na interface da aplicação (sem ser redirecionado para a página padrão do Keycloak)**, para que **eu tenha uma experiência visual fluida e segura**.
  * **Critério de Aceite 1 (Sucesso)**: *Dado que* estou na tela `/login` do Next.js, *quando* informo e-mail e senha válidos e confirmo, *então* o backend Quarkus autentica minhas credenciais no Keycloak via OIDC Direct Grant, o Next.js armazena os tokens em cookie `HttpOnly` e sou redirecionado ao Dashboard.
  * **Critério de Aceite 2 (Credenciais Inválidas)**: *Dado que* informei uma senha incorreta, *quando* submeto o formulário, *então* o sistema exibe mensagem de erro clara mantendo o e-mail preenchido sem expor detalhes internos do Keycloak.

* **US02 — Renovação Transparente de Token (RF02)**
  * **História**: Como **usuário autenticado**, eu quero **que minha sessão seja renovada automaticamente em segundo plano enquanto utilizo o sistema**, para que **eu não perca dados ao preencher um log após 5 minutos de navegação**.
  * **Critério de Aceite**: *Dado que* meu `access_token` expirou mas meu `refresh_token` no cookie `HttpOnly` ainda é válido, *quando* realizo qualquer ação ou carregamento de página no Next.js, *então* a camada BFF solicita um novo par de tokens ao Quarkus/Keycloak, atualiza o cookie e conclui minha requisição sem exigir novo login.

### Épico 2 — Motor de Metas (Templates e 100% Personalizadas)
* **US03 — Criação Rápida por Templates Padrões (RF03, RF04)**
  * **História**: Como **usuário**, eu quero **escolher entre templates prontos (Financeira, Peso/Medidas, Hábito "Fiz Hoje" ou Leitura)** ao criar uma meta, para que **eu possa configurar metas comuns em poucos segundos**.
  * **Critério de Aceite**: *Dado que* seleciono o template "Meta de Leitura", *quando* informo o título do livro, o número total de páginas (ex.: 350) e o prazo, *então* o sistema cria a meta com comportamento acumulativo (`ACCUMULATIVE`) e métrica principal em `páginas`, pronta para receber lançamentos diários de páginas lidas.

* **US04 — Criação de Meta 100% Personalizada com Múltiplas Métricas (RF03, RF04, RF05)**
  * **História**: Como **usuário**, eu quero **criar uma meta personalizada definindo sua frequência e adicionando múltiplos campos de métricas (como distância em km e tempo gasto)**, para que **eu possa rastrear todas as variáveis importantes do meu objetivo no mesmo registro**.
  * **Critério de Aceite 1 (Frequência + Métricas Informativas)**: *Dado que* estou criando a meta "Correr 3x na semana" com periodicidade Semanal e alvo de 3 execuções, *quando* adiciono a métrica "Distância (km)" e a métrica "Tempo (min)" marcadas como informativas (`INFORMATIONAL_ONLY`), *então* minha meta semanal atinge 100% ao completar 3 corridas na semana, enquanto os valores de `km` e `tempo` alimentam gráficos específicos da meta.
  * **Critério de Aceite 2 (Frequência + Métricas com Alvo Obrigatório)**: *Dado que* na mesma meta "Correr 3x na semana" eu defino que a métrica "Distância (km)" também possui alvo obrigatório de `15 km` na semana (`CONDITION_REQUIRED`), *quando* corro 3 vezes totalizando `10 km`, *então* o sistema calcula o progresso combinando a frequência (`3/3 = 100%`) e a distância (`10/15 = 66,7%`), exibindo `83,3%` de conclusão.

### Épico 3 — Metas Correlacionadas / Interligadas
* **US05 — Vínculo de Metas Correlacionadas (RF06, RF08)**
  * **História**: Como **usuário**, eu quero **interligar uma meta menor (ex.: mensal ou semanal) a uma meta maior (ex.: anual ou projeto)**, para que **o progresso registrado na meta menor atualize automaticamente a meta maior**.
  * **Critério de Aceite 1 (Soma Direta)**: *Dado que* vinculei a meta mensal "Guardar R$ 1.000 em Novembro" à meta anual "Reserva de R$ 12.000" no modo Soma (`SUM_VALUE`), *quando* registro um log de `+R$ 400` na meta mensal, *então* o saldo atual da meta anual também é incrementado em `+R$ 400`.
  * **Critério de Aceite 2 (Bloqueio de Ciclo)**: *Dado que* a Meta A já alimenta a Meta B, *quando* tento configurar a Meta B para alimentar a Meta A, *então* o sistema impede o vínculo e exibe alerta de dependência circular.

### Épico 4 — Logs Ricos (Métricas + Descrição + Imagens) e Ciclos Recorrentes
* **US06 — Registro de Log com Múltiplos Valores, Descrição e Fotos (RF07, RF14)**
  * **História**: Como **usuário**, eu quero **registrar um log em uma meta preenchendo suas métricas, escrevendo uma descrição do dia e anexando fotos**, para que **eu mantenha um histórico detalhado e visual da minha evolução**.
  * **Critério de Aceite**: *Dado que* acesso a meta "Correr 3x na semana", *quando* clico em "Novo Log", preencho `5,2 km`, `27 min`, escrevo "Treino leve no parque" e anexo uma foto do relógio/aplicativo, *então* o sistema faz o upload seguro da imagem, salva o log, atualiza o progresso da semana de `1/3` para `2/3` e exibe o registro na timeline da meta.

* **US07 — Arquivamento Automático de Ciclos Recorrentes (RF09)**
  * **História**: Como **usuário**, eu quero **que minhas metas diárias, semanais, mensais e anuais arquivem automaticamente o resultado ao final de cada período e reiniciem para o novo ciclo**, para que **eu acompanhe minha consistência histórica sem precisar recriar metas repetitivas**.
  * **Critério de Aceite**: *Dado que* possuo uma meta diária "Beber 3L de água" e atingi `2,4L (80%)` na terça-feira, *quando* o dia vira no meu fuso horário, *então* o sistema grava o snapshot de terça-feira com `80%` no histórico, atualiza o calendário de terça-feira e zera a meta para `0L / 3L` na quarta-feira.

### Épico 5 — Grupos de Metas e Compartilhamento
* **US08 — Criação de Grupo e Estatísticas Consolidadas (RF10)**
  * **História**: Como **usuário**, eu quero **agrupar várias metas em um Grupo (ex.: "Saúde" ou "Finanças 2027")**, para que **eu possa visualizar estatísticas reunidas apenas daquelas metas**.
  * **Critério de Aceite**: *Dado que* criei o grupo "Saúde" e associei as metas "Beber 3L de água", "Seguir dieta" e "Correr 3x na semana", *quando* acesso a página do grupo, *então* visualizo a média de cumprimento e o calendário heatmap filtrado exclusivamente pelas metas desse grupo.

* **US09 — Compartilhamento de Grupo com Controle de Permissão (RF11)**
  * **História**: Como **criador de um grupo de metas**, eu quero **compartilhar o grupo com outro usuário escolhendo se ele poderá apenas visualizar (`VIEWER`) ou também editar/lançar logs (`EDITOR`)**, para que **eu possa tanto mostrar meu progresso a alguém quanto construir metas em conjunto**.
  * **Critério de Aceite 1 (Permissão Viewer)**: *Dado que* compartilhei o grupo com um usuário com perfil `VIEWER`, *quando* ele acessa o grupo, *então* ele visualiza metas, gráficos e logs, mas os botões de "Novo Log" e "Editar Meta" ficam ocultos e bloqueados na API Quarkus (`HTTP 403`).
  * **Critério de Aceite 2 (Permissão Editor)**: *Dado que* compartilhei o grupo com perfil `EDITOR`, *quando* o convidado registra um log em uma meta do grupo, *então* o log é salvo identificando o autor do lançamento e atualiza o progresso compartilhado do grupo.

### Épico 6 — Calendário Heatmap e Estatísticas
* **US10 — Calendário Heatmap de Consistência (RF12)**
  * **História**: Como **usuário**, eu quero **visualizar um calendário colorido por faixas de porcentagem (nos modos Diário, Semanal, Mensal e Anual)**, para que **eu identifique rapidamente em quais períodos segui ou deixei de seguir minhas metas**.
  * **Critério de Aceite**: *Dado que* acesso a visão geral de Estatísticas, *quando* seleciono a visualização Diária do mês atual, *então* cada dia exibe a cor correspondente à porcentagem média de conclusão das metas ativas naquele dia (ex.: vermelho/cinza para `0–10%` até verde intenso para `100%`), e ao clicar em um dia vejo o detalhamento de quais metas foram cumpridas ou falharam.

## 3. Casos de Uso de Alto Nível (Classificação de Importância)

| ID | Nome do Caso de Uso | Tipo (Importância) | Atores Envolvidos | Breve Descrição (Alto Nível) |
| :--- | :--- | :--- | :--- | :--- |
| **UC01.1** | Autenticar Usuário | **Primário (Essencial)** | Usuário, Keycloak IdP | O usuário informa e-mail e senha na interface Next.js; o Quarkus valida junto ao Keycloak via OIDC, retornando tokens salvos em cookie `HttpOnly`. |
| **UC02.2** | Criar Meta Personalizada Multi-Métrica | **Primário (Essencial)** | Usuário | O usuário define título, categoria, periodicidade, tipo de cálculo e adiciona 1 ou mais métricas customizadas (com unidade, obrigatoriedade e alvo opcional). |
| **UC03.1** | Vincular Metas Correlacionadas | **Primário (Essencial)** | Usuário | O usuário conecta uma meta de origem a uma meta de destino definindo a regra de propagação (soma direta ou peso percentual). |
| **UC04.1** | Registrar Log de Progresso | **Primário (Essencial)** | Usuário / Editor, Object Storage | O usuário seleciona uma meta, preenche os valores das métricas do dia, adiciona descrição textual e fotos, atualizando o progresso da meta e de suas correlacionadas. |
| **UC04.3** | Encerrar e Arquivar Ciclo Recorrente | **Primário (Essencial)** | Scheduler (Quarkus Cron) | O sistema identifica metas cujo ciclo (diário/semanal/mensal/anual) encerrou, salva o snapshot percentual no histórico e reinicia o ciclo atual. |
| **UC06.1** | Consultar Calendário Heatmap e Estatísticas | **Primário (Essencial)** | Usuário / Viewer | O usuário visualiza o mapa de calor por dia/semana/mês/ano com faixas percentuais de adesão e gráficos específicos por métrica ou grupo. |
| **UC05.2** | Compartilhar Grupo de Metas | **Secundário** | Usuário (Owner), Membro Convidado | O criador do grupo convida outro usuário e atribui permissão de leitura (`VIEWER`) ou edição (`EDITOR`), podendo alterar ou revogar o acesso a qualquer momento. |

## 4. Casos de Uso Expandidos (Fluxos Críticos do Sistema)

### UC01.1 — Autenticar Usuário via BFF/Quarkus no Keycloak
* **Ator Principal**: Usuário
* **Ator Secundário**: Keycloak IdP
* **Tipo**: Primário, Essencial
* **Pré-condições**: Usuário não possui sessão ativa válida; container/serviço do Keycloak e API Quarkus estão operacionais.
* **Pós-condições**: Sessão autenticada criada com `access_token` e `refresh_token` armazenados em cookie `HttpOnly` no Next.js; usuário redirecionado ao painel principal.
* **Fluxo Principal (Caminho Feliz)**:
  1. O Usuário acessa a rota `/login` na aplicação Next.js.
  2. O Sistema (Next.js) apresenta o formulário próprio de login (construído com Tailwind/shadcn).
  3. O Usuário preenche `email` e `senha` e aciona o botão "Entrar".
  4. O Next.js executa uma *Server Action* validando o formato dos campos (Zod) e envia requisição `POST /api/v1/auth/login` para o Quarkus.
  5. O Quarkus valida a requisição e realiza chamada HTTP para o endpoint `/realms/{realm}/protocol/openid-connect/token` do Keycloak com `grant_type=password`, `client_id`, `client_secret`, `username` e `password`.
  6. O Keycloak valida as credenciais, gera o `access_token` (JWT), `refresh_token` e `expires_in`, e retorna ao Quarkus.
  7. O Quarkus sincroniza o registro básico do usuário na tabela local `users` (caso seja o primeiro login) e devolve os tokens para a *Server Action* do Next.js.
  8. O Next.js grava os tokens em cookies `HttpOnly`, `Secure`, `SameSite=Lax` e redireciona o Usuário para `/dashboard`.
* **Fluxos Alternativos**:
  * **4a. Campos inválidos no formulário**: O Next.js interrompe o envio e destaca os campos obrigatórios na tela.
  * **6a. Usuário com conta pendente de verificação ou bloqueada**: O Keycloak retorna código de erro específico; o Quarkus traduz para resposta padronizada e o Next.js orienta o usuário na tela.
* **Fluxos de Exceção**:
  * **6e. Credenciais incorretas (`HTTP 401 Invalid user credentials`)**: O Quarkus retorna erro `401 Unauthorized`; o Next.js exibe "E-mail ou senha incorretos" e mantém o campo de e-mail preenchido.
  * **5e. Falha de comunicação com o Keycloak (`HTTP 503`)**: O Quarkus registra o erro de infraestrutura e retorna mensagem amigável de indisponibilidade temporária.

### UC02.2 — Criar Meta 100% Personalizada com Múltiplas Métricas
* **Ator Principal**: Usuário
* **Tipo**: Primário, Essencial
* **Pré-condições**: Usuário autenticado no sistema.
* **Pós-condições**: Meta criada no banco de dados junto com suas definições de métricas (`GoalMetricDefinition`), ciclo inicial aberto (`GoalCycleSnapshot` em andamento) e vínculos opcionais (`GoalLink`) registrados.
* **Fluxo Principal**:
  1. O Usuário seleciona a opção "Nova Meta" e escolhe o modo "Personalizada" (ou parte de um Template e clica em "Personalizar Campos").
  2. O Sistema exibe o construtor de metas dividido em: Dados Básicos, Periodicidade/Ciclo, Comportamento e Métricas, e Metas Correlacionadas.
  3. O Usuário informa título (ex.: *"Correr 3x na semana"*), categoria (ex.: *"Pessoal / Saúde"*), periodicidade (`WEEKLY`) e comportamento (`FREQUENCY` com alvo de `3 execuções`).
  4. O Usuário adiciona uma ou mais métricas personalizadas clicando em "Adicionar Métrica ao Log":
     - Métrica 1: Nome = `"Distância"`, Unidade = `"km"`, Tipo = `DECIMAL`, Obrigatória no log = `true`, Papel = `INFORMATIONAL_ONLY` (ou `CONDITION_REQUIRED` com alvo = `15 km`).
     - Métrica 2: Nome = `"Tempo"`, Unidade = `"min"`, Tipo = `DURATION`, Obrigatória no log = `false`, Papel = `INFORMATIONAL_ONLY`.
  5. Opcionalmente, o Usuário seleciona um Grupo de Metas (ex.: *"Saúde"*) e/ou uma Meta-Pai correlacionada.
  6. O Usuário confirma a criação da meta.
  7. O Sistema (Quarkus) valida a estrutura em transação única, verifica a ausência de loops de correlação, persiste a meta, suas métricas e inicializa o primeiro ciclo ativo.
  8. O Sistema redireciona o Usuário para a página da meta recém-criada.
* **Fluxos Alternativos**:
  * **1a. Criação rápida via Template Padrão**: O Usuário escolhe um template (ex.: "Meta Financeira" ou "Leitura"); o sistema pré-preenche o passo 3 e 4 automaticamente, permitindo salvar direto.
* **Fluxos de Exceção**:
  * **7e. Tentativa de vínculo com meta incompatível (ex.: `SUM_VALUE` entre unidades diferentes)**: O Quarkus rejeita a requisição (`HTTP 422`) informando que a soma direta exige métricas de mesma unidade, sugerindo o modo `PERCENTAGE_WEIGHT`.

### UC04.1 — Registrar Log de Progresso (Múltiplas Métricas, Descrição, Imagens e Propagação)
* **Ator Principal**: Usuário (Proprietário da meta ou Membro `EDITOR` do grupo)
* **Ator Secundário**: Object Storage compatível com S3 (SeaweedFS local)
* **Tipo**: Primário, Essencial
* **Pré-condições**: Usuário autenticado com permissão de escrita na meta; meta com status ativa.
* **Pós-condições**: Log persistido com valores de métricas, descrição e fotos; progresso do ciclo atual recalculado; metas correlacionadas atualizadas em cascata; índice do Calendário Heatmap atualizado.
* **Fluxo Principal**:
  1. O Usuário acessa a meta e aciona "Registrar Progresso (Novo Log)".
  2. O Sistema monta dinamicamente o formulário de log renderizando os campos de entrada para cada `GoalMetricDefinition` daquela meta (ex.: campo numérico para `km` e campo de duração para `Tempo`), além do campo de `Descrição` e área de upload de `Imagens`.
  3. O Usuário preenche os valores das métricas, digita a descrição do registro e seleciona uma ou mais imagens do seu dispositivo.
  4. Caso haja imagens selecionadas, o servidor Next.js solicita ao Quarkus (`POST /api/v1/uploads/presign`) URLs pré-assinadas e entrega URLs e chaves (`objectKey`) à interface. O navegador envia os arquivos direto ao Object Storage pelo endereço que foi assinado.
  5. O Next.js envia os dados consolidados do log (`POST /api/v1/goals/{id}/logs`) para o Quarkus.
  6. O Quarkus valida se todas as métricas obrigatórias daquela meta foram preenchidas, salva o `GoalLog`, os `GoalLogMetricValue` e os `GoalLogAttachment`.
  7. O Quarkus recalcula o percentual de conclusão do ciclo atual da meta.
  8. Caso a meta possua vínculos de saída (`GoalLink`), o Quarkus propaga o valor ou o novo percentual para as metas-pai correlacionadas e recalcula o progresso delas recursivamente.
  9. O Quarkus atualiza a agregação diária/periódica do Calendário Heatmap e retorna o estado atualizado para o Next.js.
* **Fluxos Alternativos**:
  * **3a. Log sem imagens ou sem descrição**: O fluxo pula o passo 4 e registra apenas as métricas e o timestamp do check-in.
  * **3b. Registro retroativo**: O Usuário informa uma `referenceDate` de um dia anterior dentro do ciclo; o sistema aloca o log na data informada e recalcula o Heatmap daquele dia específico.
* **Fluxos de Exceção**:
  * **4e. Arquivo de imagem excede limite de tamanho (ex.: > 10MB) ou formato inválido**: O sistema bloqueia o upload antes de persistir o log e avisa o usuário.
  * **6e. Usuário com permissão `VIEWER` tenta enviar requisição de log**: O Quarkus bloqueia a operação retornando `HTTP 403 Forbidden`.
