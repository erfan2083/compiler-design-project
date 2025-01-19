%{
#include <stdio.h>
#include "parse.tab.h"
%}

%%

[0-9]+      { yylval = atoi(yytext); return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t\n]+    ;
.           { printf("Invalid input'%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}

