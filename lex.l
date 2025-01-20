%{
#include <stdio.h>
#include "parse.tab.h"
%}

%%

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
"="         { return ASSIGN; }
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