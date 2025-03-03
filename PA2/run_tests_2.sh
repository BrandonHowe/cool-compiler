FILE="cool_programs/lam.cl"

cool --parse "$FILE" && cool --type "$FILE"
diff -b -B -w --text "$FILE-type" "cmake-build-debug/$FILE-type"