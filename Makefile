CC := gcc
CC_FLAGS := -m32
NASM := nasm
NASM_FLAGS := -felf32
LD := ld
LD_FLAGS := -m elf_i386 -T link.ld
GRUB-MKRESCUE := grub-mkrescue

all: kernel kernel.iso

.PHONY: all clean

kasm.o: kernel.asm 
	$(NASM) $(NASM_FLAGS) -o $@ $<

kc.o: kernel.c kasm.o
	$(CC) $(CC_FLAGS) -c $< -o $@

kernel: kasm.o kc.o
	$(LD) $(LD_FLAGS) -o $@ $^

kernel.iso:
	mkdir -p temp/boot/grub
	cp kernel temp/boot/kernel
	cp grub.cfg temp/boot/grub/grub.cfg
	grub-mkrescue -o kernel.iso temp

clean:
	$(RM) kasm.o
	$(RM) kc.o
	$(RM) kernel
	rm -rf temp/
