%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

[0-9]+              { yylval = atoi(yytext); return NUMBER; }
[+\-*/]             { return yytext[0]; }
"="                 { return ASSIGN; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
[ \t\n]+            { }
.                   { return yytext[0]; }

%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}
