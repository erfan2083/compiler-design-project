%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse.tab.h"

int temp_count = 1;
void generate_code(char *result, char *op1, char *op, char *op2);
int check_num(int num);
void reverse_string(char *str);
int yylex();
int yyerror(const char *s);
%}

%union {
    char* string;   
    int number;     
}

%token <string> IDENTIFIER 
%token <number> NUMBER 
%token ASSIGN PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN SEMICOLON

%type <number> input
%type <number> statement
%type <number> expression
%type <number> term
%type <number> factor

%right PLUS MINUS
%left MULTIPLY DIVIDE

%%

input:
    statement { 
        printf("Resualt = %d\n", $1);
    }

statement:
    IDENTIFIER ASSIGN expression SEMICOLON {
        printf("%s = t%d;\n",$1 , temp_count - 1);
        $$ = $3;
    }
;


expression:

    expression MULTIPLY factor{
        char op1[10], op2[10], result[10];
        sprintf(op1, "%d", $1);
        sprintf(op2, "%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "*", op2);
        $$ = check_num($1 * $3);
    }

    | expression DIVIDE factor {
        char op1[10], op2[10], result[10];
        sprintf(op1, "%d", $1);
        sprintf(op2, "%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "/", op2);
        $$ = check_num($1 / $3);
    }

    | factor {
        $$ = $1;
    }
;


factor:

    term PLUS factor {
        char op1[10], op2[10], result[10];
        sprintf(op1, "%d", $1);
        sprintf(op2, "%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "+", op2);
        $$ = check_num($1 + $3);
    }

    | term MINUS factor {
        char op1[10], op2[10], result[10];
        sprintf(op1, "%d", $1);
        sprintf(op2, "%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "-", op2);
        $$ = check_num($1 - $3);
    }

    | term {
        $$ = $1;
    }
;

term:

    LPAREN expression RPAREN {
        $$ = $2;
    }
    
    | NUMBER {
        $$ = check_num($1);
    }
;

%%

void generate_code(char *result, char *op1, char *op, char *op2) {
    printf("%s = %s %s %s;\n", result, op1, op, op2);
}

int check_num(int num){
        if (num % 10 != 0) {
            char str[10];
            sprintf(str, "%d", num);
            reverse_string(str);
            num = atoi(str);
            return num;
        }
    return num;
}

void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if(str[i] == '-') continue;
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

int yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    return 0;
}

int main() {
    printf("Enter an expression:\n");
    yyparse();
    return 0;
}