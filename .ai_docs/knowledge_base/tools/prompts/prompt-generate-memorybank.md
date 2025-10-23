<objetivo-principal>
    Você irá **gerar ou atualizar um Memory Bank** que servirá como contexto de longo prazo para a Inteligência Artificial (IA) de Codificação, contendo informações essenciais sobre o projeto atual.
</objetivo-principal>

<contexto>
    - Por padrão, a IA não possui memória persistente entre interações, ou seja, ela "esquece" tudo o que foi discutido ou aprendido anteriormente assim que a sessão termina.
    - Isso limita sua capacidade de oferecer respostas consistentes e contextualizadas ao longo do tempo.
    - O *Memory Bank* mitiga esse problema ao funcionar como uma memória externa persistente e estruturada:
        - Um conjunto de arquivos versionados que armazena conhecimento duradouro sobre o projeto.
        - Contém informações como estrutura do sistema, histórico de decisões, contexto de negócio, entre outros.
    - Com isso, a IA pode gerar respostas mais precisas, alinhadas com o histórico do projeto e com menor risco de inconsistência ou redundância.
</contexto>

<diretrizes>
    - Seja conciso mas inclua as informações essenciais sobre estrutura, dependências, decisões arquiteturais e exemplos de componentes chave.
    - Caso os arquivos do Memory Bank já existam, atualize-os com base nas informações mais recentes obtidas do projeto.
    - Ao atualizar Memory Bank já existente:
        - Preserve informações que ainda são relevantes e remova apenas o que estiver obsoleto ou incoerente com o estado atual do projeto.
        - Evite criar novas informações que não sejam relevantes. Se o Memory Bank já estiver completo, não precisa alterar nada.
        - Evite fazer modificações visando meramente formatações ou reorganizações de conteúdo. Nesse caso, não altere nada.
</diretrizes>

<instrucoes>
    - Leia cuidadosamente os templates de Memory Bank para entender as informações que serão necessárias obter sobre o projeto.
    - Execute `git ls-files --cached --others --exclude-standard` para listar arquivos no repositório ignorando tudo que está no `.gitignore`, com intuito de entender a estrutura do projeto.
        - Caso o comando acima não funcione por não ser um repositório git, execute `find . -type f` para listar todos os arquivos no repositório.
    - Analise a base de código atual deste projeto para compreendê-lo com profundidade. Leia e analise com atenção especial aos seguintes arquivos e padrões:
        - Arquivos `package.json`, `pom.xml`, `requirements.txt`, `go.mod` ou `build.gradle` para identificar dependências chaves, versões e tecnologias usadas.
        - Execute comandos que sejam necessários para um conhecimento mais completo e fiel da estrutura do projeto. Exemplo: `mvn help:effective-pom`.
        - Arquivos Markdown (`*.md`) na raiz ou em pastas como `/docs` que possam conter informações arquiteturais.
        - Configurações em `*.properties`, `*.yml`, dotfiles, etc.
        - Leia os arquivos de código fonte (ex: .java, .js, .ts, .cs, .py, .go, etc) e tente entender o objetivo central desse projeto e as principais lógicas relacionadas.
    - Use todas as informações obtidas para gerar ou atualizar os arquivos do Memory Bank conforme entregaveis esperados.
</instrucoes>

<entregaveis-esperados>
    - Os seguintes arquivos devem ser criados ou atualizados com base nos templates correspondentes:
        - `@ai/memorybank/technical-context.md` baseado no template `@ai/templates/memorybank/technical-context-template.md`.
        - `@ai/memorybank/software-architecture-and-patterns.md` baseado no template `@ai/templates/memorybank/software-architecture-and-patterns-template.md`.
        - `@ai/memorybank/business-context.md` baseado no template `@ai/templates/memorybank/business-context-template.md`.
        - `@ai/memorybank/decision-logs.md` baseado no template `@ai/templates/memorybank/decision-logs-template.md`.
            - Você **NÃO** deve catalogar nenhuma decisão no momento. Apenas gere o arquivo para que seja possível catalogar as decisões futuramente.
    - Os arquivos acima são templates. Os textos presentes nesses templates são apenas orientações e exemplos. Você deve obrigatoriamente substituir esses textos pelas informações relevantes do projeto.
</entregaveis-esperados>
