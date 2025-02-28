#!/bin/bash

# Compile all .c and .h files in src/
gcc src/*.c src/*.h || exit 1

# Process each .cl-ast file
for file in cool_programs/*.cl; do
    file_no_ext="${file%.cl}"
    cool --parse "$file"
    base=$(basename "$file-ast")
    echo
    echo "Processing $file_no_ext"
    cool --out "$file_no_ext-reference" --type "$file"
    ./a.out "cool_programs/$base"
    if [[ -f "$file_no_ext-reference.cl-type" && -f "$file-type" ]]; then
            if diff -b -B -w "$file_no_ext-reference.cl-type" "$file-type" > /dev/null; then
              echo "No differences found."
            else
              echo "Differences found."
            fi
        fi
done

rm *.out **/*.gch

# Cleanup build files
rm -f src/a.out
