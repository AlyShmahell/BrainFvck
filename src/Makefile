all: brainfvck.l brainfvck.y
	# calling flex
	flex brainfvck.l
	# copying lex.yy.c to brainfvck.lexer.c
	cp lex.yy.c brainfvck.lexer.c
	# removing lex.yy.c
	rm lex.yy.c
	# calling bison
	bison -d brainfvck.y
	# copying brainfvck.tab.h to brainfvck.tokens.h
	cp brainfvck.tab.h brainfvck.tokens.h
	# removing brainfvck.tab.h
	rm brainfvck.tab.h
	# copying brainfvck.tab.c to brainfvck.c
	cp brainfvck.tab.c brainfvck.c
	# removing brainfvck.tab.c
	rm -rf brainfvck.tab.c
	# making temp
	mkdir temp -p
	# compiling brainfvck.tab.c
	g++ brainfvck.c -o temp/brainfvck -std=c++11
	# removing brainfvck.c, brainfvck.tokens.h and brainfvck.lexer.c
	rm -rf brainfvck.c brainfvck.tokens.h brainfvck.lexer.c

