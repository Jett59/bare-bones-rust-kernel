.code32

#define MULTIBOOT2_MAGIC 0xE85250D6
#define MULTIBOOT2_ARCHITECTURE 0

.section .multiboot
multiboot_header:
.long MULTIBOOT2_MAGIC /*Magic*/
.long MULTIBOOT2_ARCHITECTURE /*Architecture (i386)*/
.long multiboot_header_end - multiboot_header /*Header length*/
.long 0x100000000 - (MULTIBOOT2_MAGIC + MULTIBOOT2_ARCHITECTURE + (multiboot_header_end - multiboot_header)) /*Checksum*/
/*Tags*/

/*End tag*/
.align 8
.short 0 /*Type*/
.short 0 /*Flags*/
.long 8 /*Size*/
multiboot_header_end:

.text
.globl _start
_start:
mov %ebx, mbi_pointer
mov $pml3, %eax
or $3, %eax
mov %eax, pml4
mov $pml2, %eax
or $3, %eax
mov %eax, pml3
/* Use huge page tables to make this easier */
mov $0x83, %eax
mov $512, %ecx
mov $pml2, %edi
1: mov %eax, (%edi)
add $0x200000, %eax
add $8, %edi
dec %ecx
jnz 1b
mov $pml4, %eax
mov %eax, %cr3

movl %cr4, %eax
orl $(1 << 5), %eax
movl %eax, %cr4

movl $0xC0000080, %ecx
rdmsr
orl $(1 << 8), %eax
wrmsr

movl %cr0, %eax
orl $(1 << 31), %eax
movl %eax, %cr0

lgdt gdt_pointer
jmp $8, $_start64

.code64
_start64:
lea gdt(%rip), %rax
lgdt (%rax)
lea stack_end(%rip), %rsp
call kmain
1: jmp 1b

.data
gdt_pointer:
.word gdt_end - gdt - 1
.quad gdt

#define GDT_EXECUTABLE (1 << 43)
#define GDT_NOT_SYSTEM (1 << 44)
#define GDT_PRESENT (1 << 47)
#define GDT_LONG (1 << 53)

gdt:
.quad 0
.quad GDT_PRESENT | GDT_LONG | GDT_NOT_SYSTEM | GDT_EXECUTABLE /*Kernel code segment*/
gdt_end:

.bss
.align 4096
pml4:
.fill 4096
pml3:
.fill 4096
pml2:
.fill 4096

stack:
.fill 8192
stack_end:

mbi_pointer:
.quad 0
