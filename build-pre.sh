#!/usr/bin/env bash
WORK_DIR=$GITHUB_WORKSPACE
VERSION=17.2

cd $WORK_DIR
wget https://snapshots.linaro.org/gnu-toolchain/12.3-2023.06-1/arm-linux-gnueabihf/gcc-linaro-12.3.1-2023.06-x86_64_arm-linux-gnueabihf.tar.xz
tar -xf *.xz
rm *.xz

CC=$WORK_DIR/gcc-linaro-12.3.1-2023.06-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc
CXX=$WORK_DIR/gcc-linaro-12.3.1-2023.06-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++

git clone https://github.com/llvm/llvm-project --depth 1 -b release/$VERSION.x
mkdir -p llvm-project/bhost
mkdir -p llvm-project/build

cd llvm-project/bhost
cmake -G Ninja ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_PROJECTS="lld;clang;compiler-rt"
ninja clang-tblgen llvm-tblgen

cd $WORK_DIR/llvm-project/build
cmake -G Ninja ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="ARM;X86" -DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf -DLLVM_TARGET_ARCH=ARM -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX -DLLVM_ENABLE_PIC=ON -DLLVM_ENABLE_PROJECTS="lld;clang;compiler-rt"  -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DLLVM_ENABLE_LIBCXX=On -DLLVM_TABLEGEN=$WORK_DIR/llvm-project/bhost/bin/llvm-tblgen -DCLANG_TABLEGEN=$WORK_DIR/llvm-project/bhost/bin/clang-tblgen -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_BUILD_LLVM_DYLIB=On -DLLVM_LINK_LLVM_DYLIB=On -DLLVM_INSTALL_TOOLCHAIN_ONLY=On -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF -DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DCMAKE_INSTALL_PREFIX=$WORK_DIR/clang-arm -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF -DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DCMAKE_SYSTEM_NAME="Linux" -DCMAKE_CROSSCOMPILING=True -DCLANG_DEFAULT_LINKER=lld
ninja -j4 && ninja install

cd $WORK_DIR
tar --xz -cf clang-arm.tar clang-arm/
gh release create v$VERSION clang-arm.tar -R valium007/clang -t "LLVM/Clang $VERSION with libc++" -n "LLVM/Clang $VERSION for arm linux" -p
