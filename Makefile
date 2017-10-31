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
LDSRC := $(wildcard $(SRC)/*.ld)
COBJ := $(patsubst $(SRC)/%.c, $(BIN)/%.o, $(CSRC))
ASMOBJ := $(patsubst $(SRC)/%.asm, $(BIN)/%.o, $(ASMSRC))
ALLOBJ = $(ASMOBJ) $(COBJ) 
TARGET = $(BIN)/kernel.bin

all: $(TARGET)  kernel.iso

.PHONY: all install run clean

$(BIN)/%.o: $(SRC)/%.asm 
	$(NASM) $(NASM_FLAGS) -o $@ $<

$(BIN)/%.o: $(SRC)/%.c
	$(CC) $(CC_FLAGS) -c $< -o $@

$(TARGET): $(ALLOBJ)
	$(LD) $(LD_FLAGS) -T $(LDSRC) -o $@ $^

kernel.iso:
	mkdir -p temp/boot/grub
	cp $(BIN)/kernel.bin temp/boot/kernel
	cp config/grub.cfg temp/boot/grub/grub.cfg
	grub-mkrescue -d /usr/lib/grub/i386-pc/ -o $(BIN)/kernel.iso temp

install:
	sudo apt-get install -y grub-pc-bin xorriso qemu

run:
	qemu-system-i386 -kernel $(BIN)/kernel.bin

test:
	@echo $(LDSRC)

clean:
	$(RM) $(BIN)/*.o $(BIN)/*.bin $(BIN)/*.iso
	rm -rf temp/
