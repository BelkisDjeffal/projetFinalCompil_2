%{
    #include "syn.tab.h"
    #include <string.h>
    extern nb_ligne, col;
%}

idf         [A-Za-z_][A-Za-z0-9_]*
cstInt      [+-]?[0-9]+
cstFlt      [+-]?[0-9]{1,7}\.[0-9]{1,3}
errFlt      [+-]?[0-9]+\.[0-9]+
cstChr      \'.\'
cstStr      \"[^"]*\"
cstBol      TRUE|FALSE
slashSup    \/[ ]*\>
infSlash    \<[ ]*\/
comment     <!--.*-->

%%

docprogram  {col = col + strlen(yytext); return mc_docprogram;}
SUB         {col = col + strlen(yytext); return mc_sub;}
VARIABLE    {col = col + strlen(yytext); return mc_variable;}
AS          {col = col + strlen(yytext); return mc_as;}
INT         {col = col + strlen(yytext); return mc_int;}
FLT         {col = col + strlen(yytext); return mc_flt;}
CHR         {col = col + strlen(yytext); return mc_chr;}
STR         {col = col + strlen(yytext); return mc_str;}
BOL         {col = col + strlen(yytext); return mc_bol;}
ARRAY       {col = col + strlen(yytext); return mc_array;}
CONSTANTE   {col = col + strlen(yytext); return mc_constante;}
AND         {col = col + strlen(yytext); return mc_and;}
OR          {col = col + strlen(yytext); return mc_or;}
NOT         {col = col + strlen(yytext); return mc_not;}
SUP         {col = col + strlen(yytext); return mc_sup;}
INF         {col = col + strlen(yytext); return mc_inf;}
SUPE        {col = col + strlen(yytext); return mc_supe;}
INFE        {col = col + strlen(yytext); return mc_infe;}
EGA         {col = col + strlen(yytext); return mc_ega;}
DIF         {col = col + strlen(yytext); return mc_dif;}
AFF         {col = col + strlen(yytext); return mc_aff;}
INPUT       {col = col + strlen(yytext); return mc_input;}
OUTPUT      {col = col + strlen(yytext); return mc_output;}
IF          {col = col + strlen(yytext); return mc_if;}
THEN        {col = col + strlen(yytext); return mc_then;}
ELSE        {col = col + strlen(yytext); return mc_else;}
DO          {col = col + strlen(yytext); return mc_do;}
WHILE       {col = col + strlen(yytext); return mc_while;}
FOR         {col = col + strlen(yytext); return mc_for;}
UNTIL       {col = col + strlen(yytext); return mc_until;}
body        {col = col + strlen(yytext); return mc_body;}

{cstInt}    { 
                if(atoi(yytext) >= -32768 && atoi(yytext) <= 32767)
                {
                    col = col + strlen(yytext);
                    if(yytext[0] == '+' || yytext[0] == '-')
                       return entier_s;
                    else
                        return entier;                        
                }else
                    printf("erreur lexical a la ligne %d  la col %d l'entier %s n'appartient pas a l'intervalle [-32768, 32767] \n", nb_ligne, col, yytext);
            }
{cstFlt}    {
                col = col + strlen(yytext);
                if(yytext[0] == '+' || yytext[0] == '-')
                    return real_s;
                else 
                    return real;
            }
{errFlt}    {printf("erreur lexical a la ligne %d la col %d le real %s ne respcte pas la forme [1-7.1-3] \n", nb_ligne, col, yytext);}
{cstChr}    {col = col + strlen(yytext); return caractere;}
{cstStr}    {col = col + strlen(yytext); return string;}
{cstBol}    {
                col = col + strlen(yytext);
                if(strcmp(yytext, "TRUE") == 0)
                    return true;
                else 
                    return false;                   
            }
{idf}       {col = col + strlen(yytext); return idf;}
{slashSup}  {col = col + strlen(yytext); return slash_sup;}
{infSlash}  {col = col + strlen(yytext); return inf_slash;}
{comment}   {col = col + strlen(yytext);}

\<          {col = col + strlen(yytext); return inf;}
\!          {col = col + strlen(yytext); return pt_exclamation;}
\>          {col = col + strlen(yytext); return sup;}
\|          {col = col + strlen(yytext); return barre_v;}
\;          {col = col + strlen(yytext); return pt_virgule;}
\:          {col = col + strlen(yytext); return deux_pt;}
\=          {col = col + strlen(yytext); return egal;}
\+          {col = col + strlen(yytext); return addition;}
\-          {col = col + strlen(yytext); return soustraction;}
\/          {col = col + strlen(yytext); return division;}
\*          {col = col + strlen(yytext); return multiplication;}
\(          {col = col + strlen(yytext); return parenthese_o;}
\)          {col = col + strlen(yytext); return parenthese_f;}
\,          {col = col + strlen(yytext); return virgule;}
\[          {col = col + strlen(yytext); return crochet_o;}
\]          {col = col + strlen(yytext); return crochet_f;}

[ \t]       {col = col + strlen(yytext);}
\n          {col =1; nb_ligne++;}
. {printf("erreur lexical à la ligne %d à la col %d entite %s \n", nb_ligne, col, yytext);}
