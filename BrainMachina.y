%{
#include <stdio.h>
#include <stdlib.h>
#include "BrainMachina.lexer.c"
int cell[1000];
int pointer=0;
int errors = 0;
int sem_error=0;
char qu_array[1000];
int qu_ptr=0;
int flag=0;
int nested_loop_count=0;
int qu_begin=0;
extern FILE* yyin;
%}

%token NUMBER ID INCVAL DECVAL INCPTR DECPTR INPUT OUTPUT WHILESTART WHILEEND RETURN
%start Start

%%
Start:EXP	{printf("\nThank you for using our interpreter\n");exit(0);}
;
EXP: 
|RETURN
|EXP INCVAL	{if(flag) qu_push('+'); else cell[pointer]++;}
|EXP DECVAL	{if(flag) qu_push('-'); else cell[pointer]--;}
|EXP INCPTR	{if(flag) qu_push('>'); else pointer++;}
|EXP DECPTR	{if(flag) qu_push('<'); else pointer--;}
|EXP INPUT	{if(flag) qu_push(','); else scanf("%d",&cell[pointer]);}
|EXP OUTPUT	{if(flag) qu_push('.'); else printf("%d ",cell[pointer]);}
|EXP WHILESTART	{qu_begin=1; qu_push('['); flag++; nested_loop_count++;}
|EXP WHILEEND	{if(flag) {qu_push(']');  flag--;} if(!flag) whilestatement(qu_begin,nested_loop_count);}
;
%%

void qu_push(char val)
{
       qu_array[qu_ptr]=val;
       qu_ptr++;
}


void whilestatement(int local_qu_ptr, int local_nested_loop_count)
{
       int curr_cell_ptr = pointer;
       while(cell[curr_cell_ptr])
         {
           
           for(int curr_qu_ptr=local_qu_ptr, curr_nested_loop_count=0; curr_nested_loop_count<local_nested_loop_count; curr_qu_ptr++)
               {
                 /**
                  * Debugging
                 */
                 // if(local_qu_ptr) printf("\n peep cell[curr_qu_ptr]: %d\n",cell[curr_qu_ptr]);
                 // if(curr_nested_loop_count) printf("\n peep curr_nested_loop_count: %d\n",curr_nested_loop_count);
                 // if(local_nested_loop_count) printf("\n peep curr_nested_loop_count: %d\n",local_nested_loop_count);
                 /**
                  * Loop Commands
                 */
                 if(!cell[curr_cell_ptr]) return;
                 if(qu_array[curr_qu_ptr]=='+') cell[pointer]++;
                 if(qu_array[curr_qu_ptr]=='-') cell[pointer]--;
                 if(qu_array[curr_qu_ptr]=='>') pointer++;
                 if(qu_array[curr_qu_ptr]=='<') pointer--;
                 if(qu_array[curr_qu_ptr]==',') scanf("%d",&cell[pointer]);
                 if(qu_array[curr_qu_ptr]=='.') printf("%d ",cell[pointer]);
                 if(qu_array[curr_qu_ptr]=='[') whilestatement(curr_qu_ptr+1,local_nested_loop_count-1);
                 if(qu_array[curr_qu_ptr]==']') curr_nested_loop_count++;
               }
         }
}

void yyerror(const char* s)
{
       errors++;
       fprintf(stderr, "Parse error %d: %s at line %d, in statement: %s \n",errors,s,line,yytext);
       exit(1);
}

int yywrap()
{
    return 1;
}



int main()
{
    for(int i=0;i<1000;i++) cell[i]=0;
    yyin = stdin;

    do
    {
        yyparse();
    }
    while(!feof(yyin));

    return 0;
}
