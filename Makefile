all:	
	(cd src && make)
	mkdir -p build
	mv src/temp/BrainMachina build/
	rm -rf src/temp

hello_world_1:	
	./build/BrainMachina ./examples/hello_world_1.bm

hello_world_2:	
	./build/BrainMachina ./examples/hello_world_2.bm