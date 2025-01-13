%{
#include <stdio.h>
#include <stdlib.h>
#include "lex.yy.c"

int temp_count = 0;
%}

%union {
    int number;
}

%token <number> NUMBER
%token ASSIGN LPAREN RPAREN
%left '+' '-'
%left '*' '/'

%%

program:
    statement
    ;

statement:
    IDENTIFIER ASSIGN expression   { printf("%s = %d\n", $1, $3); }
    ;

expression:
    expression '+' term    { $$ = $1 + $3; }
    | expression '-' term  { $$ = $1 - $3; }
    | term
    ;

term:
    term '*' factor    { $$ = $1 * $3; }
    | term '/' factor  { $$ = $1 / $3; }
    | factor
    ;

factor:
    NUMBER          { $$ = $1; }
    | LPAREN expression RPAREN  { $$ = $2; }
    ;

%%

int main() {
    yyparse();
    return 0;
}