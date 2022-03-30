%{
 int nb_ligne=1, col=1;	
%}

%token 
mc_docprogram
mc_sub
mc_variable
mc_as
mc_int
mc_flt
mc_chr
mc_str
mc_bol
mc_array
mc_constante
mc_and
mc_or
mc_not
mc_sup
mc_inf
mc_supe
mc_infe
mc_ega
mc_dif
mc_aff
mc_input
mc_output
mc_if
mc_then
mc_else
mc_do
mc_while
mc_for
mc_until
mc_body
entier_s
entier
real_s
real
caractere
string
true
false
idf
inf
pt_exclamation
sup
division
barre_v
pt_virgule
deux_pt
egal
addition
soustraction
multiplication
parenthese_o
parenthese_f
virgule
crochet_o
crochet_f
inf_slash
slash_sup

%start S

%%
S:      inf pt_exclamation mc_docprogram idf sup  
                BODY 
        inf_slash mc_docprogram sup {
                printf("prog syntaxiquement correct"); YYACCEPT;
        }
        |
        inf pt_exclamation mc_docprogram idf sup 
                BLOC_DEC_VAR 
                BODY 
        inf_slash mc_docprogram sup {
                printf("prog syntaxiquement correct"); YYACCEPT;
        }
        | 
        inf pt_exclamation mc_docprogram idf sup 
                BLOC_DEC_CONST 
                BODY 
        inf_slash mc_docprogram sup {
                printf("prog syntaxiquement correct"); YYACCEPT;
        } 
        | 
        inf pt_exclamation mc_docprogram idf sup
                BLOC_DEC
                BODY 
        inf_slash mc_docprogram sup {
                printf("prog syntaxiquement correct"); YYACCEPT;
        }       
;
BLOC_DEC: BLOC_DEC_VAR BLOC_DEC_CONST
        | BLOC_DEC_CONST BLOC_DEC_VAR
;

BLOC_DEC_VAR:   inf mc_sub mc_variable sup 
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup   
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup 
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup 
;
DEC_VAR_SIMPLE: inf idf mc_as TYPE slash_sup pt_virgule
                | inf idf LISTE_IDF_VAR mc_as TYPE slash_sup pt_virgule
                | DEC_VAR_SIMPLE inf idf mc_as TYPE slash_sup pt_virgule
                | DEC_VAR_SIMPLE inf idf LISTE_IDF_VAR mc_as TYPE slash_sup pt_virgule
;
LISTE_IDF_VAR:  barre_v idf 
                | LISTE_IDF_VAR barre_v idf
;

BLOC_DEC_TAB:   inf mc_array mc_as TYPE sup
                inf_slash mc_array sup
                |
                inf mc_array mc_as TYPE sup
                        LISTE_DEC_TAB
                inf_slash mc_array sup
;
LISTE_DEC_TAB:  inf idf deux_pt VALEURE slash_sup
                | LISTE_DEC_TAB inf idf deux_pt VALEURE slash_sup 
;

BLOC_DEC_CONST: inf mc_sub mc_constante sup 
                inf_slash mc_sub mc_constante sup
                |
                inf mc_sub mc_constante sup
                        LISTE_DEC_CONST
                inf_slash mc_sub mc_constante sup
                
;
LISTE_DEC_CONST: inf idf egal VALEURE slash_sup pt_virgule 
                | inf idf mc_as TYPE slash_sup pt_virgule
                | LISTE_DEC_CONST inf idf egal VALEURE slash_sup pt_virgule
                | LISTE_DEC_CONST inf idf mc_as TYPE slash_sup pt_virgule
;
VALEURE: ENTIER 
       | REAL 
       | BOOLEEN
       | caractere
       | string
;
ENTIER: parenthese_o entier_s parenthese_f
      | entier                             
;
REAL: parenthese_o real_s parenthese_f
    | real
;
BOOLEEN: true | false
;
TYPE: mc_int | mc_flt | mc_chr | mc_str | mc_bol
;
BODY:   inf mc_body sup inf_slash mc_body sup
        | 
        inf mc_body sup 
                LISTE_INST 
        inf_slash mc_body sup
;
LISTE_INST: INST | INST LISTE_INST
;
INST: AFFECTATION 
//     | ENT 
//     | SOR 
//     | BOUCLE_DO 
//     | BOUCLE_FOR 
//     | CONDITION_IF
;
AFFECTATION: inf mc_aff deux_pt M_G_AFF virgule M_D_AFF slash_sup                 
;
M_G_AFF: idf | ELE_TAB
;
ELE_TAB: idf crochet_o entier crochet_f
       | idf crochet_o entier_s crochet_f
; 
M_D_AFF: caractere
       | string
       | BOOLEEN
       | EXPRESSION
;
EXPRESSION: EXP_ARITH | EXP_LOGIQUE | EXP_COMPARAISON
;

EXP_ARITH: OPD
         | OPD OPT EXP_ARITH
         | EXP_ARITH_PAR 
;
EXP_ARITH_PAR: parenthese_o EXP_ARITH parenthese_f
             | parenthese_o EXP_ARITH parenthese_f OPT EXP_ARITH
;
OPD: ENTIER 
   | REAL 
   | idf
   | ELE_TAB
;
OPT: addition
   | soustraction
   | multiplication
   | division
;

EXP_LOGIQUE: mc_and parenthese_o EXP LISTE_EXP parenthese_f
            | mc_or parenthese_o EXP LISTE_EXP parenthese_f
            | mc_not parenthese_o EXP parenthese_f
;
EXP: BOOLEEN | caractere | string | EXPRESSION
;
LISTE_EXP: virgule EXP
        | virgule EXP LISTE_EXP
;

EXP_COMPARAISON: MC_COMP parenthese_o M_D_AFF virgule M_D_AFF parenthese_f 
;
MC_COMP: mc_sup | mc_inf | mc_supe | mc_infe | mc_ega | mc_dif
;
%%
main()
{
yyparse();
}
yywrap()
{}
yyerror(char* msg)
{
    printf("Erreur syntaxique a la ligne %d la col %d !\n", nb_ligne, col);
}
