#!/bin/bash

set -e
set +x

source .config

cargo build --target ./targets/$ARCH.json -Z build-std=core

mkdir -p build/isoroot/boot/grub
cp target/$ARCH/debug/bare-bones-kernel build/isoroot/boot/bare-bones-kernel
cp grub/config.cfg build/isoroot/boot/grub/grub.cfg
grub-mkrescue -d /usr/lib/grub/i386-pc -o build/bare-bones.iso build/isoroot
