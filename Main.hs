module Main where

import Lex
import Parser
import AST
import Semantico
import CodeGen (gerar)
import System.Environment (getArgs)
import System.FilePath (takeBaseName, replaceExtension)
import Data.Char (isAlphaNum, isDigit)

nomeClasseValido :: String -> String
nomeClasseValido base =
    let limpo = map (\c -> if isAlphaNum c then c else '_') base
    in if null limpo || isDigit (head limpo) then '_' : limpo else limpo

main :: IO ()
main = do
    args <- getArgs
    case args of
        [file] -> do
            code <- readFile file
            let tokens = alexScanTokens code
            let astSintatica = parseProgram tokens

            let Result (temErro, mensagens, astSemantica) = checkPrograma astSintatica

            if not (null mensagens)
                then putStrLn mensagens
                else putStrLn "Analise concluida sem advertencias ou erros."

            if not temErro
                then do
                    let nomeClasse = nomeClasseValido (takeBaseName file)
                        arquivoSaida = replaceExtension file ".j"
                        codigoJasmin = gerar nomeClasse astSemantica
                    writeFile arquivoSaida codigoJasmin
                    putStrLn ("\nCodigo Jasmin gerado com sucesso em: " ++ arquivoSaida)
                    putStrLn ("Para gerar o .class use: java -jar jasmin.jar " ++ arquivoSaida)
                else putStrLn "\nA compilacao falhou devido a erros semanticos."

        _ -> putStrLn "Uso correto: ./compilador <arquivo.j-->"
