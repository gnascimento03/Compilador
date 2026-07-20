{
module Parser where
import Lex
import AST
}

%name parseProgram
%tokentype { Token }
%error { parseError }

%token
    int     { TkInteiro }
    double  { TkReal }
    string  { TkTexto }
    void    { TkVazio }
    if      { TkSe }
    else    { TkSenao }
    while   { TkEnquanto }
    print   { TkImprimir }
    read    { TkLer }
    return  { TkRetornar }
    '{'     { TkAbreChave }
    '}'     { TkFechaChave }
    '('     { TkAbreParen }
    ')'     { TkFechaParen }
    ';'     { TkPontoVirgula }
    ','     { TkVirgula }
    '='     { TkAtribuicao }
    '=='    { TkIgual }
    '/='    { TkDiferente }
    '<'     { TkMenor }
    '>'     { TkMaior }
    '<='    { TkMenorIgual }
    '>='    { TkMaiorIgual }
    '&&'    { TkE }
    '||'    { TkOu }
    '!'     { TkNao }
    '+'     { TkSoma }
    '-'     { TkSubtracao }
    '*'     { TkMultiplicacao }
    '/'     { TkDivisao }
    id      { TkIdentificador $$ }
    numInt  { TkLitInteiro $$ }
    numDbl  { TkLitReal $$ }
    litStr  { TkLitTexto $$ }

%left '||' '&&'
%nonassoc '==' '/=' '<' '>' '<=' '>='
%left '+' '-'
%left '*' '/'
%right '!'
%left UMINUS

%%

Programa :: { Programa } -- dado devolvido é do tipo programa
    : ListaFuncoes BlocoPrincipal { Prog (reverse $1) (fst $2) (snd $2) } -- reverse: inverte a pilha, e fst e snd referem-se aos elementos da tupla --
    | BlocoPrincipal              { Prog [] (fst $1) (snd $1) }

ListaFuncoes :: { [Funcao] }
    : ListaFuncoes Funcao { $2 : $1 }
    | Funcao              { [$1] }

Funcao :: { Funcao }
    : TipoRet id '(' ParamFormais ')' BlocoPrincipal { $2 :->: (reverse $4, $1, fst $6, snd $6) }
    | TipoRet id '(' ')' BlocoPrincipal              { $2 :->: ([], $1, fst $5, snd $5) }

TipoRet :: { Tipo }
    : Tipo { $1 }
    | void { TVoid }

ParamFormais :: { [Var] }
    : ParamFormais ',' ParamFormal { $3 : $1 }
    | ParamFormal                  { [$1] }

ParamFormal :: { Var }
    : Tipo id { $2 :#: ($1, 0) }

-- Retorna uma tupla: (Lista de Variáveis Declaradas, Bloco de Comandos)
BlocoPrincipal :: { ([Var], Bloco) }
    : '{' Declaracoes ListaCmd '}' { (concat (reverse $2), reverse $3) }
    | '{' ListaCmd '}'             { ([], reverse $2) }

Declaracoes :: { [[Var]] }
    : Declaracoes Declaracao { $2 : $1 }
    | Declaracao             { [$1] }

Declaracao :: { [Var] }
    : Tipo ListaId ';'       { map (\nome -> nome :#: ($1, 0)) (reverse $2) }

Tipo :: { Tipo }
    : int    { TInt }
    | double { TDouble }
    | string { TString }

ListaId :: { [Id] }
    : ListaId ',' id { $3 : $1 }
    | id             { [$1] }

Bloco :: { Bloco }
    : '{' ListaCmd '}' { reverse $2 }

ListaCmd :: { [Comando] }
    : ListaCmd Comando { $2 : $1 }
    | Comando          { [$1] }

Comando :: { Comando }
    : CmdSe       { $1 }
    | CmdEnquanto { $1 }
    | CmdAtrib    { $1 }
    | CmdEscrita  { $1 }
    | CmdLeitura  { $1 }
    | Retorno     { $1 }
    | ChamadaProc { $1 }

CmdSe :: { Comando }
    : if '(' ExpressaoLogica ')' Bloco            { If $3 $5 [] }
    | if '(' ExpressaoLogica ')' Bloco else Bloco { If $3 $5 $7 }

CmdEnquanto :: { Comando }
    : while '(' ExpressaoLogica ')' Bloco { While $3 $5 }

CmdAtrib :: { Comando }
    : id '=' ExpressaoAritmetica ';' { Atrib $1 $3 }
    | id '=' litStr ';'              { Atrib $1 (Lit $3) }

CmdEscrita :: { Comando }
    : print '(' ExpressaoAritmetica ')' ';' { Imp $3 }
    | print '(' litStr ')' ';'              { Imp (Lit $3) }

CmdLeitura :: { Comando }
    : read '(' id ')' ';' { Leitura $3 }

Retorno :: { Comando }
    : return ExpressaoAritmetica ';' { Ret (Just $2) }
    | return litStr ';'              { Ret (Just (Lit $2)) }
    | return ';'                     { Ret Nothing }

ChamadaProc :: { Comando }
    : ChamadaFuncao ';' { Proc (fst $1) (snd $1) }

ChamadaFuncao :: { (Id, [Expr]) }
    : id '(' ParamReais ')' { ($1, reverse $3) }
    | id '(' ')'            { ($1, []) }

ParamReais :: { [Expr] }
    : ParamReais ',' ExpressaoAritmetica { $3 : $1 }
    | ParamReais ',' litStr              { Lit $3 : $1 }
    | ExpressaoAritmetica                { [$1] }
    | litStr                             { [Lit $1] }

ExpressaoLogica :: { ExprL }
    : ExpressaoLogica '&&' ExpressaoLogica { And $1 $3 }
    | ExpressaoLogica '||' ExpressaoLogica { Or $1 $3 }
    | '!' ExpressaoLogica                  { Not $2 }
    | ExpressaoRelacional                  { Rel $1 }
    | '(' ExpressaoLogica ')'              { $2 }

ExpressaoRelacional :: { ExprR }
    : ExpressaoAritmetica '==' ExpressaoAritmetica { Req $1 $3 }
    | ExpressaoAritmetica '/=' ExpressaoAritmetica { Rdif $1 $3 }
    | ExpressaoAritmetica '<' ExpressaoAritmetica  { Rlt $1 $3 }
    | ExpressaoAritmetica '>' ExpressaoAritmetica  { Rgt $1 $3 }
    | ExpressaoAritmetica '<=' ExpressaoAritmetica { Rle $1 $3 }
    | ExpressaoAritmetica '>=' ExpressaoAritmetica { Rge $1 $3 }

ExpressaoAritmetica :: { Expr }
    : ExpressaoAritmetica '+' ExpressaoAritmetica { Add $1 $3 }
    | ExpressaoAritmetica '-' ExpressaoAritmetica { Sub $1 $3 }
    | ExpressaoAritmetica '*' ExpressaoAritmetica { Mul $1 $3 }
    | ExpressaoAritmetica '/' ExpressaoAritmetica { Div $1 $3 }
    | '-' ExpressaoAritmetica %prec UMINUS        { Neg $2 }
    | id                                          { IdVar $1 }
    | numInt                                      { Const (CInt $1) }
    | numDbl                                      { Const (CDouble $1) }
    | ChamadaFuncao                               { Chamada (fst $1) (snd $1) }
    | '(' ExpressaoAritmetica ')'                 { $2 }

{
parseError :: [Token] -> a
parseError [] = error "Erro Sintático! O arquivo terminou inesperadamente."
parseError tokens = error ("Erro Sintático Encontrado! Tokens não consumidos:\n" ++ show tokens)
}