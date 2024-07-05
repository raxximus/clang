# Clang for Windows ( x86, x64, arm 32 and & 64-bit ) (NO SYSROOT!!)
1. This toolchain was built in mind to compile static rust executables for android arm devices ( preferably 32 bit ), will work on sbcs like raspberry pi too.
2. Default target is arm-linux-musleabihf ( 32-bit musl ),
3. Why not 64-bit? well cause i dont have a 64-bit board.
4. Remember clang is a cross compiler it can compile for any target, you just have to provide the sysroot.
5. This clang is built with x86, x64, arm 32 & 64-bit support only no ppc, mips.

## But but bu-- Why not android NDK?
No one wants that bloated piece of shit when clang and musl exists.

## Why the host is windows?
I use windows, although building clang for linux isnt hard if you know what you are doing.

## Whats the catch?
1. It uses compiler-rt rather than libgcc, i want this toolchain to be fully seperated from gnu stuff thats why musl is my choice.
2. Doesnt come with sysroot, yep i only provide the binaries not the sysroot.
3. Default sysroot location is at `INSTALL_DIR/sysroot`
4. Default dynamic linker is `/lib/ld-musl-armhf.so.1`

## Want to compile for android?
### For 32-bit
```clang main.c -o main -Xlinker --dynamic-linker=/system/bin/linker```
### For 64-bit
```clang main.c -o main -Xlinker --dynamic-linker=/system/bin/linker64```
