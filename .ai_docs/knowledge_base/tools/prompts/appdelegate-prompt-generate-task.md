<objetivo-principal>
    O objetivo principal agora é **GERAR um PLANO de implementação DETALHADO para a tarefa**, dividindo-a em subtarefas lógicas e sequenciais necessárias para a implementação completa.
    O plano de implementação deverá ser organizado no arquivo `current-work.md`, utilizando o template `@ai/templates/task-template.md` e seguindo meticulosamente as diretrizes do fluxo de trabalho RIPER.
    Atue como um planejador e **não gere código neste estágio**.
</objetivo-principal>

<descricao-da-tarefa>
Você é um especialista em arquitetura de apps iOS com experiência em Swift, SwiftUI, gerenciamento de rotas (protocolo antigo e NavigationCore) e integrações modulares. Elabore uma especificação técnica detalhada para finalizar o app “LivenessDetectionApp” usando Tuist. O app já foi iniciado e se encontra em `Integrity/Apps/LivenessDetectionApp` , a partir dos seguintes requisitos:

Visão geral: O objetivo do app é testar o fluxo completo do módulo LivenessDetection, validando a integração de
diferentes fornecedores (RecognitionKitFramework: selfie, mlKit, idemia, unico, allowMe). O app deverá possibilitar, a
cada sessão, a configuração de um fornecedor e mock de dados iniciais.

Fluxo Principal (“happy path”):

Tela Inicial (SwiftUI): Permitir ao usuário: a) Selecionar o fornecedor do fluxo de liveness b) Configurar dados
mockados para LivenessDetectionParams: consumer (enum) identifier (string) identifierType (enum AccessIdentifierType)
userSubType (enum) userFullName (string) externalId (string) shouldAllowReturning (bool) c) Salvar as configurações
mockadas como “template” nos UserDefaults, podendo reutilizá-las ou criar novas posteriormente Após configuração, botão
“Iniciar Liveness Detection” no final da tela Fluxo de Liveness: Ao iniciar, simular service response de acordo com o
fornecedor selecionado, usando o modelo: LivenessFlowControllerSettings, RecognitionKitFramework e IdemiaSettings Todas
as requisições do service devem ter sucesso, considerando o retorno necessário para o fluxo seguir Tela de Resultados
(SwiftUI): Listar todas as imagens recebidas no processo de liveness em um grid 2 colunas, com scroll Cada imagem: Ao
tocar, apresentar modal com metadados: tamanho, tipo, data, resolução Persistência: Dados mockados/template do usuário
(exceto imagens) devem ser salvos/carregados via UserDefaults Arquitetura & Navegação: Seguir estrutura/pastas já
iniciadas no projeto Tuist Navegação entre telas: tela inicial → fluxo liveness → tela resultado Utilize o protocolo de
rotas já utilizado no app para tela inicial e fluxo liveness Novas telas devem usar NavigationCore Especificidade
técnica:

Toda UI nova deve ser SwiftUI Simular integração dos modulos sem dependência de backend real Os enums, structs e classes
(LivenessDetectionParams, AccessIdentifierType, etc) seguem os modelos fornecidos Considerar extensibilidade para novos
fornecedores/templates Resultado esperado: Uma especificação técnica clara do fluxo “happy path”, detalhando telas,
modelos de dados, persistência, navegação (antigo e NavigationCore), tipos Swift a usar, e quaisquer validações/boas
práticas recomendadas para integração modular em Tuist. </descricao-da-tarefa>

<entregavel-esperado>
    - Um único arquivo `current-work.md` contendo:
        - O planejamento detalhado, com todas as subtarefas necessárias para a implementação/execução completa da tarefa.
        - Os critérios de aceitação, **cobrindo integralmente todos os requisitos da tarefa**.
        - **ADERÊNCIA** total às regras relevantes ao contexto da tarefa (`fetch_rules`), garantindo conformidade com os guidelines do projeto.
        - **RIGOROSAMENTE** todas as seções, subseções, estrutura e organização do template `@ai/templates/task-template.md`, da primeira a última linha.
    - Mensagem final com uma lista de dúvidas, ambiguidades ou suposições que precisam de esclarecimento ou confirmação antes da execução/implementação do plano.
</entregavel-esperado>

<restricoes>
    - **Não gere código.** Este prompt é exclusivamente para planejamento.
    - Certifique-se de que cada subtarefa seja uma **ação concreta e relativamente pequena**.
    - **Não remova nenhuma** das seções, subseções, estrutura ou organização do `task-template.md` ao gerar o `current-work.md`. Mantenha toda a estrutura do documento.
</restricoes>

<fluxo-de-trabalho-riper>
    <execucao-continua>
        - **IMPORTANTE:** Realize a análise e o planejamento da tarefa de forma **contínua e fluida** seguindo as etapas do fluxo de trabalho RIPER.
        - **NÃO precisa parar** após cada etapa para aguardar instruções. **Continue trabalhando até:**
            - ❓ Ter dúvidas específicas sobre os requisitos da tarefa que precisem de esclarecimento.
            - 🚧 Encontrar ambiguidades ou lacunas nos requisitos que impeçam um planejamento completo.
            - 🔄 Precisar de validação de decisões de arquitetura ou abordagem importantes antes de finalizar o plano.
            - Em qualquer um desses casos, **você deve perguntar ao usuário** para obter os insumos necessários para continuar.
    </execucao-continua>
    <etapa-01-research>
        - 🔍 **Research (Pesquisa):**
        - Compreenda a fundo e refine os requisitos da tarefa.
        - Identifique e leia as regras relevantes (`fetch_rules`) para garantir conformidade com os guidelines do projeto.
        - Consulte arquivos do Memory Bank na pasta `@ai/memorybank/` para contexto técnico e de negócio sobre o projeto.
        - Identifique ambiguidades nos requisitos ou decisões críticas que precisam de esclarecimento.
        - Leia o código existente relevante para a tarefa.
        - Entenda o código existente, os padrões já usados, possíveis soluções já implementadas, boas práticas adotadas, etc.
        - Identifique dependências e integrações necessárias.
    </etapa-01-research>
    <etapa-02-innovate>
        - 💡 **Innovate (Inovação):**
        - Realize brainstorming para identificar possíveis soluções e abordagens para a tarefa.
        - Analise prós e contras de cada abordagem, considerando aspectos como: impacto de negócio, segurança, escalabilidade, resiliência, performance, dependências, entre outros.
        - Explore trade-offs e alternativas consideradas.
    </etapa-02-innovate>
    <etapa-03-plan>
        - 🧠 **Plan (Planejamento):**
        - Confirme a abordagem a ser detalhada no `current-work.md`.
        - Defina como irá preencher cada seção do template.
        - **Divida a tarefa em subtarefas lógicas, pequenas, claras e sequenciais, cada uma representando uma ação concreta.**
        - Identifique notas relevantes e arquivos chaves que deverão ser incluídos na seção "Contexto de Curto Prazo".
    </etapa-03-plan>
    <etapa-04-execute>
        - ⚙️ **Execute (Execução - Geração do plano):**
        - Gere o conteúdo do `current-work.md` com base na análise feita.
        - Esta fase NÃO envolve a execução do planejamento. Apenas a criação do `current-work.md` com o plano detalhado.
        - Preencha todas as seções do template no `current-work.md` detalhadamente.
        - Para cada subtarefa planejada:
            - Liste-as na seção "Plano de Execução" do `current-work.md` usando checkboxes `[ ]`.
            - Defina os **Arquivos Envolvidos** (`@caminho/arquivo.extensao`).
            - Liste as **Dependências** (outras subtarefas, componentes externos).
            - Determine o **Status Atual** (e.g., "Pronta para execução", "Requer pesquisa adicional").
        - Adicione notas relevantes e arquivos chave na seção "Contexto de Curto Prazo" do `current-work.md`.
        - Inclua uma subtask para a atualização dos arquivos no `memorybanks` como uma subtarefa final, caso alguma alteração decorrente desta tarefa seja extremamente relevante para o contexto geral do projeto, ou algo que precisa ser recordado para futuras tarefas.
    </etapa-04-execute>
    <etapa-05-review>
        - ✅ **Review (Revisão):**
        - Verifique se o plano cobre todos os requisitos da tarefa.
        - Confirme que o plano está completo, claro e sem ambiguidades.
        - Valide a conformidade com as regras relevantes ao contexto da tarefa (`fetch_rules`).
        - Valide a conformidade com o template `@ai/templates/task-template.md`.
        - Certifique-se de que impactos e dependências estão mapeados e endereçados no plano.
    </etapa-05-review>
</fluxo-de-trabalho-riper>

<validacao-e-entrega>
    - Sinalize se o plano está pronto para execução, se precisa de validação adicional ou se há dúvidas (e quais são).
    - Liste as dúvidas, ambiguidades ou suposições que precisam de esclarecimento ou confirmação antes da execução/implementação do plano.
        - Atualize o `current-work.md` com base nas respostas do usuário.
    - Verifique se gerou os entregáveis conforme esperado e dentro das restrições estabelecidas.
</validacao-e-entrega>
