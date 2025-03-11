#!/bin/bash

# Directory containing the .cl files
dir="bad_programs"

# Check if the directory exists
if [ ! -d "$dir" ]; then
    echo "Directory '$dir' not found."
    exit 1
fi

# Loop through each .cl file in the directory
for file in "$dir"/*.cl; do
    if [ -f "$file" ]; then
        echo "Executing cool on $file"
        cool "$file"
    fi
done