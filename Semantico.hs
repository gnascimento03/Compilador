module Semantico where

import AST
import Control.Monad (foldM) -- Necessário para preencher as tabelas passo a passo


data Result a = Result (Bool, String, a) deriving Show

instance Functor Result where
  fmap f (Result (b, s, a)) = Result (b, s, f a)

instance Applicative Result where
  pure a = Result (False, "", a)
  Result (b1, s1, f) <*> Result (b2, s2, x) = Result (b1 || b2, s1 <> s2, f x)   

instance Monad Result where 
  Result (b, s, a) >>= f = let Result (b', s', a') = f a in Result (b || b', s++s', a')
  
errorMsg :: String -> Result ()
errorMsg s = Result (True, "Erro: " ++ s ++ "\n", ())

warningMsg :: String -> Result ()
warningMsg s = Result (False, "Advertencia: " ++ s ++ "\n", ())



type EnvLocal = [(Id, Tipo)]
type EnvGlobal = [(Id, ([Tipo], Tipo))]

buscaVar :: Id -> EnvLocal -> Result Tipo
buscaVar nome env = case lookup nome env of
    Just tipo -> pure tipo
    Nothing   -> do
        errorMsg ("Variavel nao declarada: " ++ nome)
        pure TInt 

buscaFunc :: Id -> EnvGlobal -> Result ([Tipo], Tipo)
buscaFunc nome env = case lookup nome env of
    Just info -> pure info
    Nothing   -> do
        errorMsg ("Funcao nao declarada: " ++ nome)
        pure ([], TVoid) 




checkExpr :: EnvLocal -> EnvGlobal -> Expr -> Result (Expr, Tipo)
checkExpr _ _ (Const (CInt n)) = pure (Const (CInt n), TInt)
checkExpr _ _ (Const (CDouble n)) = pure (Const (CDouble n), TDouble)
checkExpr _ _ (Lit s) = pure (Lit s, TString)
checkExpr envL _ (IdVar nome) = do
    tipo <- buscaVar nome envL
    pure (IdVar nome, tipo)
checkExpr envL envG (Chamada nome args) = do
    (tiposFormais, tipoRetorno) <- buscaFunc nome envG
    novosArgs <- checkArgumentos envL envG nome tiposFormais args
    pure (Chamada nome novosArgs, tipoRetorno)
checkExpr envL envG (Neg e) = do
    (novaE, tipo) <- checkExpr envL envG e
    pure (Neg novaE, tipo)
checkExpr envL envG (Add e1 e2) = checkBinaria envL envG Add e1 e2
checkExpr envL envG (Sub e1 e2) = checkBinaria envL envG Sub e1 e2
checkExpr envL envG (Mul e1 e2) = checkBinaria envL envG Mul e1 e2
checkExpr envL envG (Div e1 e2) = checkBinaria envL envG Div e1 e2
checkExpr _ _ e = pure (e, TInt) -- Fallback de segurança para IntToDouble/DoubleToInt originais

checkBinaria :: EnvLocal -> EnvGlobal -> (Expr -> Expr -> Expr) -> Expr -> Expr -> Result (Expr, Tipo)
checkBinaria envL envG construtor e1 e2 = do
    (novaE1, tipo1) <- checkExpr envL envG e1
    (novaE2, tipo2) <- checkExpr envL envG e2
    case (tipo1, tipo2) of
        (TInt, TInt)       -> pure (construtor novaE1 novaE2, TInt)
        (TDouble, TDouble) -> pure (construtor novaE1 novaE2, TDouble)
        (TInt, TDouble)    -> pure (construtor (IntToDouble novaE1) novaE2, TDouble)
        (TDouble, TInt)    -> pure (construtor novaE1 (IntToDouble novaE2), TDouble)
        _ -> do
            errorMsg "Tipos incompativeis em expressao aritmetica"
            pure (construtor novaE1 novaE2, TInt)

checkExprR :: EnvLocal -> EnvGlobal -> ExprR -> Result ExprR
checkExprR envL envG exprR = case exprR of
    Req e1 e2  -> checkRel envL envG Req e1 e2
    Rdif e1 e2 -> checkRel envL envG Rdif e1 e2
    Rlt e1 e2  -> checkRel envL envG Rlt e1 e2
    Rgt e1 e2  -> checkRel envL envG Rgt e1 e2
    Rle e1 e2  -> checkRel envL envG Rle e1 e2
    Rge e1 e2  -> checkRel envL envG Rge e1 e2

checkRel :: EnvLocal -> EnvGlobal -> (Expr -> Expr -> ExprR) -> Expr -> Expr -> Result ExprR
checkRel envL envG construtor e1 e2 = do
    (novaE1, tipo1) <- checkExpr envL envG e1
    (novaE2, tipo2) <- checkExpr envL envG e2
    case (tipo1, tipo2) of
        (TInt, TInt)       -> pure (construtor novaE1 novaE2)
        (TDouble, TDouble) -> pure (construtor novaE1 novaE2)
        (TString, TString) -> pure (construtor novaE1 novaE2)
        (TInt, TDouble)    -> pure (construtor (IntToDouble novaE1) novaE2)
        (TDouble, TInt)    -> pure (construtor novaE1 (IntToDouble novaE2))
        _ -> do
            errorMsg "Tipos incompativeis em expressao relacional"
            pure (construtor novaE1 novaE2)

checkExprL :: EnvLocal -> EnvGlobal -> ExprL -> Result ExprL
checkExprL envL envG (And e1 e2) = do
    novaE1 <- checkExprL envL envG e1
    novaE2 <- checkExprL envL envG e2
    pure (And novaE1 novaE2)
checkExprL envL envG (Or e1 e2) = do
    novaE1 <- checkExprL envL envG e1
    novaE2 <- checkExprL envL envG e2
    pure (Or novaE1 novaE2)
checkExprL envL envG (Not e) = do
    novaE <- checkExprL envL envG e
    pure (Not novaE)
checkExprL envL envG (Rel exprR) = do
    novaExprR <- checkExprR envL envG exprR
    pure (Rel novaExprR)



checkArgumentos :: EnvLocal -> EnvGlobal -> Id -> [Tipo] -> [Expr] -> Result [Expr]
checkArgumentos _ _ _ [] [] = pure []
checkArgumentos envL envG nomeFunc (tipoEsperado:ts) (exprReal:es) = do
    novaExpr <- checkParam envL envG tipoEsperado exprReal
    restoExprs <- checkArgumentos envL envG nomeFunc ts es
    pure (novaExpr : restoExprs)
checkArgumentos _ _ nomeFunc _ _ = do
    errorMsg ("Numero incorreto de parametros na chamada da funcao '" ++ nomeFunc ++ "'")
    pure []

checkParam :: EnvLocal -> EnvGlobal -> Tipo -> Expr -> Result Expr
checkParam envL envG tipoEsperado exprReal = do
    (novaExpr, tipoExpr) <- checkExpr envL envG exprReal
    case (tipoEsperado, tipoExpr) of
        (TInt, TInt)       -> pure novaExpr
        (TDouble, TDouble) -> pure novaExpr
        (TString, TString) -> pure novaExpr
        (TDouble, TInt)    -> pure (IntToDouble novaExpr)
        (TInt, TDouble)    -> do
            warningMsg "Perda de precisao: Conversao de double para int em parametro"
            pure (DoubleToInt novaExpr)
        _ -> do
            errorMsg "Tipo de parametro incompativel na chamada de funcao"
            pure novaExpr



checkBloco :: EnvLocal -> EnvGlobal -> Tipo -> Bloco -> Result Bloco
checkBloco _ _ _ [] = pure []
checkBloco envL envG tipoRet (cmd:cmds) = do
    novoCmd <- checkCmd envL envG tipoRet cmd
    novosCmds <- checkBloco envL envG tipoRet cmds
    pure (novoCmd : novosCmds)

checkCmd :: EnvLocal -> EnvGlobal -> Tipo -> Comando -> Result Comando
checkCmd envL envG _ (Atrib nome expr) = do
    tipoVar <- buscaVar nome envL
    (novaExpr, tipoExpr) <- checkExpr envL envG expr
    case (tipoVar, tipoExpr) of
        (TInt, TInt)       -> pure (Atrib nome novaExpr)
        (TDouble, TDouble) -> pure (Atrib nome novaExpr)
        (TString, TString) -> pure (Atrib nome novaExpr)
        (TDouble, TInt)    -> pure (Atrib nome (IntToDouble novaExpr))
        (TInt, TDouble)    -> do
            warningMsg ("Perda de precisao: Conversao de double para int na variavel '" ++ nome ++ "'")
            pure (Atrib nome (DoubleToInt novaExpr))
        _ -> do
            errorMsg ("Atribuicao com tipos incompativeis na variavel '" ++ nome ++ "'")
            pure (Atrib nome novaExpr)

checkCmd envL envG tipoRet (If cond blocoV blocoF) = do
    novaCond <- checkExprL envL envG cond
    novoBlocoV <- checkBloco envL envG tipoRet blocoV
    novoBlocoF <- checkBloco envL envG tipoRet blocoF
    pure (If novaCond novoBlocoV novoBlocoF)

checkCmd envL envG tipoRet (While cond bloco) = do
    novaCond <- checkExprL envL envG cond
    novoBloco <- checkBloco envL envG tipoRet bloco
    pure (While novaCond novoBloco)

checkCmd envL _ _ (Leitura nome) = do
    _ <- buscaVar nome envL
    pure (Leitura nome)

checkCmd envL envG _ (Imp expr) = do
    (novaExpr, _) <- checkExpr envL envG expr
    pure (Imp novaExpr)

checkCmd _ _ tipoRet (Ret Nothing) = do
    if tipoRet == TVoid
        then pure (Ret Nothing)
        else do
            errorMsg "Funcao deveria retornar um valor, mas possui 'return;'"
            pure (Ret Nothing)

checkCmd envL envG tipoRet (Ret (Just expr)) = do
    if tipoRet == TVoid
        then do
            errorMsg "Funcao void nao deve retornar valor"
            (novaExpr, _) <- checkExpr envL envG expr
            pure (Ret (Just novaExpr))
        else do
            (novaExpr, tipoExpr) <- checkExpr envL envG expr
            case (tipoRet, tipoExpr) of
                (TInt, TInt)       -> pure (Ret (Just novaExpr))
                (TDouble, TDouble) -> pure (Ret (Just novaExpr))
                (TString, TString) -> pure (Ret (Just novaExpr))
                (TDouble, TInt)    -> pure (Ret (Just (IntToDouble novaExpr)))
                (TInt, TDouble)    -> do
                    warningMsg "Perda de precisao no retorno: Conversao de double para int"
                    pure (Ret (Just (DoubleToInt novaExpr)))
                _ -> do
                    errorMsg "Tipo de retorno incompativel com a assinatura da funcao"
                    pure (Ret (Just novaExpr))

checkCmd envL envG _ (Proc nome args) = do
    (tiposFormais, _) <- buscaFunc nome envG
    novosArgs <- checkArgumentos envL envG nome tiposFormais args
    pure (Proc nome novosArgs)


buildEnvLocal :: [Var] -> Result EnvLocal
buildEnvLocal vars = foldM addVar [] vars
  where
    addVar env (nome :#: (tipo, _)) =
        case lookup nome env of
            Just _  -> do
                errorMsg ("Variavel multiplamente declarada: " ++ nome)
                pure env
            Nothing -> pure ((nome, tipo) : env)


buildEnvGlobal :: [Funcao] -> Result EnvGlobal
buildEnvGlobal funcs = foldM addFunc [] funcs
  where
    addFunc env (nome :->: (params, tipoRet, _, _)) =
        case lookup nome env of
            Just _ -> do
                errorMsg ("Funcao multiplamente declarada: " ++ nome)
                pure env
            Nothing -> do
                let tiposParams = map (\(_ :#: (t, _)) -> t) params
                pure ((nome, (tiposParams, tipoRet)) : env)


checkFuncao :: EnvGlobal -> Funcao -> Result Funcao
checkFuncao envG (nome :->: (params, tipoRet, varsLocais, bloco)) = do
    
    envL <- buildEnvLocal (params ++ varsLocais)
    novoBloco <- checkBloco envL envG tipoRet bloco
    pure (nome :->: (params, tipoRet, varsLocais, novoBloco))


checkPrograma :: Programa -> Result Programa
checkPrograma (Prog funcs varsGlobais blocoPrincipal) = do
    envG <- buildEnvGlobal funcs
    
    
    novasFuncs <- mapM (checkFuncao envG) funcs
    
    
    envLPrincipal <- buildEnvLocal varsGlobais
    novoBlocoPrincipal <- checkBloco envLPrincipal envG TVoid blocoPrincipal
    
    pure (Prog novasFuncs varsGlobais novoBlocoPrincipal)