;;kernel.asm
bits 32		;nasm directive, set 32 bits for cpu
section .text	;start at section .text
  ;multiboot spec
  align 4
  dd 0x1BADB002 ; magic byte
  dd 0x00       ; flags (set to 0)
  dd - (0x1BADB002 + 0x00)      ; checksum, magic+flags=checksum

global start	; set entrypoint start to global, so it can be loaded
extern kmain	;kmain is our c main method

start:
  cli		; clear interrupts
  mov esp, stack_space	;set the stack pointer to point to stack_space
  call kmain	; call our c main method
  hlt		; halt the cpu

section .bss
resb 8192	; Reserve 8 Kilobytes for the stack 
stack_space:
