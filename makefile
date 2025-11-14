# Makefile
ASM = nasm
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
CFLAGS = -ffreestanding -O2 -fno-exceptions -fno-stack-protector -Wall -Wextra -mno-red-zone -m64
LDFLAGS = -nostdlib -T linker.ld

SRCDIR = src
OBJDIR = build

SOURCES = $(SRCDIR)/kernel.c $(SRCDIR)/boot.S
OBJS = $(OBJDIR)/kernel.o $(OBJDIR)/boot.o

all: iso

$(OBJDIR)/kernel.o: $(SRCDIR)/kernel.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/boot.o: $(SRCDIR)/boot.S | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

kernel.elf: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@

iso: kernel.elf
	rm -rf iso
	mkdir -p iso/boot/grub
	cp kernel.elf iso/boot/
	cp grub.cfg iso/boot/grub/
	grub-mkrescue -o typeos.iso iso

run: iso
	qemu-system-x86_64 -cdrom typeos.iso -m 512M

clean:
	rm -rf build kernel.elf typeos.iso iso
