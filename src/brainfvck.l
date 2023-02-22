%{
#include <stdio.h>
#include "brainfvck.tokens.h"
int line = 1;
%}

%%
[ \t]+		;
[0-9]+		{yylval= atoi(yytext); return NUMBER;};
[a-zA-Z]	{return ID;}
"+"		    {return INCVAL;}
"-"		    {return DECVAL;}
">"		    {return INCPTR;}
"<"		    {return DECPTR;}
","		    {return INPUT;}
"."		    {return OUTPUT;}
"["		    {return WHILESTART;}
"]"		    {return WHILEEND;}
"\n"		{line++; return RETURN;}
%%
