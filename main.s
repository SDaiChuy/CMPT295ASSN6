	.file	"main.c"
	.text
	.p2align 4
	.def	printf;	.scl	3;	.type	32;	.endef
	.seh_proc	printf
printf:
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	leaq	88(%rsp), %rbx
	movq	%rdx, 88(%rsp)
	movq	%rcx, %r12
	movl	$1, %ecx
	movq	%r8, 96(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rbx, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	movq	%r12, %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$56, %rsp
	popq	%rbx
	popq	%r12
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "%4d\0"
.LC1:
	.ascii "%4d \0"
.LC2:
	.ascii "\12\0"
	.text
	.p2align 4
	.globl	printMatrixByRow
	.def	printMatrixByRow;	.scl	2;	.type	32;	.endef
	.seh_proc	printMatrixByRow
printMatrixByRow:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movq	%rcx, 56(%rsp)
	movl	%edx, 52(%rsp)
	testl	%edx, %edx
	je	.L11
	leaq	.LC2(%rip), %rax
	movl	52(%rsp), %esi
	xorl	%r13d, %r13d
	xorl	%r12d, %r12d
	movq	%rax, 40(%rsp)
	leaq	.LC1(%rip), %rbp
	leaq	.LC0(%rip), %r14
	leal	-1(%rsi), %edi
	.p2align 4,,10
	.p2align 3
.L4:
	movq	56(%rsp), %rbx
	movl	%r13d, %eax
	xorl	%r15d, %r15d
	addq	%rax, %rbx
	jmp	.L8
	.p2align 4,,10
	.p2align 3
.L6:
	movq	%rbp, %rcx
	addq	$1, %r15
	call	printf
	cmpq	%r15, %rsi
	je	.L12
.L8:
	movsbl	(%rbx,%r15), %edx
	cmpl	%r15d, %edi
	jne	.L6
	movq	%r14, %rcx
	addq	$1, %r15
	call	printf
	cmpq	%r15, %rsi
	jne	.L8
.L12:
	movq	40(%rsp), %rcx
	addl	$1, %r12d
	call	printf
	movl	52(%rsp), %eax
	addl	%eax, %r13d
	cmpl	%eax, %r12d
	jne	.L4
.L5:
	movq	40(%rsp), %rcx
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	printf
.L11:
	leaq	.LC2(%rip), %rax
	movq	%rax, 40(%rsp)
	jmp	.L5
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC3:
	.ascii "Matrix A: \12\0"
.LC4:
	.ascii "Copy A to C\12\0"
.LC5:
	.ascii "\12Matrix C: \12\0"
	.align 8
.LC6:
	.ascii "Rotating the matrix C by 90 degrees clockwise: \12\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	leaq	A(%rip), %r13
	leaq	C(%rip), %r12
	call	__main
	leaq	.LC3(%rip), %rcx
	call	printf
	movl	$6, %edx
	movq	%r13, %rcx
	call	printMatrixByRow
	leaq	.LC4(%rip), %rcx
	call	printf
	movl	$6, %r8d
	movq	%r12, %rdx
	movq	%r13, %rcx
	call	copy
	leaq	.LC5(%rip), %rcx
	call	printf
	movl	$6, %edx
	movq	%r12, %rcx
	call	printMatrixByRow
	leaq	.LC6(%rip), %rcx
	call	printf
	movq	%r12, %rcx
	movl	$6, %edx
	call	transpose
	movq	%r12, %rcx
	movl	$6, %edx
	call	reverseColumns
	movl	$6, %edx
	movq	%r12, %rcx
	addq	$40, %rsp
	popq	%r12
	popq	%r13
	jmp	printMatrixByRow
	.seh_endproc
	.globl	C
	.bss
	.align 32
C:
	.space 36
	.globl	A
	.data
	.align 32
A:
	.ascii "\0\1\2\3\4\5"
	.ascii "\12\13\14\15\16\17"
	.ascii "\24\25\26\27\30\31"
	.ascii "\36\37 !\"#"
	.ascii "()*+,-"
	.ascii "234567"
	.ident	"GCC: (GNU) 11.2.0"
	.def	__mingw_vfprintf;	.scl	2;	.type	32;	.endef
	.def	copy;	.scl	2;	.type	32;	.endef
	.def	transpose;	.scl	2;	.type	32;	.endef
	.def	reverseColumns;	.scl	2;	.type	32;	.endef
