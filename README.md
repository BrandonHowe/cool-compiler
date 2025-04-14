# COOL Compiler

This is a typechecker and optimizing compiler for COOL (Classroom Object-Oriented Language). I made this as part of the [CS485 Special Topics course on Compilers](https://kelloggm.github.io/martinjkellogg.com/teaching/cs485-sp25/) at NJIT. The COOL specification can be found [here](https://kelloggm.github.io/martinjkellogg.com/teaching/cs485-sp25/crm/onepage/crm-onepage.html).

* PA1 contains the "rosetta stone" implementation of topological sort in Python, Rust, Haskell, and COOL. This section is the least interesting and is not part of the main project.
* PA2 contains a static analyzer that performs type checking on COOL programs, traversing the abstract syntax tree and rejecting all COOL programs that do not compy with the type system.
* PA3 contains the code generator and optimizer for COOL, outputting x86 assembly for Ubuntu 22.04. There is an optimizer that applies a number of dataflow analyses and optimizations that improve program performance while maintaining correctness.

With the exception of PA1, all the code is written in C. I have tested the code on MacOS and Ubuntu 22.04, and it should work on Windows with minimal modifications. There are a couple of files that are common to both parts:
* allocator.c/.h - contains an arena and pool allocator implementation. Most of the memory is allocated in arenas. There is not much logic to free memory, I mostly rely on the OS to clean up all the memory once the program ends.
* types.c/.h - contains string view (bh_str) and string buffer (bh_str_buf) implementations. String views are non-owning and string buffers are owning and allocator-backed.
There are also README.txt files in each part that go into more detail about the design choices for each section.
