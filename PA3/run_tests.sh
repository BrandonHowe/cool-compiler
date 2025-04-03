#!/bin/bash

# Compile all .c and .h files in src/
gcc src/*.c src/*.h || exit 1

# Process each .cl-ast file
for file in bad_programs/*.cl; do
    file_no_ext="${file%.cl}"
    cool --type "bad_programs/$file"
    base=$(basename "$file-type")
    echo
    echo "Processing $file_no_ext"
    ./a.out "bad_programs/$base"
done

rm *.out **/*.gch
rm bad_programs/*.cl-tac
rm bad_programs/*.cl-type

# Cleanup build files
rm -f src/a.out
