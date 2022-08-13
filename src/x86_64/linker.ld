ENTRY(_start)

SECTIONS {
    . = 0x200000 + SIZEOF_HEADERS;

    .multiboot : ALIGN(4k) {
        KEEP(*(.multiboot*))
    }
    .text : ALIGN(4k) {
        *(.text*)
    }
    .data : ALIGN(4k) {
        *(.data*)
    }
    .rodata : ALIGN(4k) {
        *(.rodata*)
    }
    .bss : ALIGN(4k) {
        *(.bss)
        *(.bss*)
        *(common)
        *(common*)
    }
}
