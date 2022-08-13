SOURCES=$(wildcard $(ARCH)/**/*.S $(ARCH)/*.S)
OBJECTS=$(SOURCES:.S=.o)

AS=$(ARCH)-elf-gcc
ASFLAGS=-g

libasm-$(ARCH).a: ../.config $(OBJECTS) Makefile
	ar r $@ $(OBJECTS)

%.o: %.S ../.config Makefile
	$(AS) $(ASFLAGS) -c -o $@ $<
