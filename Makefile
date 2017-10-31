CC := gcc
CC_FLAGS := -m32
NASM := nasm
NASM_FLAGS := -felf32
LD := ld
LD_FLAGS := -m elf_i386
GRUB-MKRESCUE := grub-mkrescue
SRC := src
BIN := bin
CSRC := $(wildcard $(SRC)/*.c)
ASMSRC := $(wildcard $(SRC)/*.asm)

all: $(BIN)/kernel.bin kernel.iso

.PHONY: all install run clean

$(BIN)/kasm.o: $(SRC)/kernel.asm 
	$(NASM) $(NASM_FLAGS) -o $@ $<

$(BIN)/kc.o: $(SRC)/kernel.c
	$(CC) $(CC_FLAGS) -c $< -o $@

$(BIN)/kernel.bin: $(BIN)/kasm.o $(BIN)/kc.o
	$(LD) $(LD_FLAGS) -T $(SRC)/link.ld -o $@ $^

kernel.iso:
	mkdir -p temp/boot/grub
	cp $(BIN)/kernel.bin temp/boot/kernel
	cp config/grub.cfg temp/boot/grub/grub.cfg
	grub-mkrescue -d /usr/lib/grub/i386-pc/ -o $(BIN)/kernel.iso temp

install:
	sudo apt-get install -y grub-pc-bin xorriso qemu

run:
	qemu-system-i386 -kernel $(BIN)/kernel.bin

clean:
	$(RM) $(BIN)/*.o $(BIN)/*.bin $(BIN)/*.iso
	rm -rf temp/
