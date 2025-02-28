FILE="cool_programs/list.cl"

cool --parse "$FILE" && cool --type "$FILE"
diff -b -B -w "$FILE-type" "cmake-build-debug/$FILE-type"