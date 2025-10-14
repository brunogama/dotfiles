<!--
🚨 NÃO COPIE ESTE COMENTÁRIO PARA A AI.

🚨 ATENÇÃO 1: USO RESPONSÁVEL DESTE PROMPT É CRUCIAL!

    ⚠️ Este prompt foi criado para auxiliar na geração automatizada de regras personalizadas (custom rules) para o Cursor IDE. No entanto, é fundamental entender que a criação ideal dessas regras deve ser feita por desenvolvedores humanos, com conhecimento profundo do projeto e senso crítico técnico.

    ⚠️ Embora a IA possa identificar padrões e sugerir boas práticas, ela também pode acabar reforçando padrões ruins presentes no código, especialmente em projetos com baixa qualidade técnica ou inconsistência estrutural. Por isso:

    🔍 As regras geradas devem ser revisadas cuidadosamente antes de serem aplicadas.
    🔍 Este prompt deve ser utilizado preferencialmente por desenvolvedores com alta senioridade, que conheçam bem o projeto e sejam capazes de julgar se as regras fazem sentido ou não.

    💡 O uso consciente e criterioso deste prompt é essencial para garantir que as regras geradas realmente contribuam para a qualidade e consistência do projeto.

🚨 ATENÇÃO 2: ANTES DE USAR ESTE PROMPT, GERE O MEMORY BANK!

    🔍 É fundamental gerar um Memory Bank utilizando o prompt @prompt-generate-memorybank.md. Este passo é um pré-requisito essencial para garantir que a IA tenha um contexto melhor sobre o projeto.

    - Revise o Memory Bank e confirme que as informações contidas nele estão corretas.
    - Fique à vontade para adicionar informações que julgar necessárias ao Memory Bank.
    - Se perceber que algumas informações do Memory Bank estão incorretas, corrija-as ou remova-as.

🚨 ATENÇÃO 3: Recomenda-se usar CLAUDE 4 SONNET THINKING para executar este prompt.

    - Ao finalizar o prompt, será criado um arquivo chamado `current-work.md` com o planejamento da tarefa.
    - Em seguida, você pode executar o prompt `prompt-execute-task.md` para executar o plano de execução.
    - Em ambos os casos, use CLAUDE 4 SONNET THINKING.
-->

<objetivo-principal>
    O objetivo principal agora é **GERAR um PLANO de implementação DETALHADO para a tarefa**, dividindo-a em subtarefas lógicas e sequenciais necessárias para a implementação completa.
    O plano de implementação deverá ser organizado no arquivo `current-work.md`, utilizando o template `@ai/templates/task-template.md` e seguindo meticulosamente as diretrizes do fluxo de trabalho RIPER.
    Atue como um planejador e **não gere código neste estágio**.
</objetivo-principal>

<entregavel-esperado>
    - Um único arquivo `current-work.md` contendo:
        - O planejamento detalhado, com todas as subtarefas necessárias para a implementação/execução completa da tarefa.
        - Os critérios de aceitação, **cobrindo integralmente todos os requisitos da tarefa**.
        - **RIGOROSAMENTE** todas as seções, subseções, estrutura e organização do template `@ai/templates/task-template.md`, da primeira a última linha.
        - Especificação completa do conteúdo do arquivo de regras e exemplo completo de arquivo de regra. Isso é necessário pois o `current-work.md` será a única fonte da verdade no decorrer do processo de desenvolvimento.
    - Mensagem final com uma lista de dúvidas, ambiguidades ou suposições que precisam de esclarecimento ou confirmação antes da execução/implementação do plano.
</entregavel-esperado>

<restricoes>
    - **Não gere código.** Este prompt é exclusivamente para planejamento.
    - Certifique-se de que cada subtarefa seja uma **ação concreta e relativamente pequena**.
    - **Não remova nenhuma** das seções, subseções, estrutura ou organização do `task-template.md` ao gerar o `current-work.md`. Mantenha toda a estrutura do documento.
</restricoes>

<descricao-da-tarefa>
    <contexto>
        - O Cursor IDE é um ambiente de desenvolvimento baseado no Visual Studio Code, mas com foco em integração com inteligência artificial.
        - Para que o Cursor tenha um melhor resultado, é importante criarmos regras customizadas que instruam a IA a se comportar e gerar código de forma alinhada as boas práticas e padrões de cada projeto.
        - Assim, precisamos gerar um conjunto de regras que ajudem a IA a gerar código mais consistente e alinhado com os padrões reais do projeto atual.
    </contexto>
    <fontes-de-informacao>
        - Utilize o conteúdo da pasta `@ai/memorybank/` como fonte de contexto, mas lembre-se de complementar com sua própria análise do código.
        - Analise a estrutura de pastas, nomes e conteúdos dos arquivos.
        - Identifique frameworks, bibliotecas e tecnologias utilizadas.
        - Observe padrões de nomenclatura e estilo de código.
        - Analise as regras já existentes para entender o estilo, padrões e instruções já existentes. Para isso, use `fetch_rules`.
    </fontes-de-informacao>
    <objetivo-das-regras>
        - Promover consistência no estilo de código e testes.
        - Ajudar a IA a gerar código alinhado com o projeto, **sem reforçar más práticas**.
        - Se identificar padrões ruins, **não os transforme em regras**. Em vez disso, documente no final da resposta quais padrões foram descartados e por quê.
        - Se houver incertezas, indique claramente que a sugestão foi feita com base limitada.
    </objetivo-das-regras>
    <escopo-das-regras>
        - Foque em regras para código-fonte e testes (se existirem).
        - Ignore regras para documentação, versionamento, CI/CD, etc.
    </escopo-das-regras>
    <o-que-evitar>
        - Frases genéricas como “escreva código limpo” ou “use boas práticas”.
        - Regras que reforcem padrões ruins, mesmo que já estejam presentes no projeto.
        - Regras que contradigam regras já existentes. Caso seja necessário ler alguma regra, use `fetch_rules`.
        - Regras que contradigam o estilo predominante do projeto sem justificativa técnica.
        - **Não remova regras existentes**. Se o projeto já tiver regras, **mantenha todas** e apenas adicione novas.
        - **Evite** tratar todas as regras como se fossem sempre aplicadas (ex: `alwaysApply: true`).
    </o-que-evitar>
    <organizacao-arquivos-de-regras>
        - Múltiplos arquivos de regras criados na pasta `.cursor/rules/project-specific-rules/`
        - Múltiplos arquivos de regras em formato markdown com extensao .mdc
        - Adapte-se à stack do projeto (Java, React, Python, .NET, etc.) para definir quais arquivos de regras devem ser criados.
        - Gere múltiplos arquivos de regras separados, **por exemplo**:
            - Uma para controllers.
            - Uma para testes.
            - Uma para camada de negócio (ex: service, use case, flow, workflow, etc).
        - NÃO misture regras distintas no mesmo arquivo. Na dúvida, separe-as em arquivos distintos.
        - O nome dos arquivos **devem obedecer ao seguinte padrão**:
            - <nome-da-regra>-always.mdc (para regras que devem ser aplicadas sempre)
            - <nome-da-regra>.mdc (para demais regras que não sejam aplicadas sempre)
    </organizacao-arquivos-de-regras>
    <cabecalho-do-arquivo-de-regras>
        - Cada arquivo **deve incluir um cabeçalho** que contenha os campos `description`, `globs` e `alwaysApply`.
            - `description`: descrição da regra e quando ela deve ser aplicada. Se `alwaysApply=false`, é obrigatório definir a description. Se `alwaysApply=true`, a description deve ficar em branco.
            - `globs`: Opcional. Caminhos específicos separados por vírgula.
            - `alwaysApply`: Obrigatório. false ou true.
        - O cabeçalho define como a regra será aplicada pelo Cursor IDE nas interações com o usuário:
            - Se a regra precisa ser aplicada somente em paths específicos, use `globs` e defina os paths. Caso contrário, deixe em branco.
            - Se a regra precisa ser aplicada somente em situações específicas, explique a regra e a situação a ser aplicada no campo `description`.
            - Se a regra precisa ser aplicada sempre em qualquer arquivo, código ou tarefa, use `alwaysApply: true`. Caso contrário, `alwaysApply: false`.
        - Defina o campo `description` seguindo o template: `MUST BE APPLIED WHEN planning, creating or modifying <CONCISE TERM UPPER CASE>. Full description goes here...`.
    </cabecalho-do-arquivo-de-regras>
    <exemplo-cabecalho-com-globs>
        ---
        description: MUST BE APPLIED WHEN planning, creating or modifying Java UNIT TESTS. Covers Java-specific patterns including test coverage, mocks, assertions, and best practices for writing tests.
        globs: **/*Test.java, **/test/**/*.java
        alwaysApply: false
        ---
    </exemplo-cabecalho-com-globs>
    <exemplo-cabecalho-somente-description>
        ---
        description: MUST BE APPLIED WHEN planning, creating or modifying RESILIENCY patterns like retry, circuit breaker, etc.
        globs:
        alwaysApply: false
        ---
    </exemplo-cabecalho-somente-description>
    <exemplo-cabecalho-always-apply-true>
        ---
        description:
        globs:
        alwaysApply: true
        ---
    </exemplo-cabecalho-always-apply-true>
    <conteudo-do-arquivo-de-regras explanation="Depois do cabeçalho, cada arquivo **deve seguir ESTRITAMENTE a estrutura padrão abaixo**. IMPORTANTE: As tags XML-like **DEVEM** ser em inglês. O conteúdo dentro das tags pode ser em outro idioma se preferir, mas inglês é o padrão.">
        <rule-name> <!-- Replaces the Main Heading (Heading 1) -->

````
    <context>
    <!-- This section is optional. If there is no context, remove it. -->
    <!-- Use this section to explain ESSENTIAL concepts, principles, or details necessary to understand the mandatory and prohibited practices. -->
    <!-- Generally, this section is not needed. Complementary information usually goes in the 'helpful-notes' section. -->
    </context>

    <mandatory-practices icon="✅">
    <!-- Required Section. -->
    <!-- Communicate directly and imperatively. -->
    <!-- Each practice should be a bullet point. -->
    <!-- Keywords in UPPERCASE. -->
    <!-- If necessary, group practices by theme using indentation. -->
    </mandatory-practices>

    <prohibited-practices icon="❌">
    <!-- Required Section. -->
    <!-- Communicate directly and imperatively. -->
    <!-- Each practice should be a bullet point. -->
    <!-- Keywords in UPPERCASE. -->
    <!-- If necessary, group practices by theme using indentation. -->
    </prohibited-practices>

    <helpful-notes>
    <!-- Optional section. If there are no helpful notes, use: No helpful notes yet. -->
    <!-- Use this section to explain secondary/complementary information. -->
    <!-- Normally used for details that are not obvious in the code, such as principles, decisions, internal functionalities, etc. -->
    </helpful-notes>

    <configuration>
    <!-- Optional section. If there is no configuration, use: No extra configuration. -->
    <!-- Use this section to explain configurations necessary to use the code explained by the rule. -->
    <!-- Normally used for things like dependencies, plugins, tools, etc. -->
    </configuration>

    <examples>

    <!-- Optional section. If there are no examples, use: No examples yet. -->
    <!-- Use this section to explain good and bad examples of the rule, especially code examples. -->

    <good-examples icon="✅">

    </good-examples>

    <bad-examples icon="❌">

    </bad-examples>

    </examples>

    <proprietary-code-details>
    <!-- Optional section. If there are no proprietary code details, remove it. -->
    <!-- Normally used to extend code examples with proprietary code details, focusing on outlines of classes/interfaces/enums/types/etc with method/function signatures. -->
    </proprietary-code-details>

    </rule-name>
</conteudo-do-arquivo-de-regras>

<exemplo-completo-arquivo-regra>
    ---
    description: MUST BE APPLIED WHEN planning, creating or modifying SCHEDULED JOBS. Key components include @Scheduled, @SchedulerLock, ShedLock, @MarketplaceScheduled, arch.marketplace.routine.service.JobService.
    globs:
    alwaysApply: false
    ---

    <scheduled-jobs-rules>

    <mandatory-practices icon="✅">
    - IMPLEMENT the `arch.marketplace.routine.service.JobService` interface.
    - USE the `@MarketplaceScheduled` annotation to configure the job's execution.
    - ADD the `@SchedulerLock` annotation to prevent concurrent executions.
    </mandatory-practices>

    <prohibited-practices icon="❌">
    - DO NOT use `@Scheduled` directly. Prefer `@MarketplaceScheduled`.
    - DO NOT create jobs without the `@SchedulerLock` annotation.
    </prohibited-practices>

    <helpful-notes>
    - **Concurrency Control:** `MarketplaceScheduled` has concurrency control and ensures that only one pod will execute the job at a time (lockTimeout + DynamoDB).
    </helpful-notes>

    <configuration>

    ### Maven Dependency
    ```xml
    <dependency>
    <groupId>inter</groupId>
    <artifactId>arch-marketplace-routine-micronaut</artifactId>
    <version>${arch.marketplace.version}</version>
    </dependency>
    ```
    </configuration>

    <examples>

    <good-examples icon="✅">
    ```java
    @Singleton
    @MarketplaceScheduled(cron = "${routine.my-job.cron}", description = "Description for my job.")
    public class MyJob implements JobService {

        @Override
        @SchedulerLock(name = "MyJob_execute", lockAtMostFor = "10m")
        public void execute() {
            // Job logic here
        }
    }
    ```
    </good-examples>

    <bad-examples icon="❌">
    ```java
    @Singleton
    @Scheduled(cron = "${routine.my-job.cron}") // PROHIBITED: Using @Scheduled directly
    public class MyJob implements JobService {

        @Override
        // PROHIBITED: Missing @SchedulerLock
        public void execute() {
            // Job logic here
        }
    }
    ```
    </bad-examples>

    </examples>

    <proprietary-code-details>
    ```java
    @Target({ElementType.METHOD})
    public @interface MarketplaceScheduled {
    String cron() default "";
    String fixedDelay() default "";
    String initialDelay() default "";
    String fixedRate() default "";
    String lockTimeout();
    }
    ```
    </proprietary-code-details>

    </scheduled-jobs-rules>
</exemplo-completo-arquivo-regra>
````

</descricao-da-tarefa>

<fluxo-de-trabalho-riper>
    <execucao-continua>
        - **IMPORTANTE:** Realize a análise e o planejamento da tarefa de forma **contínua e fluida** seguindo as etapas do fluxo de trabalho RIPER.
        - **NÃO precisa parar** após cada etapa para aguardar instruções. **Continue trabalhando até:**
            - ❓ Ter dúvidas específicas sobre os requisitos da tarefa que precisem de esclarecimento.
            - 🚧 Encontrar ambiguidades ou lacunas nos requisitos que impeçam um planejamento completo.
            - 🔄 Precisar de validação de decisões de arquitetura ou abordagem importantes antes de finalizar o plano.
            - Em qualquer um desses casos, você deve perguntar ao usuário para obter os insumos necessários para continuar.
    </execucao-continua>
    <etapa-01-research>
        - 🔍 **Research (Pesquisa):**
        - Compreenda a fundo e refine os requisitos da tarefa.
        - Identifique ambiguidades nos requisitos ou decisões críticas que precisam de esclarecimento.
        - Identifique e leia as regras relevantes (`fetch_rules`) para evitar contradições e garantir conformidade com os guidelines do projeto.
        - Consulte arquivos do Memory Bank na pasta `@ai/memorybank/` para contexto técnico e de negócio sobre o projeto.
        - Avalie a estrutura do projeto (pastas, nomes de arquivos, tecnologias, frameworks) para identificar padrões relevantes.
        - Entenda o código existente, os padrões já usados, possíveis soluções já implementadas, boas práticas adotadas, etc.
    </etapa-01-research>
    <etapa-02-innovate>
        - 💡 **Innovate (Inovação):**
        - Realize brainstorming para identificar possíveis soluções e abordagens para a tarefa, por exemplo, diferentes formas de organizar as regras
        - Analise prós e contras de cada abordagem, considerando aspectos como: granularidade das regras (regras genéricas vs. específicas), quantidade de instruções por regra, clareza e objetividade das instruções, etc.
        - Explore trade-offs e alternativas consideradas.
    </etapa-02-innovate>
    <etapa-03-plan>
        - 🧠 **Plan (Planejamento):**
        - Confirme a abordagem a ser detalhada no `current-work.md`.
        - Defina os arquivos de regras que serão criados, seus nomes e o escopo de cada regra.
        - **Planeje o cabeçalho de acordo com a forma de aplicar cada regra**:
            - A regra deve ser aplicada somente em situações específicas? Explique a regra e a situação a ser aplicada no campo `description`. Se aplicável, defina o `globs` para o caminho específico.
            - A regra deve ser aplicada sempre em qualquer arquivo, código, tarefa? Se sim, use `alwaysApply: true`. Caso contrário, `alwaysApply: false`.
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
            - Defina o **cabeçalho** de cada arquivo de regra.
            - Liste as **Dependências** (outras subtarefas, componentes externos).
            - Determine o **Status Atual** (e.g., "Pronta para execução", "Requer pesquisa adicional").
        - Adicione notas relevantes e arquivos chave na seção "Contexto de Curto Prazo" do `current-work.md`.
        - Inclua uma subtask para a atualização ou criação de novos arquivos no `memorybanks` como uma subtarefa final.
    </etapa-04-execute>
    <etapa-05-review>
        - ✅ **Review (Revisão):**
        - Verifique se o plano cobre todos os requisitos da tarefa.
        - Confirme que o plano está completo, claro e sem ambiguidades.
        - Valide que todos os arquivos `.mdc` planejados seguem o padrão de nomenclatura.
        - Garanta que os cabeçalhos dos arquivos estão consistentes com o padrão de cabeçalhos.
        - Observe que nenhuma regra existente foi removida ou sobrescrita.
        - Verifique que más práticas NÃO foram transformadas em regras.
        - Valide a conformidade com as regras relevantes ao contexto da tarefa (`fetch_rules`).
        - Valide a conformidade com o template `@ai/templates/task-template.md`.
        - Certifique-se de que os arquivos de regras gerados estão em conformidade com a seção `<conteudo-do-arquivo-de-regras>`.
        - Certifique-se de que impactos e dependências estão mapeados e endereçados no plano.
    </etapa-05-review>
</fluxo-de-trabalho-riper>

<validacao-e-entrega>
    - Sinalize se o plano está pronto para execução, se precisa de validação adicional ou se há dúvidas (e quais são).
    - Liste as dúvidas, ambiguidades ou suposições que precisam de esclarecimento ou confirmação antes da execução/implementação do plano.
        - Atualize o `current-work.md` com base nas respostas do usuário.
    - Verifique se gerou os entregáveis conforme esperado e dentro das restrições estabelecidas.
    - Atenção especial aos critérios de aceitação da tarefa que cobrem `organizacao-arquivos-de-regras`, `cabecalho-do-arquivo-de-regras`, `conteudo-do-arquivo-de-regras` e `exemplo-completo-arquivo-regra`.
</validacao-e-entrega>
