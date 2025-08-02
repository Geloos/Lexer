#ifndef SSC_TAB_H
#define SSC_TAB_H

#define TYPEDEF       256
#define CHAR          257
#define INT           258
#define FLOAT         259
#define STRING        260
#define CLASS         261
#define PRIVATE       262
#define PROTECTED     263
#define PUBLIC        264
#define VOID          265
#define STATIC        266
#define UNION         267
#define ENUM          268
#define LIST          269
#define CONTINUE      270
#define BREAK         271
#define IF            272
#define ELSE          273
#define WHILE         274
#define FOR           275
#define SWITCH        276
#define CASE          277
#define DEFAULT       278
#define RETURN        279
#define LENGTH        280
#define NEW           281
#define CIN           282
#define COUT          283
#define MAIN          284
#define THIS          285

#define OROP          286
#define ANDOP         287
#define INCDEC        288
#define EQUOP         289
#define RELOP         290
#define METH          291
#define INP           292
#define OUT           293
#define SIZEOF        294
#define ADDOP         295
#define MULOP         296
#define NOTOP         297
#define REFER         298
#define ASSIGN        299
#define SEMI          300
#define COLON         301
#define COMMA         302
#define LPAREN        303
#define RPAREN        304
#define LBRACK        305
#define RBRACK        306
#define LBRACE        307
#define RBRACE        308
#define DOT           309

#define LISTFUNC      310
#define ID            311
#define ICONST        312
#define FCONST        313
#define SCONST        314
#define CCONST        315

typedef union 
{
    
    int int_literal;
    double double_literal;
    char* str;
    
} YYSTYPE;

typedef struct Symbol_data
{

    char name[50];

} Symbol_data;

typedef struct 
{
    
    Symbol_data *symbol;
    int size;
    int pos;

} Symbol_table;

void yyerror(char x) {
    
    extern int yylineno;
    extern char curr_line[200];
    printf("Invalid Character:%c (line %d):%s\n", x, yylineno, curr_line);
    
}

#endif 
