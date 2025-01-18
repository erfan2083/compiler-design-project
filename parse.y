%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp_count = 1;
void generate_code(char *result, char *op1, char *op, char *op2);
%}

%token NUMBER PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%left PLUS MINUS
%left MULTIPLY DIVIDE
%right UMINUS

%%

input: 
    expression '\n' { printf("نتیجه: %d\n", $1); }
;

expression:
    NUMBER {
        // بررسی معکوس کردن عدد اگر مضرب 10 نیست
        int num = $1;
        if (num % 10 != 0) {
            char str[10];
            sprintf(str, "%d", num);
            strrev(str);
            num = atoi(str);
        }
        $$ = num;
    }
    | expression PLUS expression {
        generate_code("t%d", $1, "+", $3);
        $$ = $1 + $3;
    }
    | expression MINUS expression {
        generate_code("t%d", $1, "-", $3);
        $$ = $1 - $3;
    }
    | expression MULTIPLY expression {
        generate_code("t%d", $1, "*", $3);
        $$ = $1 * $3;
    }
    | expression DIVIDE expression {
        generate_code("t%d", $1, "/", $3);
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

int main() {
    printf("عبارت خود را وارد کنید:\n");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "خطا: %s\n", s);
    return 1;
}
