all: kernel

.PHONY: all clean

kasm.o:
	nasm -f elf32 kernel.asm -o kasm.o

kc.o: kasm.o
	gcc -m32 -c kernel.c -o kc.o

kernel: kc.o
	ld -m elf_i386 -T link.ld -o kernel kasm.o kc.o

iso:
	mkdir -p temp/boot/grub
	cp kernel temp/boot/kernel
	cp grub.cfg temp/boot/grub/grub.cfg
	grub-mkrescue -o kernel.iso temp

clean:
	$(RM) kasm.o
	$(RM) kc.o
	$(RM) kernel
	$(RM) temp/
