%{
#include "parser.tab.h"
#include <string.h>
%}

%%

"<"[a-zA-Z_][a-zA-Z0-9_]*">"          { yylval = strdup(yytext); return OPEN_TAG; }
"</"[a-zA-Z_][a-zA-Z0-9_]*">"         { yylval = strdup(yytext); return CLOSE_TAG; }
[a-zA-Z_][a-zA-Z0-9_]*"="\"[^\"]*\""  { yylval = strdup(yytext); return ATTRIBUTE; }
[a-zA-Z_][a-zA-Z0-9_]*                { yylval = strdup(yytext); return IDENTIFIER; }
"\"[^\"]*\""                          { yylval = strdup(yytext); return VALUE; }
[ \t\n]+                              { /* ignore whitespace */ }
.                                     { return UNKNOWN; }

%%

int yywrap() {
    return 1;
}

