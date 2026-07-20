# Compilador para JVM (Haskell)

Compilador desenvolvido em Haskell para uma linguagem de propósito acadêmico, com geração de código intermediário **Jasmin** (assembly da JVM), permitindo que o programa final seja executado como bytecode Java.

## Pipeline de compilação

```
código-fonte (.j--)
      │
      ▼
 Análise Léxica (Lex.x / Lex.hs — gerado com Alex)
      │
      ▼
 Análise Sintática (Parser.y / Parser.hs — gerado com Happy) → AST.hs
      │
      ▼
 Análise Semântica (Semantico.hs)
      │
      ▼
 Geração de Código (CodeGen.hs) → arquivo .j (Jasmin)
      │
      ▼
 jasmin.jar → .class (bytecode JVM)
```

## Estrutura

| Arquivo | Responsabilidade |
|---|---|
| `Lex.x` / `Lex.hs` | Especificação e implementação do analisador léxico (tokenização), gerado via [Alex](https://haskell-alex.readthedocs.io/) |
| `Parser.y` / `Parser.hs` | Gramática e analisador sintático, gerado via [Happy](https://haskell-happy.readthedocs.io/) |
| `AST.hs` | Definição da Árvore Sintática Abstrata |
| `Semantico.hs` | Verificação semântica (tipos, escopos, erros) |
| `CodeGen.hs` | Geração do código Jasmin a partir da AST validada |
| `Main.hs` | Ponto de entrada: orquestra léxico → sintático → semântico → geração |
| `exemplos/` | Arquivos de exemplo na linguagem-fonte |

## Como compilar e rodar

Pré-requisitos: [GHC](https://www.haskell.org/ghc/) e as bibliotecas Alex/Happy (`cabal install alex happy` ou via Stack).

```bash
# Gerar os arquivos a partir das especificações (se necessário)
alex Lex.x
happy Parser.y

# Compilar o projeto
ghc -o compilador Main.hs

# Compilar um arquivo de exemplo
./compilador exemplos/teste.j--
```

Isso gera um arquivo `.j` (assembly Jasmin). Para transformar em bytecode executável pela JVM:

```bash
java -jar jasmin.jar exemplos/teste.j
java NomeDaClasse
```

## Sobre o projeto

Trabalho da disciplina de Compiladores, cobrindo todas as etapas clássicas de construção de um compilador: análise léxica, sintática, semântica e geração de código para uma máquina-alvo real (JVM).
