{
module Lex where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-
  $white+                       ;
  "//".* ;
  "int"                         { \_ -> TkInteiro }
  "double"                      { \_ -> TkReal }
  "string"                      { \_ -> TkTexto }
  "void"                        { \_ -> TkVazio }
  "if"                          { \_ -> TkSe }
  "else"                        { \_ -> TkSenao }
  "while"                       { \_ -> TkEnquanto }
  "print"                       { \_ -> TkImprimir }
  "read"                        { \_ -> TkLer }
  "return"                      { \_ -> TkRetornar }
  "{"                           { \_ -> TkAbreChave }
  "}"                           { \_ -> TkFechaChave }
  "("                           { \_ -> TkAbreParen }
  ")"                           { \_ -> TkFechaParen }
  ";"                           { \_ -> TkPontoVirgula }
  ","                           { \_ -> TkVirgula }
  "=="                          { \_ -> TkIgual }
  "/="                          { \_ -> TkDiferente }
  "<="                          { \_ -> TkMenorIgual }
  ">="                          { \_ -> TkMaiorIgual }
  "<"                           { \_ -> TkMenor }
  ">"                           { \_ -> TkMaior }
  "="                           { \_ -> TkAtribuicao }
  "&&"                          { \_ -> TkE }
  "||"                          { \_ -> TkOu }
  "!"                           { \_ -> TkNao }
  "+"                           { \_ -> TkSoma }
  "-"                           { \_ -> TkSubtracao }
  "*"                           { \_ -> TkMultiplicacao }
  "/"                           { \_ -> TkDivisao }
  $alpha [$alpha $digit \_]* { \s -> TkIdentificador s }
  $digit+ \. $digit+            { \s -> TkLitReal (read s) }
  $digit+                       { \s -> TkLitInteiro (read s) }
  \" [^\"]* \"                  { \s -> TkLitTexto (init (tail s)) } -- Remove as aspas aqui

{
data Token = TkInteiro | TkReal | TkTexto | TkVazio
           | TkSe | TkSenao | TkEnquanto 
           | TkImprimir | TkLer | TkRetornar
           | TkAbreChave | TkFechaChave | TkAbreParen | TkFechaParen
           | TkPontoVirgula | TkVirgula | TkAtribuicao
           | TkIgual | TkDiferente | TkMenor | TkMaior | TkMenorIgual | TkMaiorIgual
           | TkE | TkOu | TkNao
           | TkSoma | TkSubtracao | TkMultiplicacao | TkDivisao
           | TkIdentificador String
           | TkLitReal Double
           | TkLitInteiro Int
           | TkLitTexto String
           deriving (Eq, Show)
}