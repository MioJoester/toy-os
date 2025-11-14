/* linker.ld */
ENTRY(start)

SECTIONS
{
  . = 0x100000; /* load at 1 MiB (typical for kernels) */

  .text : {
    *(.multiboot_header)
    *(.text*)
    *(.rodata*)
  }

  .data : { *(.data*) }

  .bss : {
    __bss_start = .;
    *(.bss*)
    *(COMMON)
    __bss_end = .;
  }

  /DISCARD/ : { *(.eh_frame*) }
}
