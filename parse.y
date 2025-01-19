%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse.tab.h"

int temp_count = 1;
void generate_code(char *result, char *op1, char *op, char *op2);
void reverse_string(char *str);
%}

%token NUMBER PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right UMINUS

%%

input: 
    | input expression '\n' { printf("نتیجه: %d\n", $2); }
;

expression:
    NUMBER {
        int num = $1;
        if (num % 10 != 0) {
            char str[10];
            sprintf(str, "%d", num);
            reverse_string(str);
            num = atoi(str);
        }
        $$ = num;
    }


    | expression PLUS expression {
        char op1[10], op2[10], result[10];
        sprintf(op1, "t%d", $1);
        sprintf(op2, "t%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "+", op2);
        $$ = $1 + $3;
    }


    | expression MINUS expression {
        char op1[10], op2[10], result[10];
        sprintf(op1, "t%d", $1);
        sprintf(op2, "t%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "-", op2);
        $$ = $1 - $3;
    }


    | expression MULTIPLY expression {
        char op1[10], op2[10], result[10];
        sprintf(op1, "t%d", $1);
        sprintf(op2, "t%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "*", op2);
        $$ = $1 * $3;
    }


    | expression DIVIDE expression {
        char op1[10], op2[10], result[10];
        sprintf(op1, "t%d", $1);
        sprintf(op2, "t%d", $3);
        sprintf(result, "t%d", temp_count++);
        generate_code(result, op1, "/", op2);
        $$ = $1 / $3;
    }


    | LPAREN expression RPAREN {
        $$ = $2;
    }

    
    | MINUS expression %prec UMINUS {
        $$ = -$2;
    }
;

%%

void generate_code(char *result, char *op1, char *op, char *op2) {
    printf("%s = %s %s %s;\n", result, op1, op, op2);
}

void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

int main() {
    printf("Enter an expression:\n");
    yyparse();
    return 0;
}