# Clang for Windows ( x86, x64, arm 32 and & 64-bit ) (NO SYSROOT!!)
This toolchain was built in mind to compile static rust executables for android arm devices ( preferably 32 bit ), will work on sbcs like raspberry pi too.
Default target is arm-linux-musleabihf ( 32-bit musl ),
Why not 64-bit? well cause i dont have a 64-bit board.
Remember clang is a cross compiler it can compile for any target, you just have to provide the sysroot.
This clang is built with x86, x64, arm 32 & 64-bit support only no ppc, mips.

## But but bu-- Why not android NDK?
No one wants that bloated piece of shit when clang and musl exists.

## Why the host is windows?
I use windows, although building clang for linux isnt hard if you know what you are doing.

## Whats the catch?
It uses compiler-rt rather than libgcc, i want this toolchain to be fully seperated from gnu stuff thats why musl is my choice.
Doesnt come with sysroot, yep i only provide the binaries not the sysroot.
Default sysroot location is at `INSTALL_DIR/sysroot`
Default dynamic linker is `/lib/ld-musl-armhf.so.1`

## Want to compile for android?
( for 32-bit )
```clang main.c -o main -Xlinker --dynamic-linker=/system/bin/linker```
( for 64-bit )
```clang main.c -o main -Xlinker --dynamic-linker=/system/bin/linker64```
