%{
/**
 * Includes
 */
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <iostream>
#include <unordered_map>
#include "BrainMachina.lexer.c"
/**
 * Brainf*ck Globals
 */
std::unordered_map<char, char> data;
int data_head     = 0;
std::vector<int> while_program;
int while_level   = 0;
/**
 * Bison Globals
 */
int errors = 0;
extern FILE* yyin;
/**
 * While Program Tree Definition
 */
struct Node  
{ 
    int command = -1; 
    std::vector<struct Node> children;
}; 
/**
 * While Program Tree Parser Definition
 */
Node while_parse()
{
    int level = -1;
    Node tree;
    std::vector<struct Node> branches;
    for (auto command: while_program)
    {
        if(command == '[')
        {
            level++;
            if(level >= branches.size())
            {
                Node branch;
                branches.push_back(branch);
            }
            else
            {
                branches[level].children.clear();
            }
            continue;
        }
        if(command == ']')
        {
            branches[level-1].children.push_back(branches[level]);
            
            level--;
            continue;
        }
        Node leaf;
        leaf.command = command;
        branches[level].children.push_back(leaf);
    }
    tree = branches[0];
    return tree;
}
/**
 * While Program Execution Definition
 */
void while_execute(Node tree)
{
    do
    {
        for(auto child: tree.children)
            {
                if(child.children.size() > 0)
                    while_execute(child);
                if(child.command == '>')
                    data_head++;
                if(child.command == '<')
                    data_head--;
                if(child.command == '+')
                    {
                        data[data_head]++;
                        if(data[data_head] > 127)
                            data[data_head] = 0;
                    }
                if(child.command == '-')
                    {
                        data[data_head]--;
                        if(data[data_head]<0)
                            data[data_head] = 127;
                    }
                if(child.command == ',')
                    std::cin>>data[data_head];
                if(child.command == '.')
                    std::cout<<(char)data[data_head];
            }
    } while(data[data_head] > 0);
}
/**
 * Error Function Definition
 */
void yyerror(const char* error)
{
       errors++;
       fprintf(stderr,
               "Parse error %d: %s at line %d, in statement: %s \n",
               errors,
               error,
               line,
               yytext);
       exit(1);
}
/**
 * Lexer Terminator Definition
 */
int yywrap()
{
    return 1;
}

%}


%token NUMBER ID INCVAL DECVAL INCPTR DECPTR INPUT OUTPUT WHILESTART WHILEEND RETURN
%start Start


%%
Start:EXP	{
                std::cout<<std::endl;
                exit(0);
            };
EXP:
|RETURN
|EXP INCVAL	{
                if(while_level > 0)
                    while_program.push_back('+');
                else
                    {
                        data[data_head]++;
                        if(data[data_head] > 127)
                            data[data_head] = 0;
                    }
            }
|EXP DECVAL	{
                if(while_level > 0)
                    while_program.push_back('-');
                else
                    {
                        data[data_head]--;
                        if(data[data_head]<0)
                            data[data_head] = 127;
                    }
            }
|EXP INCPTR	{
                if(while_level > 0)
                    while_program.push_back('>');
                else
                    data_head++;
            }
|EXP DECPTR	{
                if(while_level > 0)
                    while_program.push_back('<');
                else
                    data_head--;
            }
|EXP INPUT	{
                if(while_level > 0)
                    while_program.push_back(',');
                else
                    std::cin>>data[data_head];
            }
|EXP OUTPUT	{
                if(while_level > 0)
                    while_program.push_back('.');
                else
                    std::cout<<(char)data[data_head];
            }
|EXP WHILESTART	{
                    while_level++;
                    while_program.push_back('[');
                }
|EXP WHILEEND	{
                    if(while_level > 0)
                        {
                            while_program.push_back(']');
                            while_level--;
                        }
                    if(while_level <= 0)
                        {
                            Node tree = while_parse();
                            while_program.clear();
                            while_execute(tree);
                        }
                }
%%


/**
 * Main
 */
int main(int argc, char *argv[])
{
    if(argc==2)
    {
        yyin =  fopen(argv[1], "r");
        if (yyin==NULL)
            {
                fprintf(stderr,
                    "Error opening file (%s).\n",
                    argv[1]);
                exit(1);
            }
    }
    else if (argc==1)
    {
        yyin = stdin;
    }
    else
    {
        fprintf(stderr,
                "Too many arguments (%d).\n",
                argc-1);
        exit(1);
    }
    do
    {
        yyparse();
    }
    while(!feof(yyin));
    return 0;
}
