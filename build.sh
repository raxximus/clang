#!/usr/bin/env bash
WORK_DIR=/root
VERSION=18

cd $WORK_DIR

git clone https://github.com/llvm/llvm-project --depth 1 -b release/$VERSION.x
mkdir -p llvm-project/bhost
mkdir -p llvm-project/build

cd llvm-project/bhost
cmake -G Ninja ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_PROJECTS="lld;clang;compiler-rt"
ninja clang-tblgen llvm-tblgen

cd $WORK_DIR/llvm-project/build
cmake -G Ninja ../llvm \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_TARGETS_TO_BUILD="ARM;AArch64;X86" \
-DCLANG_DEFAULT_RTLIB=compiler-rt \
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-musleabihf \
-DLLVM_TARGET_ARCH=ARM \
-DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc-posix \
-DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++-posix \
-DLLVM_ENABLE_PIC=ON \
-DLLVM_ENABLE_PROJECTS="lld;clang" \
-DLLVM_TABLEGEN=$WORK_DIR/llvm-project/bhost/bin/llvm-tblgen \
-DCLANG_TABLEGEN=$WORK_DIR/llvm-project/bhost/bin/clang-tblgen \
-DLLVM_PARALLEL_LINK_JOBS=1 \
-DLLVM_BUILD_LLVM_DYLIB=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
-DLLVM_INCLUDE_TESTS=OFF \
-DCLANG_INCLUDE_TESTS=OFF \
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF \
-DLLVM_ENABLE_LIBEDIT=OFF \
-DCMAKE_INSTALL_PREFIX=$WORK_DIR/clang \
-DCMAKE_SYSTEM_NAME="Windows" \
-DCMAKE_CROSSCOMPILING=True \
-DCLANG_DEFAULT_LINKER=lld \
-DLLVM_BUILD_TOOLS=NO \
-DDEFAULT_SYSROOT="../sysroot"

ninja -j4 && ninja install

DEST_DIR=$WORK_DIR/clang/bin
FILES=(libatomic-1.dll libssp-0.dll libgcc_s_seh-1.dll libstdc++-6.dll libgomp-1.dll libwinpthread-1.dll libquadmath-0.dll)
# Search for the files in all directories on the system
for file in "${FILES[@]}"; do
find /usr -type f -name "$file" -exec cp {} "$DEST_DIR" \; 2>&1 > /dev/null
done


cd $WORK_DIR
zip -r clang.zip clang
cp clang.zip /home/
