{-# OPTIONS_GHC -w #-}
module Parser where
import Lex
import AST
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Programa)
	| HappyAbsSyn5 ([Funcao])
	| HappyAbsSyn6 (Funcao)
	| HappyAbsSyn7 (Tipo)
	| HappyAbsSyn8 ([Var])
	| HappyAbsSyn9 (Var)
	| HappyAbsSyn10 (([Var], Bloco))
	| HappyAbsSyn11 ([[Var]])
	| HappyAbsSyn14 ([Id])
	| HappyAbsSyn15 (Bloco)
	| HappyAbsSyn16 ([Comando])
	| HappyAbsSyn17 (Comando)
	| HappyAbsSyn25 ((Id, [Expr]))
	| HappyAbsSyn26 ([Expr])
	| HappyAbsSyn27 (ExprL)
	| HappyAbsSyn28 (ExprR)
	| HappyAbsSyn29 (Expr)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140 :: () => Prelude.Int -> ({-HappyReduction (HappyIdentity) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,338) ([0,57344,129,0,0,57344,1,0,0,57344,129,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,57344,122,2048,0,57344,122,2048,0,0,0,0,0,0,0,2048,0,0,378,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,512,0,0,0,512,0,0,0,512,0,0,0,512,0,0,0,2560,30976,0,0,8704,0,0,0,512,0,0,0,0,0,0,0,0,0,0,57344,1024,0,0,0,1536,30976,0,0,512,30976,0,0,0,0,0,0,2048,1920,0,0,512,14592,0,0,0,0,0,0,512,14592,0,0,512,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,2048,0,0,512,30976,0,0,512,14656,0,0,512,14656,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6144,0,0,0,0,0,0,0,0,0,0,0,378,2048,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,1024,48,0,0,0,0,0,0,49152,1935,0,0,512,14656,0,0,512,14656,0,0,1024,48,0,0,1024,1920,0,0,1024,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,1024,1920,0,0,0,0,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,2048,1920,0,0,2048,0,0,0,5120,0,0,0,0,1920,0,0,0,0,0,0,0,0,0,0,5120,0,0,0,0,0,0,0,0,2048,0,0,128,0,0,0,0,0,0,0,0,0,0,0,128,0,0,57344,0,0,0,0,0,0,0,0,512,30976,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1536,0,0,0,1536,0,0,0,0,0,0,2048,0,0,0,2048,0,0,0,2048,0,0,0,128,0,0,0,512,14656,0,0,512,14656,0,0,0,0,0,0,1024,48,0,0,50176,1935,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,512,14592,0,0,128,0,0,0,0,0,0,0,4,0,0,0,122,2048,0,0,0,1920,0,0,0,1920,0,0,0,1920,0,0,0,1920,0,0,0,1920,0,0,0,1920,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1920,0,0,0,0,0,0,0,0,0,0,0,0,0,0,378,2048,0,0,128,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseProgram","Programa","ListaFuncoes","Funcao","TipoRet","ParamFormais","ParamFormal","BlocoPrincipal","Declaracoes","Declaracao","Tipo","ListaId","Bloco","ListaCmd","Comando","CmdSe","CmdEnquanto","CmdAtrib","CmdEscrita","CmdLeitura","Retorno","ChamadaProc","ChamadaFuncao","ParamReais","ExpressaoLogica","ExpressaoRelacional","ExpressaoAritmetica","int","double","string","void","if","else","while","print","read","return","'{'","'}'","'('","')'","';'","','","'='","'=='","'/='","'<'","'>'","'<='","'>='","'&&'","'||'","'!'","'+'","'-'","'*'","'/'","id","numInt","numDbl","litStr","%eof"]
        bit_start = st Prelude.* 64
        bit_end = (st Prelude.+ 1) Prelude.* 64
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..63]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (30) = happyShift action_6
action_0 (31) = happyShift action_7
action_0 (32) = happyShift action_8
action_0 (33) = happyShift action_9
action_0 (40) = happyShift action_12
action_0 (4) = happyGoto action_10
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (10) = happyGoto action_11
action_0 (13) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (30) = happyShift action_6
action_1 (31) = happyShift action_7
action_1 (32) = happyShift action_8
action_1 (33) = happyShift action_9
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (13) = happyGoto action_5
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (30) = happyShift action_6
action_2 (31) = happyShift action_7
action_2 (32) = happyShift action_8
action_2 (33) = happyShift action_9
action_2 (40) = happyShift action_12
action_2 (6) = happyGoto action_33
action_2 (7) = happyGoto action_4
action_2 (10) = happyGoto action_34
action_2 (13) = happyGoto action_5
action_2 _ = happyFail (happyExpListPerState 2)

action_3 _ = happyReduce_4

action_4 (60) = happyShift action_32
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_7

action_6 _ = happyReduce_17

action_7 _ = happyReduce_18

action_8 _ = happyReduce_19

action_9 _ = happyReduce_8

action_10 (64) = happyAccept
action_10 _ = happyFail (happyExpListPerState 10)

action_11 _ = happyReduce_2

action_12 (30) = happyShift action_6
action_12 (31) = happyShift action_7
action_12 (32) = happyShift action_8
action_12 (34) = happyShift action_26
action_12 (36) = happyShift action_27
action_12 (37) = happyShift action_28
action_12 (38) = happyShift action_29
action_12 (39) = happyShift action_30
action_12 (60) = happyShift action_31
action_12 (11) = happyGoto action_13
action_12 (12) = happyGoto action_14
action_12 (13) = happyGoto action_15
action_12 (16) = happyGoto action_16
action_12 (17) = happyGoto action_17
action_12 (18) = happyGoto action_18
action_12 (19) = happyGoto action_19
action_12 (20) = happyGoto action_20
action_12 (21) = happyGoto action_21
action_12 (22) = happyGoto action_22
action_12 (23) = happyGoto action_23
action_12 (24) = happyGoto action_24
action_12 (25) = happyGoto action_25
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (30) = happyShift action_6
action_13 (31) = happyShift action_7
action_13 (32) = happyShift action_8
action_13 (34) = happyShift action_26
action_13 (36) = happyShift action_27
action_13 (37) = happyShift action_28
action_13 (38) = happyShift action_29
action_13 (39) = happyShift action_30
action_13 (60) = happyShift action_31
action_13 (12) = happyGoto action_56
action_13 (13) = happyGoto action_15
action_13 (16) = happyGoto action_57
action_13 (17) = happyGoto action_17
action_13 (18) = happyGoto action_18
action_13 (19) = happyGoto action_19
action_13 (20) = happyGoto action_20
action_13 (21) = happyGoto action_21
action_13 (22) = happyGoto action_22
action_13 (23) = happyGoto action_23
action_13 (24) = happyGoto action_24
action_13 (25) = happyGoto action_25
action_13 _ = happyFail (happyExpListPerState 13)

action_14 _ = happyReduce_15

action_15 (60) = happyShift action_55
action_15 (14) = happyGoto action_54
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (34) = happyShift action_26
action_16 (36) = happyShift action_27
action_16 (37) = happyShift action_28
action_16 (38) = happyShift action_29
action_16 (39) = happyShift action_30
action_16 (41) = happyShift action_53
action_16 (60) = happyShift action_31
action_16 (17) = happyGoto action_52
action_16 (18) = happyGoto action_18
action_16 (19) = happyGoto action_19
action_16 (20) = happyGoto action_20
action_16 (21) = happyGoto action_21
action_16 (22) = happyGoto action_22
action_16 (23) = happyGoto action_23
action_16 (24) = happyGoto action_24
action_16 (25) = happyGoto action_25
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_24

action_18 _ = happyReduce_25

action_19 _ = happyReduce_26

action_20 _ = happyReduce_27

action_21 _ = happyReduce_28

action_22 _ = happyReduce_29

action_23 _ = happyReduce_30

action_24 _ = happyReduce_31

action_25 (44) = happyShift action_51
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (42) = happyShift action_50
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (42) = happyShift action_49
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (42) = happyShift action_48
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (42) = happyShift action_47
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (42) = happyShift action_40
action_30 (44) = happyShift action_41
action_30 (57) = happyShift action_42
action_30 (60) = happyShift action_43
action_30 (61) = happyShift action_44
action_30 (62) = happyShift action_45
action_30 (63) = happyShift action_46
action_30 (25) = happyGoto action_38
action_30 (29) = happyGoto action_39
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (42) = happyShift action_36
action_31 (46) = happyShift action_37
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (42) = happyShift action_35
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_3

action_34 _ = happyReduce_1

action_35 (30) = happyShift action_6
action_35 (31) = happyShift action_7
action_35 (32) = happyShift action_8
action_35 (43) = happyShift action_87
action_35 (8) = happyGoto action_84
action_35 (9) = happyGoto action_85
action_35 (13) = happyGoto action_86
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (42) = happyShift action_40
action_36 (43) = happyShift action_82
action_36 (57) = happyShift action_42
action_36 (60) = happyShift action_43
action_36 (61) = happyShift action_44
action_36 (62) = happyShift action_45
action_36 (63) = happyShift action_83
action_36 (25) = happyGoto action_38
action_36 (26) = happyGoto action_80
action_36 (29) = happyGoto action_81
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (42) = happyShift action_40
action_37 (57) = happyShift action_42
action_37 (60) = happyShift action_43
action_37 (61) = happyShift action_44
action_37 (62) = happyShift action_45
action_37 (63) = happyShift action_79
action_37 (25) = happyGoto action_38
action_37 (29) = happyGoto action_78
action_37 _ = happyFail (happyExpListPerState 37)

action_38 _ = happyReduce_69

action_39 (44) = happyShift action_73
action_39 (56) = happyShift action_74
action_39 (57) = happyShift action_75
action_39 (58) = happyShift action_76
action_39 (59) = happyShift action_77
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (42) = happyShift action_40
action_40 (57) = happyShift action_42
action_40 (60) = happyShift action_43
action_40 (61) = happyShift action_44
action_40 (62) = happyShift action_45
action_40 (25) = happyGoto action_38
action_40 (29) = happyGoto action_72
action_40 _ = happyFail (happyExpListPerState 40)

action_41 _ = happyReduce_42

action_42 (42) = happyShift action_40
action_42 (57) = happyShift action_42
action_42 (60) = happyShift action_43
action_42 (61) = happyShift action_44
action_42 (62) = happyShift action_45
action_42 (25) = happyGoto action_38
action_42 (29) = happyGoto action_71
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (42) = happyShift action_36
action_43 _ = happyReduce_66

action_44 _ = happyReduce_67

action_45 _ = happyReduce_68

action_46 (44) = happyShift action_70
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (60) = happyShift action_69
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (42) = happyShift action_40
action_48 (57) = happyShift action_42
action_48 (60) = happyShift action_43
action_48 (61) = happyShift action_44
action_48 (62) = happyShift action_45
action_48 (63) = happyShift action_68
action_48 (25) = happyGoto action_38
action_48 (29) = happyGoto action_67
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (42) = happyShift action_64
action_49 (55) = happyShift action_65
action_49 (57) = happyShift action_42
action_49 (60) = happyShift action_43
action_49 (61) = happyShift action_44
action_49 (62) = happyShift action_45
action_49 (25) = happyGoto action_38
action_49 (27) = happyGoto action_66
action_49 (28) = happyGoto action_62
action_49 (29) = happyGoto action_63
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (42) = happyShift action_64
action_50 (55) = happyShift action_65
action_50 (57) = happyShift action_42
action_50 (60) = happyShift action_43
action_50 (61) = happyShift action_44
action_50 (62) = happyShift action_45
action_50 (25) = happyGoto action_38
action_50 (27) = happyGoto action_61
action_50 (28) = happyGoto action_62
action_50 (29) = happyGoto action_63
action_50 _ = happyFail (happyExpListPerState 50)

action_51 _ = happyReduce_43

action_52 _ = happyReduce_23

action_53 _ = happyReduce_13

action_54 (44) = happyShift action_59
action_54 (45) = happyShift action_60
action_54 _ = happyFail (happyExpListPerState 54)

action_55 _ = happyReduce_21

action_56 _ = happyReduce_14

action_57 (34) = happyShift action_26
action_57 (36) = happyShift action_27
action_57 (37) = happyShift action_28
action_57 (38) = happyShift action_29
action_57 (39) = happyShift action_30
action_57 (41) = happyShift action_58
action_57 (60) = happyShift action_31
action_57 (17) = happyGoto action_52
action_57 (18) = happyGoto action_18
action_57 (19) = happyGoto action_19
action_57 (20) = happyGoto action_20
action_57 (21) = happyGoto action_21
action_57 (22) = happyGoto action_22
action_57 (23) = happyGoto action_23
action_57 (24) = happyGoto action_24
action_57 (25) = happyGoto action_25
action_57 _ = happyFail (happyExpListPerState 57)

action_58 _ = happyReduce_12

action_59 _ = happyReduce_16

action_60 (60) = happyShift action_117
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (43) = happyShift action_116
action_61 (53) = happyShift action_105
action_61 (54) = happyShift action_106
action_61 _ = happyFail (happyExpListPerState 61)

action_62 _ = happyReduce_53

action_63 (47) = happyShift action_110
action_63 (48) = happyShift action_111
action_63 (49) = happyShift action_112
action_63 (50) = happyShift action_113
action_63 (51) = happyShift action_114
action_63 (52) = happyShift action_115
action_63 (56) = happyShift action_74
action_63 (57) = happyShift action_75
action_63 (58) = happyShift action_76
action_63 (59) = happyShift action_77
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (42) = happyShift action_64
action_64 (55) = happyShift action_65
action_64 (57) = happyShift action_42
action_64 (60) = happyShift action_43
action_64 (61) = happyShift action_44
action_64 (62) = happyShift action_45
action_64 (25) = happyGoto action_38
action_64 (27) = happyGoto action_108
action_64 (28) = happyGoto action_62
action_64 (29) = happyGoto action_109
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (42) = happyShift action_64
action_65 (55) = happyShift action_65
action_65 (57) = happyShift action_42
action_65 (60) = happyShift action_43
action_65 (61) = happyShift action_44
action_65 (62) = happyShift action_45
action_65 (25) = happyGoto action_38
action_65 (27) = happyGoto action_107
action_65 (28) = happyGoto action_62
action_65 (29) = happyGoto action_63
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (43) = happyShift action_104
action_66 (53) = happyShift action_105
action_66 (54) = happyShift action_106
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (43) = happyShift action_103
action_67 (56) = happyShift action_74
action_67 (57) = happyShift action_75
action_67 (58) = happyShift action_76
action_67 (59) = happyShift action_77
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (43) = happyShift action_102
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (43) = happyShift action_101
action_69 _ = happyFail (happyExpListPerState 69)

action_70 _ = happyReduce_41

action_71 _ = happyReduce_65

action_72 (43) = happyShift action_100
action_72 (56) = happyShift action_74
action_72 (57) = happyShift action_75
action_72 (58) = happyShift action_76
action_72 (59) = happyShift action_77
action_72 _ = happyFail (happyExpListPerState 72)

action_73 _ = happyReduce_40

action_74 (42) = happyShift action_40
action_74 (57) = happyShift action_42
action_74 (60) = happyShift action_43
action_74 (61) = happyShift action_44
action_74 (62) = happyShift action_45
action_74 (25) = happyGoto action_38
action_74 (29) = happyGoto action_99
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (42) = happyShift action_40
action_75 (57) = happyShift action_42
action_75 (60) = happyShift action_43
action_75 (61) = happyShift action_44
action_75 (62) = happyShift action_45
action_75 (25) = happyGoto action_38
action_75 (29) = happyGoto action_98
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (42) = happyShift action_40
action_76 (57) = happyShift action_42
action_76 (60) = happyShift action_43
action_76 (61) = happyShift action_44
action_76 (62) = happyShift action_45
action_76 (25) = happyGoto action_38
action_76 (29) = happyGoto action_97
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (42) = happyShift action_40
action_77 (57) = happyShift action_42
action_77 (60) = happyShift action_43
action_77 (61) = happyShift action_44
action_77 (62) = happyShift action_45
action_77 (25) = happyGoto action_38
action_77 (29) = happyGoto action_96
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (44) = happyShift action_95
action_78 (56) = happyShift action_74
action_78 (57) = happyShift action_75
action_78 (58) = happyShift action_76
action_78 (59) = happyShift action_77
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (44) = happyShift action_94
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (43) = happyShift action_92
action_80 (45) = happyShift action_93
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (56) = happyShift action_74
action_81 (57) = happyShift action_75
action_81 (58) = happyShift action_76
action_81 (59) = happyShift action_77
action_81 _ = happyReduce_48

action_82 _ = happyReduce_45

action_83 _ = happyReduce_49

action_84 (43) = happyShift action_90
action_84 (45) = happyShift action_91
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_10

action_86 (60) = happyShift action_89
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (40) = happyShift action_12
action_87 (10) = happyGoto action_88
action_87 _ = happyFail (happyExpListPerState 87)

action_88 _ = happyReduce_6

action_89 _ = happyReduce_11

action_90 (40) = happyShift action_12
action_90 (10) = happyGoto action_136
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (30) = happyShift action_6
action_91 (31) = happyShift action_7
action_91 (32) = happyShift action_8
action_91 (9) = happyGoto action_135
action_91 (13) = happyGoto action_86
action_91 _ = happyFail (happyExpListPerState 91)

action_92 _ = happyReduce_44

action_93 (42) = happyShift action_40
action_93 (57) = happyShift action_42
action_93 (60) = happyShift action_43
action_93 (61) = happyShift action_44
action_93 (62) = happyShift action_45
action_93 (63) = happyShift action_134
action_93 (25) = happyGoto action_38
action_93 (29) = happyGoto action_133
action_93 _ = happyFail (happyExpListPerState 93)

action_94 _ = happyReduce_36

action_95 _ = happyReduce_35

action_96 _ = happyReduce_64

action_97 _ = happyReduce_63

action_98 (58) = happyShift action_76
action_98 (59) = happyShift action_77
action_98 _ = happyReduce_62

action_99 (58) = happyShift action_76
action_99 (59) = happyShift action_77
action_99 _ = happyReduce_61

action_100 _ = happyReduce_70

action_101 (44) = happyShift action_132
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (44) = happyShift action_131
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (44) = happyShift action_130
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (40) = happyShift action_119
action_104 (15) = happyGoto action_129
action_104 _ = happyFail (happyExpListPerState 104)

action_105 (42) = happyShift action_64
action_105 (55) = happyShift action_65
action_105 (57) = happyShift action_42
action_105 (60) = happyShift action_43
action_105 (61) = happyShift action_44
action_105 (62) = happyShift action_45
action_105 (25) = happyGoto action_38
action_105 (27) = happyGoto action_128
action_105 (28) = happyGoto action_62
action_105 (29) = happyGoto action_63
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (42) = happyShift action_64
action_106 (55) = happyShift action_65
action_106 (57) = happyShift action_42
action_106 (60) = happyShift action_43
action_106 (61) = happyShift action_44
action_106 (62) = happyShift action_45
action_106 (25) = happyGoto action_38
action_106 (27) = happyGoto action_127
action_106 (28) = happyGoto action_62
action_106 (29) = happyGoto action_63
action_106 _ = happyFail (happyExpListPerState 106)

action_107 _ = happyReduce_52

action_108 (43) = happyShift action_126
action_108 (53) = happyShift action_105
action_108 (54) = happyShift action_106
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (43) = happyShift action_100
action_109 (47) = happyShift action_110
action_109 (48) = happyShift action_111
action_109 (49) = happyShift action_112
action_109 (50) = happyShift action_113
action_109 (51) = happyShift action_114
action_109 (52) = happyShift action_115
action_109 (56) = happyShift action_74
action_109 (57) = happyShift action_75
action_109 (58) = happyShift action_76
action_109 (59) = happyShift action_77
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (42) = happyShift action_40
action_110 (57) = happyShift action_42
action_110 (60) = happyShift action_43
action_110 (61) = happyShift action_44
action_110 (62) = happyShift action_45
action_110 (25) = happyGoto action_38
action_110 (29) = happyGoto action_125
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (42) = happyShift action_40
action_111 (57) = happyShift action_42
action_111 (60) = happyShift action_43
action_111 (61) = happyShift action_44
action_111 (62) = happyShift action_45
action_111 (25) = happyGoto action_38
action_111 (29) = happyGoto action_124
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (42) = happyShift action_40
action_112 (57) = happyShift action_42
action_112 (60) = happyShift action_43
action_112 (61) = happyShift action_44
action_112 (62) = happyShift action_45
action_112 (25) = happyGoto action_38
action_112 (29) = happyGoto action_123
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (42) = happyShift action_40
action_113 (57) = happyShift action_42
action_113 (60) = happyShift action_43
action_113 (61) = happyShift action_44
action_113 (62) = happyShift action_45
action_113 (25) = happyGoto action_38
action_113 (29) = happyGoto action_122
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (42) = happyShift action_40
action_114 (57) = happyShift action_42
action_114 (60) = happyShift action_43
action_114 (61) = happyShift action_44
action_114 (62) = happyShift action_45
action_114 (25) = happyGoto action_38
action_114 (29) = happyGoto action_121
action_114 _ = happyFail (happyExpListPerState 114)

action_115 (42) = happyShift action_40
action_115 (57) = happyShift action_42
action_115 (60) = happyShift action_43
action_115 (61) = happyShift action_44
action_115 (62) = happyShift action_45
action_115 (25) = happyGoto action_38
action_115 (29) = happyGoto action_120
action_115 _ = happyFail (happyExpListPerState 115)

action_116 (40) = happyShift action_119
action_116 (15) = happyGoto action_118
action_116 _ = happyFail (happyExpListPerState 116)

action_117 _ = happyReduce_20

action_118 (35) = happyShift action_138
action_118 _ = happyReduce_32

action_119 (34) = happyShift action_26
action_119 (36) = happyShift action_27
action_119 (37) = happyShift action_28
action_119 (38) = happyShift action_29
action_119 (39) = happyShift action_30
action_119 (60) = happyShift action_31
action_119 (16) = happyGoto action_137
action_119 (17) = happyGoto action_17
action_119 (18) = happyGoto action_18
action_119 (19) = happyGoto action_19
action_119 (20) = happyGoto action_20
action_119 (21) = happyGoto action_21
action_119 (22) = happyGoto action_22
action_119 (23) = happyGoto action_23
action_119 (24) = happyGoto action_24
action_119 (25) = happyGoto action_25
action_119 _ = happyFail (happyExpListPerState 119)

action_120 (56) = happyShift action_74
action_120 (57) = happyShift action_75
action_120 (58) = happyShift action_76
action_120 (59) = happyShift action_77
action_120 _ = happyReduce_60

action_121 (56) = happyShift action_74
action_121 (57) = happyShift action_75
action_121 (58) = happyShift action_76
action_121 (59) = happyShift action_77
action_121 _ = happyReduce_59

action_122 (56) = happyShift action_74
action_122 (57) = happyShift action_75
action_122 (58) = happyShift action_76
action_122 (59) = happyShift action_77
action_122 _ = happyReduce_58

action_123 (56) = happyShift action_74
action_123 (57) = happyShift action_75
action_123 (58) = happyShift action_76
action_123 (59) = happyShift action_77
action_123 _ = happyReduce_57

action_124 (56) = happyShift action_74
action_124 (57) = happyShift action_75
action_124 (58) = happyShift action_76
action_124 (59) = happyShift action_77
action_124 _ = happyReduce_56

action_125 (56) = happyShift action_74
action_125 (57) = happyShift action_75
action_125 (58) = happyShift action_76
action_125 (59) = happyShift action_77
action_125 _ = happyReduce_55

action_126 _ = happyReduce_54

action_127 _ = happyReduce_51

action_128 _ = happyReduce_50

action_129 _ = happyReduce_34

action_130 _ = happyReduce_37

action_131 _ = happyReduce_38

action_132 _ = happyReduce_39

action_133 (56) = happyShift action_74
action_133 (57) = happyShift action_75
action_133 (58) = happyShift action_76
action_133 (59) = happyShift action_77
action_133 _ = happyReduce_46

action_134 _ = happyReduce_47

action_135 _ = happyReduce_9

action_136 _ = happyReduce_5

action_137 (34) = happyShift action_26
action_137 (36) = happyShift action_27
action_137 (37) = happyShift action_28
action_137 (38) = happyShift action_29
action_137 (39) = happyShift action_30
action_137 (41) = happyShift action_140
action_137 (60) = happyShift action_31
action_137 (17) = happyGoto action_52
action_137 (18) = happyGoto action_18
action_137 (19) = happyGoto action_19
action_137 (20) = happyGoto action_20
action_137 (21) = happyGoto action_21
action_137 (22) = happyGoto action_22
action_137 (23) = happyGoto action_23
action_137 (24) = happyGoto action_24
action_137 (25) = happyGoto action_25
action_137 _ = happyFail (happyExpListPerState 137)

action_138 (40) = happyShift action_119
action_138 (15) = happyGoto action_139
action_138 _ = happyFail (happyExpListPerState 138)

action_139 _ = happyReduce_33

action_140 _ = happyReduce_22

happyReduce_1 = happySpecReduce_2  4 happyReduction_1
happyReduction_1 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Prog (reverse happy_var_1) (fst happy_var_2) (snd happy_var_2)
	)
happyReduction_1 _ _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  4 happyReduction_2
happyReduction_2 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn4
		 (Prog [] (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_2 : happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  5 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happyReduce 6 6 happyReduction_5
happyReduction_5 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_2)) `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (happy_var_2 :->: (reverse happy_var_4, happy_var_1, fst happy_var_6, snd happy_var_6)
	) `HappyStk` happyRest

happyReduce_6 = happyReduce 5 6 happyReduction_6
happyReduction_6 ((HappyAbsSyn10  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_2)) `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (happy_var_2 :->: ([], happy_var_1, fst happy_var_5, snd happy_var_5)
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  7 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  7 happyReduction_8
happyReduction_8 _
	 =  HappyAbsSyn7
		 (TVoid
	)

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_3 : happy_var_1
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_2  9 happyReduction_11
happyReduction_11 (HappyTerminal (TkIdentificador happy_var_2))
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_2 :#: (happy_var_1, 0)
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happyReduce 4 10 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	(HappyAbsSyn11  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ((concat (reverse happy_var_2), reverse happy_var_3)
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_3  10 happyReduction_13
happyReduction_13 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (([], reverse happy_var_2)
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  11 happyReduction_14
happyReduction_14 (HappyAbsSyn8  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_2 : happy_var_1
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  11 happyReduction_15
happyReduction_15 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn11
		 ([happy_var_1]
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  12 happyReduction_16
happyReduction_16 _
	(HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn8
		 (map (\nome -> nome :#: (happy_var_1, 0)) (reverse happy_var_2)
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  13 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn7
		 (TInt
	)

happyReduce_18 = happySpecReduce_1  13 happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn7
		 (TDouble
	)

happyReduce_19 = happySpecReduce_1  13 happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn7
		 (TString
	)

happyReduce_20 = happySpecReduce_3  14 happyReduction_20
happyReduction_20 (HappyTerminal (TkIdentificador happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_3 : happy_var_1
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  14 happyReduction_21
happyReduction_21 (HappyTerminal (TkIdentificador happy_var_1))
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  15 happyReduction_22
happyReduction_22 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (reverse happy_var_2
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  16 happyReduction_23
happyReduction_23 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_2 : happy_var_1
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  16 happyReduction_24
happyReduction_24 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  17 happyReduction_25
happyReduction_25 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  17 happyReduction_26
happyReduction_26 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  17 happyReduction_27
happyReduction_27 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  17 happyReduction_28
happyReduction_28 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  17 happyReduction_29
happyReduction_29 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  17 happyReduction_30
happyReduction_30 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  17 happyReduction_31
happyReduction_31 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happyReduce 5 18 happyReduction_32
happyReduction_32 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (If happy_var_3 happy_var_5 []
	) `HappyStk` happyRest

happyReduce_33 = happyReduce 7 18 happyReduction_33
happyReduction_33 ((HappyAbsSyn15  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (If happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_34 = happyReduce 5 19 happyReduction_34
happyReduction_34 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_35 = happyReduce 4 20 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Atrib happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_36 = happyReduce 4 20 happyReduction_36
happyReduction_36 (_ `HappyStk`
	(HappyTerminal (TkLitTexto happy_var_3)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Atrib happy_var_1 (Lit happy_var_3)
	) `HappyStk` happyRest

happyReduce_37 = happyReduce 5 21 happyReduction_37
happyReduction_37 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Imp happy_var_3
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 5 21 happyReduction_38
happyReduction_38 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkLitTexto happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Imp (Lit happy_var_3)
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 5 22 happyReduction_39
happyReduction_39 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Leitura happy_var_3
	) `HappyStk` happyRest

happyReduce_40 = happySpecReduce_3  23 happyReduction_40
happyReduction_40 _
	(HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn17
		 (Ret (Just happy_var_2)
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  23 happyReduction_41
happyReduction_41 _
	(HappyTerminal (TkLitTexto happy_var_2))
	_
	 =  HappyAbsSyn17
		 (Ret (Just (Lit happy_var_2))
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_2  23 happyReduction_42
happyReduction_42 _
	_
	 =  HappyAbsSyn17
		 (Ret Nothing
	)

happyReduce_43 = happySpecReduce_2  24 happyReduction_43
happyReduction_43 _
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn17
		 (Proc (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_43 _ _  = notHappyAtAll 

happyReduce_44 = happyReduce 4 25 happyReduction_44
happyReduction_44 (_ `HappyStk`
	(HappyAbsSyn26  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TkIdentificador happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 ((happy_var_1, reverse happy_var_3)
	) `HappyStk` happyRest

happyReduce_45 = happySpecReduce_3  25 happyReduction_45
happyReduction_45 _
	_
	(HappyTerminal (TkIdentificador happy_var_1))
	 =  HappyAbsSyn25
		 ((happy_var_1, [])
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  26 happyReduction_46
happyReduction_46 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_3 : happy_var_1
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  26 happyReduction_47
happyReduction_47 (HappyTerminal (TkLitTexto happy_var_3))
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (Lit happy_var_3 : happy_var_1
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  26 happyReduction_48
happyReduction_48 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  26 happyReduction_49
happyReduction_49 (HappyTerminal (TkLitTexto happy_var_1))
	 =  HappyAbsSyn26
		 ([Lit happy_var_1]
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  27 happyReduction_50
happyReduction_50 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (And happy_var_1 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  27 happyReduction_51
happyReduction_51 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (Or happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_2  27 happyReduction_52
happyReduction_52 (HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn27
		 (Not happy_var_2
	)
happyReduction_52 _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  27 happyReduction_53
happyReduction_53 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn27
		 (Rel happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  27 happyReduction_54
happyReduction_54 _
	(HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn27
		 (happy_var_2
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  28 happyReduction_55
happyReduction_55 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Req happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  28 happyReduction_56
happyReduction_56 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rdif happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  28 happyReduction_57
happyReduction_57 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rlt happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  28 happyReduction_58
happyReduction_58 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rgt happy_var_1 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  28 happyReduction_59
happyReduction_59 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rle happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  28 happyReduction_60
happyReduction_60 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rge happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  29 happyReduction_61
happyReduction_61 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (Add happy_var_1 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  29 happyReduction_62
happyReduction_62 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  29 happyReduction_63
happyReduction_63 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (Mul happy_var_1 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  29 happyReduction_64
happyReduction_64 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (Div happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  29 happyReduction_65
happyReduction_65 (HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (Neg happy_var_2
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  29 happyReduction_66
happyReduction_66 (HappyTerminal (TkIdentificador happy_var_1))
	 =  HappyAbsSyn29
		 (IdVar happy_var_1
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_1  29 happyReduction_67
happyReduction_67 (HappyTerminal (TkLitInteiro happy_var_1))
	 =  HappyAbsSyn29
		 (Const (CInt happy_var_1)
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  29 happyReduction_68
happyReduction_68 (HappyTerminal (TkLitReal happy_var_1))
	 =  HappyAbsSyn29
		 (Const (CDouble happy_var_1)
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  29 happyReduction_69
happyReduction_69 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn29
		 (Chamada (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  29 happyReduction_70
happyReduction_70 _
	(HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (happy_var_2
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 64 64 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TkInteiro -> cont 30;
	TkReal -> cont 31;
	TkTexto -> cont 32;
	TkVazio -> cont 33;
	TkSe -> cont 34;
	TkSenao -> cont 35;
	TkEnquanto -> cont 36;
	TkImprimir -> cont 37;
	TkLer -> cont 38;
	TkRetornar -> cont 39;
	TkAbreChave -> cont 40;
	TkFechaChave -> cont 41;
	TkAbreParen -> cont 42;
	TkFechaParen -> cont 43;
	TkPontoVirgula -> cont 44;
	TkVirgula -> cont 45;
	TkAtribuicao -> cont 46;
	TkIgual -> cont 47;
	TkDiferente -> cont 48;
	TkMenor -> cont 49;
	TkMaior -> cont 50;
	TkMenorIgual -> cont 51;
	TkMaiorIgual -> cont 52;
	TkE -> cont 53;
	TkOu -> cont 54;
	TkNao -> cont 55;
	TkSoma -> cont 56;
	TkSubtracao -> cont 57;
	TkMultiplicacao -> cont 58;
	TkDivisao -> cont 59;
	TkIdentificador happy_dollar_dollar -> cont 60;
	TkLitInteiro happy_dollar_dollar -> cont 61;
	TkLitReal happy_dollar_dollar -> cont 62;
	TkLitTexto happy_dollar_dollar -> cont 63;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 64 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Prelude.Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Prelude.Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (Prelude.return)
happyThen1 m k tks = (Prelude.>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (Prelude.return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> HappyIdentity a
happyError' = HappyIdentity Prelude.. (\(tokens, _) -> parseError tokens)
parseProgram tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError [] = error "Erro Sintático! O arquivo terminou inesperadamente."
parseError tokens = error ("Erro Sintático Encontrado! Tokens não consumidos:\n" ++ show tokens)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
