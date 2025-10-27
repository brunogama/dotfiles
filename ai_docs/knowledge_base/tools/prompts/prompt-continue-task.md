<objetivo-principal>
    O objetivo principal agora é **atualizar** o estado atual no `current-work.md` com as informações relevantes aprendidas durante a execução que possam ser úteis para futuras subtarefas ou para o contexto geral do projeto e também com as observações importantes logo abaixo, se existirem.

```
Após isso, você deve **continuar a execução das subtarefas**, uma de cada vez, até finalizar a tarefa por completo, seguindo meticulosamente as diretrizes do **fluxo de trabalho RIPER para cada subtarefa**.
```

</objetivo-principal>

<observacoes-importantes>
[Caso existam observações importantes a serem adicionadas após o início da execução das subtarefas, elas aparecerão aqui]
</observacoes-importantes>

<restricoes>
    - **Não invente ou adicione mudanças além do planejado na subtarefa, exceto se o usuário solicitar ou se for estritamente necessário para implementar a tarefa.**
    - **Não remova nenhuma das seções, subseções, estrutura e organização do `current-work.md` ao atualizá-lo**. Mantenha toda a estrutura do documento.
</restricoes>

<fluxo-de-trabalho-riper>
    <execucao-continua>
        - **IMPORTANTE:** Execute as subtarefas de forma **contínua e fluida** seguindo as etapas do fluxo de trabalho RIPER.
        - **NÃO precisa parar** após cada subtarefa para aguardar instruções. **Continue trabalhando até:**
            -  Ter dúvidas específicas que precisem de esclarecimento.
            -  Encontrar bloqueios que impeçam o progresso.
            -  Precisar de validação de decisões arquiteturais importantes.
            - Em qualquer um desses casos, você deve perguntar ao usuário para obter os insumos necessários para continuar.
    </execucao-continua>
    <loop-de-etapas-para-cada-subtarefa>
        <etapa-01-research>
            -  **Research (Pesquisa):**
            - Revise o arquivo `current-work.md` para entender o progresso atual e o contexto de curto prazo.
            - Identifique e leia as regras relevantes (`fetch_rules`) para a subtarefa, visando aderência aos guidelines do projeto.
            - Consulte arquivos do Memory Bank na pasta `@ai/memorybank/` para contexto técnico e de negócio sobre o projeto.
            - Entenda o código existente relevante para a subtarefa.
            - Identifique dependências e integrações necessárias.
        </etapa-01-research>
        <etapa-02-innovate>
            -  **Innovate (Inovação):**
            - Realize brainstorming para encontrar abordagens e soluções.
            - Analise os prós e contras de cada abordagem.
            - Explore trade-offs e alternativas consideradas.
        </etapa-02-innovate>
        <etapa-03-plan>
            -  **Plan (Planejamento):**
            - Confirme a abordagem exata para implementar a subtarefa
            - Identifique quais arquivos serão modificados/criados
            - Planeje a estrutura do código a ser adicionado/alterado
            - Mantenha o alinhamento com as regras consideradas relevantes (`fetch_rules`)
            - Considere impactos em outras partes do sistema
        </etapa-03-plan>
        <etapa-04-execute>
            -  **Execute (Execução):**
            - Implemente as mudanças seguindo as regras consideradas relevantes (`fetch_rules`)
            - Aplique os padrões arquiteturais definidos no projeto
            - Adicione logs para observabilidade e comentários para explicar decisões de design complexas ou não óbvias (o 'porquê'), nunca para descrever o 'o quê' do código.
        </etapa-04-execute>
        <etapa-05-review>
            -  **Review (Revisão):**
            - Verifique se o código atende aos requisitos da subtarefa
            - Confirme consistência com o resto do projeto
            - Valide contra as regras consideradas relevantes (`fetch_rules`)
            - Teste a funcionalidade implementada
        </etapa-05-review>
        <apos-completar-subtarefa>
            - **Atualize o arquivo `current-work.md`:**
                - Marque a subtarefa como concluída `[X]`
                - Adicione notas relevantes na seção "Contexto de Curto Prazo"
                - Atualize próximos passos se necessário
                - Adicione/modifique outras subtarefas baseado no que foi aprendido
            - **Continue** imediatamente para a próxima subtarefa a partir da `etapa-01-research`.
        </apos-completar-subtarefa>
    </loop-de-etapas-para-cada-subtarefa>
</fluxo-de-trabalho-riper>

<finalizacao-da-tarefa>
    - **Após finalizar todas as subtarefas** em `current-work.md`, sinalize a conclusão completa da tarefa.
</finalizacao-da-tarefa>
