#!/bin/bash

for file in ../bad_programs2/*; do
    filename=$(basename "$file")
    echo "=== Running test: $filename ==="

    cp "$file" ../cool_programs/helloworld.cl

    ~/cool --type ../cool_programs/helloworld.cl

    gcc -w *.c *.h
    ./a.out ../cool_programs/helloworld.cl-type

    gcc -w --no-pie --static -g ../cool_programs/helloworld.s
    ./a.out &> my_output

    ~/cool --x86 ../cool_programs/helloworld.cl
    gcc -w --no-pie --static -g ../cool_programs/helloworld.s
    ./a.out &> reference_output

    # diff my_output reference_output
done

rm my_output
rm reference_output
