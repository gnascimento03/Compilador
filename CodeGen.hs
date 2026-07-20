module CodeGen (gerar) where

import AST
import Control.Monad.State
import Numeric (showFFloat)

-- ============================================================
--  Tipos auxiliares
-- ============================================================

-- Tabela de variaveis locais: nome -> (tipo, indice do slot na JVM)
type Tabela = [(Id, (Tipo, Int))]

-- Tabela de funcoes: nome -> (tipos dos parametros, tipo de retorno)
type TabFuncoes = [(Id, ([Tipo], Tipo))]

-- Monad usado apenas para gerar rotulos (labels) unicos dentro de um metodo
type M = State Int

novoLabel :: M String
novoLabel = do
    n <- get
    put (n + 1)
    return ("L" ++ show n)

-- ============================================================
--  Funcao principal exportada
-- ============================================================

-- gerar recebe o nome da classe (arquivo .j vai se chamar <nome>.j) e o
-- Programa (ja validado/anotado pelo analisador semantico) e devolve o
-- codigo assembly Jasmin completo, pronto para ser salvo em um arquivo .j
-- e montado com "java -jar jasmin.jar <nome>.j"
gerar :: String -> Programa -> String
gerar nomeClasse (Prog funcoes varsGlobais blocoPrincipal) =
    let tabFuncoes = buildTabFuncoes funcoes
        temLeitura  = usaLeitura funcoes blocoPrincipal
        cabecalho   = genCabecalho nomeClasse temLeitura
        codFuncoes  = concatMap (\f -> evalState (genFuncao nomeClasse tabFuncoes f) 0) funcoes
        codMain     = evalState (genMain nomeClasse tabFuncoes varsGlobais blocoPrincipal) 0
    in cabecalho ++ codFuncoes ++ codMain

-- ============================================================
--  Cabecalho da classe (construtor + campo/estatico Scanner se precisar de read)
-- ============================================================

genCabecalho :: String -> Bool -> String
genCabecalho nome temLeitura =
    ".class public " ++ nome ++ "\n" ++
    ".super java/lang/Object\n\n" ++
    (if temLeitura
        then ".field private static input Ljava/util/Scanner;\n\n"
        else "") ++
    ".method public <init>()V\n" ++
    "\taload_0\n" ++
    "\tinvokespecial java/lang/Object/<init>()V\n" ++
    "\treturn\n" ++
    ".end method\n\n" ++
    if temLeitura
        then ".method static <clinit>()V\n" ++
             "\t.limit stack 3\n" ++
             "\t.limit locals 0\n" ++
             "\tnew java/util/Scanner\n" ++
             "\tdup\n" ++
             "\tgetstatic java/lang/System/in Ljava/io/InputStream;\n" ++
             "\tinvokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V\n" ++
             "\tputstatic " ++ nome ++ "/input Ljava/util/Scanner;\n" ++
             "\treturn\n" ++
             ".end method\n\n"
        else ""

-- Verifica (de forma simples e conservadora) se o programa usa o comando read
-- em algum lugar, para so declarar o Scanner estatico quando necessario.
usaLeitura :: [Funcao] -> Bloco -> Bool
usaLeitura funcoes blocoPrincipal =
    any blocoTemLeitura blocoPrincipal ||
    any (\(_ :->: (_, _, _, b)) -> any blocoTemLeitura b) funcoes
  where
    blocoTemLeitura (Leitura _)      = True
    blocoTemLeitura (If _ b1 b2)     = any blocoTemLeitura b1 || any blocoTemLeitura b2
    blocoTemLeitura (While _ b)      = any blocoTemLeitura b
    blocoTemLeitura _                = False

-- ============================================================
--  Tabela de simbolos (mapeamento de variaveis para slots da JVM)
-- ============================================================

tipoJVM :: Tipo -> String
tipoJVM TInt    = "I"
tipoJVM TDouble = "D"
tipoJVM TString = "Ljava/lang/String;"
tipoJVM TVoid   = "V"

-- double ocupa 2 slots na JVM; os demais tipos usados aqui ocupam 1
slotSize :: Tipo -> Int
slotSize TDouble = 2
slotSize _       = 1

-- constroi a tabela de variaveis locais a partir de uma lista de Var,
-- comecando a numeracao dos slots em "inicio"
buildTabela :: Int -> [Var] -> Tabela
buildTabela _ [] = []
buildTabela inicio ((nome :#: (tipo, _)) : resto) =
    (nome, (tipo, inicio)) : buildTabela (inicio + slotSize tipo) resto

contaSlots :: [Var] -> Int
contaSlots = sum . map (\(_ :#: (t, _)) -> slotSize t)

buscaTab :: Id -> Tabela -> (Tipo, Int)
buscaTab nome tab = case lookup nome tab of
    Just info -> info
    Nothing   -> error ("Erro interno do gerador de codigo: variavel nao encontrada: " ++ nome)

buildTabFuncoes :: [Funcao] -> TabFuncoes
buildTabFuncoes = map $ \(nome :->: (params, tipoRet, _, _)) ->
    (nome, (map (\(_ :#: (t, _)) -> t) params, tipoRet))

buscaFuncao :: Id -> TabFuncoes -> ([Tipo], Tipo)
buscaFuncao nome tf = case lookup nome tf of
    Just info -> info
    Nothing   -> error ("Erro interno do gerador de codigo: funcao nao encontrada: " ++ nome)

descritor :: [Tipo] -> Tipo -> String
descritor tiposParam tipoRet = "(" ++ concatMap tipoJVM tiposParam ++ ")" ++ tipoJVM tipoRet

-- ============================================================
--  Geracao de funcoes definidas pelo usuario
-- ============================================================

-- Estimativa conservadora (porem generosa) do limite de pilha necessario.
-- Uma analise exata exigiria calcular a profundidade maxima da pilha de
-- avaliacao; para os programas gerados por este compilador esse valor
-- fixo e suficiente e seguro.
limitePilhaPadrao :: Int
limitePilhaPadrao = 100

genFuncao :: String -> TabFuncoes -> Funcao -> M String
genFuncao nomeClasse tabFuncoes (nome :->: (params, tipoRet, locais, bloco)) = do
    let tabela    = buildTabela 0 (params ++ locais)
        numLocais = max 1 (contaSlots (params ++ locais))
    corpo <- genBloco nomeClasse tabela tabFuncoes bloco
    let retornoPadrao = genRetornoPadrao tipoRet
    return $
        ".method public static " ++ nome ++ descritor (map tipoParam params) tipoRet ++ "\n" ++
        "\t.limit stack " ++ show limitePilhaPadrao ++ "\n" ++
        "\t.limit locals " ++ show numLocais ++ "\n\n" ++
        corpo ++
        retornoPadrao ++
        ".end method\n\n"
  where
    tipoParam (_ :#: (t, _)) = t

-- Instrucao de retorno "de seguranca" inserida ao final do corpo do metodo.
-- Isso evita o erro de verificacao da JVM "falling off the end of the code"
-- caso o fluxo de controle (ex.: um if sem else em todos os caminhos) chegue
-- ao fim do metodo sem um return explicito. Se o programa sempre retorna
-- antes disso, este trecho fica simplesmente inalcancavel e nao afeta a
-- execucao.
genRetornoPadrao :: Tipo -> String
genRetornoPadrao TInt    = "\tldc 0\n\tireturn\n"
genRetornoPadrao TDouble = "\tldc2_w 0.0\n\tdreturn\n"
genRetornoPadrao TString = "\taconst_null\n\tareturn\n"
genRetornoPadrao TVoid   = "\treturn\n"

-- ============================================================
--  Geracao do bloco principal (vira o main da JVM)
-- ============================================================

genMain :: String -> TabFuncoes -> [Var] -> Bloco -> M String
genMain nomeClasse tabFuncoes varsGlobais bloco = do
    -- slot 0 e reservado para o parametro String[] args do main
    let tabela    = buildTabela 1 varsGlobais
        numLocais = 1 + contaSlots varsGlobais
    corpo <- genBloco nomeClasse tabela tabFuncoes bloco
    return $
        ".method public static main([Ljava/lang/String;)V\n" ++
        "\t.limit stack " ++ show limitePilhaPadrao ++ "\n" ++
        "\t.limit locals " ++ show numLocais ++ "\n\n" ++
        corpo ++
        "\treturn\n" ++
        ".end method\n\n"

-- ============================================================
--  Comandos
-- ============================================================

genBloco :: String -> Tabela -> TabFuncoes -> Bloco -> M String
genBloco nomeClasse tab tf cmds = concat <$> mapM (genCmd nomeClasse tab tf) cmds

genCmd :: String -> Tabela -> TabFuncoes -> Comando -> M String

genCmd nomeClasse tab tf (Atrib nome expr) = do
    (tipoExpr, codExpr) <- genExpr nomeClasse tab tf expr
    let (tipoVar, idx) = buscaTab nome tab
    return (codExpr ++ genStore tipoVar idx)

genCmd nomeClasse tab tf (If cond blocoV blocoF) = do
    lVerdadeiro <- novoLabel
    lFalso      <- novoLabel
    lFim        <- novoLabel
    condCod <- genExprL nomeClasse tab tf lVerdadeiro lFalso cond
    vCod    <- genBloco nomeClasse tab tf blocoV
    if null blocoF
        then return $
            condCod ++
            lVerdadeiro ++ ":\n" ++ vCod ++
            lFalso ++ ":\n"
        else do
            fCod <- genBloco nomeClasse tab tf blocoF
            return $
                condCod ++
                lVerdadeiro ++ ":\n" ++ vCod ++ "\tgoto " ++ lFim ++ "\n" ++
                lFalso ++ ":\n" ++ fCod ++
                lFim ++ ":\n"

genCmd nomeClasse tab tf (While cond bloco) = do
    lInicio <- novoLabel
    lVerdadeiro <- novoLabel
    lFim <- novoLabel
    condCod <- genExprL nomeClasse tab tf lVerdadeiro lFim cond
    corpoCod <- genBloco nomeClasse tab tf bloco
    return $
        lInicio ++ ":\n" ++
        condCod ++
        lVerdadeiro ++ ":\n" ++
        corpoCod ++
        "\tgoto " ++ lInicio ++ "\n" ++
        lFim ++ ":\n"

genCmd nomeClasse tab tf (Leitura nome) = do
    let (tipo, idx) = buscaTab nome tab
        metodo = case tipo of
            TInt    -> "nextInt()I"
            TDouble -> "nextDouble()D"
            TString -> "next()Ljava/lang/String;"
            TVoid   -> error "Nao e possivel ler uma variavel do tipo void"
    return $
        "\tgetstatic " ++ nomeClasse ++ "/input Ljava/util/Scanner;\n" ++
        "\tinvokevirtual java/util/Scanner/" ++ metodo ++ "\n" ++
        genStore tipo idx

genCmd nomeClasse tab tf (Imp expr) = do
    (tipo, cod) <- genExpr nomeClasse tab tf expr
    return $
        "\tgetstatic java/lang/System/out Ljava/io/PrintStream;\n" ++
        cod ++
        "\tinvokevirtual java/io/PrintStream/println(" ++ tipoJVM tipo ++ ")V\n"

genCmd _ _ _ (Ret Nothing) = return "\treturn\n"

genCmd nomeClasse tab tf (Ret (Just expr)) = do
    (tipo, cod) <- genExpr nomeClasse tab tf expr
    let instrRet = case tipo of
            TInt    -> "ireturn"
            TDouble -> "dreturn"
            TString -> "areturn"
            TVoid   -> "return"
    return (cod ++ "\t" ++ instrRet ++ "\n")

genCmd nomeClasse tab tf (Proc nome args) = do
    let (tiposFormais, tipoRet) = buscaFuncao nome tf
    codsArgs <- mapM (genExpr nomeClasse tab tf) args
    let codArgs = concatMap snd codsArgs
        chamada = "\tinvokestatic " ++ nomeClasse ++ "/" ++ nome ++
                  descritor tiposFormais tipoRet ++ "\n"
        -- como o resultado (se houver) nao e usado, desempilha o valor
        pop = case tipoRet of
            TVoid   -> ""
            TDouble -> "\tpop2\n"
            _       -> "\tpop\n"
    return (codArgs ++ chamada ++ pop)

-- ============================================================
--  Expressoes logicas / relacionais (codigo "saltador": jumping code)
--
--  genExprL/genExprR nao "empilham" um booleano: em vez disso recebem dois
--  rotulos, v (destino caso a expressao seja verdadeira) e f (destino caso
--  seja falsa), e geram codigo que sempre termina desviando para um dos
--  dois - nunca cai (fall-through) para o codigo seguinte.
-- ============================================================

genExprL :: String -> Tabela -> TabFuncoes -> String -> String -> ExprL -> M String
genExprL nomeClasse tab tf v f (And e1 e2) = do
    l1 <- novoLabel
    e1' <- genExprL nomeClasse tab tf l1 f e1
    e2' <- genExprL nomeClasse tab tf v f e2
    return (e1' ++ l1 ++ ":\n" ++ e2')
genExprL nomeClasse tab tf v f (Or e1 e2) = do
    l1 <- novoLabel
    e1' <- genExprL nomeClasse tab tf v l1 e1
    e2' <- genExprL nomeClasse tab tf v f e2
    return (e1' ++ l1 ++ ":\n" ++ e2')
genExprL nomeClasse tab tf v f (Not e) =
    genExprL nomeClasse tab tf f v e
genExprL nomeClasse tab tf v f (Rel r) =
    genExprR nomeClasse tab tf v f r

genExprR :: String -> Tabela -> TabFuncoes -> String -> String -> ExprR -> M String
genExprR nomeClasse tab tf v f exprR = case exprR of
    Req  e1 e2 -> gerarComparacao "eq" e1 e2
    Rdif e1 e2 -> gerarComparacao "ne" e1 e2
    Rlt  e1 e2 -> gerarComparacao "lt" e1 e2
    Rgt  e1 e2 -> gerarComparacao "gt" e1 e2
    Rle  e1 e2 -> gerarComparacao "le" e1 e2
    Rge  e1 e2 -> gerarComparacao "ge" e1 e2
  where
    gerarComparacao op e1 e2 = do
        (t1, c1) <- genExpr nomeClasse tab tf e1
        (_ , c2) <- genExpr nomeClasse tab tf e2
        return (c1 ++ c2 ++ genRel t1 op v f)

-- Gera a comparacao propriamente dita: sempre desvia explicitamente para
-- v (verdadeiro) ou f (falso), nunca cai para a proxima instrucao.
genRel :: Tipo -> String -> String -> String -> String
genRel TInt op v f =
    "\t" ++ opInt op ++ " " ++ v ++ "\n" ++
    "\tgoto " ++ f ++ "\n"
genRel TDouble op v f =
    "\t" ++ instrucaoDcmp op ++ "\n" ++
    "\t" ++ opZero op ++ " " ++ v ++ "\n" ++
    "\tgoto " ++ f ++ "\n"
genRel TString op v f
    | op `elem` ["eq", "ne"] =
        "\tinvokevirtual java/lang/String/equals(Ljava/lang/Object;)Z\n" ++
        "\t" ++ (if op == "eq" then "ifne" else "ifeq") ++ " " ++ v ++ "\n" ++
        "\tgoto " ++ f ++ "\n"
    | otherwise =
        "\tinvokevirtual java/lang/String/compareTo(Ljava/lang/String;)I\n" ++
        "\t" ++ opZero op ++ " " ++ v ++ "\n" ++
        "\tgoto " ++ f ++ "\n"
genRel TVoid _ _ _ = error "Nao e possivel comparar expressoes do tipo void"

-- Escolha da instrucao de comparacao de double correta para NaN
-- (mesma convencao usada pelo javac): dcmpg para < e <=, dcmpl para > e >=.
-- Para == e /= tanto faz, ja que nenhum dos dois da 0 quando ha NaN.
instrucaoDcmp :: String -> String
instrucaoDcmp "lt" = "dcmpg"
instrucaoDcmp "le" = "dcmpg"
instrucaoDcmp "gt" = "dcmpl"
instrucaoDcmp "ge" = "dcmpl"
instrucaoDcmp _     = "dcmpg"

opInt :: String -> String
opInt "eq" = "if_icmpeq"
opInt "ne" = "if_icmpne"
opInt "lt" = "if_icmplt"
opInt "gt" = "if_icmpgt"
opInt "le" = "if_icmple"
opInt "ge" = "if_icmpge"
opInt op   = error ("Operador relacional desconhecido: " ++ op)

opZero :: String -> String
opZero "eq" = "ifeq"
opZero "ne" = "ifne"
opZero "lt" = "iflt"
opZero "gt" = "ifgt"
opZero "le" = "ifle"
opZero "ge" = "ifge"
opZero op   = error ("Operador relacional desconhecido: " ++ op)

-- ============================================================
--  Expressoes aritmeticas / valores
-- ============================================================

genExpr :: String -> Tabela -> TabFuncoes -> Expr -> M (Tipo, String)

genExpr _ _ _ (Const (CInt i)) = return (TInt, genLdcInt i)
genExpr _ _ _ (Const (CDouble d)) = return (TDouble, genLdcDouble d)
genExpr _ _ _ (Lit s) = return (TString, "\tldc " ++ show s ++ "\n")

genExpr _ tab _ (IdVar nome) =
    let (tipo, idx) = buscaTab nome tab
    in return (tipo, genLoad tipo idx)

genExpr nomeClasse tab tf (Add e1 e2) = genBin nomeClasse tab tf "add" e1 e2
genExpr nomeClasse tab tf (Sub e1 e2) = genBin nomeClasse tab tf "sub" e1 e2
genExpr nomeClasse tab tf (Mul e1 e2) = genBin nomeClasse tab tf "mul" e1 e2
genExpr nomeClasse tab tf (Div e1 e2) = genBin nomeClasse tab tf "div" e1 e2

genExpr nomeClasse tab tf (Neg e) = do
    (tipo, cod) <- genExpr nomeClasse tab tf e
    let instr = if tipo == TDouble then "\tdneg\n" else "\tineg\n"
    return (tipo, cod ++ instr)

genExpr nomeClasse tab tf (IntToDouble e) = do
    (_, cod) <- genExpr nomeClasse tab tf e
    return (TDouble, cod ++ "\ti2d\n")

genExpr nomeClasse tab tf (DoubleToInt e) = do
    (_, cod) <- genExpr nomeClasse tab tf e
    return (TInt, cod ++ "\td2i\n")

genExpr nomeClasse tab tf (Chamada nome args) = do
    let (tiposFormais, tipoRet) = buscaFuncao nome tf
    codsArgs <- mapM (genExpr nomeClasse tab tf) args
    let codArgs = concatMap snd codsArgs
    return (tipoRet,
            codArgs ++
            "\tinvokestatic " ++ nomeClasse ++ "/" ++ nome ++
            descritor tiposFormais tipoRet ++ "\n")

genBin :: String -> Tabela -> TabFuncoes -> String -> Expr -> Expr -> M (Tipo, String)
genBin nomeClasse tab tf op e1 e2 = do
    (t1, c1) <- genExpr nomeClasse tab tf e1
    (_ , c2) <- genExpr nomeClasse tab tf e2
    return (t1, c1 ++ c2 ++ genOp t1 op)

genOp :: Tipo -> String -> String
genOp TInt    op = "\ti" ++ op ++ "\n"
genOp TDouble op = "\td" ++ op ++ "\n"
genOp t       _  = error ("Operacao aritmetica invalida para o tipo " ++ show t)

-- ============================================================
--  Instrucoes de load/store e constantes, com pequenas otimizacoes
--  de tamanho de bytecode (nao obrigatorias, mas deixam o .j mais limpo)
-- ============================================================

genLoad :: Tipo -> Int -> String
genLoad TInt    idx = "\tiload" ++ sufixoIndice idx ++ "\n"
genLoad TDouble idx = "\tdload" ++ sufixoIndice idx ++ "\n"
genLoad TString idx = "\taload" ++ sufixoIndice idx ++ "\n"
genLoad TVoid   _   = error "Nao e possivel carregar uma variavel do tipo void"

genStore :: Tipo -> Int -> String
genStore TInt    idx = "\tistore" ++ sufixoIndice idx ++ "\n"
genStore TDouble idx = "\tdstore" ++ sufixoIndice idx ++ "\n"
genStore TString idx = "\tastore" ++ sufixoIndice idx ++ "\n"
genStore TVoid   _   = error "Nao e possivel armazenar em uma variavel do tipo void"

-- Para indices de 0 a 3 o Jasmin permite (e e mais compacto) usar a forma
-- "_N" (ex.: iload_0); para os demais, usa-se a forma "N" com espaco.
sufixoIndice :: Int -> String
sufixoIndice n
    | n >= 0 && n <= 3 = "_" ++ show n
    | otherwise        = " " ++ show n

genLdcInt :: Int -> String
genLdcInt i
    | i == -1          = "\ticonst_m1\n"
    | i >= 0 && i <= 5 = "\ticonst_" ++ show i ++ "\n"
    | otherwise        = "\tldc " ++ show i ++ "\n"

genLdcDouble :: Double -> String
genLdcDouble d
    | d == 0.0 = "\tdconst_0\n"
    | d == 1.0 = "\tdconst_1\n"
    | otherwise = "\tldc2_w " ++ showFFloat Nothing d "" ++ "\n"
