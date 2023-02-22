all:	
	(cd src && make)
	mkdir -p build
	mv src/temp/brainfvck build/
	rm -rf src/temp

hello_world_1:	
	./build/brainfvck ./examples/hello_world_1.bm

hello_world_2:	
	./build/brainfvck ./examples/hello_world_2.bm