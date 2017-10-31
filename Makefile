CC := gcc
NASM := nasm
LD := ld
GRUB-MKRESCUE := grub-mkrescue
QEMU := qemu-system-i386

CC_FLAGS := -m32
NASM_FLAGS := -felf32
LD_FLAGS := -m elf_i386

SRC := src
BIN := bin

CSRC := $(wildcard $(SRC)/*.c)
ASMSRC := $(wildcard $(SRC)/*.asm)
LDSRC := $(wildcard $(SRC)/*.ld)

COBJ := $(patsubst $(SRC)/%.c, $(BIN)/%.o, $(CSRC))
ASMOBJ := $(patsubst $(SRC)/%.asm, $(BIN)/%.o, $(ASMSRC))
ALLOBJ = $(ASMOBJ) $(COBJ) 

TARGET = $(BIN)/kernel.bin

all: $(TARGET)  $(BIN)/kernel.iso

.PHONY: all install run clean

$(BIN)/%.o: $(SRC)/%.asm 
	$(NASM) $(NASM_FLAGS) -o $@ $<

$(BIN)/%.o: $(SRC)/%.c
	$(CC) $(CC_FLAGS) -c $< -o $@

$(TARGET): $(ALLOBJ)
	$(LD) $(LD_FLAGS) -T $(LDSRC) -o $@ $^

$(BIN)/%.iso:
	mkdir -p temp/boot/grub
	cp $(TARGET) temp/boot/kernel
	cp config/grub.cfg temp/boot/grub/grub.cfg
	$(GRUB-MKRESCUE) -d /usr/lib/grub/i386-pc/ -o $@ temp

install:
	sudo apt-get install -y grub-pc-bin xorriso qemu

run:
	$(QEMU) -kernel $(BIN)/kernel.bin

clean:
	$(RM) $(ALLOBJ) $(TARGET)
	rm -rf temp/
