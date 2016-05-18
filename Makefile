compile: BrainMachina.l BrainMachina.y
	# calling flex
	flex BrainMachina.l
	# copying lex.yy.c to BrainMachina.lexer.c
	cp lex.yy.c BrainMachina.lexer.c
	# removing lex.yy.c
	rm lex.yy.c
	# calling bison
	bison -d BrainMachina.y
	# copying BrainMachina.tab.h to BrainMachina.tokens.h
	cp BrainMachina.tab.h BrainMachina.tokens.h
	# removing BrainMachina.tab.h
	rm BrainMachina.tab.h
	# copying BrainMachina.tab.c to BrainMachina.c
	cp BrainMachina.tab.c BrainMachina.c
	# removing BrainMachina.tab.c
	rm -rf BrainMachina.tab.c
	# compiling BrainMachina.tab.c
	gcc BrainMachina.c -o BrainMachina
	# removing BrainMachina.c, BrainMachina.tokens.h and BrainMachina.lexer.c
	rm -rf BrainMachina.c BrainMachina.tokens.h BrainMachina.lexer.c
	# executing BrainMachina
	./BrainMachina

