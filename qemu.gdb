file target/x86_64/debug/bare-bones-kernel
target remote | qemu-system-x86_64 -S -gdb stdio -cdrom build/bare-bones.iso -no-reboot -no-shutdown -D qemu.log -d int
