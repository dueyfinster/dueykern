.PHONY: all
all: kernel

kasm.o:
	nasm -f elf32 kernel.asm -o kasm.o

kc.o: kasm.o
	gcc -m32 -c kernel.c -o kc.o

kernel: kc.o
	ld -m elf_i386 -T link.ld -o kernel kasm.o kc.o
