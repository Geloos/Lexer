%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "ssc.tab.h"

    YYSTYPE yylval;
    Symbol_table st;
    Symbol_table initialize_st();
    
    int insert_symbol(char *x);
    char error_handler();
    extern void yyerror(char x);
    void get_line(char *x);
    void print_st();
    void free_st();

    char curr_line[200];
    char after_invalid[200];
    int line_fully_read = 0;
    int curr_line_pos = 0;
    
    #ifdef DEBUGSSC
        #define debugFlex(t) (printf("line:%d Token:%d value:%s\n",yylineno,t,yytext))
    #else
        #define debugFlex(t)
    #endif
%}

%option case-insensitive
%option noyywrap
%option yylineno

ID              (_|__)?[a-zA-Z]([a-zA-Z0-9]|_[a-zA-Z0-9])*_?
ICONST          0|[1-9][0-9]*|0[Xx][1-9A-F][0-9A-F]*|0[Oo][1-7][0-7]*|0[Bb]1[01]*
FCONST          0\.[0-9]+|([1-9][0-9]*)?(\.|E[+-]?)[0-9]*[1-9][0-9]*|0[Xx][0-9A-Fa-f]*\.[0-9A-Fa-f]*[1-9A-Fa-f][0-9A-Fa-f]*|0[Bb][0-7]*\.[0-7]*[1-7][0-7]*|0[Oo][01]\.[01]*[1][01]*
LISTFUNC        C(AD*|D+)R
SCONST          \"([^"'\\\n]|\\([nftrbv'"]|\n))*\"
CCONST          \'([ -~]|\\[nfrtbv])\'
BLOCK_COMMENT   \/\*([^*]|\*[^/])*\*\/
LINE_COMMENT    \/\/.*

%%
"\n"            { curr_line_pos = 0; line_fully_read = 0; }
[ \t]+          { get_line(yytext); }
{BLOCK_COMMENT} {  }
{LINE_COMMENT}  {  }

"typedef"       { get_line(yytext); debugFlex(TYPEDEF);   yylval.str=yytext;  return TYPEDEF; }
"char"          { get_line(yytext); debugFlex(CHAR);      yylval.str=yytext;  return CHAR; }
"int"           { get_line(yytext); debugFlex(INT);       yylval.str=yytext;  return INT; }
"FLOAT"         { get_line(yytext); debugFlex(FLOAT);     yylval.str=yytext;  return FLOAT; }
"string"        { get_line(yytext); debugFlex(STRING);    yylval.str=yytext;  return STRING; }
"class"         { get_line(yytext); debugFlex(CLASS);     yylval.str=yytext;  return CLASS; }
"private"       { get_line(yytext); debugFlex(PRIVATE);   yylval.str=yytext;  return PRIVATE; }
"protected"     { get_line(yytext); debugFlex(PROTECTED); yylval.str=yytext;  return PROTECTED; }
"public"        { get_line(yytext); debugFlex(PUBLIC);    yylval.str=yytext;  return PUBLIC; }
"void"          { get_line(yytext); debugFlex(VOID);      yylval.str=yytext;  return VOID; }
"static"        { get_line(yytext); debugFlex(STATIC);    yylval.str=yytext;  return STATIC; }
"union"         { get_line(yytext); debugFlex(UNION);     yylval.str=yytext;  return UNION; }
"enum"          { get_line(yytext); debugFlex(ENUM);      yylval.str=yytext;  return ENUM; }
"list"          { get_line(yytext); debugFlex(LIST);      yylval.str=yytext;  return LIST; }
"continue"      { get_line(yytext); debugFlex(CONTINUE);  yylval.str=yytext;  return CONTINUE; }
"break"         { get_line(yytext); debugFlex(BREAK);     yylval.str=yytext;  return BREAK; }
"if"            { get_line(yytext); debugFlex(IF);        yylval.str=yytext;  return IF; }
"else"          { get_line(yytext); debugFlex(ELSE);      yylval.str=yytext;  return ELSE; }
"while"         { get_line(yytext); debugFlex(WHILE);     yylval.str=yytext;  return WHILE; }
"for"           { get_line(yytext); debugFlex(FOR);       yylval.str=yytext;  return FOR; }
"switch"        { get_line(yytext); debugFlex(SWITCH);    yylval.str=yytext;  return SWITCH; }
"case"          { get_line(yytext); debugFlex(CASE);      yylval.str=yytext;  return CASE; }
"default"       { get_line(yytext); debugFlex(DEFAULT);   yylval.str=yytext;  return DEFAULT; }
"return"        { get_line(yytext); debugFlex(RETURN);    yylval.str=yytext;  return RETURN; }
"length"        { get_line(yytext); debugFlex(LENGTH);    yylval.str=yytext;  return LENGTH; }
"new"           { get_line(yytext); debugFlex(NEW);       yylval.str=yytext;  return NEW; }
"cin"           { get_line(yytext); debugFlex(CIN);       yylval.str=yytext;  return CIN; }
"cout"          { get_line(yytext); debugFlex(COUT);      yylval.str=yytext;  return COUT; }
"main"          { get_line(yytext); debugFlex(MAIN);      yylval.str=yytext;  return MAIN; }
"this"          { get_line(yytext); debugFlex(THIS);      yylval.str=yytext;  return THIS; }

"||"            { get_line(yytext); debugFlex(OROP);      yylval.str=yytext;  return OROP; }
"&&"            { get_line(yytext); debugFlex(ANDOP);     yylval.str=yytext;  return ANDOP; }
"++"            { get_line(yytext); debugFlex(INCDEC);    yylval.str=yytext;  return INCDEC; }
"--"            { get_line(yytext); debugFlex(INCDEC);    yylval.str=yytext;  return INCDEC; }
"=="            { get_line(yytext); debugFlex(EQUOP);     yylval.str=yytext;  return EQUOP; }
"!="            { get_line(yytext); debugFlex(EQUOP);     yylval.str=yytext;  return EQUOP; }
">="            { get_line(yytext); debugFlex(RELOP);     yylval.str=yytext;  return RELOP; }
"<="            { get_line(yytext); debugFlex(RELOP);     yylval.str=yytext;  return RELOP; }
"::"            { get_line(yytext); debugFlex(METH);      yylval.str=yytext;  return METH; }
">>"            { get_line(yytext); debugFlex(INP);       yylval.str=yytext;  return INP; }
"<<"            { get_line(yytext); debugFlex(OUT);       yylval.str=yytext;  return OUT; }
"sizeof"        { get_line(yytext); debugFlex(SIZEOF);    yylval.str=yytext;  return SIZEOF; }

">"             { get_line(yytext); debugFlex(RELOP);     yylval.str=yytext;  return RELOP; }
"<"             { get_line(yytext); debugFlex(RELOP);     yylval.str=yytext;  return RELOP; }
"+"             { get_line(yytext); debugFlex(ADDOP);     yylval.str=yytext;  return ADDOP; }
"-"             { get_line(yytext); debugFlex(ADDOP);     yylval.str=yytext;  return ADDOP; }
"*"             { get_line(yytext); debugFlex(MULOP);     yylval.str=yytext;  return MULOP; }
"/"             { get_line(yytext); debugFlex(MULOP);     yylval.str=yytext;  return MULOP; }
"%"             { get_line(yytext); debugFlex(MULOP);     yylval.str=yytext;  return MULOP; }
"!"             { get_line(yytext); debugFlex(NOTOP);     yylval.str=yytext;  return NOTOP; }
"&"             { get_line(yytext); debugFlex(REFER);     yylval.str=yytext;  return REFER; }
"="             { get_line(yytext); debugFlex(ASSIGN);    yylval.str=yytext;  return ASSIGN; }
";"             { get_line(yytext); debugFlex(SEMI);      yylval.str=yytext;  return SEMI; }
":"             { get_line(yytext); debugFlex(COLON);     yylval.str=yytext;  return COLON; }
","             { get_line(yytext); debugFlex(COMMA);     yylval.str=yytext;  return COMMA; }
"\("            { get_line(yytext); debugFlex(LPAREN);    yylval.str=yytext;  return LPAREN; }
"\)"            { get_line(yytext); debugFlex(RPAREN);    yylval.str=yytext;  return RPAREN; }
"\["            { get_line(yytext); debugFlex(LBRACK);    yylval.str=yytext;  return LBRACK; }
"\]"            { get_line(yytext); debugFlex(RBRACK);    yylval.str=yytext;  return RBRACK; }
"\{"            { get_line(yytext); debugFlex(LBRACE);    yylval.str=yytext;  return LBRACE; }
"\}"            { get_line(yytext); debugFlex(RBRACE);    yylval.str=yytext;  return RBRACE; }
"\."            { get_line(yytext); debugFlex(DOT);       yylval.str=yytext;  return DOT; }

{LISTFUNC}      { get_line(yytext); debugFlex(LISTFUNC); printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.str = yytext; return LISTFUNC; }
{ID}            { get_line(yytext); debugFlex(ID);       printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.str = yytext; return ID; }
{ICONST}        { get_line(yytext); debugFlex(ICONST);   printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.int_literal = atoi(yytext); return ICONST; }
{CCONST}        { get_line(yytext); debugFlex(CCONST);   printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.str = yytext; return CCONST; }
{SCONST}        { get_line(yytext); debugFlex(SCONST);   printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.str = yytext; return SCONST; }
{FCONST}        { get_line(yytext); debugFlex(FCONST);   printf("Symbol Index: %d\n", insert_symbol(yytext)); yylval.double_literal = atof(yytext); return FCONST; }

<<EOF>>         { return 0; }

.               { get_line(yytext); yyerror(error_handler()); }
            
                

%%

char error_handler(){
    
    char ch;
    char invalid = yytext[0];
    int i = 0;
    
    while((ch = input()) && ch != EOF && ch != '\n' && i < sizeof(after_invalid) - 1){
        after_invalid[i++]= ch;
    }
    
    after_invalid[i] = '\0';
    
    if (ch == '\n') {
        unput(ch);
    }
    
    if (!line_fully_read) {
        if (curr_line_pos + i < sizeof(curr_line)) {
            memcpy(&curr_line[curr_line_pos], after_invalid, i);
            curr_line_pos += i; 
            curr_line[curr_line_pos] = '\0';
        }
        
        line_fully_read = 1;
    }
    
    for (int j = i - 1 ; j>=0; j--){
        if (after_invalid[j] != invalid){
            unput(after_invalid[j]);
        }
        
    }

    return invalid;

}

void get_line(char *x) {
    
    if(line_fully_read == 1){
        return;
    }
    
    if (curr_line_pos + yyleng < sizeof(curr_line)) {
        memcpy(&curr_line[curr_line_pos], x, yyleng);
        curr_line_pos += yyleng;
        curr_line[curr_line_pos] = '\0';
    }
}

int insert_symbol(char *name){
    for(int i = 0; i < st.pos; i++){
        if(strcmp(st.symbol[i].name,name) == 0){
            return i;
        }
    }
    
    if(st.pos >= st.size){
        st.size *= 2;
        Symbol_data *new_block = realloc(st.symbol, (st.size) * sizeof(Symbol_data));
        if(!st.symbol){
            printf("realloc failed\n");
            free(st.symbol);
            exit(1);
        }    
        
        st.symbol = new_block;
    }
    
    if(yyleng < sizeof(st.symbol[st.pos].name)){
        memcpy(st.symbol[st.pos].name,name,yyleng);
        st.symbol[st.pos].name[yyleng] = '\0';
    }
   
    return st.pos++;
}

Symbol_table initialize_st(){
    st.symbol = malloc(50 * sizeof(Symbol_data));
    
    if(!st.symbol){
        printf("malloc failed\n");
        exit(1);
    }
    
    st.size = 50;
    st.pos = 0;
    
    return st;
}

void print_st(){
    for (int i = 0; i < st.pos; i++){
        printf("Symbol:%s Index:%d\n",st.symbol[i].name,i);
    }
    printf("Total symbols: %d\n", st.pos);
}

void free_st(){
    if(st.symbol){
        free(st.symbol);
    }
}

int main(int argc, char** argv) {
    FILE *fp = stdin;
    st = initialize_st();

    if(argc > 1) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            printf("Error: file could not be opened\n");
            return 1;
        }
    }

    yyin = fp;
    
   
    while (yylex());
    

    if (fp != stdin) {
        fclose(fp);
    }
    
    print_st();
    free_st();
    printf("\n");
    return 0;
}
