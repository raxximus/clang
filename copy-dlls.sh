#!/usr/bin/env bash

# Check if the destination directory is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <destination_directory>"
    exit 1
fi

DEST_DIR=$1
FILES=(libgcc_s_seh-1.dll libstdc++-6.dll)
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $DEST_DIR
# Search for the files in all directories on the system
for file in "${FILES[@]}"; do
    find /lib/gcc/x86_64-w64-mingw32/*posix -type f -name "$file" -exec cp {} "$DEST_DIR" \; 2>&1 > /dev/null
done
