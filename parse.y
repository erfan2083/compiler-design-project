%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse.tab.h"

int temp_count = 1;
void generate_code(char *result, char *op1, char *op, char *op2);
void reverse_string(char *str);
int yylex();
int yyerror(const char *s);
%}

%token IDENTIFIER NUMBER ASSIGN PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%right PLUS MINUS  /* جمع و تفریق از راست به چپ */
%left MULTIPLY DIVIDE  /* ضرب و تقسیم از چپ به راست */

%%

input: 
    | input statement '\n' { /* پایان خط */ }
;

statement:
    IDENTIFIER ASSIGN expression {
        printf("%s = t%d;\n", $1, $3);
        printf("value = %d\n", $3);  /* چاپ مقدار نهایی */
    }
;

expression:
    NUMBER {
        int num = $1;
        if (num % 10 != 0) {  // معکوس کردن اعداد غیر از مضرب 10
            char str[10];
            sprintf(str, "%d", num);
            reverse_string(str);
            num = atoi(str);
        }
        $$ = num;  // مقدار عدد
        printf("t%d = %d;\n", temp_count, num);  // تولید کد سه‌آدرسی
        $$ = temp_count++;
    }

    | expression PLUS expression {
        char result[10];
        sprintf(result, "t%d", temp_count);
        printf("%s = t%d + t%d;\n", result, $1, $3);
        $$ = $1 + $3;  // محاسبه مقدار نهایی جمع
        temp_count++;
    }

    | expression MINUS expression {
        char result[10];
        sprintf(result, "t%d", temp_count);
        printf("%s = t%d - t%d;\n", result, $1, $3);
        $$ = $1 - $3;  // محاسبه مقدار نهایی تفریق
        temp_count++;
    }

    | expression MULTIPLY expression {
        char result[10];
        sprintf(result, "t%d", temp_count);
        printf("%s = t%d * t%d;\n", result, $1, $3);
        $$ = $1 * $3;  // محاسبه مقدار نهایی ضرب
        temp_count++;
    }

    | expression DIVIDE expression {
        char result[10];
        sprintf(result, "t%d", temp_count);
        if ($3 != 0) {
            printf("%s = t%d / t%d;\n", result, $1, $3);
            $$ = $1 / $3;  // محاسبه مقدار نهایی تقسیم
            temp_count++;
        } else {
            yyerror("تقسیم بر صفر مجاز نیست!");
        }
    }

    | LPAREN expression RPAREN {
        $$ = $2;  // مقدار داخل پرانتز
    }

    | MINUS expression %prec UMINUS {
        char result[10];
        sprintf(result, "t%d", temp_count);
        printf("%s = -t%d;\n", result, $2);
        $$ = -$2;  // اعمال منفی کردن
        temp_count++;
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

int yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    return 0;
}

int main() {
    printf("Enter an expression:\n");
    yyparse();
    return 0;
}
