                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Board..vtable
Board..vtable:          ## virtual function table for Board
                        .quad string1
                        .quad Board..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad IO.in_int
                        .quad IO.in_string
                        .quad IO.out_int
                        .quad IO.out_string
                        .quad Board.size_of_board
                        .quad Board.board_init
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Bool..vtable
Bool..vtable:           ## virtual function table for Bool
                        .quad string2
                        .quad Bool..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton..vtable
CellularAutomaton..vtable:## virtual function table for CellularAutomaton
                        .quad string3
                        .quad CellularAutomaton..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad IO.in_int
                        .quad IO.in_string
                        .quad IO.out_int
                        .quad IO.out_string
                        .quad Board.size_of_board
                        .quad Board.board_init
                        .quad CellularAutomaton.init
                        .quad CellularAutomaton.print
                        .quad CellularAutomaton.num_cells
                        .quad CellularAutomaton.cell
                        .quad CellularAutomaton.north
                        .quad CellularAutomaton.south
                        .quad CellularAutomaton.east
                        .quad CellularAutomaton.west
                        .quad CellularAutomaton.northwest
                        .quad CellularAutomaton.northeast
                        .quad CellularAutomaton.southeast
                        .quad CellularAutomaton.southwest
                        .quad CellularAutomaton.neighbors
                        .quad CellularAutomaton.cell_at_next_evolution
                        .quad CellularAutomaton.evolve
                        .quad CellularAutomaton.option
                        .quad CellularAutomaton.prompt
                        .quad CellularAutomaton.prompt2
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO..vtable
IO..vtable:             ## virtual function table for IO
                        .quad string4
                        .quad IO..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad IO.in_int
                        .quad IO.in_string
                        .quad IO.out_int
                        .quad IO.out_string
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Int..vtable
Int..vtable:            ## virtual function table for Int
                        .quad string5
                        .quad Int..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main..vtable
Main..vtable:           ## virtual function table for Main
                        .quad string6
                        .quad Main..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad IO.in_int
                        .quad IO.in_string
                        .quad IO.out_int
                        .quad IO.out_string
                        .quad Board.size_of_board
                        .quad Board.board_init
                        .quad CellularAutomaton.init
                        .quad CellularAutomaton.print
                        .quad CellularAutomaton.num_cells
                        .quad CellularAutomaton.cell
                        .quad CellularAutomaton.north
                        .quad CellularAutomaton.south
                        .quad CellularAutomaton.east
                        .quad CellularAutomaton.west
                        .quad CellularAutomaton.northwest
                        .quad CellularAutomaton.northeast
                        .quad CellularAutomaton.southeast
                        .quad CellularAutomaton.southwest
                        .quad CellularAutomaton.neighbors
                        .quad CellularAutomaton.cell_at_next_evolution
                        .quad CellularAutomaton.evolve
                        .quad CellularAutomaton.option
                        .quad CellularAutomaton.prompt
                        .quad CellularAutomaton.prompt2
                        .quad Main.main
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object..vtable
Object..vtable:         ## virtual function table for Object
                        .quad string7
                        .quad Object..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String..vtable
String..vtable:         ## virtual function table for String
                        .quad string8
                        .quad String..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad String.concat
                        .quad String.length
                        .quad String.substr
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Board..new
Board..new:             ## constructor for Board
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $6, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $10, %r14
                        movq %r14, 0(%r12)
                        movq $6, %r14
                        movq %r14, 8(%r12)
                        movq $Board..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field rows (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[4] holds field columns (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 32(%r12)
                        ## self[5] holds field board_size (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 40(%r12)
                        ## self[3] rows initializer -- none 
                        ## self[4] columns initializer -- none 
                        ## self[5] board_size initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Bool..new
Bool..new:              ## constructor for Bool
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $0, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $Bool..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (Int)
                        movq $0, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton..new
CellularAutomaton..new: ## constructor for CellularAutomaton
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $7, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $11, %r14
                        movq %r14, 0(%r12)
                        movq $7, %r14
                        movq %r14, 8(%r12)
                        movq $CellularAutomaton..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field rows (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[4] holds field columns (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 32(%r12)
                        ## self[5] holds field board_size (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 40(%r12)
                        ## self[6] holds field population_map (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 48(%r12)
                        ## self[3] rows initializer -- none 
                        ## self[4] columns initializer -- none 
                        ## self[5] board_size initializer -- none 
                        ## self[6] population_map initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO..new
IO..new:                ## constructor for IO
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $3, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $12, %r14
                        movq %r14, 0(%r12)
                        movq $3, %r14
                        movq %r14, 8(%r12)
                        movq $IO..vtable, %r14
                        movq %r14, 16(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Int..new
Int..new:               ## constructor for Int
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $1, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $Int..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (Int)
                        movq $0, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main..new
Main..new:              ## constructor for Main
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $8, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $13, %r14
                        movq %r14, 0(%r12)
                        movq $8, %r14
                        movq %r14, 8(%r12)
                        movq $Main..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field rows (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[4] holds field columns (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 32(%r12)
                        ## self[5] holds field board_size (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 40(%r12)
                        ## self[6] holds field population_map (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 48(%r12)
                        ## self[7] holds field cells (CellularAutomaton)
                        movq $0, %r13
                        movq %r13, 56(%r12)
                        ## self[3] rows initializer -- none 
                        ## self[4] columns initializer -- none 
                        ## self[5] board_size initializer -- none 
                        ## self[6] population_map initializer -- none 
                        ## self[7] cells initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object..new
Object..new:            ## constructor for Object
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $3, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $14, %r14
                        movq %r14, 0(%r12)
                        movq $3, %r14
                        movq %r14, 8(%r12)
                        movq $Object..vtable, %r14
                        movq %r14, 16(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String..new
String..new:            ## constructor for String
                        pushq %rbp
                        movq %rsp, %rbp
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        movq $4, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $3, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $String..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field (raw content) (String)
                        movq $the.empty.string, %r13
                        movq %r13, 24(%r12)
                        ## self[3] (raw content) initializer -- none 
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.abort
Object.abort:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## method body begins
                        movq $string9, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl Object.abort.end
Object.abort.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.copy
Object.copy:            ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## method body begins
                        movq 8(%r12), %r14
                        movq $8, %rsi
			movq %r14, %rdi
			call calloc
			movq %rax, %r13
                        pushq %r13
.globl l1
l1:                     cmpq $0, %r14
			je l2
                        movq 0(%r12), %r15
                        movq %r15, 0(%r13)
                        movq $8, %r15
                        addq %r15, %r12
                        addq %r15, %r13
                        movq $1, %r15
                        subq %r15, %r14
                        jmp l1
.globl l2
l2:                     ## done with Object.copy loop
                        popq %r13
.globl Object.copy.end
Object.copy.end:        ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.type_name
Object.type_name:       ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## obtain vtable for self object
                        movq 16(%r12), %r14
                        ## look up type name at offset 0 in vtable
                        movq 0(%r14), %r14
                        movq %r14, 24(%r13)
.globl Object.type_name.end
Object.type_name.end:   ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_int
IO.in_int:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## method body begins
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        movl	$1, %esi
			movl $4096, %edi
			call calloc
			pushq %rax
			movq %rax, %rdi
			movq $4096, %rsi 
			movq stdin(%rip), %rdx
			call fgets 
			popq %rdi 
			movl $0, %eax
			pushq %rax
			movq %rsp, %rdx
			movq $percent.ld, %rsi
			call sscanf
			popq %rax
			movq $0, %rsi 
			cmpq $2147483647, %rax 
			cmovg %rsi, %rax
			cmpq $-2147483648, %rax 
			cmovl %rsi, %rax
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl IO.in_int.end
IO.in_int.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_string
IO.in_string:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        call coolgetstr 
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl IO.in_string.end
IO.in_string.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_int
IO.out_int:             ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## fp[3] holds argument x (Int)
                        ## method body begins
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r13
                        movq $percent.d, %rdi
		movl %r13d, %eax
		cdqe
		movq %rax, %rsi
			movl $0, %eax
			call printf
                        movq %r12, %r13
.globl IO.out_int.end
IO.out_int.end:         ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_string
IO.out_string:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## fp[3] holds argument x (String)
                        ## method body begins
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r13
                        movq %r13, %rdi
			call cooloutstr
                        movq %r12, %r13
.globl IO.out_string.end
IO.out_string.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Board.size_of_board
Board.size_of_board:    ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## fp[3] holds argument initial (String)
                        ## method body begins
                        ## initial.length(...)
                        pushq %r12
                        pushq %rbp
                        ## initial
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l3
                        movq $string10, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l3
l3:                     pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl Board.size_of_board.end
Board.size_of_board.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Board.board_init
Board.board_init:       ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## fp[3] holds argument start (String)
                        ## method body begins
                        ## fp[0] holds local size (Int)
                        ## size_of_board(...)
                        pushq %r12
                        pushq %rbp
                        ## start
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Board
                        movq 16(%r12), %r14
                        ## look up size_of_board() at offset 9 in vtable
                        movq 72(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l4
.globl l5
l5:                     ## false branch
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $16, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l7
.globl l8
l8:                     ## false branch
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $20, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l10
.globl l11
l11:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $21, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l13
.globl l14
l14:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $25, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l16
.globl l17
l17:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## size
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $28, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l19
.globl l20
l20:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
                        jmp l21
.globl l19
l19:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l21
l21:                    ## end of if conditional
                        jmp l18
.globl l16
l16:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l18
l18:                    ## end of if conditional
                        jmp l15
.globl l13
l13:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l15
l15:                    ## end of if conditional
                        jmp l12
.globl l10
l10:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l12
l12:                    ## end of if conditional
                        jmp l9
.globl l7
l7:                     ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l9
l9:                     ## end of if conditional
                        jmp l6
.globl l4
l4:                     ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 32(%r12)
                        ## size
                        movq 0(%rbp), %r13
                        movq %r13, 40(%r12)
.globl l6
l6:                     ## end of if conditional
                        movq %r12, %r13
.globl Board.board_init.end
Board.board_init.end:   ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.init
CellularAutomaton.init: ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument map (String)
                        ## method body begins
                        ## map
                        movq 24(%rbp), %r13
                        movq %r13, 48(%r12)
                        ## board_init(...)
                        pushq %r12
                        pushq %rbp
                        ## map
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up board_init() at offset 10 in vtable
                        movq 80(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r12, %r13
.globl CellularAutomaton.init.end
CellularAutomaton.init.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.print
CellularAutomaton.print:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 5
                        movq $40, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## fp[0] holds local i (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local num (Int)
                        ## board_size
                        movq 40(%r12), %r13
                        movq %r13, -8(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l22
l22:                    ## while conditional check
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## num
                        movq -8(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l23
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## population_map.substr(...)
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## columns
                        movq 32(%r12), %r13
                        pushq %r13
                        ## population_map
                        movq 48(%r12), %r13
                        cmpq $0, %r13
			jne l24
                        movq $string12, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l24
l24:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up substr() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## i
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq -16(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -16(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -16(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        jmp l22
.globl l23
l23:                    ## end of while loop
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r12, %r13
.globl CellularAutomaton.print.end
CellularAutomaton.print.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.num_cells
CellularAutomaton.num_cells:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## population_map.length(...)
                        pushq %r12
                        pushq %rbp
                        ## population_map
                        movq 48(%r12), %r13
                        cmpq $0, %r13
			jne l25
                        movq $string13, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l25
l25:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl CellularAutomaton.num_cells.end
CellularAutomaton.num_cells.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.cell
CellularAutomaton.cell: ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## board_size
                        movq 40(%r12), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l26
.globl l27
l27:                    ## false branch
                        ## population_map.substr(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## population_map
                        movq 48(%r12), %r13
                        cmpq $0, %r13
			jne l29
                        movq $string14, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l29
l29:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up substr() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        jmp l28
.globl l26
l26:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l28
l28:                    ## end of if conditional
.globl CellularAutomaton.cell.end
CellularAutomaton.cell.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.north
CellularAutomaton.north:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l30
.globl l31
l31:                    ## false branch
                        ## cell(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l32
.globl l30
l30:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l32
l32:                    ## end of if conditional
.globl CellularAutomaton.north.end
CellularAutomaton.north.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.south
CellularAutomaton.south:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## board_size
                        movq 40(%r12), %r13
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l33
.globl l34
l34:                    ## false branch
                        ## cell(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l35
.globl l33
l33:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l35
l35:                    ## end of if conditional
.globl CellularAutomaton.south.end
CellularAutomaton.south.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.east
CellularAutomaton.east: ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l36
                        movq $string16, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l36
l36:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l37
.globl l38
l38:                    ## false branch
                        ## cell(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l39
.globl l37
l37:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l39
l39:                    ## end of if conditional
.globl CellularAutomaton.east.end
CellularAutomaton.east.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.west
CellularAutomaton.west: ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l40
.globl l41
l41:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l43
                        movq $string17, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l43
l43:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l44
.globl l45
l45:                    ## false branch
                        ## cell(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l46
.globl l44
l44:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l46
l46:                    ## end of if conditional
                        jmp l42
.globl l40
l40:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l42
l42:                    ## end of if conditional
.globl CellularAutomaton.west.end
CellularAutomaton.west.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.northwest
CellularAutomaton.northwest:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l47
.globl l48
l48:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l50
                        movq $string18, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l50
l50:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l51
.globl l52
l52:                    ## false branch
                        ## north(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up north() at offset 15 in vtable
                        movq 120(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l53
.globl l51
l51:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l53
l53:                    ## end of if conditional
                        jmp l49
.globl l47
l47:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l49
l49:                    ## end of if conditional
.globl CellularAutomaton.northwest.end
CellularAutomaton.northwest.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.northeast
CellularAutomaton.northeast:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l54
.globl l55
l55:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l57
                        movq $string19, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l57
l57:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l58
.globl l59
l59:                    ## false branch
                        ## north(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up north() at offset 15 in vtable
                        movq 120(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l60
.globl l58
l58:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l60
l60:                    ## end of if conditional
                        jmp l56
.globl l54
l54:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l56
l56:                    ## end of if conditional
.globl CellularAutomaton.northeast.end
CellularAutomaton.northeast.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.southeast
CellularAutomaton.southeast:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## board_size
                        movq 40(%r12), %r13
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l61
.globl l62
l62:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l64
                        movq $string20, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l64
l64:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l65
.globl l66
l66:                    ## false branch
                        ## south(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up south() at offset 16 in vtable
                        movq 128(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l67
.globl l65
l65:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l67
l67:                    ## end of if conditional
                        jmp l63
.globl l61
l61:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l63
l63:                    ## end of if conditional
.globl CellularAutomaton.southeast.end
CellularAutomaton.southeast.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.southwest
CellularAutomaton.southwest:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## board_size
                        movq 40(%r12), %r13
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l68
.globl l69
l69:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l71
                        movq $string21, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l71
l71:                    ## division is OK
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## columns
                        movq 32(%r12), %r13
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l72
.globl l73
l73:                    ## false branch
                        ## south(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up south() at offset 16 in vtable
                        movq 128(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l74
.globl l72
l72:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l74
l74:                    ## end of if conditional
                        jmp l70
.globl l68
l68:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string15 holds " "
                        movq $string15, %r14
                        movq %r14, 24(%r13)
.globl l70
l70:                    ## end of if conditional
.globl CellularAutomaton.southwest.end
CellularAutomaton.southwest.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.neighbors
CellularAutomaton.neighbors:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## north(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up north() at offset 15 in vtable
                        movq 120(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l75
.globl l76
l76:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l77
.globl l75
l75:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l77
l77:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## south(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up south() at offset 16 in vtable
                        movq 128(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l78
.globl l79
l79:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l80
.globl l78
l78:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l80
l80:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## east(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up east() at offset 17 in vtable
                        movq 136(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l81
.globl l82
l82:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l83
.globl l81
l81:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l83
l83:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## west(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up west() at offset 18 in vtable
                        movq 144(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l84
.globl l85
l85:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l86
.globl l84
l84:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l86
l86:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## northeast(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up northeast() at offset 20 in vtable
                        movq 160(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l87
.globl l88
l88:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l89
.globl l87
l87:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l89
l89:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## northwest(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up northwest() at offset 19 in vtable
                        movq 152(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l90
.globl l91
l91:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l92
.globl l90
l90:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l92
l92:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## southeast(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up southeast() at offset 21 in vtable
                        movq 168(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l93
.globl l94
l94:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l95
.globl l93
l93:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l95
l95:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## southwest(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up southwest() at offset 22 in vtable
                        movq 176(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l96
.globl l97
l97:                    ## false branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l98
.globl l96
l96:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l98
l98:                    ## end of if conditional
                        movq 24(%r13), %r13
                        movq 0(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq 0(%rbp), %r14
                        movq %r14, 24(%r13)
.globl CellularAutomaton.neighbors.end
CellularAutomaton.neighbors.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.cell_at_next_evolution
CellularAutomaton.cell_at_next_evolution:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## fp[3] holds argument position (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## neighbors(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up neighbors() at offset 23 in vtable
                        movq 184(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l99
.globl l100
l100:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## neighbors(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up neighbors() at offset 23 in vtable
                        movq 184(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l102
.globl l103
l103:                   ## false branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "-"
                        movq $string23, %r14
                        movq %r14, 24(%r13)
                        jmp l104
.globl l102
l102:                   ## true branch
                        pushq %r12
                        pushq %rbp
                        ## cell(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l105
.globl l106
l106:                   ## false branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "-"
                        movq $string23, %r14
                        movq %r14, 24(%r13)
                        jmp l107
.globl l105
l105:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
.globl l107
l107:                   ## end of if conditional
.globl l104
l104:                   ## end of if conditional
                        jmp l101
.globl l99
l99:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "X"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
.globl l101
l101:                   ## end of if conditional
.globl CellularAutomaton.cell_at_next_evolution.end
CellularAutomaton.cell_at_next_evolution.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.evolve
CellularAutomaton.evolve:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 6
                        movq $48, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## fp[0] holds local position (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local num (Int)
                        ## num_cells(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up num_cells() at offset 13 in vtable
                        movq 104(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, -8(%rbp)
                        ## fp[-2] holds local temp (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -16(%rbp)
.globl l108
l108:                   ## while conditional check
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## num
                        movq -8(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l109
                        ## temp.concat(...)
                        pushq %r12
                        pushq %rbp
                        ## cell_at_next_evolution(...)
                        pushq %r12
                        pushq %rbp
                        ## position
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up cell_at_next_evolution() at offset 24 in vtable
                        movq 192(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## temp
                        movq -16(%rbp), %r13
                        cmpq $0, %r13
			jne l110
                        movq $string24, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l110
l110:                   pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up concat() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, -16(%rbp)
                        ## position
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -24(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -24(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -24(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -24(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        jmp l108
.globl l109
l109:                   ## end of while loop
                        ## temp
                        movq -16(%rbp), %r13
                        movq %r13, 48(%r12)
                        movq %r12, %r13
.globl CellularAutomaton.evolve.end
CellularAutomaton.evolve.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.option
CellularAutomaton.option:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## fp[0] holds local num (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string25 holds "\nPlease chose a num..."
                        movq $string25, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string26 holds "\t1: A cross\n"
                        movq $string26, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string27 holds "\t2: A slash from th..."
                        movq $string27, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string28 holds "\t3: A slash from th..."
                        movq $string28, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string29 holds "\t4: An X\n"
                        movq $string29, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string30 holds "\t5: A greater than ..."
                        movq $string30, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string31 holds "\t6: A less than sig..."
                        movq $string31, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string32 holds "\t7: Two greater tha..."
                        movq $string32, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string33 holds "\t8: Two less than s..."
                        movq $string33, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string34 holds "\t9: A 'V'\n"
                        movq $string34, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string35 holds "\t10: An inverse 'V'..."
                        movq $string35, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string36 holds "\t11: Numbers 9 and ..."
                        movq $string36, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string37 holds "\t12: A full grid\n"
                        movq $string37, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string38 holds "\t13: A 'T'\n"
                        movq $string38, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string39 holds "\t14: A plus '+'\n"
                        movq $string39, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string40 holds "\t15: A 'W'\n"
                        movq $string40, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string41 holds "\t16: An 'M'\n"
                        movq $string41, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string42 holds "\t17: An 'E'\n"
                        movq $string42, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string43 holds "\t18: A '3'\n"
                        movq $string43, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string44 holds "\t19: An 'O'\n"
                        movq $string44, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string45 holds "\t20: An '8'\n"
                        movq $string45, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string46 holds "\t21: An 'S'\n"
                        movq $string46, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string47 holds "Your choice => "
                        movq $string47, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## in_int(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up in_int() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l111
.globl l112
l112:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l114
.globl l115
l115:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l117
.globl l118
l118:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l120
.globl l121
l121:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l123
.globl l124
l124:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $6, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l126
.globl l127
l127:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l129
.globl l130
l130:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l132
.globl l133
l133:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l135
.globl l136
l136:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l138
.globl l139
l139:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l141
.globl l142
l142:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $12, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l144
.globl l145
l145:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $13, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l147
.globl l148
l148:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $14, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l150
.globl l151
l151:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $15, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l153
.globl l154
l154:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $16, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l156
.globl l157
l157:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $17, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l159
.globl l160
l160:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $18, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l162
.globl l163
l163:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $19, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l165
.globl l166
l166:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $20, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l168
.globl l169
l169:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## num
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $21, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l171
.globl l172
l172:                   ## false branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string48 holds "                    ..."
                        movq $string48, %r14
                        movq %r14, 24(%r13)
                        jmp l173
.globl l171
l171:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string49 holds " XXXX   X    XX    X..."
                        movq $string49, %r14
                        movq %r14, 24(%r13)
.globl l173
l173:                   ## end of if conditional
                        jmp l170
.globl l168
l168:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string50 holds " XX X  XX  X XX X  X..."
                        movq $string50, %r14
                        movq %r14, 24(%r13)
.globl l170
l170:                   ## end of if conditional
                        jmp l167
.globl l165
l165:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string51 holds " XX X  XX  X XX "
                        movq $string51, %r14
                        movq %r14, 24(%r13)
.globl l167
l167:                   ## end of if conditional
                        jmp l164
.globl l162
l162:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string52 holds "XXX    X   X  X    X..."
                        movq $string52, %r14
                        movq %r14, 24(%r13)
.globl l164
l164:                   ## end of if conditional
                        jmp l161
.globl l159
l159:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string53 holds "XXXXX   X   XXXXX   ..."
                        movq $string53, %r14
                        movq %r14, 24(%r13)
.globl l161
l161:                   ## end of if conditional
                        jmp l158
.globl l156
l156:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string54 holds "  X X   X X X X     ..."
                        movq $string54, %r14
                        movq %r14, 24(%r13)
.globl l158
l158:                   ## end of if conditional
                        jmp l155
.globl l153
l153:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string55 holds "X     X X X X   X X ..."
                        movq $string55, %r14
                        movq %r14, 24(%r13)
.globl l155
l155:                   ## end of if conditional
                        jmp l152
.globl l150
l150:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string56 holds "  X    X  XXXXX  X  ..."
                        movq $string56, %r14
                        movq %r14, 24(%r13)
.globl l152
l152:                   ## end of if conditional
                        jmp l149
.globl l147
l147:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string57 holds "XXXXX  X    X    X  ..."
                        movq $string57, %r14
                        movq %r14, 24(%r13)
.globl l149
l149:                   ## end of if conditional
                        jmp l146
.globl l144
l144:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string58 holds "XXXXXXXXXXXXXXXXXXXX..."
                        movq $string58, %r14
                        movq %r14, 24(%r13)
.globl l146
l146:                   ## end of if conditional
                        jmp l143
.globl l141
l141:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string59 holds "X X X X X X X X"
                        movq $string59, %r14
                        movq %r14, 24(%r13)
.globl l143
l143:                   ## end of if conditional
                        jmp l140
.globl l138
l138:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string60 holds "  X   X X X   X"
                        movq $string60, %r14
                        movq %r14, 24(%r13)
.globl l140
l140:                   ## end of if conditional
                        jmp l137
.globl l135
l135:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string61 holds "X   X X X   X  "
                        movq $string61, %r14
                        movq %r14, 24(%r13)
.globl l137
l137:                   ## end of if conditional
                        jmp l134
.globl l132
l132:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string62 holds " X  XX  X  X  X     "
                        movq $string62, %r14
                        movq %r14, 24(%r13)
.globl l134
l134:                   ## end of if conditional
                        jmp l131
.globl l129
l129:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string63 holds "X  X  X  XX  X      "
                        movq $string63, %r14
                        movq %r14, 24(%r13)
.globl l131
l131:                   ## end of if conditional
                        jmp l128
.globl l126
l126:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string64 holds "    X   X   X     X ..."
                        movq $string64, %r14
                        movq %r14, 24(%r13)
.globl l128
l128:                   ## end of if conditional
                        jmp l125
.globl l123
l123:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string65 holds "X     X     X   X   ..."
                        movq $string65, %r14
                        movq %r14, 24(%r13)
.globl l125
l125:                   ## end of if conditional
                        jmp l122
.globl l120
l120:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string66 holds "X   X X X   X   X X ..."
                        movq $string66, %r14
                        movq %r14, 24(%r13)
.globl l122
l122:                   ## end of if conditional
                        jmp l119
.globl l117
l117:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string67 holds "X     X     X     X ..."
                        movq $string67, %r14
                        movq %r14, 24(%r13)
.globl l119
l119:                   ## end of if conditional
                        jmp l116
.globl l114
l114:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string68 holds "    X   X   X   X   ..."
                        movq $string68, %r14
                        movq %r14, 24(%r13)
.globl l116
l116:                   ## end of if conditional
                        jmp l113
.globl l111
l111:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string69 holds " XX  XXXX XXXX  XX  "
                        movq $string69, %r14
                        movq %r14, 24(%r13)
.globl l113
l113:                   ## end of if conditional
.globl CellularAutomaton.option.end
CellularAutomaton.option.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.prompt
CellularAutomaton.prompt:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## fp[0] holds local ans (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string70 holds "Would you like to co..."
                        movq $string70, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string71 holds "Please use lowercase..."
                        movq $string71, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string11 holds "\n"
                        movq $string11, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r12
                        pushq %rbp
                        ## ans
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string72 holds "n"
                        movq $string72, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l174
.globl l175
l175:                   ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp l176
.globl l174
l174:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl l176
l176:                   ## end of if conditional
.globl CellularAutomaton.prompt.end
CellularAutomaton.prompt.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl CellularAutomaton.prompt2
CellularAutomaton.prompt2:## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## method body begins
                        ## fp[0] holds local ans (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string73 holds "\n\n"
                        movq $string73, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string74 holds "Would you like to ch..."
                        movq $string74, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string75 holds "Please use lowercase..."
                        movq $string75, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type CellularAutomaton
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## ans
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string76 holds "y"
                        movq $string76, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l177
.globl l178
l178:                   ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp l179
.globl l177
l177:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l179
l179:                   ## end of if conditional
.globl CellularAutomaton.prompt2.end
CellularAutomaton.prompt2.end:## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.main
Main.main:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 5
                        movq $40, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field rows (Int)
                        ## self[4] holds field columns (Int)
                        ## self[5] holds field board_size (Int)
                        ## self[6] holds field population_map (String)
                        ## self[7] holds field cells (CellularAutomaton)
                        ## method body begins
                        ## fp[0] holds local continue (Bool)
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local choice (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $the.empty.string, %r15
                        movq %r15, 24(%r13)
                        movq %r13, -8(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string77 holds "Welcome to the Game ..."
                        movq $string77, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string78 holds "There are many initi..."
                        movq $string78, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up out_string() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l180
l180:                   ## while conditional check
                        ## prompt2(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up prompt2() at offset 28 in vtable
                        movq 224(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l181
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## option(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up option() at offset 26 in vtable
                        movq 208(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, -8(%rbp)
                        ## new CellularAutomaton.init(...)
                        pushq %r12
                        pushq %rbp
                        ## choice
                        movq -8(%rbp), %r13
                        pushq %r13
                        ## new CellularAutomaton
                        pushq %rbp
                        pushq %r12
                        movq $CellularAutomaton..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l182
                        movq $string79, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l182
l182:                   pushq %r13
                        ## obtain vtable from object in r1 with static type CellularAutomaton
                        movq 16(%r13), %r14
                        ## look up init() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 56(%r12)
                        ## cells.print(...)
                        pushq %r12
                        pushq %rbp
                        ## cells
                        movq 56(%r12), %r13
                        cmpq $0, %r13
			jne l183
                        movq $string80, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l183
l183:                   pushq %r13
                        ## obtain vtable from object in r1 with static type CellularAutomaton
                        movq 16(%r13), %r14
                        ## look up print() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl l184
l184:                   ## while conditional check
                        ## continue
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l185
                        ## prompt(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up prompt() at offset 27 in vtable
                        movq 216(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l186
.globl l187
l187:                   ## false branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        jmp l188
.globl l186
l186:                   ## true branch
                        ## cells.evolve(...)
                        pushq %r12
                        pushq %rbp
                        ## cells
                        movq 56(%r12), %r13
                        cmpq $0, %r13
			jne l189
                        movq $string81, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l189
l189:                   pushq %r13
                        ## obtain vtable from object in r1 with static type CellularAutomaton
                        movq 16(%r13), %r14
                        ## look up evolve() at offset 25 in vtable
                        movq 200(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        ## cells.print(...)
                        pushq %r12
                        pushq %rbp
                        ## cells
                        movq 56(%r12), %r13
                        cmpq $0, %r13
			jne l190
                        movq $string82, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l190
l190:                   pushq %r13
                        ## obtain vtable from object in r1 with static type CellularAutomaton
                        movq 16(%r13), %r14
                        ## look up print() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl l188
l188:                   ## end of if conditional
                        jmp l184
.globl l185
l185:                   ## end of while loop
                        jmp l180
.globl l181
l181:                   ## end of while loop
                        movq %r12, %r13
.globl Main.main.end
Main.main.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.concat
String.concat:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument s (String)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r15
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r14
                        movq 24(%r12), %r13
                        movq %r13, %rdi
			movq %r14, %rsi
			call coolstrcat
			movq %rax, %r13
                        movq %r13, 24(%r15)
                        movq %r15, %r13
.globl String.concat.end
String.concat.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.length
String.length:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## method body begins
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r14
                        movq 24(%r12), %r13
                        movq %r13, %rdi
			movl $0, %eax
			call coolstrlen
			movq %rax, %r13
                        movq %r13, 24(%r14)
                        movq %r14, %r13
.globl String.length.end
String.length.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.substr
String.substr:          ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[4] holds argument i (Int)
                        ## fp[3] holds argument l (Int)
                        ## method body begins
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, %r15
                        movq 24(%rbp), %r14
                        movq 24(%r14), %r14
                        movq 32(%rbp), %r13
                        movq 24(%r13), %r13
                        movq 24(%r12), %r12
                        movq %r12, %rdi
			movq %r13, %rsi
			movq %r14, %rdx
			call coolsubstr
			movq %rax, %r13
                        cmpq $0, %r13
			jne l191
                        movq $string83, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l191
l191:                   movq %r13, 24(%r15)
                        movq %r15, %r13
.globl String.substr.end
String.substr.end:      ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ## global string constants
.globl the.empty.string
the.empty.string:       # ""
.byte 0

.globl percent.d
percent.d:              # "%ld"
.byte  37 # '%'
.byte 108 # 'l'
.byte 100 # 'd'
.byte 0

.globl percent.ld
percent.ld:             # " %ld"
.byte  32 # ' '
.byte  37 # '%'
.byte 108 # 'l'
.byte 100 # 'd'
.byte 0

.globl string1
string1:                # "Board"
.byte  66 # 'B'
.byte 111 # 'o'
.byte  97 # 'a'
.byte 114 # 'r'
.byte 100 # 'd'
.byte 0

.globl string2
string2:                # "Bool"
.byte  66 # 'B'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 108 # 'l'
.byte 0

.globl string3
string3:                # "CellularAutomaton"
.byte  67 # 'C'
.byte 101 # 'e'
.byte 108 # 'l'
.byte 108 # 'l'
.byte 117 # 'u'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 114 # 'r'
.byte  65 # 'A'
.byte 117 # 'u'
.byte 116 # 't'
.byte 111 # 'o'
.byte 109 # 'm'
.byte  97 # 'a'
.byte 116 # 't'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 0

.globl string4
string4:                # "IO"
.byte  73 # 'I'
.byte  79 # 'O'
.byte 0

.globl string5
string5:                # "Int"
.byte  73 # 'I'
.byte 110 # 'n'
.byte 116 # 't'
.byte 0

.globl string6
string6:                # "Main"
.byte  77 # 'M'
.byte  97 # 'a'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 0

.globl string7
string7:                # "Object"
.byte  79 # 'O'
.byte  98 # 'b'
.byte 106 # 'j'
.byte 101 # 'e'
.byte  99 # 'c'
.byte 116 # 't'
.byte 0

.globl string8
string8:                # "String"
.byte  83 # 'S'
.byte 116 # 't'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 0

.globl string9
string9:                # "abort\\n"
.byte  97 # 'a'
.byte  98 # 'b'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 116 # 't'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string10
string10:               # "ERROR: 52: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  53 # '5'
.byte  50 # '2'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string11
string11:               # "\\n"
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string12
string12:               # "ERROR: 132: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  51 # '3'
.byte  50 # '2'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string13
string13:               # "ERROR: 144: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  52 # '4'
.byte  52 # '4'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string14
string14:               # "ERROR: 151: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  53 # '5'
.byte  49 # '1'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string15
string15:               # " "
.byte  32 # ' '
.byte 0

.globl string16
string16:               # "ERROR: 172: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  55 # '7'
.byte  50 # '2'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string17
string17:               # "ERROR: 183: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  56 # '8'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string18
string18:               # "ERROR: 193: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  57 # '9'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string19
string19:               # "ERROR: 203: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  48 # '0'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string20
string20:               # "ERROR: 213: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  49 # '1'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string21
string21:               # "ERROR: 223: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  50 # '2'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte 122 # 'z'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 111 # 'o'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string22
string22:               # "X"
.byte  88 # 'X'
.byte 0

.globl string23
string23:               # "-"
.byte  45 # '-'
.byte 0

.globl string24
string24:               # "ERROR: 271: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  55 # '7'
.byte  49 # '1'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string25
string25:               # "\\nPlease chose a number:\\n"
.byte  92 # '\\'
.byte 110 # 'n'
.byte  80 # 'P'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte  99 # 'c'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string26
string26:               # "\\t1: A cross\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte  99 # 'c'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 115 # 's'
.byte 115 # 's'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string27
string27:               # "\\t2: A slash from the upper left to lower right\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  50 # '2'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 115 # 's'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 104 # 'h'
.byte  32 # ' '
.byte 102 # 'f'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 109 # 'm'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte 117 # 'u'
.byte 112 # 'p'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 108 # 'l'
.byte 101 # 'e'
.byte 102 # 'f'
.byte 116 # 't'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte 108 # 'l'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 114 # 'r'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 104 # 'h'
.byte 116 # 't'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string28
string28:               # "\\t3: A slash from the upper right to lower left\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 115 # 's'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 104 # 'h'
.byte  32 # ' '
.byte 102 # 'f'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 109 # 'm'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte 117 # 'u'
.byte 112 # 'p'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 114 # 'r'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 104 # 'h'
.byte 116 # 't'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte 108 # 'l'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 108 # 'l'
.byte 101 # 'e'
.byte 102 # 'f'
.byte 116 # 't'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string29
string29:               # "\\t4: An X\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  52 # '4'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  88 # 'X'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string30
string30:               # "\\t5: A greater than sign \\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  53 # '5'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 103 # 'g'
.byte 114 # 'r'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  32 # ' '
.byte 115 # 's'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 110 # 'n'
.byte  32 # ' '
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string31
string31:               # "\\t6: A less than sign\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  54 # '6'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 108 # 'l'
.byte 101 # 'e'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  32 # ' '
.byte 115 # 's'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 110 # 'n'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string32
string32:               # "\\t7: Two greater than signs\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  55 # '7'
.byte  58 # ':'
.byte  32 # ' '
.byte  84 # 'T'
.byte 119 # 'w'
.byte 111 # 'o'
.byte  32 # ' '
.byte 103 # 'g'
.byte 114 # 'r'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  32 # ' '
.byte 115 # 's'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 110 # 'n'
.byte 115 # 's'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string33
string33:               # "\\t8: Two less than signs\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  56 # '8'
.byte  58 # ':'
.byte  32 # ' '
.byte  84 # 'T'
.byte 119 # 'w'
.byte 111 # 'o'
.byte  32 # ' '
.byte 108 # 'l'
.byte 101 # 'e'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  32 # ' '
.byte 115 # 's'
.byte 105 # 'i'
.byte 103 # 'g'
.byte 110 # 'n'
.byte 115 # 's'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string34
string34:               # "\\t9: A 'V'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  57 # '9'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte  39 # '\''
.byte  86 # 'V'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string35
string35:               # "\\t10: An inverse 'V'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  48 # '0'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte 105 # 'i'
.byte 110 # 'n'
.byte 118 # 'v'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte  39 # '\''
.byte  86 # 'V'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string36
string36:               # "\\t11: Numbers 9 and 10 combined\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  49 # '1'
.byte  58 # ':'
.byte  32 # ' '
.byte  78 # 'N'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 115 # 's'
.byte  32 # ' '
.byte  57 # '9'
.byte  32 # ' '
.byte  97 # 'a'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte  49 # '1'
.byte  48 # '0'
.byte  32 # ' '
.byte  99 # 'c'
.byte 111 # 'o'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 101 # 'e'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string37
string37:               # "\\t12: A full grid\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  50 # '2'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 102 # 'f'
.byte 117 # 'u'
.byte 108 # 'l'
.byte 108 # 'l'
.byte  32 # ' '
.byte 103 # 'g'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string38
string38:               # "\\t13: A 'T'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte  39 # '\''
.byte  84 # 'T'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string39
string39:               # "\\t14: A plus '+'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  52 # '4'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte 112 # 'p'
.byte 108 # 'l'
.byte 117 # 'u'
.byte 115 # 's'
.byte  32 # ' '
.byte  39 # '\''
.byte  43 # '+'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string40
string40:               # "\\t15: A 'W'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  53 # '5'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte  39 # '\''
.byte  87 # 'W'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string41
string41:               # "\\t16: An 'M'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  54 # '6'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  39 # '\''
.byte  77 # 'M'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string42
string42:               # "\\t17: An 'E'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  55 # '7'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  39 # '\''
.byte  69 # 'E'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string43
string43:               # "\\t18: A '3'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  56 # '8'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte  32 # ' '
.byte  39 # '\''
.byte  51 # '3'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string44
string44:               # "\\t19: An 'O'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  49 # '1'
.byte  57 # '9'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  39 # '\''
.byte  79 # 'O'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string45
string45:               # "\\t20: An '8'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  50 # '2'
.byte  48 # '0'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  39 # '\''
.byte  56 # '8'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string46
string46:               # "\\t21: An 'S'\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  50 # '2'
.byte  49 # '1'
.byte  58 # ':'
.byte  32 # ' '
.byte  65 # 'A'
.byte 110 # 'n'
.byte  32 # ' '
.byte  39 # '\''
.byte  83 # 'S'
.byte  39 # '\''
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string47
string47:               # "Your choice => "
.byte  89 # 'Y'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 114 # 'r'
.byte  32 # ' '
.byte  99 # 'c'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 105 # 'i'
.byte  99 # 'c'
.byte 101 # 'e'
.byte  32 # ' '
.byte  61 # '='
.byte  62 # '>'
.byte  32 # ' '
.byte 0

.globl string48
string48:               # "                         "
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string49
string49:               # " XXXX   X    XX    X   XXXX "
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte 0

.globl string50
string50:               # " XX X  XX  X XX X  XX  X XX "
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte 0

.globl string51
string51:               # " XX X  XX  X XX "
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte 0

.globl string52
string52:               # "XXX    X   X  X    X   XXXX "
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte 0

.globl string53
string53:               # "XXXXX   X   XXXXX   X   XXXX"
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte 0

.globl string54
string54:               # "  X X   X X X X     X"
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string55
string55:               # "X     X X X X   X X  "
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string56
string56:               # "  X    X  XXXXX  X    X  "
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string57
string57:               # "XXXXX  X    X    X    X  "
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string58
string58:               # "XXXXXXXXXXXXXXXXXXXXXXXXX"
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte 0

.globl string59
string59:               # "X X X X X X X X"
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string60
string60:               # "  X   X X X   X"
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string61
string61:               # "X   X X X   X  "
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string62
string62:               # " X  XX  X  X  X     "
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string63
string63:               # "X  X  X  XX  X      "
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string64
string64:               # "    X   X   X     X     X"
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string65
string65:               # "X     X     X   X   X    "
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string66
string66:               # "X   X X X   X   X X X   X"
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string67
string67:               # "X     X     X     X     X"
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte 0

.globl string68
string68:               # "    X   X   X   X   X    "
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string69
string69:               # " XX  XXXX XXXX  XX  "
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte  88 # 'X'
.byte  88 # 'X'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string70
string70:               # "Would you like to continue with the next generation? \\n"
.byte  87 # 'W'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 108 # 'l'
.byte 100 # 'd'
.byte  32 # ' '
.byte 121 # 'y'
.byte 111 # 'o'
.byte 117 # 'u'
.byte  32 # ' '
.byte 108 # 'l'
.byte 105 # 'i'
.byte 107 # 'k'
.byte 101 # 'e'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte  99 # 'c'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 116 # 't'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 117 # 'u'
.byte 101 # 'e'
.byte  32 # ' '
.byte 119 # 'w'
.byte 105 # 'i'
.byte 116 # 't'
.byte 104 # 'h'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte 110 # 'n'
.byte 101 # 'e'
.byte 120 # 'x'
.byte 116 # 't'
.byte  32 # ' '
.byte 103 # 'g'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  97 # 'a'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  63 # '?'
.byte  32 # ' '
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string71
string71:               # "Please use lowercase y or n for your answer [y]: "
.byte  80 # 'P'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 117 # 'u'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 108 # 'l'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 121 # 'y'
.byte  32 # ' '
.byte 111 # 'o'
.byte 114 # 'r'
.byte  32 # ' '
.byte 110 # 'n'
.byte  32 # ' '
.byte 102 # 'f'
.byte 111 # 'o'
.byte 114 # 'r'
.byte  32 # ' '
.byte 121 # 'y'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 114 # 'r'
.byte  32 # ' '
.byte  97 # 'a'
.byte 110 # 'n'
.byte 115 # 's'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  91 # '['
.byte 121 # 'y'
.byte  93 # ']'
.byte  58 # ':'
.byte  32 # ' '
.byte 0

.globl string72
string72:               # "n"
.byte 110 # 'n'
.byte 0

.globl string73
string73:               # "\\n\\n"
.byte  92 # '\\'
.byte 110 # 'n'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string74
string74:               # "Would you like to choose a background pattern? \\n"
.byte  87 # 'W'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 108 # 'l'
.byte 100 # 'd'
.byte  32 # ' '
.byte 121 # 'y'
.byte 111 # 'o'
.byte 117 # 'u'
.byte  32 # ' '
.byte 108 # 'l'
.byte 105 # 'i'
.byte 107 # 'k'
.byte 101 # 'e'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte  99 # 'c'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte  98 # 'b'
.byte  97 # 'a'
.byte  99 # 'c'
.byte 107 # 'k'
.byte 103 # 'g'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 110 # 'n'
.byte  63 # '?'
.byte  32 # ' '
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string75
string75:               # "Please use lowercase y or n for your answer [n]: "
.byte  80 # 'P'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 117 # 'u'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 108 # 'l'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 121 # 'y'
.byte  32 # ' '
.byte 111 # 'o'
.byte 114 # 'r'
.byte  32 # ' '
.byte 110 # 'n'
.byte  32 # ' '
.byte 102 # 'f'
.byte 111 # 'o'
.byte 114 # 'r'
.byte  32 # ' '
.byte 121 # 'y'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 114 # 'r'
.byte  32 # ' '
.byte  97 # 'a'
.byte 110 # 'n'
.byte 115 # 's'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  91 # '['
.byte 110 # 'n'
.byte  93 # ']'
.byte  58 # ':'
.byte  32 # ' '
.byte 0

.globl string76
string76:               # "y"
.byte 121 # 'y'
.byte 0

.globl string77
string77:               # "Welcome to the Game of Life.\\n"
.byte  87 # 'W'
.byte 101 # 'e'
.byte 108 # 'l'
.byte  99 # 'c'
.byte 111 # 'o'
.byte 109 # 'm'
.byte 101 # 'e'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte  71 # 'G'
.byte  97 # 'a'
.byte 109 # 'm'
.byte 101 # 'e'
.byte  32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte  32 # ' '
.byte  76 # 'L'
.byte 105 # 'i'
.byte 102 # 'f'
.byte 101 # 'e'
.byte  46 # '.'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string78
string78:               # "There are many initial states to choose from. \\n"
.byte  84 # 'T'
.byte 104 # 'h'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 101 # 'e'
.byte  32 # ' '
.byte  97 # 'a'
.byte 114 # 'r'
.byte 101 # 'e'
.byte  32 # ' '
.byte 109 # 'm'
.byte  97 # 'a'
.byte 110 # 'n'
.byte 121 # 'y'
.byte  32 # ' '
.byte 105 # 'i'
.byte 110 # 'n'
.byte 105 # 'i'
.byte 116 # 't'
.byte 105 # 'i'
.byte  97 # 'a'
.byte 108 # 'l'
.byte  32 # ' '
.byte 115 # 's'
.byte 116 # 't'
.byte  97 # 'a'
.byte 116 # 't'
.byte 101 # 'e'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte  99 # 'c'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 102 # 'f'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 109 # 'm'
.byte  46 # '.'
.byte  32 # ' '
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string79
string79:               # "ERROR: 418: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  49 # '1'
.byte  56 # '8'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string80
string80:               # "ERROR: 419: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  49 # '1'
.byte  57 # '9'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string81
string81:               # "ERROR: 423: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  50 # '2'
.byte  51 # '3'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string82
string82:               # "ERROR: 424: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  50 # '2'
.byte  52 # '4'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte  32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string83
string83:               # "ERROR: 0: Exception: String.substr out of range\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  48 # '0'
.byte  58 # ':'
.byte  32 # ' '
.byte  69 # 'E'
.byte 120 # 'x'
.byte  99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte  58 # ':'
.byte  32 # ' '
.byte  83 # 'S'
.byte 116 # 't'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte  46 # '.'
.byte 115 # 's'
.byte 117 # 'u'
.byte  98 # 'b'
.byte 115 # 's'
.byte 116 # 't'
.byte 114 # 'r'
.byte  32 # ' '
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte  32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte  32 # ' '
.byte 114 # 'r'
.byte  97 # 'a'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 101 # 'e'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl eq_handler
eq_handler:             ## helper function for =
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je eq_true
                        movq $0, %r15
                        cmpq %r15, %r13
			je eq_false
                        cmpq %r15, %r14
			je eq_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je eq_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je eq_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je eq_string
                        ## otherwise, use pointer comparison
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je eq_true
.globl eq_false
eq_false:               ## not equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp eq_end
.globl eq_true
eq_true:                ## equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp eq_end
.globl eq_bool
eq_bool:                ## two Bools
.globl eq_int
eq_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpq %r14, %r13
			je eq_true
                        jmp eq_false
.globl eq_string
eq_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        
  movq %r13, %rdi
  movq %r14, %rsi
  call strcmp 
  cmp $0, %eax
  je eq_true
                        jmp eq_false
.globl eq_end
eq_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl le_handler
le_handler:             ## helper function for <=
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je le_true
                        movq $0, %r15
                        cmpq %r15, %r13
			je le_false
                        cmpq %r15, %r14
			je le_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je le_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je le_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je le_string
                        ## for non-primitives, equality is our only hope
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        cmpq %r14, %r13
			je le_true
.globl le_false
le_false:               ## not less-than-or-equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp le_end
.globl le_true
le_true:                ## less-than-or-equal
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp le_end
.globl le_bool
le_bool:                ## two Bools
.globl le_int
le_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpl %r14d, %r13d
			jle le_true
                        jmp le_false
.globl le_string
le_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        
  movq %r13, %rdi
  movq %r14, %rsi
  call strcmp 
  cmp $0, %eax
  jle le_true
                        jmp le_false
.globl le_end
le_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl lt_handler
lt_handler:             ## helper function for <
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 32(%rbp), %r12
                        ## return address handling
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq $0, %r15
                        cmpq %r15, %r13
			je lt_false
                        cmpq %r15, %r14
			je lt_false
                        movq 0(%r13), %r13
                        movq 0(%r14), %r14
                        ## place the sum of the type tags in r1
                        addq %r14, %r13
                        movq $0, %r14
                        cmpq %r14, %r13
			je lt_bool
                        movq $2, %r14
                        cmpq %r14, %r13
			je lt_int
                        movq $6, %r14
                        cmpq %r14, %r13
			je lt_string
                        ## for non-primitives, < is always false
.globl lt_false
lt_false:               ## not less than
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        jmp lt_end
.globl lt_true
lt_true:                ## less than
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        jmp lt_end
.globl lt_bool
lt_bool:                ## two Bools
.globl lt_int
lt_int:                 ## two Ints
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        cmpl %r14d, %r13d
			jl lt_true
                        jmp lt_false
.globl lt_string
lt_string:              ## two Strings
                        movq 32(%rbp), %r13
                        movq 24(%rbp), %r14
                        movq 24(%r13), %r13
                        movq 24(%r14), %r14
                        
  movq %r13, %rdi
  movq %r14, %rsi
  call strcmp 
  cmp $0, %eax
  jl lt_true
                        jmp lt_false
.globl lt_end
lt_end:                 ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl start
start:                  ## program begins here
                        .globl main
			.type main, @function
main:
                        movq $Main..new, %r14
                        pushq %rbp
                        call *%r14
                        pushq %rbp
                        pushq %r13
                        movq $Main.main, %r14
                        call *%r14
                        movl $0, %edi
			call exit
                        
.globl cooloutstr
	.type	cooloutstr, @function
cooloutstr:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2
.L5:
	movl	-4(%rbp), %eax
	cltq
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L3
	movl	-4(%rbp), %eax
	cltq
	addq	$1, %rax
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$110, %al
	jne	.L3
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc
	addl	$2, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	cltq
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L4
	movl	-4(%rbp), %eax
	cltq
	addq	$1, %rax
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$116, %al
	jne	.L4
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$9, %edi
	call	fputc
	addl	$2, -4(%rbp)
	jmp	.L2
.L4:
	movq	stdout(%rip), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fputc
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cltq
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L5
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	cooloutstr, .-cooloutstr
.globl coolstrlen
	.type	coolstrlen, @function
coolstrlen:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L7
.L8:
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -4(%rbp)
.L7:
	movl	-4(%rbp), %eax
	mov	%eax, %eax
	addq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L8
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	coolstrlen, .-coolstrlen
	.section	.rodata
.LC0:
	.string	"%s%s"
	.text
.globl coolstrcat
	.type	coolstrcat, @function
coolstrcat:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L10
	.cfi_offset 3, -24
	movq	-48(%rbp), %rax
	jmp	.L11
.L10:
	cmpq	$0, -48(%rbp)
	jne	.L12
	movq	-40(%rbp), %rax
	jmp	.L11
.L12:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, %ebx
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	leal	(%rbx,%rax), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	calloc
	movq	%rax, -32(%rbp)
	movl	$.LC0, %edx
	movl	-20(%rbp), %eax
	movslq	%eax, %rbx
	movq	-48(%rbp), %rsi
	movq	-40(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rsi, %r8
	movq	%rbx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	movq	-32(%rbp), %rax
.L11:
	addq	$40, %rsp
	popq	%rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	coolstrcat, .-coolstrcat
	.section	.rodata
.LC1:
	.string	""
	.text
.globl coolgetstr
	.type	coolgetstr, @function
coolgetstr:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$1, %esi
	movl	$40960, %edi
	call	calloc
	movq	%rax, -16(%rbp)
	movl	$0, -4(%rbp)
.L20:
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fgetc
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	je	.L14
	cmpl	$10, -20(%rbp)
	jne	.L15
.L14:
	cmpl	$0, -4(%rbp)
	je	.L16
	movl	$.LC1, %eax
	jmp	.L17
.L16:
	movq	-16(%rbp), %rax
	jmp	.L17
.L15:
	cmpl	$0, -20(%rbp)
	jne	.L18
	movl	$1, -4(%rbp)
	jmp	.L20
.L18:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	mov	%eax, %eax
	addq	-16(%rbp), %rax
	movl	-20(%rbp), %edx
	movb	%dl, (%rax)
	jmp	.L20
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	coolgetstr, .-coolgetstr
.globl coolsubstr
	.type	coolsubstr, @function
coolsubstr:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, -4(%rbp)
	cmpq	$0, -32(%rbp)
	js	.L22
	cmpq	$0, -40(%rbp)
	js	.L22
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jle	.L23
.L22:
	movl	$0, %eax
	jmp	.L24
.L23:
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strndup
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	coolsubstr, .-coolsubstr

