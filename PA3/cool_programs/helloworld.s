                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A..vtable
A..vtable:              ## virtual function table for A
                        .quad string1
                        .quad A..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A.value
                        .quad A.set_var
                        .quad A.method1
                        .quad A.method2
                        .quad A.method3
                        .quad A.method4
                        .quad A.method5
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I..vtable
A2I..vtable:            ## virtual function table for A2I
                        .quad string2
                        .quad A2I..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A2I.c2i
                        .quad A2I.i2c
                        .quad A2I.a2i
                        .quad A2I.a2i_aux
                        .quad A2I.i2a
                        .quad A2I.i2a_aux
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl B..vtable
B..vtable:              ## virtual function table for B
                        .quad string3
                        .quad B..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A.value
                        .quad A.set_var
                        .quad A.method1
                        .quad A.method2
                        .quad A.method3
                        .quad A.method4
                        .quad B.method5
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Bool..vtable
Bool..vtable:           ## virtual function table for Bool
                        .quad string4
                        .quad Bool..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl C..vtable
C..vtable:              ## virtual function table for C
                        .quad string5
                        .quad C..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A.value
                        .quad A.set_var
                        .quad A.method1
                        .quad A.method2
                        .quad A.method3
                        .quad A.method4
                        .quad C.method5
                        .quad C.method6
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl D..vtable
D..vtable:              ## virtual function table for D
                        .quad string6
                        .quad D..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A.value
                        .quad A.set_var
                        .quad A.method1
                        .quad A.method2
                        .quad A.method3
                        .quad A.method4
                        .quad B.method5
                        .quad D.method7
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl E..vtable
E..vtable:              ## virtual function table for E
                        .quad string7
                        .quad E..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad A.value
                        .quad A.set_var
                        .quad A.method1
                        .quad A.method2
                        .quad A.method3
                        .quad A.method4
                        .quad B.method5
                        .quad D.method7
                        .quad E.method6
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO..vtable
IO..vtable:             ## virtual function table for IO
                        .quad string8
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
                        .quad string9
                        .quad Int..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main..vtable
Main..vtable:           ## virtual function table for Main
                        .quad string10
                        .quad Main..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad IO.in_int
                        .quad IO.in_string
                        .quad IO.out_int
                        .quad IO.out_string
                        .quad Main.menu
                        .quad Main.prompt
                        .quad Main.get_int
                        .quad Main.is_even
                        .quad Main.class_type
                        .quad Main.print
                        .quad Main.main
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object..vtable
Object..vtable:         ## virtual function table for Object
                        .quad string11
                        .quad Object..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String..vtable
String..vtable:         ## virtual function table for String
                        .quad string12
                        .quad String..new
                        .quad Object.abort
                        .quad Object.copy
                        .quad Object.type_name
                        .quad String.concat
                        .quad String.length
                        .quad String.substr
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A..new
A..new:                 ## constructor for A
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
                        movq $10, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $A..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field var (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[3] var initializer <- 0
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I..new
A2I..new:               ## constructor for A2I
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
                        movq $11, %r14
                        movq %r14, 0(%r12)
                        movq $3, %r14
                        movq %r14, 8(%r12)
                        movq $A2I..vtable, %r14
                        movq %r14, 16(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl B..new
B..new:                 ## constructor for B
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
                        movq $12, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $B..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field var (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[3] var initializer <- 0
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
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
.globl C..new
C..new:                 ## constructor for C
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
                        movq $13, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $C..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field var (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[3] var initializer <- 0
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl D..new
D..new:                 ## constructor for D
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
                        movq $14, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $D..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field var (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[3] var initializer <- 0
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
                        movq %r12, %r13
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl E..new
E..new:                 ## constructor for E
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
                        movq $15, %r14
                        movq %r14, 0(%r12)
                        movq $4, %r14
                        movq %r14, 8(%r12)
                        movq $E..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field var (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[3] var initializer <- 0
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 24(%r12)
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
                        movq $16, %r14
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
                        movq $7, %r12
                        movq $8, %rsi
			movq %r12, %rdi
			call calloc
			movq %rax, %r12
                        ## store class tag, object size and vtable pointer
                        movq $17, %r14
                        movq %r14, 0(%r12)
                        movq $7, %r14
                        movq %r14, 8(%r12)
                        movq $Main..vtable, %r14
                        movq %r14, 16(%r12)
                        ## initialize attributes
                        ## self[3] holds field char (String)
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 24(%r12)
                        ## self[4] holds field avar (A)
                        movq $0, %r13
                        movq %r13, 32(%r12)
                        ## self[5] holds field a_var (A)
                        movq $0, %r13
                        movq %r13, 40(%r12)
                        ## self[6] holds field flag (Bool)
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 48(%r12)
                        ## self[3] char initializer -- none 
                        ## self[4] avar initializer -- none 
                        ## self[5] a_var initializer -- none 
                        ## self[6] flag initializer <- true
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 48(%r12)
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
                        movq $18, %r14
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
                        ## self[3] holds field var (Int)
                        ## method body begins
                        movq $string13, %r13
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
                        ## self[3] holds field var (Int)
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
                        ## self[3] holds field var (Int)
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
.globl A.value
A.value:                ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## method body begins
                        ## var
                        movq 24(%r12), %r13
.globl A.value.end
A.value.end:            ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.set_var
A.set_var:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## num
                        movq 24(%rbp), %r13
                        movq %r13, 24(%r12)
                        movq %r12, %r13
.globl A.set_var.end
A.set_var.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method1
A.method1:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        movq %r12, %r13
.globl A.method1.end
A.method1.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method2
A.method2:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[4] holds argument num1 (Int)
                        ## fp[3] holds argument num2 (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num1
                        movq 32(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num2
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        addq %r14, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new B.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new B
                        pushq %rbp
                        pushq %r12
                        movq $B..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l3
                        movq $string14, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l3
l3:                     pushq %r13
                        ## obtain vtable from object in r1 with static type B
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl A.method2.end
A.method2.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method3
A.method3:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new C.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new C
                        pushq %rbp
                        pushq %r12
                        movq $C..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l4
                        movq $string15, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l4
l4:                     pushq %r13
                        ## obtain vtable from object in r1 with static type C
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl A.method3.end
A.method3.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method4
A.method4:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[4] holds argument num1 (Int)
                        ## fp[3] holds argument num2 (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## num2
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## num1
                        movq 32(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l5
.globl l6
l6:                     ## false branch
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num2
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num1
                        movq 32(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new D.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new D
                        pushq %rbp
                        pushq %r12
                        movq $D..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l8
                        movq $string16, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l8
l8:                     pushq %r13
                        ## obtain vtable from object in r1 with static type D
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l7
.globl l5
l5:                     ## true branch
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num1
                        movq 32(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num2
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new D.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new D
                        pushq %rbp
                        pushq %r12
                        movq $D..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l9
                        movq $string17, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l9
l9:                     pushq %r13
                        ## obtain vtable from object in r1 with static type D
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l7
l7:                     ## end of if conditional
.globl A.method4.end
A.method4.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method5
A.method5:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 5
                        movq $40, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local y (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -8(%rbp)
.globl l10
l10:                    ## while conditional check
                        pushq %r12
                        pushq %rbp
                        ## y
                        movq -8(%rbp), %r13
                        pushq %r13
                        ## num
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call le_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l11
                        ## x
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
                        ## y
                        movq -8(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -16(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
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
                        ## y
                        movq -8(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
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
                        movq %r13, -8(%rbp)
                        jmp l10
.globl l11
l11:                    ## end of while loop
                        ## new E.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new E
                        pushq %rbp
                        pushq %r12
                        movq $E..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l12
                        movq $string18, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l12
l12:                    pushq %r13
                        ## obtain vtable from object in r1 with static type E
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl A.method5.end
A.method5.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.c2i
A2I.c2i:                ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument char (String)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string19 holds "0"
                        movq $string19, %r14
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
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string20 holds "1"
                        movq $string20, %r14
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
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string21 holds "2"
                        movq $string21, %r14
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
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "3"
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
			jne l22
.globl l23
l23:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "4"
                        movq $string23, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l25
.globl l26
l26:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string24 holds "5"
                        movq $string24, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l28
.globl l29
l29:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string25 holds "6"
                        movq $string25, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l31
.globl l32
l32:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string26 holds "7"
                        movq $string26, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l34
.globl l35
l35:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string27 holds "8"
                        movq $string27, %r14
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
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%rbp), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string28 holds "9"
                        movq $string28, %r14
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
                        ## abort(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up abort() at offset 2 in vtable
                        movq 16(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l42
.globl l40
l40:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $9, %r14
                        movq %r14, 24(%r13)
.globl l42
l42:                    ## end of if conditional
                        jmp l39
.globl l37
l37:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
.globl l39
l39:                    ## end of if conditional
                        jmp l36
.globl l34
l34:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $7, %r14
                        movq %r14, 24(%r13)
.globl l36
l36:                    ## end of if conditional
                        jmp l33
.globl l31
l31:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $6, %r14
                        movq %r14, 24(%r13)
.globl l33
l33:                    ## end of if conditional
                        jmp l30
.globl l28
l28:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $5, %r14
                        movq %r14, 24(%r13)
.globl l30
l30:                    ## end of if conditional
                        jmp l27
.globl l25
l25:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $4, %r14
                        movq %r14, 24(%r13)
.globl l27
l27:                    ## end of if conditional
                        jmp l24
.globl l22
l22:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
.globl l24
l24:                    ## end of if conditional
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
                        movq $2, %r14
                        movq %r14, 24(%r13)
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
                        movq $1, %r14
                        movq %r14, 24(%r13)
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
                        movq $0, %r14
                        movq %r14, 24(%r13)
.globl l15
l15:                    ## end of if conditional
.globl A2I.c2i.end
A2I.c2i.end:            ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2c
A2I.i2c:                ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument i (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## i
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
			jne l43
.globl l44
l44:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
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
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l46
.globl l47
l47:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l49
.globl l50
l50:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l52
.globl l53
l53:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l55
.globl l56
l56:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l58
.globl l59
l59:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l61
.globl l62
l62:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l64
.globl l65
l65:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l67
.globl l68
l68:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
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
			jne l70
.globl l71
l71:                    ## false branch
                        ## abort(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up abort() at offset 2 in vtable
                        movq 16(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string29 holds ""
                        movq $string29, %r14
                        movq %r14, 24(%r13)
                        jmp l72
.globl l70
l70:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string28 holds "9"
                        movq $string28, %r14
                        movq %r14, 24(%r13)
.globl l72
l72:                    ## end of if conditional
                        jmp l69
.globl l67
l67:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string27 holds "8"
                        movq $string27, %r14
                        movq %r14, 24(%r13)
.globl l69
l69:                    ## end of if conditional
                        jmp l66
.globl l64
l64:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string26 holds "7"
                        movq $string26, %r14
                        movq %r14, 24(%r13)
.globl l66
l66:                    ## end of if conditional
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
                        ## string25 holds "6"
                        movq $string25, %r14
                        movq %r14, 24(%r13)
.globl l63
l63:                    ## end of if conditional
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
                        ## string24 holds "5"
                        movq $string24, %r14
                        movq %r14, 24(%r13)
.globl l60
l60:                    ## end of if conditional
                        jmp l57
.globl l55
l55:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string23 holds "4"
                        movq $string23, %r14
                        movq %r14, 24(%r13)
.globl l57
l57:                    ## end of if conditional
                        jmp l54
.globl l52
l52:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string22 holds "3"
                        movq $string22, %r14
                        movq %r14, 24(%r13)
.globl l54
l54:                    ## end of if conditional
                        jmp l51
.globl l49
l49:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string21 holds "2"
                        movq $string21, %r14
                        movq %r14, 24(%r13)
.globl l51
l51:                    ## end of if conditional
                        jmp l48
.globl l46
l46:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string20 holds "1"
                        movq $string20, %r14
                        movq %r14, 24(%r13)
.globl l48
l48:                    ## end of if conditional
                        jmp l45
.globl l43
l43:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string19 holds "0"
                        movq $string19, %r14
                        movq %r14, 24(%r13)
.globl l45
l45:                    ## end of if conditional
.globl A2I.i2c.end
A2I.i2c.end:            ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.a2i
A2I.a2i:                ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument s (String)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## s.length(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l73
                        movq $string30, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l73
l73:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
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
			jne l74
.globl l75
l75:                    ## false branch
                        pushq %r12
                        pushq %rbp
                        ## s.substr(...)
                        pushq %r12
                        pushq %rbp
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
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l77
                        movq $string31, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l77
l77:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up substr() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $24, %rsp
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
                        ## string32 holds "-"
                        movq $string32, %r14
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
                        pushq %r12
                        pushq %rbp
                        ## s.substr(...)
                        pushq %r12
                        pushq %rbp
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
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l81
                        movq $string33, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l81
l81:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up substr() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $24, %rsp
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
                        ## string34 holds "+"
                        movq $string34, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l82
.globl l83
l83:                    ## false branch
                        ## a2i_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up a2i_aux() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l84
.globl l82
l82:                    ## true branch
                        ## a2i_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## s.substr(...)
                        pushq %r12
                        pushq %rbp
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
                        ## s.length(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l85
                        movq $string33, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l85
l85:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
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
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l86
                        movq $string33, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l86
l86:                    pushq %r13
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
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up a2i_aux() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l84
l84:                    ## end of if conditional
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
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, 0(%rbp)
                        ## a2i_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## s.substr(...)
                        pushq %r12
                        pushq %rbp
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
                        ## s.length(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l87
                        movq $string31, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l87
l87:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
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
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l88
                        movq $string31, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l88
l88:                    pushq %r13
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
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up a2i_aux() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
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
.globl l80
l80:                    ## end of if conditional
                        jmp l76
.globl l74
l74:                    ## true branch
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
.globl l76
l76:                    ## end of if conditional
.globl A2I.a2i.end
A2I.a2i.end:            ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.a2i_aux
A2I.a2i_aux:            ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 6
                        movq $48, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument s (String)
                        ## method body begins
                        ## fp[0] holds local int (Int)
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
                        ## fp[-1] holds local j (Int)
                        ## s.length(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l89
                        movq $string35, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l89
l89:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up length() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, -8(%rbp)
                        ## fp[-2] holds local i (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq %r13, -16(%rbp)
.globl l90
l90:                    ## while conditional check
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq -16(%rbp), %r13
                        pushq %r13
                        ## j
                        movq -8(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l91
                        ## int
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
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -24(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
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
                        movq 24(%r13), %r13
                        movq %r13, -24(%rbp)
                        ## c2i(...)
                        pushq %r12
                        pushq %rbp
                        ## s.substr(...)
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq -16(%rbp), %r13
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
                        ## s
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l92
                        movq $string36, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l92
l92:                    pushq %r13
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
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up c2i() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
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
                        ## i
                        movq -16(%rbp), %r13
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
                        movq %r13, -16(%rbp)
                        jmp l90
.globl l91
l91:                    ## end of while loop
                        ## int
                        movq 0(%rbp), %r13
.globl A2I.a2i_aux.end
A2I.a2i_aux.end:        ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2a
A2I.i2a:                ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument i (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## i
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
			jne l93
.globl l94
l94:                    ## false branch
                        pushq %r12
                        pushq %rbp
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
                        ## i
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        call lt_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l96
.globl l97
l97:                    ## false branch
                        ## "-".concat(...)
                        pushq %r12
                        pushq %rbp
                        ## i2a_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## i
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
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
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
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
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
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up i2a_aux() at offset 10 in vtable
                        movq 80(%r14), %r14
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
                        ## string32 holds "-"
                        movq $string32, %r14
                        movq %r14, 24(%r13)
                        cmpq $0, %r13
			jne l99
                        movq $string37, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l99
l99:                    pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up concat() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l98
.globl l96
l96:                    ## true branch
                        ## i2a_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up i2a_aux() at offset 10 in vtable
                        movq 80(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l98
l98:                    ## end of if conditional
                        jmp l95
.globl l93
l93:                    ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string19 holds "0"
                        movq $string19, %r14
                        movq %r14, 24(%r13)
.globl l95
l95:                    ## end of if conditional
.globl A2I.i2a.end
A2I.i2a.end:            ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2a_aux
A2I.i2a_aux:            ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 4
                        movq $32, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## fp[3] holds argument i (Int)
                        ## method body begins
                        pushq %r12
                        pushq %rbp
                        ## i
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
			jne l100
.globl l101
l101:                   ## false branch
                        ## fp[0] holds local next (Int)
                        ## i
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
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l103
                        movq $string38, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l103
l103:                   ## division is OK
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
                        movq %r13, 0(%rbp)
                        ## i2a_aux(...).concat(...)
                        pushq %r12
                        pushq %rbp
                        ## i2c(...)
                        pushq %r12
                        pushq %rbp
                        ## i
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## next
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $10, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -16(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
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
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up i2c() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## i2a_aux(...)
                        pushq %r12
                        pushq %rbp
                        ## next
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type A2I
                        movq 16(%r12), %r14
                        ## look up i2a_aux() at offset 10 in vtable
                        movq 80(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        cmpq $0, %r13
			jne l104
                        movq $string39, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l104
l104:                   pushq %r13
                        ## obtain vtable from object in r1 with static type String
                        movq 16(%r13), %r14
                        ## look up concat() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l102
.globl l100
l100:                   ## true branch
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string29 holds ""
                        movq $string29, %r14
                        movq %r14, 24(%r13)
.globl l102
l102:                   ## end of if conditional
.globl A2I.i2a_aux.end
A2I.i2a_aux.end:        ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl B.method5
B.method5:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new E.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new E
                        pushq %rbp
                        pushq %r12
                        movq $E..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l105
                        movq $string40, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l105
l105:                   pushq %r13
                        ## obtain vtable from object in r1 with static type E
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl B.method5.end
B.method5.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl C.method5
C.method5:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new E.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new E
                        pushq %rbp
                        pushq %r12
                        movq $E..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l106
                        movq $string41, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l106
l106:                   pushq %r13
                        ## obtain vtable from object in r1 with static type E
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl C.method5.end
C.method5.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl C.method6
C.method6:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new A.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l107
                        movq $string42, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l107
l107:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl C.method6.end
C.method6.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl D.method7
D.method7:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## num
                        movq 24(%rbp), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
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
			jne l108
.globl l109
l109:                   ## false branch
                        pushq %r12
                        pushq %rbp
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
                        ## x
                        movq 0(%rbp), %r13
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
                        ## x
                        movq 0(%rbp), %r13
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
                        ## x
                        movq 0(%rbp), %r13
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
                        ## method7(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $3, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type D
                        movq 16(%r12), %r14
                        ## look up method7() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l119
.globl l117
l117:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl l119
l119:                   ## end of if conditional
                        jmp l116
.globl l114
l114:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl l116
l116:                   ## end of if conditional
                        jmp l113
.globl l111
l111:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l113
l113:                   ## end of if conditional
                        jmp l110
.globl l108
l108:                   ## true branch
                        ## method7(...)
                        pushq %r12
                        pushq %rbp
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## x
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type D
                        movq 16(%r12), %r14
                        ## look up method7() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l110
l110:                   ## end of if conditional
.globl D.method7.end
D.method7.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl E.method6
E.method6:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field var (Int)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## num
                        movq 24(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r14
                        cmpq $0, %r14
			jne l120
                        movq $string43, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l120
l120:                   ## division is OK
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        
movq $0, %rdx
movq %r14, %rax
cdq 
idivl %r13d
movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        movq %r13, 0(%rbp)
                        ## new A.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l121
                        movq $string44, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l121
l121:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl E.method6.end
E.method6.end:          ## method body ends
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
.globl Main.menu
Main.menu:              ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## method body begins
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
                        ## string45 holds "\n\tTo add a number ..."
                        movq $string45, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string46 holds "...enter a:\n"
                        movq $string46, %r14
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
                        ## string47 holds "\tTo negate "
                        movq $string47, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string48 holds "...enter b:\n"
                        movq $string48, %r14
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
                        ## string49 holds "\tTo find the differ..."
                        movq $string49, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string50 holds "and another number....."
                        movq $string50, %r14
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
                        ## string51 holds "\tTo find the factor..."
                        movq $string51, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string52 holds "...enter d:\n"
                        movq $string52, %r14
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
                        ## string53 holds "\tTo square "
                        movq $string53, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string54 holds "...enter e:\n"
                        movq $string54, %r14
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
                        ## string55 holds "\tTo cube "
                        movq $string55, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string56 holds "...enter f:\n"
                        movq $string56, %r14
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
                        ## string57 holds "\tTo find out if "
                        movq $string57, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string58 holds "is a multiple of 3....."
                        movq $string58, %r14
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
                        ## string59 holds "\tTo divide "
                        movq $string59, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string60 holds "by 8...enter h:\n"
                        movq $string60, %r14
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
                        ## string61 holds "\tTo get a new numbe..."
                        movq $string61, %r14
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
                        ## string62 holds "\tTo quit...enter q:..."
                        movq $string62, %r14
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
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl Main.menu.end
Main.menu.end:          ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.prompt
Main.prompt:            ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 1
                        movq $8, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## method body begins
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
                        ## string63 holds "\n"
                        movq $string63, %r14
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
                        ## string64 holds "Please enter a numbe..."
                        movq $string64, %r14
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
                        ## in_string(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up in_string() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
.globl Main.prompt.end
Main.prompt.end:        ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.get_int
Main.get_int:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## method body begins
                        ## fp[0] holds local z (A2I)
                        ## new A2I
                        pushq %rbp
                        pushq %r12
                        movq $A2I..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local s (String)
                        ## prompt(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up prompt() at offset 10 in vtable
                        movq 80(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, -8(%rbp)
                        ## z.a2i(...)
                        pushq %r12
                        pushq %rbp
                        ## s
                        movq -8(%rbp), %r13
                        pushq %r13
                        ## z
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l122
                        movq $string65, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l122
l122:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A2I
                        movq 16(%r13), %r14
                        ## look up a2i() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl Main.get_int.end
Main.get_int.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.is_even
Main.is_even:           ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 3
                        movq $24, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## fp[3] holds argument num (Int)
                        ## method body begins
                        ## fp[0] holds local x (Int)
                        ## num
                        movq 24(%rbp), %r13
                        movq %r13, 0(%rbp)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
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
			jne l123
.globl l124
l124:                   ## false branch
                        pushq %r12
                        pushq %rbp
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
                        ## x
                        movq 0(%rbp), %r13
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
                        ## x
                        movq 0(%rbp), %r13
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
                        ## is_even(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $2, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up is_even() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        jmp l131
.globl l129
l129:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
.globl l131
l131:                   ## end of if conditional
                        jmp l128
.globl l126
l126:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $1, %r14
                        movq %r14, 24(%r13)
.globl l128
l128:                   ## end of if conditional
                        jmp l125
.globl l123
l123:                   ## true branch
                        ## is_even(...)
                        pushq %r12
                        pushq %rbp
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## x
                        movq 0(%rbp), %r13
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up is_even() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
.globl l125
l125:                   ## end of if conditional
.globl Main.is_even.end
Main.is_even.end:       ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.class_type
Main.class_type:        ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## fp[3] holds argument var (A)
                        ## method body begins
                        ## case expression begins
                        ## var
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			je l132
                        movq %r13, 0(%rbp)
                        movq 0(%r13), %r13
                        ## case A will jump to l133
                        ## case B will jump to l134
                        ## case C will jump to l135
                        ## case D will jump to l136
                        ## case E will jump to l137
                        ## case Object will jump to l138
                        ## case expression: compare type tags
                        movq $10, %r14
                        cmpq %r14, %r13
			je l133
                        movq $11, %r14
                        cmpq %r14, %r13
			je l138
                        movq $12, %r14
                        cmpq %r14, %r13
			je l134
                        movq $0, %r14
                        cmpq %r14, %r13
			je l138
                        movq $13, %r14
                        cmpq %r14, %r13
			je l135
                        movq $14, %r14
                        cmpq %r14, %r13
			je l136
                        movq $15, %r14
                        cmpq %r14, %r13
			je l137
                        movq $16, %r14
                        cmpq %r14, %r13
			je l138
                        movq $1, %r14
                        cmpq %r14, %r13
			je l138
                        movq $17, %r14
                        cmpq %r14, %r13
			je l138
                        movq $18, %r14
                        cmpq %r14, %r13
			je l138
                        movq $3, %r14
                        cmpq %r14, %r13
			je l138
.globl l139
l139:                   ## case expression: error case
                        movq $string66, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l132
l132:                   ## case expression: void case
                        movq $string67, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
                        ## case expression: branches
.globl l133
l133:                   ## fp[0] holds case a (A)
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
                        ## string68 holds "Class type is now A\..."
                        movq $string68, %r14
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
                        jmp l140
.globl l134
l134:                   ## fp[0] holds case b (B)
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
                        ## string69 holds "Class type is now B\..."
                        movq $string69, %r14
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
                        jmp l140
.globl l135
l135:                   ## fp[0] holds case c (C)
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
                        ## string70 holds "Class type is now C\..."
                        movq $string70, %r14
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
                        jmp l140
.globl l136
l136:                   ## fp[0] holds case d (D)
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
                        ## string71 holds "Class type is now D\..."
                        movq $string71, %r14
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
                        jmp l140
.globl l137
l137:                   ## fp[0] holds case e (E)
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
                        ## string72 holds "Class type is now E\..."
                        movq $string72, %r14
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
                        jmp l140
.globl l138
l138:                   ## fp[0] holds case o (Object)
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
                        ## string73 holds "Oooops\n"
                        movq $string73, %r14
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
                        jmp l140
.globl l140
l140:                   ## case expression ends
.globl Main.class_type.end
Main.class_type.end:    ## method body ends
                        ## return address handling
                        movq %rbp, %rsp
                        popq %rbp
                        ret
                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.print
Main.print:             ## method definition
                        pushq %rbp
                        movq %rsp, %rbp
                        movq 16(%rbp), %r12
                        ## stack room for temporaries: 2
                        movq $16, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## fp[3] holds argument var (A)
                        ## method body begins
                        ## fp[0] holds local z (A2I)
                        ## new A2I
                        pushq %rbp
                        pushq %r12
                        movq $A2I..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 0(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## z.i2a(...)
                        pushq %r12
                        pushq %rbp
                        ## var.value(...)
                        pushq %r12
                        pushq %rbp
                        ## var
                        movq 24(%rbp), %r13
                        cmpq $0, %r13
			jne l141
                        movq $string74, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l141
l141:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## z
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l142
                        movq $string74, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l142
l142:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A2I
                        movq 16(%r13), %r14
                        ## look up i2a() at offset 9 in vtable
                        movq 72(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
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
                        ## string75 holds " "
                        movq $string75, %r14
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
.globl Main.print.end
Main.print.end:         ## method body ends
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
                        ## stack room for temporaries: 6
                        movq $48, %r14
                        subq %r14, %rsp
                        ## return address handling
                        ## self[3] holds field char (String)
                        ## self[4] holds field avar (A)
                        ## self[5] holds field a_var (A)
                        ## self[6] holds field flag (Bool)
                        ## method body begins
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 32(%r12)
.globl l143
l143:                   ## while conditional check
                        ## flag
                        movq 48(%r12), %r13
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			je l144
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
                        ## string76 holds "number "
                        movq $string76, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## is_even(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l145
                        movq $string77, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l145
l145:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up is_even() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l146
.globl l147
l147:                   ## false branch
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
                        ## string78 holds "is odd!\n"
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
                        jmp l148
.globl l146
l146:                   ## true branch
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
                        ## string79 holds "is even!\n"
                        movq $string79, %r14
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
.globl l148
l148:                   ## end of if conditional
                        ## class_type(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up class_type() at offset 13 in vtable
                        movq 104(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        ## menu(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up menu() at offset 9 in vtable
                        movq 72(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 24(%r12)
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string80 holds "a"
                        movq $string80, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l149
.globl l150
l150:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string81 holds "b"
                        movq $string81, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l152
.globl l153
l153:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string82 holds "c"
                        movq $string82, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l155
.globl l156
l156:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string83 holds "d"
                        movq $string83, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l158
.globl l159
l159:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string84 holds "e"
                        movq $string84, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l161
.globl l162
l162:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string85 holds "f"
                        movq $string85, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l164
.globl l165
l165:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string86 holds "g"
                        movq $string86, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l167
.globl l168
l168:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string87 holds "h"
                        movq $string87, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l170
.globl l171
l171:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string88 holds "j"
                        movq $string88, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l173
.globl l174
l174:                   ## false branch
                        pushq %r12
                        pushq %rbp
                        ## char
                        movq 24(%r12), %r13
                        pushq %r13
                        ## new String
                        pushq %rbp
                        pushq %r12
                        movq $String..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        ## string89 holds "q"
                        movq $string89, %r14
                        movq %r14, 24(%r13)
                        pushq %r13
                        pushq %r12
                        call eq_handler
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l176
.globl l177
l177:                   ## false branch
                        ## new A.method1(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l179
                        movq $string90, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l179
l179:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l180
                        movq $string90, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l180
l180:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up method1() at offset 7 in vtable
                        movq 56(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
                        jmp l178
.globl l176
l176:                   ## true branch
                        ## new Bool
                        pushq %rbp
                        pushq %r12
                        movq $Bool..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 48(%r12)
.globl l178
l178:                   ## end of if conditional
                        jmp l175
.globl l173
l173:                   ## true branch
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, 32(%r12)
.globl l175
l175:                   ## end of if conditional
                        jmp l172
.globl l170
l170:                   ## true branch
                        ## fp[0] holds local x (A)
                        movq $0, %r13
                        movq %r13, 0(%rbp)
                        ## new E.method6(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l181
                        movq $string91, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l181
l181:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new E
                        pushq %rbp
                        pushq %r12
                        movq $E..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l182
                        movq $string91, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l182
l182:                   pushq %r13
                        ## obtain vtable from object in r1 with static type E
                        movq 16(%r13), %r14
                        ## look up method6() at offset 13 in vtable
                        movq 104(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 0(%rbp)
                        ## fp[-1] holds local r (Int)
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l183
                        movq $string92, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l183
l183:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        movq %r13, -8(%rbp)
                        ## x.value(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l184
                        movq $string92, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l184
l184:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        movq %r13, -16(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $8, %r14
                        movq %r14, 24(%r13)
                        movq 24(%r13), %r13
                        movq -16(%rbp), %r14
                        
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
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
                        movq 24(%r13), %r13
                        movq -8(%rbp), %r14
                        movq %r14, %rax
			subq %r13, %rax
			movq %rax, %r13
                        movq %r13, -8(%rbp)
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq -8(%rbp), %r14
                        movq %r14, 24(%r13)
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
                        ## string76 holds "number "
                        movq $string76, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string93 holds "is equal to "
                        movq $string93, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## x
                        movq 0(%rbp), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string94 holds "times 8 with a remai..."
                        movq $string94, %r14
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
                        ## fp[-2] holds local a (A2I)
                        ## new A2I
                        pushq %rbp
                        pushq %r12
                        movq $A2I..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq %r13, -16(%rbp)
                        ## out_string(...)
                        pushq %r12
                        pushq %rbp
                        ## a.i2a(...)
                        pushq %r12
                        pushq %rbp
                        ## r
                        movq -8(%rbp), %r13
                        pushq %r13
                        ## a
                        movq -16(%rbp), %r13
                        cmpq $0, %r13
			jne l185
                        movq $string95, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l185
l185:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A2I
                        movq 16(%r13), %r14
                        ## look up i2a() at offset 9 in vtable
                        movq 72(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
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
                        ## string63 holds "\n"
                        movq $string63, %r14
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
                        ## x
                        movq 0(%rbp), %r13
                        movq %r13, 32(%r12)
.globl l172
l172:                   ## end of if conditional
                        jmp l169
.globl l167
l167:                   ## true branch
                        ## new D.method7(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l186
                        movq $string96, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l186
l186:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new D
                        pushq %rbp
                        pushq %r12
                        movq $D..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l187
                        movq $string96, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l187
l187:                   pushq %r13
                        ## obtain vtable from object in r1 with static type D
                        movq 16(%r13), %r14
                        ## look up method7() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq 24(%r13), %r13
                        cmpq $0, %r13
			jne l188
.globl l189
l189:                   ## false branch
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
                        ## string76 holds "number "
                        movq $string76, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string97 holds "is not divisible by ..."
                        movq $string97, %r14
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
                        jmp l190
.globl l188
l188:                   ## true branch
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
                        ## string76 holds "number "
                        movq $string76, %r14
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
                        ## print(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        pushq %r13
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up print() at offset 14 in vtable
                        movq 112(%r14), %r14
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
                        ## string98 holds "is divisible by 3.\n"
                        movq $string98, %r14
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
.globl l190
l190:                   ## end of if conditional
.globl l169
l169:                   ## end of if conditional
                        jmp l166
.globl l164
l164:                   ## true branch
                        ## new C@C.method5(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l191
                        movq $string99, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l191
l191:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new C
                        pushq %rbp
                        pushq %r12
                        movq $C..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l192
                        movq $string99, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l192
l192:                   pushq %r13
                        ## obtain vtable for class C
                        movq $C..vtable, %r14
                        ## look up method5() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
.globl l166
l166:                   ## end of if conditional
                        jmp l163
.globl l161
l161:                   ## true branch
                        ## new C@B.method5(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l193
                        movq $string100, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l193
l193:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new C
                        pushq %rbp
                        pushq %r12
                        movq $C..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l194
                        movq $string100, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l194
l194:                   pushq %r13
                        ## obtain vtable for class B
                        movq $B..vtable, %r14
                        ## look up method5() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
.globl l163
l163:                   ## end of if conditional
                        jmp l160
.globl l158
l158:                   ## true branch
                        ## new C@A.method5(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l195
                        movq $string101, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l195
l195:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new C
                        pushq %rbp
                        pushq %r12
                        movq $C..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l196
                        movq $string101, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l196
l196:                   pushq %r13
                        ## obtain vtable for class A
                        movq $A..vtable, %r14
                        ## look up method5() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
.globl l160
l160:                   ## end of if conditional
                        jmp l157
.globl l155
l155:                   ## true branch
                        ## new A.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## get_int(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up get_int() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l197
                        movq $string102, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l197
l197:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 40(%r12)
                        ## new D.method4(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l198
                        movq $string103, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l198
l198:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## a_var.value(...)
                        pushq %r12
                        pushq %rbp
                        ## a_var
                        movq 40(%r12), %r13
                        cmpq $0, %r13
			jne l199
                        movq $string103, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l199
l199:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new D
                        pushq %rbp
                        pushq %r12
                        movq $D..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l200
                        movq $string103, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l200
l200:                   pushq %r13
                        ## obtain vtable from object in r1 with static type D
                        movq 16(%r13), %r14
                        ## look up method4() at offset 10 in vtable
                        movq 80(%r14), %r14
                        call *%r14
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
.globl l157
l157:                   ## end of if conditional
                        jmp l154
.globl l152
l152:                   ## true branch
                        ## case expression begins
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			je l201
                        movq %r13, 0(%rbp)
                        movq 0(%r13), %r13
                        ## case C will jump to l202
                        ## case A will jump to l203
                        ## case Object will jump to l204
                        ## case expression: compare type tags
                        movq $10, %r14
                        cmpq %r14, %r13
			je l203
                        movq $11, %r14
                        cmpq %r14, %r13
			je l204
                        movq $12, %r14
                        cmpq %r14, %r13
			je l203
                        movq $0, %r14
                        cmpq %r14, %r13
			je l204
                        movq $13, %r14
                        cmpq %r14, %r13
			je l202
                        movq $14, %r14
                        cmpq %r14, %r13
			je l203
                        movq $15, %r14
                        cmpq %r14, %r13
			je l203
                        movq $16, %r14
                        cmpq %r14, %r13
			je l204
                        movq $1, %r14
                        cmpq %r14, %r13
			je l204
                        movq $17, %r14
                        cmpq %r14, %r13
			je l204
                        movq $18, %r14
                        cmpq %r14, %r13
			je l204
                        movq $3, %r14
                        cmpq %r14, %r13
			je l204
.globl l205
l205:                   ## case expression: error case
                        movq $string104, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l201
l201:                   ## case expression: void case
                        movq $string105, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
                        ## case expression: branches
.globl l202
l202:                   ## fp[0] holds case c (C)
                        ## c.method6(...)
                        pushq %r12
                        pushq %rbp
                        ## c.value(...)
                        pushq %r12
                        pushq %rbp
                        ## c
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l207
                        movq $string106, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l207
l207:                   pushq %r13
                        ## obtain vtable from object in r1 with static type C
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## c
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l208
                        movq $string106, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l208
l208:                   pushq %r13
                        ## obtain vtable from object in r1 with static type C
                        movq 16(%r13), %r14
                        ## look up method6() at offset 12 in vtable
                        movq 96(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
                        jmp l206
.globl l203
l203:                   ## fp[0] holds case a (A)
                        ## a.method3(...)
                        pushq %r12
                        pushq %rbp
                        ## a.value(...)
                        pushq %r12
                        pushq %rbp
                        ## a
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l209
                        movq $string107, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l209
l209:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## a
                        movq 0(%rbp), %r13
                        cmpq $0, %r13
			jne l210
                        movq $string107, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l210
l210:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up method3() at offset 9 in vtable
                        movq 72(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
                        jmp l206
.globl l204
l204:                   ## fp[0] holds case o (Object)
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
                        ## string73 holds "Oooops\n"
                        movq $string73, %r14
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
                        ## abort(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up abort() at offset 2 in vtable
                        movq 16(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        ## new Int
                        pushq %rbp
                        pushq %r12
                        movq $Int..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        movq $0, %r14
                        movq %r14, 24(%r13)
                        jmp l206
.globl l206
l206:                   ## case expression ends
.globl l154
l154:                   ## end of if conditional
                        jmp l151
.globl l149
l149:                   ## true branch
                        ## new A.set_var(...)
                        pushq %r12
                        pushq %rbp
                        ## get_int(...)
                        pushq %r12
                        pushq %rbp
                        pushq %r12
                        ## obtain vtable for self object of type Main
                        movq 16(%r12), %r14
                        ## look up get_int() at offset 11 in vtable
                        movq 88(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new A
                        pushq %rbp
                        pushq %r12
                        movq $A..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l211
                        movq $string108, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l211
l211:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up set_var() at offset 6 in vtable
                        movq 48(%r14), %r14
                        call *%r14
                        addq $16, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 40(%r12)
                        ## new B.method2(...)
                        pushq %r12
                        pushq %rbp
                        ## avar.value(...)
                        pushq %r12
                        pushq %rbp
                        ## avar
                        movq 32(%r12), %r13
                        cmpq $0, %r13
			jne l212
                        movq $string109, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l212
l212:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## a_var.value(...)
                        pushq %r12
                        pushq %rbp
                        ## a_var
                        movq 40(%r12), %r13
                        cmpq $0, %r13
			jne l213
                        movq $string109, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l213
l213:                   pushq %r13
                        ## obtain vtable from object in r1 with static type A
                        movq 16(%r13), %r14
                        ## look up value() at offset 5 in vtable
                        movq 40(%r14), %r14
                        call *%r14
                        addq $8, %rsp
                        popq %rbp
                        popq %r12
                        pushq %r13
                        ## new B
                        pushq %rbp
                        pushq %r12
                        movq $B..new, %r14
                        call *%r14
                        popq %r12
                        popq %rbp
                        cmpq $0, %r13
			jne l214
                        movq $string109, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l214
l214:                   pushq %r13
                        ## obtain vtable from object in r1 with static type B
                        movq 16(%r13), %r14
                        ## look up method2() at offset 8 in vtable
                        movq 64(%r14), %r14
                        call *%r14
                        addq $24, %rsp
                        popq %rbp
                        popq %r12
                        movq %r13, 32(%r12)
.globl l151
l151:                   ## end of if conditional
                        jmp l143
.globl l144
l144:                   ## end of while loop
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
			jne l215
                        movq $string110, %r13
                        movq %r13, %rdi
			call cooloutstr
                        movl $0, %edi
			call exit
.globl l215
l215:                   movq %r13, 24(%r15)
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
string1:                # "A"
.byte  65 # 'A'
.byte 0

.globl string2
string2:                # "A2I"
.byte  65 # 'A'
.byte  50 # '2'
.byte  73 # 'I'
.byte 0

.globl string3
string3:                # "B"
.byte  66 # 'B'
.byte 0

.globl string4
string4:                # "Bool"
.byte  66 # 'B'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 108 # 'l'
.byte 0

.globl string5
string5:                # "C"
.byte  67 # 'C'
.byte 0

.globl string6
string6:                # "D"
.byte  68 # 'D'
.byte 0

.globl string7
string7:                # "E"
.byte  69 # 'E'
.byte 0

.globl string8
string8:                # "IO"
.byte  73 # 'I'
.byte  79 # 'O'
.byte 0

.globl string9
string9:                # "Int"
.byte  73 # 'I'
.byte 110 # 'n'
.byte 116 # 't'
.byte 0

.globl string10
string10:               # "Main"
.byte  77 # 'M'
.byte  97 # 'a'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 0

.globl string11
string11:               # "Object"
.byte  79 # 'O'
.byte  98 # 'b'
.byte 106 # 'j'
.byte 101 # 'e'
.byte  99 # 'c'
.byte 116 # 't'
.byte 0

.globl string12
string12:               # "String"
.byte  83 # 'S'
.byte 116 # 't'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 0

.globl string13
string13:               # "abort\\n"
.byte  97 # 'a'
.byte  98 # 'b'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 116 # 't'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string14
string14:               # "ERROR: 28: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
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

.globl string15
string15:               # "ERROR: 37: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  55 # '7'
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

.globl string16
string16:               # "ERROR: 54: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  53 # '5'
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

.globl string17
string17:               # "ERROR: 47: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  55 # '7'
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

.globl string18
string18:               # "ERROR: 71: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
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

.globl string19
string19:               # "0"
.byte  48 # '0'
.byte 0

.globl string20
string20:               # "1"
.byte  49 # '1'
.byte 0

.globl string21
string21:               # "2"
.byte  50 # '2'
.byte 0

.globl string22
string22:               # "3"
.byte  51 # '3'
.byte 0

.globl string23
string23:               # "4"
.byte  52 # '4'
.byte 0

.globl string24
string24:               # "5"
.byte  53 # '5'
.byte 0

.globl string25
string25:               # "6"
.byte  54 # '6'
.byte 0

.globl string26
string26:               # "7"
.byte  55 # '7'
.byte 0

.globl string27
string27:               # "8"
.byte  56 # '8'
.byte 0

.globl string28
string28:               # "9"
.byte  57 # '9'
.byte 0

.globl string29
string29:               # ""
.byte 0

.globl string30
string30:               # "ERROR: 200: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  48 # '0'
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

.globl string31
string31:               # "ERROR: 201: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  48 # '0'
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

.globl string32
string32:               # "-"
.byte  45 # '-'
.byte 0

.globl string33
string33:               # "ERROR: 202: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  48 # '0'
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

.globl string34
string34:               # "+"
.byte  43 # '+'
.byte 0

.globl string35
string35:               # "ERROR: 214: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  49 # '1'
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

.globl string36
string36:               # "ERROR: 218: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
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

.globl string37
string37:               # "ERROR: 235: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  51 # '3'
.byte  53 # '5'
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

.globl string38
string38:               # "ERROR: 243: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
.byte  52 # '4'
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

.globl string39
string39:               # "ERROR: 244: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  50 # '2'
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

.globl string40
string40:               # "ERROR: 84: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  56 # '8'
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

.globl string41
string41:               # "ERROR: 106: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  48 # '0'
.byte  54 # '6'
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

.globl string42
string42:               # "ERROR: 97: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  57 # '9'
.byte  55 # '7'
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

.globl string43
string43:               # "ERROR: 133: Exception: division by zero\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  51 # '3'
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

.globl string44
string44:               # "ERROR: 134: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  49 # '1'
.byte  51 # '3'
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

.globl string45
string45:               # "\\n\\tTo add a number to "
.byte  92 # '\\'
.byte 110 # 'n'
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte  97 # 'a'
.byte 100 # 'd'
.byte 100 # 'd'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte 0

.globl string46
string46:               # "...enter a:\\n"
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  97 # 'a'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string47
string47:               # "\\tTo negate "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 110 # 'n'
.byte 101 # 'e'
.byte 103 # 'g'
.byte  97 # 'a'
.byte 116 # 't'
.byte 101 # 'e'
.byte  32 # ' '
.byte 0

.globl string48
string48:               # "...enter b:\\n"
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  98 # 'b'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string49
string49:               # "\\tTo find the difference between "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 102 # 'f'
.byte 102 # 'f'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 101 # 'e'
.byte 110 # 'n'
.byte  99 # 'c'
.byte 101 # 'e'
.byte  32 # ' '
.byte  98 # 'b'
.byte 101 # 'e'
.byte 116 # 't'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 101 # 'e'
.byte 110 # 'n'
.byte  32 # ' '
.byte 0

.globl string50
string50:               # "and another number...enter c:\\n"
.byte  97 # 'a'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte  97 # 'a'
.byte 110 # 'n'
.byte 111 # 'o'
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  99 # 'c'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string51
string51:               # "\\tTo find the factorial of "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte  32 # ' '
.byte 102 # 'f'
.byte  97 # 'a'
.byte  99 # 'c'
.byte 116 # 't'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 105 # 'i'
.byte  97 # 'a'
.byte 108 # 'l'
.byte  32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte  32 # ' '
.byte 0

.globl string52
string52:               # "...enter d:\\n"
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 100 # 'd'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string53
string53:               # "\\tTo square "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 115 # 's'
.byte 113 # 'q'
.byte 117 # 'u'
.byte  97 # 'a'
.byte 114 # 'r'
.byte 101 # 'e'
.byte  32 # ' '
.byte 0

.globl string54
string54:               # "...enter e:\\n"
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 101 # 'e'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string55
string55:               # "\\tTo cube "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte  99 # 'c'
.byte 117 # 'u'
.byte  98 # 'b'
.byte 101 # 'e'
.byte  32 # ' '
.byte 0

.globl string56
string56:               # "...enter f:\\n"
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 102 # 'f'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string57
string57:               # "\\tTo find out if "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte  32 # ' '
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte  32 # ' '
.byte 105 # 'i'
.byte 102 # 'f'
.byte  32 # ' '
.byte 0

.globl string58
string58:               # "is a multiple of 3...enter g:\\n"
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 109 # 'm'
.byte 117 # 'u'
.byte 108 # 'l'
.byte 116 # 't'
.byte 105 # 'i'
.byte 112 # 'p'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte  32 # ' '
.byte  51 # '3'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 103 # 'g'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string59
string59:               # "\\tTo divide "
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 101 # 'e'
.byte  32 # ' '
.byte 0

.globl string60
string60:               # "by 8...enter h:\\n"
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte  56 # '8'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 104 # 'h'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string61
string61:               # "\\tTo get a new number...enter j:\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 103 # 'g'
.byte 101 # 'e'
.byte 116 # 't'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 110 # 'n'
.byte 101 # 'e'
.byte 119 # 'w'
.byte  32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 106 # 'j'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string62
string62:               # "\\tTo quit...enter q:\\n\\n"
.byte  92 # '\\'
.byte 116 # 't'
.byte  84 # 'T'
.byte 111 # 'o'
.byte  32 # ' '
.byte 113 # 'q'
.byte 117 # 'u'
.byte 105 # 'i'
.byte 116 # 't'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 113 # 'q'
.byte  58 # ':'
.byte  92 # '\\'
.byte 110 # 'n'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string63
string63:               # "\\n"
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string64
string64:               # "Please enter a number...  "
.byte  80 # 'P'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  46 # '.'
.byte  46 # '.'
.byte  46 # '.'
.byte  32 # ' '
.byte  32 # ' '
.byte 0

.globl string65
string65:               # "ERROR: 303: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
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

.globl string66
string66:               # "ERROR: 320: Exception: case without matching branch\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  50 # '2'
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
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 119 # 'w'
.byte 105 # 'i'
.byte 116 # 't'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte  32 # ' '
.byte 109 # 'm'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte  32 # ' '
.byte  98 # 'b'
.byte 114 # 'r'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string67
string67:               # "ERROR: 320: Exception: case on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  50 # '2'
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
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
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

.globl string68
string68:               # "Class type is now A\\n"
.byte  67 # 'C'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte  32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte  32 # ' '
.byte  65 # 'A'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string69
string69:               # "Class type is now B\\n"
.byte  67 # 'C'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte  32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte  32 # ' '
.byte  66 # 'B'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string70
string70:               # "Class type is now C\\n"
.byte  67 # 'C'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte  32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte  32 # ' '
.byte  67 # 'C'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string71
string71:               # "Class type is now D\\n"
.byte  67 # 'C'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte  32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte  32 # ' '
.byte  68 # 'D'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string72
string72:               # "Class type is now E\\n"
.byte  67 # 'C'
.byte 108 # 'l'
.byte  97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte  32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte  32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte  32 # ' '
.byte  69 # 'E'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string73
string73:               # "Oooops\\n"
.byte  79 # 'O'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 112 # 'p'
.byte 115 # 's'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string74
string74:               # "ERROR: 333: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  51 # '3'
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

.globl string75
string75:               # " "
.byte  32 # ' '
.byte 0

.globl string76
string76:               # "number "
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte  98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 0

.globl string77
string77:               # "ERROR: 347: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  52 # '4'
.byte  55 # '7'
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

.globl string78
string78:               # "is odd!\\n"
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 111 # 'o'
.byte 100 # 'd'
.byte 100 # 'd'
.byte  33 # '!'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string79
string79:               # "is even!\\n"
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 101 # 'e'
.byte 118 # 'v'
.byte 101 # 'e'
.byte 110 # 'n'
.byte  33 # '!'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string80
string80:               # "a"
.byte  97 # 'a'
.byte 0

.globl string81
string81:               # "b"
.byte  98 # 'b'
.byte 0

.globl string82
string82:               # "c"
.byte  99 # 'c'
.byte 0

.globl string83
string83:               # "d"
.byte 100 # 'd'
.byte 0

.globl string84
string84:               # "e"
.byte 101 # 'e'
.byte 0

.globl string85
string85:               # "f"
.byte 102 # 'f'
.byte 0

.globl string86
string86:               # "g"
.byte 103 # 'g'
.byte 0

.globl string87
string87:               # "h"
.byte 104 # 'h'
.byte 0

.globl string88
string88:               # "j"
.byte 106 # 'j'
.byte 0

.globl string89
string89:               # "q"
.byte 113 # 'q'
.byte 0

.globl string90
string90:               # "ERROR: 422: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  50 # '2'
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

.globl string91
string91:               # "ERROR: 398: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  57 # '9'
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

.globl string92
string92:               # "ERROR: 399: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  57 # '9'
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

.globl string93
string93:               # "is equal to "
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 101 # 'e'
.byte 113 # 'q'
.byte 117 # 'u'
.byte  97 # 'a'
.byte 108 # 'l'
.byte  32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte  32 # ' '
.byte 0

.globl string94
string94:               # "times 8 with a remainder of "
.byte 116 # 't'
.byte 105 # 'i'
.byte 109 # 'm'
.byte 101 # 'e'
.byte 115 # 's'
.byte  32 # ' '
.byte  56 # '8'
.byte  32 # ' '
.byte 119 # 'w'
.byte 105 # 'i'
.byte 116 # 't'
.byte 104 # 'h'
.byte  32 # ' '
.byte  97 # 'a'
.byte  32 # ' '
.byte 114 # 'r'
.byte 101 # 'e'
.byte 109 # 'm'
.byte  97 # 'a'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 101 # 'e'
.byte 114 # 'r'
.byte  32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte  32 # ' '
.byte 0

.globl string95
string95:               # "ERROR: 408: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  52 # '4'
.byte  48 # '0'
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

.globl string96
string96:               # "ERROR: 381: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  56 # '8'
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

.globl string97
string97:               # "is not divisible by 3.\\n"
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 116 # 't'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte  98 # 'b'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte  51 # '3'
.byte  46 # '.'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string98
string98:               # "is divisible by 3.\\n"
.byte 105 # 'i'
.byte 115 # 's'
.byte  32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte  98 # 'b'
.byte 108 # 'l'
.byte 101 # 'e'
.byte  32 # ' '
.byte  98 # 'b'
.byte 121 # 'y'
.byte  32 # ' '
.byte  51 # '3'
.byte  46 # '.'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string99
string99:               # "ERROR: 378: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  55 # '7'
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

.globl string100
string100:              # "ERROR: 376: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  55 # '7'
.byte  54 # '6'
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

.globl string101
string101:              # "ERROR: 374: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  55 # '7'
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

.globl string102
string102:              # "ERROR: 371: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
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

.globl string103
string103:              # "ERROR: 372: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
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

.globl string104
string104:              # "ERROR: 361: Exception: case without matching branch\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  54 # '6'
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
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte  32 # ' '
.byte 119 # 'w'
.byte 105 # 'i'
.byte 116 # 't'
.byte 104 # 'h'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte  32 # ' '
.byte 109 # 'm'
.byte  97 # 'a'
.byte 116 # 't'
.byte  99 # 'c'
.byte 104 # 'h'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte  32 # ' '
.byte  98 # 'b'
.byte 114 # 'r'
.byte  97 # 'a'
.byte 110 # 'n'
.byte  99 # 'c'
.byte 104 # 'h'
.byte  92 # '\\'
.byte 110 # 'n'
.byte 0

.globl string105
string105:              # "ERROR: 361: Exception: case on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  54 # '6'
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
.byte  99 # 'c'
.byte  97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
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

.globl string106
string106:              # "ERROR: 362: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  54 # '6'
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

.globl string107
string107:              # "ERROR: 363: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  54 # '6'
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

.globl string108
string108:              # "ERROR: 357: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  53 # '5'
.byte  55 # '7'
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

.globl string109
string109:              # "ERROR: 358: Exception: dispatch on void\\n"
.byte  69 # 'E'
.byte  82 # 'R'
.byte  82 # 'R'
.byte  79 # 'O'
.byte  82 # 'R'
.byte  58 # ':'
.byte  32 # ' '
.byte  51 # '3'
.byte  53 # '5'
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

.globl string110
string110:              # "ERROR: 0: Exception: String.substr out of range\\n"
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

