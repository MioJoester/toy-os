/* src/boot.S - multiboot2 header for GRUB + 64-bit entry */
.section .multiboot_header
.align 8
/* Multiboot2 header (minimal): magic, architecture, header_length, checksum */
.long 0xE85250D6        /* magic */
.long 0x0               /* architecture (0 = i386) */
.long 32                /* header length (adjust if fields change) */
.long -(0xE85250D6 + 0 + 32)

.global start
.section .text
.align 4096
start:
    /* GRUB will put us in 32-bit protected or long mode depending - but with multiboot2
       and grub on x86_64 we get long mode if configured. For simplicity we assume
       GRUB loads us in 64-bit long mode entry below. */
    jmp kernel_entry

/* Minimal 64-bit entry point (GRUB will already set long mode) */
.global kernel_entry
kernel_entry:
    /* Align stack */
    mov $stack_top, %rsp
    /* call C kernel_main */
    extern kernel_main
    call kernel_main

/* stack */
.section .bss
.align 16
stack:
    .space 16384
stack_top:
