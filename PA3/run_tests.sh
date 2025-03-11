#!/bin/bash

# Compile all .c and .h files in src/
gcc src/*.c src/*.h || exit 1

# Process each .cl-ast file
for file in bad_programs/*.cl; do
    file_no_ext="${file%.cl}"
    cool --type "$file"
    base=$(basename "$file-type")
    echo
    echo "Processing $file_no_ext"
    cool --out "$file_no_ext-reference" --tac "$file"
    ./a.out "bad_programs/$base"
    if [[ -f "$file_no_ext-reference.cl-tac" && -f "$file-tac" ]]; then
        if diff -b -B -w "$file_no_ext-reference.cl-tac" "$file-tac" > /dev/null; then
            echo "No differences found."
        else
            echo "Differences found."
        fi
    fi
done

rm *.out **/*.gch
rm bad_programs/*.cl-tac
rm bad_programs/*.cl-type

# Cleanup build files
rm -f src/a.out
