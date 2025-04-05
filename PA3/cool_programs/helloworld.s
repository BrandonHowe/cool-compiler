## vtable definitions
.globl A..vtable
A..vtable:
.quad A_name
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
.globl A2I..vtable
A2I..vtable:
.quad A2I_name
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
.globl B..vtable
B..vtable:
.quad B_name
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
.globl Bool..vtable
Bool..vtable:
.quad Bool_name
.quad Bool..new
.quad Object.abort
.quad Object.copy
.quad Object.type_name
.globl C..vtable
C..vtable:
.quad C_name
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
.globl D..vtable
D..vtable:
.quad D_name
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
.globl E..vtable
E..vtable:
.quad E_name
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
.globl IO..vtable
IO..vtable:
.quad IO_name
.quad IO..new
.quad Object.abort
.quad Object.copy
.quad Object.type_name
.quad IO.in_int
.quad IO.in_string
.quad IO.out_int
.quad IO.out_string
.globl Int..vtable
Int..vtable:
.quad Int_name
.quad Int..new
.quad Object.abort
.quad Object.copy
.quad Object.type_name
.globl Main..vtable
Main..vtable:
.quad Main_name
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
.globl Object..vtable
Object..vtable:
.quad Object_name
.quad Object..new
.quad Object.abort
.quad Object.copy
.quad Object.type_name
.globl String..vtable
String..vtable:
.quad String_name
.quad String..new
.quad Object.abort
.quad Object.copy
.quad Object.type_name
.quad String.concat
.quad String.length
.quad String.substr
.globl A..new
A..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $0, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $A..vtable, %r14
movq %r14, 16(%r12)
## define attributes
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## initialize attributes
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl A2I..new
A2I..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $3, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $1, %r14
movq %r14, 0(%r12)
## store object size
movq $3, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $A2I..vtable, %r14
movq %r14, 16(%r12)
## define attributes
## initialize attributes
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl B..new
B..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $2, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $B..vtable, %r14
movq %r14, 16(%r12)
## define attributes
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## initialize attributes
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl Bool..new
Bool..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $-1, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $Bool..vtable, %r14
movq %r14, 16(%r12)
## define built-in attributes
movq $0, %r13
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl C..new
C..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $4, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $C..vtable, %r14
movq %r14, 16(%r12)
## define attributes
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## initialize attributes
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl D..new
D..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $5, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $D..vtable, %r14
movq %r14, 16(%r12)
## define attributes
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## initialize attributes
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl E..new
E..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $6, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $E..vtable, %r14
movq %r14, 16(%r12)
## define attributes
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## initialize attributes
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl IO..new
IO..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $3, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $7, %r14
movq %r14, 0(%r12)
## store object size
movq $3, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $IO..vtable, %r14
movq %r14, 16(%r12)
## define attributes
## initialize attributes
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl Int..new
Int..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $-2, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $Int..vtable, %r14
movq %r14, 16(%r12)
## define built-in attributes
movq $0, %r13
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl Main..new
Main..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $7, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $9, %r14
movq %r14, 0(%r12)
## store object size
movq $7, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $Main..vtable, %r14
movq %r14, 16(%r12)
## define attributes
movq $0, %r13
movq %r13, 24(%r12)
movq $0, %r13
movq %r13, 32(%r12)
movq $0, %r13
movq %r13, 40(%r12)
movq $0, %r13
movq %r13, 48(%r12)
## initialize attributes
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 24(%r12)
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
movq %r13, 48(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl Object..new
Object..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $3, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $10, %r14
movq %r14, 0(%r12)
## store object size
movq $3, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $Object..vtable, %r14
movq %r14, 16(%r12)
## define attributes
## initialize attributes
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl String..new
String..new:
pushq %rbp
movq %rsp, %rbp
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
movq $4, %r12
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r12, %rdi
call calloc
movq %rax, %r12
## store class tag
movq $-3, %r14
movq %r14, 0(%r12)
## store object size
movq $4, %r14
movq %r14, 8(%r12)
## store vtable pointer
movq $String..vtable, %r14
movq %r14, 16(%r12)
## define built-in attributes
movq $the_empty_string, %r13
movq %r13, 24(%r12)
## return from constructor
movq %r12, %r13
movq %rbp, %rsp
popq %rbp
ret
.globl A.value
A.value:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 24(%r12), %r13
movq %r13, 0(%rbp)
.globl A.value.end
A.value.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.set_var
A.set_var:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r13
movq %r13, 24(%r12)
movq 24(%r12), %r13
movq %r13, -8(%rbp)
movq %r12, %r13
movq %r13, 0(%rbp)
.globl A.set_var.end
A.set_var.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method1
A.method1:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq %r12, %r13
movq %r13, 0(%rbp)
.globl A.method1.end
A.method1.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method2
A.method2:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $64, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 32(%rbp), %r13
movq %r13, -24(%rbp)
movq 24(%rbp), %r13
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
addq %r14, %r13
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -48(%rbp)
cmpq $0, %r13
 jne l1
movq $error1, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l1
l1:
movq -40(%rbp), %r13
pushq %r13
movq -48(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl A.method2.end
A.method2.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method3
A.method3:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $48, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 24(%rbp), %r13
movq %r13, -24(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -24(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -32(%rbp)
pushq %rbp
pushq %r12
movq $C..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -40(%rbp)
cmpq $0, %r13
 jne l2
movq $error2, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l2
l2:
movq -32(%rbp), %r13
pushq %r13
movq -40(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl A.method3.end
A.method3.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method4
A.method4:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $144, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -16(%rbp)
movq 32(%rbp), %r13
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call lt_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A_method4_1
## else branch
.globl A_method4_0
A_method4_0:
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -40(%rbp)
movq 24(%rbp), %r13
movq %r13, -56(%rbp)
movq 32(%rbp), %r13
movq %r13, -64(%rbp)
movq -56(%rbp), %r13
movq -64(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -40(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -40(%rbp)
movq -40(%rbp), %r13
movq %r13, -48(%rbp)
pushq %r12
pushq %rbp
movq -40(%rbp), %r13
movq %r13, -72(%rbp)
pushq %rbp
pushq %r12
movq $D..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -80(%rbp)
cmpq $0, %r13
 jne l3
movq $error3, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l3
l3:
movq -72(%rbp), %r13
pushq %r13
movq -80(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A_method4_2
## then branch
.globl A_method4_1
A_method4_1:
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -88(%rbp)
movq 32(%rbp), %r13
movq %r13, -104(%rbp)
movq 24(%rbp), %r13
movq %r13, -112(%rbp)
movq -104(%rbp), %r13
movq -112(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -88(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -88(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -88(%rbp), %r13
movq %r13, -96(%rbp)
pushq %r12
pushq %rbp
movq -88(%rbp), %r13
movq %r13, -120(%rbp)
pushq %rbp
pushq %r12
movq $D..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -128(%rbp)
cmpq $0, %r13
 jne l4
movq $error4, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l4
l4:
movq -120(%rbp), %r13
pushq %r13
movq -128(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A_method4_2
## if-join
.globl A_method4_2
A_method4_2:
.globl A.method4.end
A.method4.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A.method5
A.method5:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $128, %r14
subq %r14, %rsp
## method body begins
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
## while-pred
.globl A_method5_0
A_method5_0:
pushq %r12
pushq %rbp
movq -24(%rbp), %r13
movq %r13, -40(%rbp)
movq 24(%rbp), %r13
movq %r13, -48(%rbp)
movq -40(%rbp), %r13
movq -48(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call le_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -32(%rbp)
movq -32(%rbp), %r13
movq 24(%r13), %r13
cmpq $0, %r13
 jne l5
.globl l6
l6:
## false branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
jmp l7
.globl l5
l5:
## true branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
.globl l7
l7:
movq %r13, -16(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A_method5_1
## while-body
movq -8(%rbp), %r13
movq %r13, -72(%rbp)
movq -24(%rbp), %r13
movq %r13, -80(%rbp)
movq -72(%rbp), %r13
movq -80(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -64(%rbp)
movq -24(%rbp), %r13
movq %r13, -88(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -96(%rbp)
movq -88(%rbp), %r13
movq -96(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
addq %r14, %r13
movq %r13, -24(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -24(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -24(%rbp), %r13
movq %r13, -56(%rbp)
jmp A_method5_0
## while-join
.globl A_method5_1
A_method5_1:
## default constructor
pushq %rbp
pushq %r12
movq $Object..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -104(%rbp)
pushq %rbp
pushq %r12
movq $E..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -112(%rbp)
cmpq $0, %r13
 jne l8
movq $error5, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l8
l8:
movq -104(%rbp), %r13
pushq %r13
movq -112(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl A.method5.end
A.method5.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.c2i
A2I.c2i:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $336, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -16(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_1
## else branch
.globl A2I_c2i_0
A2I_c2i_0:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -48(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string1, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -48(%rbp), %r13
movq -56(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -40(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_4
## else branch
.globl A2I_c2i_3
A2I_c2i_3:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -80(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string2, %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -80(%rbp), %r13
movq -88(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -72(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_7
## else branch
.globl A2I_c2i_6
A2I_c2i_6:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -112(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string3, %r14
movq %r14, 24(%r13)
movq %r13, -120(%rbp)
movq -112(%rbp), %r13
movq -120(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -104(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_10
## else branch
.globl A2I_c2i_9
A2I_c2i_9:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -144(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string4, %r14
movq %r14, 24(%r13)
movq %r13, -152(%rbp)
movq -144(%rbp), %r13
movq -152(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -136(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_13
## else branch
.globl A2I_c2i_12
A2I_c2i_12:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -176(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string5, %r14
movq %r14, 24(%r13)
movq %r13, -184(%rbp)
movq -176(%rbp), %r13
movq -184(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -168(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_16
## else branch
.globl A2I_c2i_15
A2I_c2i_15:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -208(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string6, %r14
movq %r14, 24(%r13)
movq %r13, -216(%rbp)
movq -208(%rbp), %r13
movq -216(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -200(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_19
## else branch
.globl A2I_c2i_18
A2I_c2i_18:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -240(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string7, %r14
movq %r14, 24(%r13)
movq %r13, -248(%rbp)
movq -240(%rbp), %r13
movq -248(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -232(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_22
## else branch
.globl A2I_c2i_21
A2I_c2i_21:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -272(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string8, %r14
movq %r14, 24(%r13)
movq %r13, -280(%rbp)
movq -272(%rbp), %r13
movq -280(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -264(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_25
## else branch
.globl A2I_c2i_24
A2I_c2i_24:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -304(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string9, %r14
movq %r14, 24(%r13)
movq %r13, -312(%rbp)
movq -304(%rbp), %r13
movq -312(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -296(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_c2i_28
## else branch
.globl A2I_c2i_27
A2I_c2i_27:
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 16(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -328(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_29
## then branch
.globl A2I_c2i_28
A2I_c2i_28:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $9, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_29
## if-join
.globl A2I_c2i_29
A2I_c2i_29:
jmp A2I_c2i_26
## then branch
.globl A2I_c2i_25
A2I_c2i_25:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $8, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_26
## if-join
.globl A2I_c2i_26
A2I_c2i_26:
jmp A2I_c2i_23
## then branch
.globl A2I_c2i_22
A2I_c2i_22:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $7, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_23
## if-join
.globl A2I_c2i_23
A2I_c2i_23:
jmp A2I_c2i_20
## then branch
.globl A2I_c2i_19
A2I_c2i_19:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $6, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_20
## if-join
.globl A2I_c2i_20
A2I_c2i_20:
jmp A2I_c2i_17
## then branch
.globl A2I_c2i_16
A2I_c2i_16:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $5, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_17
## if-join
.globl A2I_c2i_17
A2I_c2i_17:
jmp A2I_c2i_14
## then branch
.globl A2I_c2i_13
A2I_c2i_13:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $4, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_14
## if-join
.globl A2I_c2i_14
A2I_c2i_14:
jmp A2I_c2i_11
## then branch
.globl A2I_c2i_10
A2I_c2i_10:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $3, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_11
## if-join
.globl A2I_c2i_11
A2I_c2i_11:
jmp A2I_c2i_8
## then branch
.globl A2I_c2i_7
A2I_c2i_7:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $2, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_8
## if-join
.globl A2I_c2i_8
A2I_c2i_8:
jmp A2I_c2i_5
## then branch
.globl A2I_c2i_4
A2I_c2i_4:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_5
## if-join
.globl A2I_c2i_5
A2I_c2i_5:
jmp A2I_c2i_2
## then branch
.globl A2I_c2i_1
A2I_c2i_1:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_c2i_2
## if-join
.globl A2I_c2i_2
A2I_c2i_2:
.globl A2I.c2i.end
A2I.c2i.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2c
A2I.i2c:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $336, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -16(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_1
## else branch
.globl A2I_i2c_0
A2I_i2c_0:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -48(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -48(%rbp), %r13
movq -56(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -40(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_4
## else branch
.globl A2I_i2c_3
A2I_i2c_3:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -80(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $2, %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -80(%rbp), %r13
movq -88(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -72(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_7
## else branch
.globl A2I_i2c_6
A2I_i2c_6:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -112(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $3, %r14
movq %r14, 24(%r13)
movq %r13, -120(%rbp)
movq -112(%rbp), %r13
movq -120(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -104(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_10
## else branch
.globl A2I_i2c_9
A2I_i2c_9:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -144(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $4, %r14
movq %r14, 24(%r13)
movq %r13, -152(%rbp)
movq -144(%rbp), %r13
movq -152(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -136(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_13
## else branch
.globl A2I_i2c_12
A2I_i2c_12:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -176(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $5, %r14
movq %r14, 24(%r13)
movq %r13, -184(%rbp)
movq -176(%rbp), %r13
movq -184(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -168(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_16
## else branch
.globl A2I_i2c_15
A2I_i2c_15:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -208(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $6, %r14
movq %r14, 24(%r13)
movq %r13, -216(%rbp)
movq -208(%rbp), %r13
movq -216(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -200(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_19
## else branch
.globl A2I_i2c_18
A2I_i2c_18:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -240(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $7, %r14
movq %r14, 24(%r13)
movq %r13, -248(%rbp)
movq -240(%rbp), %r13
movq -248(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -232(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_22
## else branch
.globl A2I_i2c_21
A2I_i2c_21:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -272(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $8, %r14
movq %r14, 24(%r13)
movq %r13, -280(%rbp)
movq -272(%rbp), %r13
movq -280(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -264(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_25
## else branch
.globl A2I_i2c_24
A2I_i2c_24:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -304(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $9, %r14
movq %r14, 24(%r13)
movq %r13, -312(%rbp)
movq -304(%rbp), %r13
movq -312(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -296(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2c_28
## else branch
.globl A2I_i2c_27
A2I_i2c_27:
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 16(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -328(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string10, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_29
## then branch
.globl A2I_i2c_28
A2I_i2c_28:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string11, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_29
## if-join
.globl A2I_i2c_29
A2I_i2c_29:
jmp A2I_i2c_26
## then branch
.globl A2I_i2c_25
A2I_i2c_25:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string12, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_26
## if-join
.globl A2I_i2c_26
A2I_i2c_26:
jmp A2I_i2c_23
## then branch
.globl A2I_i2c_22
A2I_i2c_22:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string13, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_23
## if-join
.globl A2I_i2c_23
A2I_i2c_23:
jmp A2I_i2c_20
## then branch
.globl A2I_i2c_19
A2I_i2c_19:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string14, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_20
## if-join
.globl A2I_i2c_20
A2I_i2c_20:
jmp A2I_i2c_17
## then branch
.globl A2I_i2c_16
A2I_i2c_16:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string15, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_17
## if-join
.globl A2I_i2c_17
A2I_i2c_17:
jmp A2I_i2c_14
## then branch
.globl A2I_i2c_13
A2I_i2c_13:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string16, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_14
## if-join
.globl A2I_i2c_14
A2I_i2c_14:
jmp A2I_i2c_11
## then branch
.globl A2I_i2c_10
A2I_i2c_10:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string17, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_11
## if-join
.globl A2I_i2c_11
A2I_i2c_11:
jmp A2I_i2c_8
## then branch
.globl A2I_i2c_7
A2I_i2c_7:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string18, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_8
## if-join
.globl A2I_i2c_8
A2I_i2c_8:
jmp A2I_i2c_5
## then branch
.globl A2I_i2c_4
A2I_i2c_4:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string19, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_5
## if-join
.globl A2I_i2c_5
A2I_i2c_5:
jmp A2I_i2c_2
## then branch
.globl A2I_i2c_1
A2I_i2c_1:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string20, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2c_2
## if-join
.globl A2I_i2c_2
A2I_i2c_2:
.globl A2I.i2c.end
A2I.i2c.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.a2i
A2I.a2i:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $288, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -32(%rbp)
cmpq $0, %r13
 jne l9
movq $error6, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l9
l9:
movq -32(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -16(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_a2i_1
## else branch
.globl A2I_a2i_0
A2I_a2i_0:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -72(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -80(%rbp)
movq 24(%rbp), %r13
movq %r13, -88(%rbp)
cmpq $0, %r13
 jne l10
movq $error7, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l10
l10:
movq -72(%rbp), %r13
pushq %r13
movq -80(%rbp), %r13
pushq %r13
movq -88(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -56(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string21, %r14
movq %r14, 24(%r13)
movq %r13, -64(%rbp)
movq -56(%rbp), %r13
movq -64(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -48(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_a2i_4
## else branch
.globl A2I_a2i_3
A2I_a2i_3:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -128(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -136(%rbp)
movq 24(%rbp), %r13
movq %r13, -144(%rbp)
cmpq $0, %r13
 jne l11
movq $error8, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l11
l11:
movq -128(%rbp), %r13
pushq %r13
movq -136(%rbp), %r13
pushq %r13
movq -144(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -112(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string22, %r14
movq %r14, 24(%r13)
movq %r13, -120(%rbp)
movq -112(%rbp), %r13
movq -120(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -104(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_a2i_7
## else branch
.globl A2I_a2i_6
A2I_a2i_6:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -160(%rbp)
movq -160(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A2I_a2i_8
## then branch
.globl A2I_a2i_7
A2I_a2i_7:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -176(%rbp)
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -208(%rbp)
cmpq $0, %r13
 jne l12
movq $error9, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l12
l12:
movq -208(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -192(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -200(%rbp)
movq -192(%rbp), %r13
movq -200(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -184(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -184(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -184(%rbp)
movq 24(%rbp), %r13
movq %r13, -216(%rbp)
cmpq $0, %r13
 jne l13
movq $error10, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l13
l13:
movq -176(%rbp), %r13
pushq %r13
movq -184(%rbp), %r13
pushq %r13
movq -216(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -168(%rbp)
movq -168(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A2I_a2i_8
## if-join
.globl A2I_a2i_8
A2I_a2i_8:
jmp A2I_a2i_5
## then branch
.globl A2I_a2i_4
A2I_a2i_4:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -240(%rbp)
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -272(%rbp)
cmpq $0, %r13
 jne l14
movq $error11, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l14
l14:
movq -272(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -256(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -264(%rbp)
movq -256(%rbp), %r13
movq -264(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -248(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -248(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -248(%rbp)
movq 24(%rbp), %r13
movq %r13, -280(%rbp)
cmpq $0, %r13
 jne l15
movq $error12, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l15
l15:
movq -240(%rbp), %r13
pushq %r13
movq -248(%rbp), %r13
pushq %r13
movq -280(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -232(%rbp)
movq -232(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -224(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -224(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_a2i_5
## if-join
.globl A2I_a2i_5
A2I_a2i_5:
jmp A2I_a2i_2
## then branch
.globl A2I_a2i_1
A2I_a2i_1:
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_a2i_2
## if-join
.globl A2I_a2i_2
A2I_a2i_2:
.globl A2I.a2i.end
A2I.a2i.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.a2i_aux
A2I.a2i_aux:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $176, %r14
subq %r14, %rsp
## method body begins
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -32(%rbp)
cmpq $0, %r13
 jne l16
movq $error13, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l16
l16:
movq -32(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -40(%rbp)
## while-pred
.globl A2I_a2i_aux_0
A2I_a2i_aux_0:
pushq %r12
pushq %rbp
movq -40(%rbp), %r13
movq %r13, -56(%rbp)
movq -24(%rbp), %r13
movq %r13, -64(%rbp)
movq -56(%rbp), %r13
movq -64(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call lt_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -48(%rbp)
movq -48(%rbp), %r13
movq 24(%r13), %r13
cmpq $0, %r13
 jne l17
.globl l18
l18:
## false branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
jmp l19
.globl l17
l17:
## true branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
.globl l19
l19:
movq %r13, -16(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_a2i_aux_1
## while-body
movq -8(%rbp), %r13
movq %r13, -104(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $10, %r14
movq %r14, 24(%r13)
movq %r13, -112(%rbp)
movq -104(%rbp), %r13
movq -112(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -88(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -88(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq -40(%rbp), %r13
movq %r13, -128(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -136(%rbp)
movq 24(%rbp), %r13
movq %r13, -144(%rbp)
cmpq $0, %r13
 jne l20
movq $error14, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l20
l20:
movq -128(%rbp), %r13
pushq %r13
movq -136(%rbp), %r13
pushq %r13
movq -144(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -120(%rbp)
movq -120(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 40(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -96(%rbp)
movq -88(%rbp), %r13
movq -96(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
addq %r14, %r13
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -80(%rbp)
movq -40(%rbp), %r13
movq %r13, -152(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -160(%rbp)
movq -152(%rbp), %r13
movq -160(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
addq %r14, %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -40(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -40(%rbp)
movq -40(%rbp), %r13
movq %r13, -72(%rbp)
jmp A2I_a2i_aux_0
## while-join
.globl A2I_a2i_aux_1
A2I_a2i_aux_1:
## default constructor
pushq %rbp
pushq %r12
movq $Object..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -16(%rbp)
movq -8(%rbp), %r13
movq %r13, 0(%rbp)
.globl A2I.a2i_aux.end
A2I.a2i_aux.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2a
A2I.i2a:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $128, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -16(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2a_1
## else branch
.globl A2I_i2a_0
A2I_i2a_0:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -48(%rbp)
movq 24(%rbp), %r13
movq %r13, -56(%rbp)
movq -48(%rbp), %r13
movq -56(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call lt_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -40(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2a_4
## else branch
.globl A2I_i2a_3
A2I_i2a_3:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -88(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -104(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -104(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, -96(%rbp)
movq -88(%rbp), %r13
movq -96(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -80(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -80(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -80(%rbp)
movq -80(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 80(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -72(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string23, %r14
movq %r14, 24(%r13)
movq %r13, -112(%rbp)
cmpq $0, %r13
 jne l21
movq $error15, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l21
l21:
movq -72(%rbp), %r13
pushq %r13
movq -112(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A2I_i2a_5
## then branch
.globl A2I_i2a_4
A2I_i2a_4:
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -120(%rbp)
movq -120(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 80(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A2I_i2a_5
## if-join
.globl A2I_i2a_5
A2I_i2a_5:
jmp A2I_i2a_2
## then branch
.globl A2I_i2a_1
A2I_i2a_1:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string24, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2a_2
## if-join
.globl A2I_i2a_2
A2I_i2a_2:
.globl A2I.i2a.end
A2I.i2a.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl A2I.i2a_aux
A2I.i2a_aux:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $128, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -16(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq -16(%rbp), %r13
movq -24(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne A2I_i2a_aux_1
## else branch
.globl A2I_i2a_aux_0
A2I_i2a_aux_0:
movq 24(%rbp), %r13
movq %r13, -48(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $10, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -48(%rbp), %r13
movq -56(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq $0, %rdx
movq %r13, %rax
cdq
idivl %r14d
movq %rax, %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -40(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -40(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -80(%rbp)
movq -40(%rbp), %r13
movq %r13, -96(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $10, %r14
movq %r14, 24(%r13)
movq %r13, -104(%rbp)
movq -96(%rbp), %r13
movq -104(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -88(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -88(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -80(%rbp), %r13
movq -88(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -72(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -72(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -72(%rbp)
movq -72(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -64(%rbp)
pushq %r12
pushq %rbp
movq -40(%rbp), %r13
movq %r13, -120(%rbp)
movq -120(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 80(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -112(%rbp)
cmpq $0, %r13
 jne l22
movq $error16, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l22
l22:
movq -64(%rbp), %r13
pushq %r13
movq -112(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp A2I_i2a_aux_2
## then branch
.globl A2I_i2a_aux_1
A2I_i2a_aux_1:
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string25, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp A2I_i2a_aux_2
## if-join
.globl A2I_i2a_aux_2
A2I_i2a_aux_2:
.globl A2I.i2a_aux.end
A2I.i2a_aux.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl B.method5
B.method5:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $64, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 24(%rbp), %r13
movq %r13, -24(%rbp)
movq 24(%rbp), %r13
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $E..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -48(%rbp)
cmpq $0, %r13
 jne l23
movq $error17, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l23
l23:
movq -40(%rbp), %r13
pushq %r13
movq -48(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl B.method5.end
B.method5.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl C.method5
C.method5:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $80, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 24(%rbp), %r13
movq %r13, -40(%rbp)
movq 24(%rbp), %r13
movq %r13, -48(%rbp)
movq -40(%rbp), %r13
movq -48(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -24(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -24(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
movq 24(%rbp), %r13
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -56(%rbp)
pushq %rbp
pushq %r12
movq $E..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -64(%rbp)
cmpq $0, %r13
 jne l24
movq $error18, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l24
l24:
movq -56(%rbp), %r13
pushq %r13
movq -64(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl C.method5.end
C.method5.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl C.method6
C.method6:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $48, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 24(%rbp), %r13
movq %r13, -24(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -24(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -32(%rbp)
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -40(%rbp)
cmpq $0, %r13
 jne l25
movq $error19, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l25
l25:
movq -32(%rbp), %r13
pushq %r13
movq -40(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl C.method6.end
C.method6.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl D.method7
D.method7:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $192, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r13
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -24(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call lt_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -16(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne D_method7_1
## else branch
.globl D_method7_0
D_method7_0:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -8(%rbp), %r13
movq %r13, -64(%rbp)
movq -56(%rbp), %r13
movq -64(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -48(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne D_method7_4
## else branch
.globl D_method7_3
D_method7_3:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -8(%rbp), %r13
movq %r13, -96(%rbp)
movq -88(%rbp), %r13
movq -96(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -80(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne D_method7_7
## else branch
.globl D_method7_6
D_method7_6:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $2, %r14
movq %r14, 24(%r13)
movq %r13, -120(%rbp)
movq -8(%rbp), %r13
movq %r13, -128(%rbp)
movq -120(%rbp), %r13
movq -128(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -112(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne D_method7_10
## else branch
.globl D_method7_9
D_method7_9:
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -152(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $3, %r14
movq %r14, 24(%r13)
movq %r13, -160(%rbp)
movq -152(%rbp), %r13
movq -160(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -144(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -144(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -144(%rbp)
movq -144(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp D_method7_11
## then branch
.globl D_method7_10
D_method7_10:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 0(%rbp)
jmp D_method7_11
## if-join
.globl D_method7_11
D_method7_11:
jmp D_method7_8
## then branch
.globl D_method7_7
D_method7_7:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 0(%rbp)
jmp D_method7_8
## if-join
.globl D_method7_8
D_method7_8:
jmp D_method7_5
## then branch
.globl D_method7_4
D_method7_4:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp D_method7_5
## if-join
.globl D_method7_5
D_method7_5:
jmp D_method7_2
## then branch
.globl D_method7_1
D_method7_1:
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -176(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -176(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, -168(%rbp)
movq -168(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp D_method7_2
## if-join
.globl D_method7_2
D_method7_2:
.globl D.method7.end
D.method7.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl E.method6
E.method6:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $64, %r14
subq %r14, %rsp
## method body begins
## default constructor
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
movq 24(%rbp), %r13
movq %r13, -24(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $8, %r14
movq %r14, 24(%r13)
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq $0, %rdx
movq %r13, %rax
cdq
idivl %r14d
movq %rax, %r13
movq %r13, -8(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -8(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -8(%rbp)
movq -8(%rbp), %r13
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -40(%rbp)
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -48(%rbp)
cmpq $0, %r13
 jne l26
movq $error20, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l26
l26:
movq -40(%rbp), %r13
pushq %r13
movq -48(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl E.method6.end
E.method6.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_int
IO.in_int:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, %r14
 movl $1, %esi
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
IO.in_int.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.in_string
IO.in_string:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, %r14
andq $-16, %rsp
 call coolgetstr
mov %rax, %r13
movq %r13, 24(%r14)
movq %r14, %r13
.globl IO.in_string.end
IO.in_string.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_int
IO.out_int:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r14
movq 24(%r14), %r13
andq $-16, %rsp
 ## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $percent.d, %rdi
movl %r13d, %eax
cdqe
movq %rax, %rsi
movl $0, %eax
call printf
movq %r12, %r13
.globl IO.out_int.end
IO.out_int.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl IO.out_string
IO.out_string:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r14
movq 24(%r14), %r13
andq $-16, %rsp
 movq %r13, %rdi
call cooloutstr
movq %r12, %r13
.globl IO.out_string.end
IO.out_string.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.menu
Main.menu:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $432, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string26, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -32(%rbp)
movq -32(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string27, %r14
movq %r14, 24(%r13)
movq %r13, -48(%rbp)
movq -48(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -40(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string28, %r14
movq %r14, 24(%r13)
movq %r13, -64(%rbp)
movq -64(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -56(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -80(%rbp)
movq -80(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -72(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string29, %r14
movq %r14, 24(%r13)
movq %r13, -96(%rbp)
movq -96(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -88(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string30, %r14
movq %r14, 24(%r13)
movq %r13, -112(%rbp)
movq -112(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -104(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -128(%rbp)
movq -128(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -120(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string31, %r14
movq %r14, 24(%r13)
movq %r13, -144(%rbp)
movq -144(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -136(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string32, %r14
movq %r14, 24(%r13)
movq %r13, -160(%rbp)
movq -160(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -152(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -176(%rbp)
movq -176(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -168(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string33, %r14
movq %r14, 24(%r13)
movq %r13, -192(%rbp)
movq -192(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -184(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string34, %r14
movq %r14, 24(%r13)
movq %r13, -208(%rbp)
movq -208(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -200(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -224(%rbp)
movq -224(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -216(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string35, %r14
movq %r14, 24(%r13)
movq %r13, -240(%rbp)
movq -240(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -232(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string36, %r14
movq %r14, 24(%r13)
movq %r13, -256(%rbp)
movq -256(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -248(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -272(%rbp)
movq -272(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -264(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string37, %r14
movq %r14, 24(%r13)
movq %r13, -288(%rbp)
movq -288(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -280(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string38, %r14
movq %r14, 24(%r13)
movq %r13, -304(%rbp)
movq -304(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -296(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -320(%rbp)
movq -320(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -312(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string39, %r14
movq %r14, 24(%r13)
movq %r13, -336(%rbp)
movq -336(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -328(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string40, %r14
movq %r14, 24(%r13)
movq %r13, -352(%rbp)
movq -352(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -344(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -368(%rbp)
movq -368(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -360(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string41, %r14
movq %r14, 24(%r13)
movq %r13, -384(%rbp)
movq -384(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -376(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string42, %r14
movq %r14, 24(%r13)
movq %r13, -400(%rbp)
movq -400(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -392(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string43, %r14
movq %r14, 24(%r13)
movq %r13, -416(%rbp)
movq -416(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -408(%rbp)
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl Main.menu.end
Main.menu.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.prompt
Main.prompt:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $48, %r14
subq %r14, %rsp
## method body begins
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string44, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string45, %r14
movq %r14, 24(%r13)
movq %r13, -32(%rbp)
movq -32(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 48(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl Main.prompt.end
Main.prompt.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.get_int
Main.get_int:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $48, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $A2I..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 80(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
movq -16(%rbp), %r13
movq %r13, -24(%rbp)
movq -8(%rbp), %r13
movq %r13, -32(%rbp)
cmpq $0, %r13
 jne l27
movq $error21, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l27
l27:
movq -24(%rbp), %r13
pushq %r13
movq -32(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl Main.get_int.end
Main.get_int.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.is_even
Main.is_even:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $160, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r13
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -24(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -32(%rbp)
movq -24(%rbp), %r13
movq -32(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call lt_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -16(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_is_even_1
## else branch
.globl Main_is_even_0
Main_is_even_0:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -8(%rbp), %r13
movq %r13, -64(%rbp)
movq -56(%rbp), %r13
movq -64(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -48(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_is_even_4
## else branch
.globl Main_is_even_3
Main_is_even_3:
pushq %r12
pushq %rbp
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, -88(%rbp)
movq -8(%rbp), %r13
movq %r13, -96(%rbp)
movq -88(%rbp), %r13
movq -96(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -80(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_is_even_7
## else branch
.globl Main_is_even_6
Main_is_even_6:
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -120(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $2, %r14
movq %r14, 24(%r13)
movq %r13, -128(%rbp)
movq -120(%rbp), %r13
movq -128(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -112(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -112(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -112(%rbp)
movq -112(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp Main_is_even_8
## then branch
.globl Main_is_even_7
Main_is_even_7:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 0(%rbp)
jmp Main_is_even_8
## if-join
.globl Main_is_even_8
Main_is_even_8:
jmp Main_is_even_5
## then branch
.globl Main_is_even_4
Main_is_even_4:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
movq %r13, 0(%rbp)
jmp Main_is_even_5
## if-join
.globl Main_is_even_5
Main_is_even_5:
jmp Main_is_even_2
## then branch
.globl Main_is_even_1
Main_is_even_1:
pushq %r12
pushq %rbp
movq -8(%rbp), %r13
movq %r13, -144(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
pushq %r13
movq 24(%r13), %r14
movq -144(%rbp), %r13
movq 24(%r13), %r13
subq %r13, %r14
popq %r13
movq %r14, 24(%r13)
movq %r13, -136(%rbp)
movq -136(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp Main_is_even_2
## if-join
.globl Main_is_even_2
Main_is_even_2:
.globl Main.is_even.end
Main.is_even.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.class_type
Main.class_type:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 24(%rbp), %r13
movq %r13, -8(%rbp)
## TAC CASE STATEMENT
movq -8(%rbp), %r13
cmpq $0, %r13
je l35
movq 0(%r13), %r13
movq $0, %r14
cmpq %r14, %r13
je l28
movq $1, %r14
cmpq %r14, %r13
je l33
movq $2, %r14
cmpq %r14, %r13
je l29
movq $-1, %r14
cmpq %r14, %r13
je l33
movq $4, %r14
cmpq %r14, %r13
je l30
movq $5, %r14
cmpq %r14, %r13
je l31
movq $6, %r14
cmpq %r14, %r13
je l32
movq $7, %r14
cmpq %r14, %r13
je l33
movq $-2, %r14
cmpq %r14, %r13
je l33
movq $9, %r14
cmpq %r14, %r13
je l33
movq $10, %r14
cmpq %r14, %r13
je l33
movq $-3, %r14
cmpq %r14, %r13
je l33
.globl l34
l34:
## case expression: error
movq $error22, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l35
l35:
## case expression: void
movq $error23, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
## case expression: branches
## A
.globl l28
l28:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string46, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
## B
.globl l29
l29:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string47, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
## C
.globl l30
l30:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string48, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
## D
.globl l31
l31:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string49, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
## E
.globl l32
l32:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string50, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
## Object
.globl l33
l33:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string51, %r14
movq %r14, 24(%r13)
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
jmp l36
.globl l36
l36:
## TAC CASE STATEMENT
.globl Main.class_type.end
Main.class_type.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.print
Main.print:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $64, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $A2I..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -8(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 24(%rbp), %r13
movq %r13, -40(%rbp)
cmpq $0, %r13
 jne l37
movq $error24, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l37
l37:
movq -40(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -32(%rbp)
movq -8(%rbp), %r13
movq %r13, -48(%rbp)
cmpq $0, %r13
 jne l38
movq $error25, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l38
l38:
movq -32(%rbp), %r13
pushq %r13
movq -48(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 72(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
movq -24(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -16(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string52, %r14
movq %r14, 24(%r13)
movq %r13, -56(%rbp)
movq -56(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 0(%rbp)
.globl Main.print.end
Main.print.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Main.main
Main.main:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $1056, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -8(%rbp)
## while-pred
.globl Main_main_0
Main_main_0:
movq 48(%r12), %r13
movq %r13, -16(%rbp)
movq -16(%rbp), %r13
movq 24(%r13), %r13
cmpq $0, %r13
 jne l39
.globl l40
l40:
## false branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq $1, %r14
movq %r14, 24(%r13)
jmp l41
.globl l39
l39:
## true branch
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
.globl l41
l41:
movq %r13, 0(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_1
## while-body
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string53, %r14
movq %r14, 24(%r13)
movq %r13, -40(%rbp)
movq -40(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -32(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -56(%rbp)
movq -56(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -48(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -88(%rbp)
cmpq $0, %r13
 jne l42
movq $error26, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l42
l42:
movq -88(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -80(%rbp)
movq -80(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -72(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_3
## else branch
.globl Main_main_2
Main_main_2:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string54, %r14
movq %r14, 24(%r13)
movq %r13, -104(%rbp)
movq -104(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -64(%rbp)
jmp Main_main_4
## then branch
.globl Main_main_3
Main_main_3:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string55, %r14
movq %r14, 24(%r13)
movq %r13, -112(%rbp)
movq -112(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -64(%rbp)
jmp Main_main_4
## if-join
.globl Main_main_4
Main_main_4:
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -128(%rbp)
movq -128(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 104(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -120(%rbp)
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 72(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, 24(%r12)
movq 24(%r12), %r13
movq %r13, -136(%rbp)
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -152(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string56, %r14
movq %r14, 24(%r13)
movq %r13, -160(%rbp)
movq -152(%rbp), %r13
movq -160(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -144(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_6
## else branch
.globl Main_main_5
Main_main_5:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -184(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string57, %r14
movq %r14, 24(%r13)
movq %r13, -192(%rbp)
movq -184(%rbp), %r13
movq -192(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -176(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_9
## else branch
.globl Main_main_8
Main_main_8:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -216(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string58, %r14
movq %r14, 24(%r13)
movq %r13, -224(%rbp)
movq -216(%rbp), %r13
movq -224(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -208(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_12
## else branch
.globl Main_main_11
Main_main_11:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -248(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string59, %r14
movq %r14, 24(%r13)
movq %r13, -256(%rbp)
movq -248(%rbp), %r13
movq -256(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -240(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_15
## else branch
.globl Main_main_14
Main_main_14:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -280(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string60, %r14
movq %r14, 24(%r13)
movq %r13, -288(%rbp)
movq -280(%rbp), %r13
movq -288(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -272(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_18
## else branch
.globl Main_main_17
Main_main_17:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -312(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string61, %r14
movq %r14, 24(%r13)
movq %r13, -320(%rbp)
movq -312(%rbp), %r13
movq -320(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -304(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_21
## else branch
.globl Main_main_20
Main_main_20:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -344(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string62, %r14
movq %r14, 24(%r13)
movq %r13, -352(%rbp)
movq -344(%rbp), %r13
movq -352(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -336(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_24
## else branch
.globl Main_main_23
Main_main_23:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -376(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string63, %r14
movq %r14, 24(%r13)
movq %r13, -384(%rbp)
movq -376(%rbp), %r13
movq -384(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -368(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_27
## else branch
.globl Main_main_26
Main_main_26:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -408(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string64, %r14
movq %r14, 24(%r13)
movq %r13, -416(%rbp)
movq -408(%rbp), %r13
movq -416(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -400(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_30
## else branch
.globl Main_main_29
Main_main_29:
pushq %r12
pushq %rbp
movq 24(%r12), %r13
movq %r13, -440(%rbp)
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string65, %r14
movq %r14, 24(%r13)
movq %r13, -448(%rbp)
movq -440(%rbp), %r13
movq -448(%rbp), %r14
pushq %r13
pushq %r14
pushq %r12
call eq_handler
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, -432(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_33
## else branch
.globl Main_main_32
Main_main_32:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -472(%rbp)
cmpq $0, %r13
 jne l43
movq $error27, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l43
l43:
movq -472(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -464(%rbp)
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -480(%rbp)
cmpq $0, %r13
 jne l44
movq $error28, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l44
l44:
movq -464(%rbp), %r13
pushq %r13
movq -480(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 56(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_34
## then branch
.globl Main_main_33
Main_main_33:
## new Bool
pushq %rbp
pushq %r12
movq $Bool..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 48(%r12)
movq 48(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_34
## if-join
.globl Main_main_34
Main_main_34:
jmp Main_main_31
## then branch
.globl Main_main_30
Main_main_30:
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_31
## if-join
.globl Main_main_31
Main_main_31:
jmp Main_main_28
## then branch
.globl Main_main_27
Main_main_27:
## default constructor
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -488(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -512(%rbp)
cmpq $0, %r13
 jne l45
movq $error29, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l45
l45:
movq -512(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -504(%rbp)
pushq %rbp
pushq %r12
movq $E..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -520(%rbp)
cmpq $0, %r13
 jne l46
movq $error30, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l46
l46:
movq -504(%rbp), %r13
pushq %r13
movq -520(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 104(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -488(%rbp)
movq -488(%rbp), %r13
movq %r13, -496(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -560(%rbp)
cmpq $0, %r13
 jne l47
movq $error31, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l47
l47:
movq -560(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -544(%rbp)
pushq %r12
pushq %rbp
movq -488(%rbp), %r13
movq %r13, -584(%rbp)
cmpq $0, %r13
 jne l48
movq $error32, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l48
l48:
movq -584(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -568(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $8, %r14
movq %r14, 24(%r13)
movq %r13, -576(%rbp)
movq -568(%rbp), %r13
movq -576(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
movq %r14, %rax
imull %r13d, %eax
shlq $32, %rax
shrq $32, %rax
movl %eax, %r13d
movq %r13, -552(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -552(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -552(%rbp)
movq -544(%rbp), %r13
movq -552(%rbp), %r14
movq 24(%r13), %r13
movq 24(%r14), %r14
subq %r14, %r13
movq %r13, -536(%rbp)
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq -536(%rbp), %r14
movq %r14, 24(%r13)
movq %r13, -536(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string66, %r14
movq %r14, 24(%r13)
movq %r13, -600(%rbp)
movq -600(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -592(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -616(%rbp)
movq -616(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -608(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string67, %r14
movq %r14, 24(%r13)
movq %r13, -632(%rbp)
movq -632(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -624(%rbp)
pushq %r12
pushq %rbp
movq -488(%rbp), %r13
movq %r13, -648(%rbp)
movq -648(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -640(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string68, %r14
movq %r14, 24(%r13)
movq %r13, -664(%rbp)
movq -664(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -656(%rbp)
pushq %rbp
pushq %r12
movq $A2I..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -672(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq -536(%rbp), %r13
movq %r13, -696(%rbp)
movq -672(%rbp), %r13
movq %r13, -704(%rbp)
cmpq $0, %r13
 jne l49
movq $error33, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l49
l49:
movq -696(%rbp), %r13
pushq %r13
movq -704(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 72(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -688(%rbp)
movq -688(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -680(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string69, %r14
movq %r14, 24(%r13)
movq %r13, -712(%rbp)
movq -712(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -528(%rbp)
movq -488(%rbp), %r13
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_28
## if-join
.globl Main_main_28
Main_main_28:
jmp Main_main_25
## then branch
.globl Main_main_24
Main_main_24:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -736(%rbp)
cmpq $0, %r13
 jne l50
movq $error34, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l50
l50:
movq -736(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -728(%rbp)
pushq %rbp
pushq %r12
movq $D..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -744(%rbp)
cmpq $0, %r13
 jne l51
movq $error35, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l51
l51:
movq -728(%rbp), %r13
pushq %r13
movq -744(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -720(%rbp)
movq 24(%r13), %r13
cmpq $0, %r13
 jne Main_main_36
## else branch
.globl Main_main_35
Main_main_35:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string70, %r14
movq %r14, 24(%r13)
movq %r13, -768(%rbp)
movq -768(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -760(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -784(%rbp)
movq -784(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -776(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string71, %r14
movq %r14, 24(%r13)
movq %r13, -792(%rbp)
movq -792(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
jmp Main_main_37
## then branch
.globl Main_main_36
Main_main_36:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string72, %r14
movq %r14, 24(%r13)
movq %r13, -808(%rbp)
movq -808(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -800(%rbp)
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -824(%rbp)
movq -824(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 112(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -816(%rbp)
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string73, %r14
movq %r14, 24(%r13)
movq %r13, -832(%rbp)
movq -832(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -24(%rbp)
jmp Main_main_37
## if-join
.globl Main_main_37
Main_main_37:
jmp Main_main_25
## if-join
.globl Main_main_25
Main_main_25:
jmp Main_main_22
## then branch
.globl Main_main_21
Main_main_21:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -848(%rbp)
cmpq $0, %r13
 jne l52
movq $error36, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l52
l52:
movq -848(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -840(%rbp)
pushq %rbp
pushq %r12
movq $C..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -856(%rbp)
cmpq $0, %r13
 jne l53
movq $error37, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l53
l53:
movq -840(%rbp), %r13
pushq %r13
movq -856(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 88(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_22
## if-join
.globl Main_main_22
Main_main_22:
jmp Main_main_19
## then branch
.globl Main_main_18
Main_main_18:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -872(%rbp)
cmpq $0, %r13
 jne l54
movq $error38, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l54
l54:
movq -872(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -864(%rbp)
pushq %rbp
pushq %r12
movq $C..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -880(%rbp)
cmpq $0, %r13
 jne l55
movq $error39, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l55
l55:
movq -864(%rbp), %r13
pushq %r13
movq -880(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 88(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_19
## if-join
.globl Main_main_19
Main_main_19:
jmp Main_main_16
## then branch
.globl Main_main_15
Main_main_15:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -896(%rbp)
cmpq $0, %r13
 jne l56
movq $error40, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l56
l56:
movq -896(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -888(%rbp)
pushq %rbp
pushq %r12
movq $C..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -904(%rbp)
cmpq $0, %r13
 jne l57
movq $error41, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l57
l57:
movq -888(%rbp), %r13
pushq %r13
movq -904(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 88(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_16
## if-join
.globl Main_main_16
Main_main_16:
jmp Main_main_13
## then branch
.globl Main_main_12
Main_main_12:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 88(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -920(%rbp)
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -928(%rbp)
cmpq $0, %r13
 jne l58
movq $error42, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l58
l58:
movq -920(%rbp), %r13
pushq %r13
movq -928(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 40(%r12)
movq 40(%r12), %r13
movq %r13, -912(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -944(%rbp)
cmpq $0, %r13
 jne l59
movq $error43, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l59
l59:
movq -944(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -936(%rbp)
pushq %r12
pushq %rbp
movq 40(%r12), %r13
movq %r13, -960(%rbp)
cmpq $0, %r13
 jne l60
movq $error44, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l60
l60:
movq -960(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -952(%rbp)
pushq %rbp
pushq %r12
movq $D..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -968(%rbp)
cmpq $0, %r13
 jne l61
movq $error45, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l61
l61:
movq -936(%rbp), %r13
pushq %r13
movq -952(%rbp), %r13
pushq %r13
movq -968(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 80(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_13
## if-join
.globl Main_main_13
Main_main_13:
jmp Main_main_10
## then branch
.globl Main_main_9
Main_main_9:
movq 32(%r12), %r13
movq %r13, -976(%rbp)
## TAC CASE STATEMENT
movq -976(%rbp), %r13
cmpq $0, %r13
je l66
movq 0(%r13), %r13
movq $0, %r14
cmpq %r14, %r13
je l63
movq $1, %r14
cmpq %r14, %r13
je l64
movq $2, %r14
cmpq %r14, %r13
je l63
movq $-1, %r14
cmpq %r14, %r13
je l64
movq $4, %r14
cmpq %r14, %r13
je l62
movq $5, %r14
cmpq %r14, %r13
je l63
movq $6, %r14
cmpq %r14, %r13
je l63
movq $7, %r14
cmpq %r14, %r13
je l64
movq $-2, %r14
cmpq %r14, %r13
je l64
movq $9, %r14
cmpq %r14, %r13
je l64
movq $10, %r14
cmpq %r14, %r13
je l64
movq $-3, %r14
cmpq %r14, %r13
je l64
.globl l65
l65:
## case expression: error
movq $error46, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l66
l66:
## case expression: void
movq $error47, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
## case expression: branches
## C
.globl l62
l62:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq -976(%rbp), %r13
movq %r13, -1056(%rbp)
cmpq $0, %r13
 jne l68
movq $error48, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l68
l68:
movq -1056(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -1048(%rbp)
movq -976(%rbp), %r13
movq %r13, -1064(%rbp)
cmpq $0, %r13
 jne l69
movq $error49, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l69
l69:
movq -1048(%rbp), %r13
pushq %r13
movq -1064(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 96(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp l67
## A
.globl l63
l63:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq -976(%rbp), %r13
movq %r13, -1056(%rbp)
cmpq $0, %r13
 jne l70
movq $error50, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l70
l70:
movq -1056(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -1048(%rbp)
movq -976(%rbp), %r13
movq %r13, -1064(%rbp)
cmpq $0, %r13
 jne l71
movq $error51, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l71
l71:
movq -1048(%rbp), %r13
pushq %r13
movq -1064(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 72(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp l67
## Object
.globl l64
l64:
pushq %r12
pushq %rbp
## new String
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq $string74, %r14
movq %r14, 24(%r13)
movq %r13, -1056(%rbp)
movq -1056(%rbp), %r13
pushq %r13
pushq %r12
movq 16(%r12), %r14
movq 64(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, -1048(%rbp)
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 16(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -1064(%rbp)
## new Int
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq $0, %r14
movq %r14, 24(%r13)
movq %r13, -24(%rbp)
jmp l67
.globl l67
l67:
## TAC CASE STATEMENT
jmp Main_main_10
## if-join
.globl Main_main_10
Main_main_10:
jmp Main_main_7
## then branch
.globl Main_main_6
Main_main_6:
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
pushq %r12
movq 16(%r12), %r14
movq 88(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -992(%rbp)
pushq %rbp
pushq %r12
movq $A..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -1000(%rbp)
cmpq $0, %r13
 jne l72
movq $error52, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l72
l72:
movq -992(%rbp), %r13
pushq %r13
movq -1000(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 48(%r14), %r14
call %r14
addq $16, %rsp
popq %rbp
popq %r12
movq %r13, 40(%r12)
movq 40(%r12), %r13
movq %r13, -984(%rbp)
pushq %r12
pushq %rbp
pushq %r12
pushq %rbp
movq 32(%r12), %r13
movq %r13, -1016(%rbp)
cmpq $0, %r13
 jne l73
movq $error53, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l73
l73:
movq -1016(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -1008(%rbp)
pushq %r12
pushq %rbp
movq 40(%r12), %r13
movq %r13, -1032(%rbp)
cmpq $0, %r13
 jne l74
movq $error54, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l74
l74:
movq -1032(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 40(%r14), %r14
call %r14
addq $8, %rsp
popq %rbp
popq %r12
movq %r13, -1024(%rbp)
pushq %rbp
pushq %r12
movq $B..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, -1040(%rbp)
cmpq $0, %r13
 jne l75
movq $error55, %r13
 movq %r13, %rdi
call cooloutstr
 call exit
.globl l75
l75:
movq -1008(%rbp), %r13
pushq %r13
movq -1024(%rbp), %r13
pushq %r13
movq -1040(%rbp), %r13
pushq %r13
movq 16(%r13), %r14
movq 64(%r14), %r14
call %r14
addq $24, %rsp
popq %rbp
popq %r12
movq %r13, 32(%r12)
movq 32(%r12), %r13
movq %r13, -24(%rbp)
jmp Main_main_7
## if-join
.globl Main_main_7
Main_main_7:
jmp Main_main_36
## while-join
.globl Main_main_1
Main_main_1:
## default constructor
pushq %rbp
pushq %r12
movq $Object..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, 0(%rbp)
.globl Main.main.end
Main.main.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.abort
Object.abort:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq string_abort, %r13
andq $-16, %rsp
 movq %r13, %rdi
call cooloutstr
andq $-16, %rsp
 call exit
.globl Object.abort.end
Object.abort.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.copy
Object.copy:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
movq 8(%r12), %r14
andq $-16, %rsp
## guarantee 16-byte alignment before call
andq $0xFFFFFFFFFFFFFFF0, %rsp
movq $8, %rsi
movq %r14, %rdi
call calloc
movq %rax, %r13
pushq %r13
.globl l76
l76:
cmpq $0, %r14
 jne l77
movq 0(%r12), %r15
movq %r15, 0(%r13)
movq $8, %r15
addq %r15, %r12
addq %r15, %r13
movq $1, %r15
subq %r15, %r14
jmp l76
.globl l77
l77:
popq %r13
.globl Object.copy.end
Object.copy.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl Object.type_name
Object.type_name:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq 16(%r12), %r14
movq 0(%r14), %r14
movq %r14, 24(%r13)
.globl Object.type_name.end
Object.type_name.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.concat
String.concat:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, %r15
movq 24(%rbp), %r14
movq 24(%r14), %r14
movq 24(%r12), %r13
movq %r13, %rdi
movq %r14, %rsi
andq $-16, %rsp
call coolstrcat
movq %rax, %r13
movq %r13, 24(%r15)
movq %r15, %r13
.globl String.concat.end
String.concat.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.length
String.length:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $Int..new, %r14
call %r14
popq %r12
popq %rbp
movq %r13, %r14
movq 24(%r12), %r13
movq %r13, %rdi
movq $0, %rax
andq $-16, %rsp
call coolstrlen
movq %rax, %r13
movq %r13, 24(%r14)
movq %r14, %r13
.globl String.length.end
String.length.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl String.substr
String.substr:
## method definition
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r12
## stack room for temporaries
movq $16, %r14
subq %r14, %rsp
## method body begins
pushq %rbp
pushq %r12
movq $String..new, %r14
call %r14
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
andq $-16, %rsp
call coolsubstr
movq %rax, %r13
cmpq $0, %r13
 jne l78
movq $substr_out_of_range, %r13
andq $-16, %rsp
 movq %r13, %rdi
call cooloutstr
movq $0, %rdi
andq $-16, %rsp
 call exit
.globl l78
l78:
movq %r13, 24(%r15)
movq %r15, %r13
.globl String.substr.end
String.substr.end:
movq %rbp, %rsp
popq %rbp
ret
## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
## global string constants
.globl the_empty_string
the_empty_string:
 .byte 0

.globl string_abort
string_abort:
 .byte 97 # 'a'
.byte 98 # 'b'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 116 # 't'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl percent.d
percent.d:
 .byte 37 # '%'
.byte 108 # 'l'
.byte 100 # 'd'
.byte 0

.globl percent.ld
percent.ld:
 .byte 32 # ' '
.byte 37 # '%'
.byte 108 # 'l'
.byte 100 # 'd'
.byte 0

.globl substr_out_of_range
substr_out_of_range:
 .byte 69 # 'E'
.byte 82 # 'R'
.byte 82 # 'R'
.byte 79 # 'O'
.byte 82 # 'R'
.byte 58 # ':'
.byte 32 # ' '
.byte 48 # '0'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 83 # 'S'
.byte 116 # 't'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 46 # '.'
.byte 115 # 's'
.byte 117 # 'u'
.byte 98 # 'b'
.byte 115 # 's'
.byte 116 # 't'
.byte 114 # 'r'
.byte 32 # ' '
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte 32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte 32 # ' '
.byte 114 # 'r'
.byte 97 # 'a'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 101 # 'e'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl A_name
A_name:
 .byte 65 # 'A'
.byte 0

.globl A2I_name
A2I_name:
 .byte 65 # 'A'
.byte 50 # '2'
.byte 73 # 'I'
.byte 0

.globl B_name
B_name:
 .byte 66 # 'B'
.byte 0

.globl Bool_name
Bool_name:
 .byte 66 # 'B'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 108 # 'l'
.byte 0

.globl C_name
C_name:
 .byte 67 # 'C'
.byte 0

.globl D_name
D_name:
 .byte 68 # 'D'
.byte 0

.globl E_name
E_name:
 .byte 69 # 'E'
.byte 0

.globl IO_name
IO_name:
 .byte 73 # 'I'
.byte 79 # 'O'
.byte 0

.globl Int_name
Int_name:
 .byte 73 # 'I'
.byte 110 # 'n'
.byte 116 # 't'
.byte 0

.globl Main_name
Main_name:
 .byte 77 # 'M'
.byte 97 # 'a'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 0

.globl Object_name
Object_name:
 .byte 79 # 'O'
.byte 98 # 'b'
.byte 106 # 'j'
.byte 101 # 'e'
.byte 99 # 'c'
.byte 116 # 't'
.byte 0

.globl String_name
String_name:
 .byte 83 # 'S'
.byte 116 # 't'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 103 # 'g'
.byte 0

.globl error1
error1:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error2
error2:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error3
error3:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error4
error4:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error5
error5:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string0
string0:
 .byte 48 # '0'
.byte 0

.globl string1
string1:
 .byte 49 # '1'
.byte 0

.globl string2
string2:
 .byte 50 # '2'
.byte 0

.globl string3
string3:
 .byte 51 # '3'
.byte 0

.globl string4
string4:
 .byte 52 # '4'
.byte 0

.globl string5
string5:
 .byte 53 # '5'
.byte 0

.globl string6
string6:
 .byte 54 # '6'
.byte 0

.globl string7
string7:
 .byte 55 # '7'
.byte 0

.globl string8
string8:
 .byte 56 # '8'
.byte 0

.globl string9
string9:
 .byte 57 # '9'
.byte 0

.globl string10
string10:
 .byte 0

.globl string11
string11:
 .byte 57 # '9'
.byte 0

.globl string12
string12:
 .byte 56 # '8'
.byte 0

.globl string13
string13:
 .byte 55 # '7'
.byte 0

.globl string14
string14:
 .byte 54 # '6'
.byte 0

.globl string15
string15:
 .byte 53 # '5'
.byte 0

.globl string16
string16:
 .byte 52 # '4'
.byte 0

.globl string17
string17:
 .byte 51 # '3'
.byte 0

.globl string18
string18:
 .byte 50 # '2'
.byte 0

.globl string19
string19:
 .byte 49 # '1'
.byte 0

.globl string20
string20:
 .byte 48 # '0'
.byte 0

.globl error6
error6:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error7
error7:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string21
string21:
 .byte 45 # '-'
.byte 0

.globl error8
error8:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string22
string22:
 .byte 43 # '+'
.byte 0

.globl error9
error9:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error10
error10:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error11
error11:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error12
error12:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error13
error13:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error14
error14:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string23
string23:
 .byte 45 # '-'
.byte 0

.globl error15
error15:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string24
string24:
 .byte 48 # '0'
.byte 0

.globl error16
error16:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string25
string25:
 .byte 0

.globl error17
error17:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error18
error18:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error19
error19:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error20
error20:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string26
string26:
 .byte 92 # '\'
.byte 110 # 'n'
.byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 97 # 'a'
.byte 100 # 'd'
.byte 100 # 'd'
.byte 32 # ' '
.byte 97 # 'a'
.byte 32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte 32 # ' '
.byte 0

.globl string27
string27:
 .byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 97 # 'a'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string28
string28:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 110 # 'n'
.byte 101 # 'e'
.byte 103 # 'g'
.byte 97 # 'a'
.byte 116 # 't'
.byte 101 # 'e'
.byte 32 # ' '
.byte 0

.globl string29
string29:
 .byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 98 # 'b'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string30
string30:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 102 # 'f'
.byte 102 # 'f'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 32 # ' '
.byte 98 # 'b'
.byte 101 # 'e'
.byte 116 # 't'
.byte 119 # 'w'
.byte 101 # 'e'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 32 # ' '
.byte 0

.globl string31
string31:
 .byte 97 # 'a'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 32 # ' '
.byte 97 # 'a'
.byte 110 # 'n'
.byte 111 # 'o'
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 99 # 'c'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string32
string32:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 32 # ' '
.byte 116 # 't'
.byte 104 # 'h'
.byte 101 # 'e'
.byte 32 # ' '
.byte 102 # 'f'
.byte 97 # 'a'
.byte 99 # 'c'
.byte 116 # 't'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 105 # 'i'
.byte 97 # 'a'
.byte 108 # 'l'
.byte 32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte 32 # ' '
.byte 0

.globl string33
string33:
 .byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 100 # 'd'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string34
string34:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 115 # 's'
.byte 113 # 'q'
.byte 117 # 'u'
.byte 97 # 'a'
.byte 114 # 'r'
.byte 101 # 'e'
.byte 32 # ' '
.byte 0

.globl string35
string35:
 .byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 101 # 'e'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string36
string36:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 99 # 'c'
.byte 117 # 'u'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 32 # ' '
.byte 0

.globl string37
string37:
 .byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 102 # 'f'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string38
string38:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 102 # 'f'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 32 # ' '
.byte 111 # 'o'
.byte 117 # 'u'
.byte 116 # 't'
.byte 32 # ' '
.byte 105 # 'i'
.byte 102 # 'f'
.byte 32 # ' '
.byte 0

.globl string39
string39:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 97 # 'a'
.byte 32 # ' '
.byte 109 # 'm'
.byte 117 # 'u'
.byte 108 # 'l'
.byte 116 # 't'
.byte 105 # 'i'
.byte 112 # 'p'
.byte 108 # 'l'
.byte 101 # 'e'
.byte 32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte 32 # ' '
.byte 51 # '3'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 103 # 'g'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string40
string40:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 101 # 'e'
.byte 32 # ' '
.byte 0

.globl string41
string41:
 .byte 98 # 'b'
.byte 121 # 'y'
.byte 32 # ' '
.byte 56 # '8'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 104 # 'h'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string42
string42:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 103 # 'g'
.byte 101 # 'e'
.byte 116 # 't'
.byte 32 # ' '
.byte 97 # 'a'
.byte 32 # ' '
.byte 110 # 'n'
.byte 101 # 'e'
.byte 119 # 'w'
.byte 32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 106 # 'j'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string43
string43:
 .byte 92 # '\'
.byte 116 # 't'
.byte 84 # 'T'
.byte 111 # 'o'
.byte 32 # ' '
.byte 113 # 'q'
.byte 117 # 'u'
.byte 105 # 'i'
.byte 116 # 't'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 113 # 'q'
.byte 58 # ':'
.byte 92 # '\'
.byte 110 # 'n'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string44
string44:
 .byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string45
string45:
 .byte 80 # 'P'
.byte 108 # 'l'
.byte 101 # 'e'
.byte 97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte 32 # ' '
.byte 101 # 'e'
.byte 110 # 'n'
.byte 116 # 't'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 97 # 'a'
.byte 32 # ' '
.byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 46 # '.'
.byte 46 # '.'
.byte 46 # '.'
.byte 32 # ' '
.byte 32 # ' '
.byte 0

.globl error21
error21:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error22
error22:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 51 # '3'
.byte 50 # '2'
.byte 48 # '0'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 32 # ' '
.byte 99 # 'c'
.byte 97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte 32 # ' '
.byte 98 # 'b'
.byte 114 # 'r'
.byte 97 # 'a'
.byte 110 # 'n'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 102 # 'f'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 0

.globl error23
error23:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 51 # '3'
.byte 50 # '2'
.byte 48 # '0'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 99 # 'c'
.byte 97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte 32 # ' '
.byte 101 # 'e'
.byte 120 # 'x'
.byte 112 # 'p'
.byte 114 # 'r'
.byte 101 # 'e'
.byte 115 # 's'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string46
string46:
 .byte 67 # 'C'
.byte 108 # 'l'
.byte 97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte 32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 32 # ' '
.byte 65 # 'A'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string47
string47:
 .byte 67 # 'C'
.byte 108 # 'l'
.byte 97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte 32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 32 # ' '
.byte 66 # 'B'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string48
string48:
 .byte 67 # 'C'
.byte 108 # 'l'
.byte 97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte 32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 32 # ' '
.byte 67 # 'C'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string49
string49:
 .byte 67 # 'C'
.byte 108 # 'l'
.byte 97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte 32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 32 # ' '
.byte 68 # 'D'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string50
string50:
 .byte 67 # 'C'
.byte 108 # 'l'
.byte 97 # 'a'
.byte 115 # 's'
.byte 115 # 's'
.byte 32 # ' '
.byte 116 # 't'
.byte 121 # 'y'
.byte 112 # 'p'
.byte 101 # 'e'
.byte 32 # ' '
.byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 119 # 'w'
.byte 32 # ' '
.byte 69 # 'E'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string51
string51:
 .byte 79 # 'O'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 112 # 'p'
.byte 115 # 's'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl error24
error24:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error25
error25:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string52
string52:
 .byte 32 # ' '
.byte 0

.globl string53
string53:
 .byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 0

.globl error26
error26:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string54
string54:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 111 # 'o'
.byte 100 # 'd'
.byte 100 # 'd'
.byte 33 # '!'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string55
string55:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 101 # 'e'
.byte 118 # 'v'
.byte 101 # 'e'
.byte 110 # 'n'
.byte 33 # '!'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string56
string56:
 .byte 97 # 'a'
.byte 0

.globl string57
string57:
 .byte 98 # 'b'
.byte 0

.globl string58
string58:
 .byte 99 # 'c'
.byte 0

.globl string59
string59:
 .byte 100 # 'd'
.byte 0

.globl string60
string60:
 .byte 101 # 'e'
.byte 0

.globl string61
string61:
 .byte 102 # 'f'
.byte 0

.globl string62
string62:
 .byte 103 # 'g'
.byte 0

.globl string63
string63:
 .byte 104 # 'h'
.byte 0

.globl string64
string64:
 .byte 106 # 'j'
.byte 0

.globl string65
string65:
 .byte 113 # 'q'
.byte 0

.globl error27
error27:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error28
error28:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error29
error29:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error30
error30:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error31
error31:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error32
error32:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string66
string66:
 .byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 0

.globl string67
string67:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 101 # 'e'
.byte 113 # 'q'
.byte 117 # 'u'
.byte 97 # 'a'
.byte 108 # 'l'
.byte 32 # ' '
.byte 116 # 't'
.byte 111 # 'o'
.byte 32 # ' '
.byte 0

.globl string68
string68:
 .byte 116 # 't'
.byte 105 # 'i'
.byte 109 # 'm'
.byte 101 # 'e'
.byte 115 # 's'
.byte 32 # ' '
.byte 56 # '8'
.byte 32 # ' '
.byte 119 # 'w'
.byte 105 # 'i'
.byte 116 # 't'
.byte 104 # 'h'
.byte 32 # ' '
.byte 97 # 'a'
.byte 32 # ' '
.byte 114 # 'r'
.byte 101 # 'e'
.byte 109 # 'm'
.byte 97 # 'a'
.byte 105 # 'i'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 111 # 'o'
.byte 102 # 'f'
.byte 32 # ' '
.byte 0

.globl error33
error33:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string69
string69:
 .byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl error34
error34:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error35
error35:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string70
string70:
 .byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 0

.globl string71
string71:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 116 # 't'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 98 # 'b'
.byte 108 # 'l'
.byte 101 # 'e'
.byte 32 # ' '
.byte 98 # 'b'
.byte 121 # 'y'
.byte 32 # ' '
.byte 51 # '3'
.byte 46 # '.'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl string72
string72:
 .byte 110 # 'n'
.byte 117 # 'u'
.byte 109 # 'm'
.byte 98 # 'b'
.byte 101 # 'e'
.byte 114 # 'r'
.byte 32 # ' '
.byte 0

.globl string73
string73:
 .byte 105 # 'i'
.byte 115 # 's'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 118 # 'v'
.byte 105 # 'i'
.byte 115 # 's'
.byte 105 # 'i'
.byte 98 # 'b'
.byte 108 # 'l'
.byte 101 # 'e'
.byte 32 # ' '
.byte 98 # 'b'
.byte 121 # 'y'
.byte 32 # ' '
.byte 51 # '3'
.byte 46 # '.'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl error36
error36:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error37
error37:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error38
error38:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error39
error39:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error40
error40:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error41
error41:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error42
error42:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error43
error43:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error44
error44:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error45
error45:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error46
error46:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 51 # '3'
.byte 54 # '6'
.byte 49 # '1'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 110 # 'n'
.byte 111 # 'o'
.byte 32 # ' '
.byte 99 # 'c'
.byte 97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte 32 # ' '
.byte 98 # 'b'
.byte 114 # 'r'
.byte 97 # 'a'
.byte 110 # 'n'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 102 # 'f'
.byte 111 # 'o'
.byte 117 # 'u'
.byte 110 # 'n'
.byte 100 # 'd'
.byte 0

.globl error47
error47:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 51 # '3'
.byte 54 # '6'
.byte 49 # '1'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 99 # 'c'
.byte 97 # 'a'
.byte 115 # 's'
.byte 101 # 'e'
.byte 32 # ' '
.byte 101 # 'e'
.byte 120 # 'x'
.byte 112 # 'p'
.byte 114 # 'r'
.byte 101 # 'e'
.byte 115 # 's'
.byte 115 # 's'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error48
error48:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error49
error49:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error50
error50:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error51
error51:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl string74
string74:
 .byte 79 # 'O'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 111 # 'o'
.byte 112 # 'p'
.byte 115 # 's'
.byte 92 # '\'
.byte 110 # 'n'
.byte 0

.globl error52
error52:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error53
error53:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error54
error54:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

.globl error55
error55:
 .byte 69 # 'E'
.byte 114 # 'r'
.byte 114 # 'r'
.byte 111 # 'o'
.byte 114 # 'r'
.byte 32 # ' '
.byte 49 # '1'
.byte 56 # '8'
.byte 58 # ':'
.byte 32 # ' '
.byte 69 # 'E'
.byte 120 # 'x'
.byte 99 # 'c'
.byte 101 # 'e'
.byte 112 # 'p'
.byte 116 # 't'
.byte 105 # 'i'
.byte 111 # 'o'
.byte 110 # 'n'
.byte 58 # ':'
.byte 32 # ' '
.byte 100 # 'd'
.byte 105 # 'i'
.byte 115 # 's'
.byte 112 # 'p'
.byte 97 # 'a'
.byte 116 # 't'
.byte 99 # 'c'
.byte 104 # 'h'
.byte 32 # ' '
.byte 111 # 'o'
.byte 110 # 'n'
.byte 32 # ' '
.byte 118 # 'v'
.byte 111 # 'o'
.byte 105 # 'i'
.byte 100 # 'd'
.byte 0

## program begins here
.globl start
start:
.globl main
.type main, @function
main:
movq $Main..new, %r14
pushq %rbp
call %r14
pushq %rbp
pushq %r13
movq $Main.main, %r14
call %r14
 call exit

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
                        movq $-2, %r14
                        cmpq %r14, %r13
			je eq_bool
                        movq $-4, %r14
                        cmpq %r14, %r13
			je eq_int
                        movq $-6, %r14
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
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
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
                        movq $-2, %r14
                        cmpq %r14, %r13
			je le_bool
                        movq $-4, %r14
                        cmpq %r14, %r13
			je le_int
                        movq $-6, %r14
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
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
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
                        movq $-2, %r14
                        cmpq %r14, %r13
			je lt_bool
                        movq $-4, %r14
                        cmpq %r14, %r13
			je lt_int
                        movq $-6, %r14
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
                        ## guarantee 16-byte alignment before call
			andq $0xFFFFFFFFFFFFFFF0, %rsp
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
	.globl	cooloutstr
	.type	cooloutstr, @function
cooloutstr:
.LFB6:
	.cfi_startproc
	endbr64
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
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L3
	movl	-4(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$110, %al
	jne	.L3
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	addl	$2, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$92, %al
	jne	.L4
	movl	-4(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$116, %al
	jne	.L4
	movq	stdout(%rip), %rax
	movq	%rax, %rsi
	movl	$9, %edi
	call	fputc@PLT
	addl	$2, -4(%rbp)
	jmp	.L2
.L4:
	movq	stdout(%rip), %rdx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fputc@PLT
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L5
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	cooloutstr, .-cooloutstr
	.globl	coolstrlen
	.type	coolstrlen, @function
coolstrlen:
.LFB7:
	.cfi_startproc
	endbr64
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
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L8
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	coolstrlen, .-coolstrlen
	.section	.rodata
.LC0:
	.string	"%s%s"
	.text
	.globl	coolstrcat
	.type	coolstrcat, @function
coolstrcat:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L11
	movq	-48(%rbp), %rax
	jmp	.L12
.L11:
	cmpq	$0, -48(%rbp)
	jne	.L13
	movq	-40(%rbp), %rax
	jmp	.L12
.L13:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, %ebx
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	addl	%ebx, %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, -24(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rsi
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movq	-24(%rbp), %rax
.L12:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	coolstrcat, .-coolstrcat
	.section	.rodata
.LC1:
	.string	""
	.text
	.globl	coolgetstr
	.type	coolgetstr, @function
coolgetstr:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$1, %esi
	movl	$40960, %edi
	call	calloc@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -16(%rbp)
.L21:
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fgetc@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	je	.L15
	cmpl	$10, -12(%rbp)
	jne	.L16
.L15:
	cmpl	$0, -16(%rbp)
	je	.L17
	leaq	.LC1(%rip), %rax
	jmp	.L18
.L17:
	movq	-8(%rbp), %rax
	jmp	.L18
.L16:
	cmpl	$0, -12(%rbp)
	jne	.L19
	movl	$1, -16(%rbp)
	jmp	.L21
.L19:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	coolstrlen
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movl	-12(%rbp), %edx
	movb	%dl, (%rax)
	jmp	.L21
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	coolgetstr, .-coolgetstr
	.globl	coolsubstr
	.type	coolsubstr, @function
coolsubstr:
.LFB10:
	.cfi_startproc
	endbr64
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
	js	.L23
	cmpq	$0, -40(%rbp)
	js	.L23
	movq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jle	.L24
.L23:
	movl	$0, %eax
	jmp	.L25
.L24:
	movq	-40(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strndup@PLT
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	coolsubstr, .-coolsubstr
