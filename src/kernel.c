// src/kernel.c
#include <stdint.h>

extern void kernel_main();

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void kprint(const char *s) {
    // VGA text mode (0xB8000)
    volatile uint16_t *video = (uint16_t*)0xB8000;
    static int pos = 0;
    while (*s) {
        video[pos++] = (uint16_t)(0x0F00 | (uint8_t)*s++);
        if (pos >= 80*25) pos = 0;
    }
}

void kernel_main() {
    kprint("Hello, Type-OS! Boot successful.\n");
    // simple halt loop
    while (1) {
        __asm__ volatile ("hlt");
    }
}
