#!/bin/bash

# Compile all .c and .h files in src/
gcc src/*.c src/*.h || exit 1

# Process each .cl-ast file
for file in bad_testcases/*.cl; do
    file_no_ext="${file%.cl}"
    cool --parse "$file"
    base=$(basename "$file-ast")
    echo
    echo "Processing $file_no_ext"
    cool --out "$file_no_ext-reference" --class-map "$file"
    ./a.out "bad_testcases/$base"
    if [[ -f "$file_no_ext-reference.cl-type" && -f "$file-type" ]]; then
            diff -b -B -w "$file_no_ext-reference.cl-type" "$file-type"
        fi
done

rm *.out **/*.gch

# Cleanup build files
rm -f src/a.out
