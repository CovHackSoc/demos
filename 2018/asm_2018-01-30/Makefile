NASM_FLAGS=-f elf64

build:
	yasm $(NASM_FLAGS) -o test.o test.s
	ld -o test ./test.o

clean:
	rm *.o
