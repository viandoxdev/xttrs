.bss
	.balign 8
	.lcomm buffer, 8 * 8 # buffer of random values
	.lcomm buffer_length, 8 # number of random values in the buffer
	.lcomm key, 32 # key for ChaCha
	.lcomm nonce, 12 # nonce for ChaCha
	.lcomm counter, 4 # counter for ChaCha
	.balign 8
	.lcomm matrix, 4 * 16 # ChaCha Matrix
	#  0  0 |  4  1 |  8  2 | 12  3
	# -----------------------------
	# 16  4 | 20  5 | 24  6 | 28  7
	# -----------------------------
	# 32  8 | 36  0 | 40  0 | 44  0
	# -----------------------------
	# 48 12 | 52 13 | 56 14 | 60 15
.text
# used for key and nonce generation
dev_random: .ascii "/dev/random\0"
constant: .ascii "silksong when ??"
assert_eq_panic: .ascii "assert eq failed\0"

.set SYS_READ, 0
.set SYS_OPEN, 2
.set SYS_CLOSE, 3

# do a ChaCha quarter round over indices a b c d, expects the address of the matrix in %rax, overwrites %rdx
.macro QUARTERROUND a, b, c, d
	.set _A, \a * 4
	.set _B, \b * 4
	.set _C, \c * 4
	.set _D, \d * 4
	
	movl _B(%rax), %edx
	addl %edx, _A(%rax)
	movl _A(%rax), %edx
	xorl %edx, _D(%rax)
	roll $16, _D(%rax)
	movl _D(%rax), %edx
	addl %edx, _C(%rax) 
	movl _C(%rax), %edx
	xorl %edx, _B(%rax) 
	roll $12, _B(%rax) 
	movl _B(%rax), %edx
	addl %edx, _A(%rax) 
	movl _A(%rax), %edx
	xorl %edx, _D(%rax) 
	roll $8, _D(%rax) 
	movl _D(%rax), %edx
	addl %edx, _C(%rax) 
	movl _C(%rax), %edx
	xorl %edx, _B(%rax) 
	roll $7, _B(%rax) 
.endm
# do two ChaCha round, a diagonal and a column one, expect the addres of the matrix in %rax, overwrites %rdx
.macro DOUBLEROUND
	QUARTERROUND 0, 4,  8, 12
	QUARTERROUND 1, 5,  9, 13
	QUARTERROUND 2, 6, 10, 14
	QUARTERROUND 3, 7, 11, 15
	QUARTERROUND 0, 5, 10, 15
	QUARTERROUND 1, 6, 11, 12
	QUARTERROUND 2, 7,  8, 13
	QUARTERROUND 3, 4,  9, 14
.endm
.global random_init
random_init:
	movq $SYS_OPEN, %rax
	leaq dev_random(%rip), %rdi
	xorq %rsi, %rsi
	xorq %rdx, %rdx
	syscall

	pushq %rax
	
	movq %rax, %rdi
	movq $SYS_READ, %rax
	leaq key(%rip), %rsi
	movq $32, %rdx
	syscall

	movq $SYS_READ, %rax
	movq (%rsp), %rdi
	leaq nonce(%rip), %rsi
	movq $12, %rdx
	syscall

	movl $1, counter(%rip)

	movq $SYS_CLOSE, %rax
	popq %rdi
	syscall

	movq $0, buffer_length(%rip)

	call fill_buffer

	ret
fill_buffer:
	pushq %rdx
	pushq %rcx

	leaq matrix(%rip), %rax

	# 1 - copy data into matrix

	leaq constant(%rip), %rdx
	# constant[0-2] -> matrix[0-2]
	movq (%rdx), %rcx
	movq %rcx, (%rax)
	# constant[2-4] -> matrix[2-4]
	movq 8(%rdx), %rcx
	movq %rcx, 8(%rax)

	leaq key(%rip), %rdx
	# key[0-2] -> matrix[4-6]
	movq (%rdx), %rcx
	movq %rcx, 16(%rax)
	# key[2-4] -> matrix[6-8]
	movq 8(%rdx), %rcx
	movq %rcx, 24(%rax)
	# key[4-6] -> matrix[8-10]
	movq 16(%rdx), %rcx
	movq %rcx, 32(%rax)
	# key[6-8] -> matrix[10-12]
	movq 24(%rdx), %rcx
	movq %rcx, 40(%rax)
	
	# counter[0-1] -> matrix[12-13]
	movl counter(%rip), %ecx
	movl %ecx, 48(%rax)

	leaq nonce(%rip), %rdx
	# nonce[0-1] -> matrix[13-14]
	movl (%rdx), %ecx
	movl %ecx, 52(%rax)
	# nonce[1-3] -> matrix[14-16]
	movq 4(%rdx), %rcx
	movq %rcx, 56(%rax)

	# 2 - ChaCha12 rounds

	DOUBLEROUND
	DOUBLEROUND
	DOUBLEROUND
	DOUBLEROUND
	DOUBLEROUND
	DOUBLEROUND

	# 3 - add original to matrix

	leaq constant(%rip), %rdx
	# matrix[0] += constant[0]
	movl (%rdx), %ecx
	addl %ecx, (%rax)
	# matrix[1] += constant[1]
	movl 4(%rdx), %ecx
	addl %ecx, 4(%rax)
	# matrix[2] += constant[2]
	movl 8(%rdx), %ecx
	addl %ecx, 8(%rax)
	# matrix[3] += constant[3]
	movl 12(%rdx), %ecx
	addl %ecx, 12(%rax)

	leaq key(%rip), %rdx
	# matrix[4] += key[0]
	movl (%rdx), %ecx
	addl %ecx, 16(%rax)
	# matrix[5] += key[1]
	movl 4(%rdx), %ecx
	addl %ecx, 20(%rax)
	# matrix[6] += key[2]
	movl 8(%rdx), %ecx
	addl %ecx, 24(%rax)
	# matrix[7] += key[3]
	movl 12(%rdx), %ecx
	addl %ecx, 28(%rax)
	# matrix[8] += key[4]
	movl 16(%rdx), %ecx
	addl %ecx, 32(%rax)
	# matrix[9] += key[5]
	movl 20(%rdx), %ecx
	addl %ecx, 36(%rax)
	# matrix[10] += key[6]
	movl 24(%rdx), %ecx
	addl %ecx, 40(%rax)
	# matrix[11] += key[7]
	movl 28(%rdx), %ecx
	addl %ecx, 44(%rax)

	# matrix[12] += counter
	movl counter(%rip), %ecx
	addl %ecx, 48(%rax)

	leaq nonce(%rip), %rdx
	# matrix[13] += nonce[0]
	movl (%rdx), %ecx
	addl %ecx, 52(%rax)
	# matrix[14] += nonce[1]
	movl 4(%rdx), %ecx
	addl %ecx, 56(%rax)
	# matrix[15] += nonce[2]
	movl 8(%rdx), %ecx
	addl %ecx, 60(%rax)

	# 6 - increment counter

	incl counter(%rip)

	# 5 - write results to buffer

	leaq buffer(%rip), %rdx
	movq (%rax), %rcx
	movq %rcx, (%rdx)
	movq 8(%rax), %rcx
	movq %rcx, 8(%rdx)
	movq 16(%rax), %rcx
	movq %rcx, 16(%rdx)
	movq 24(%rax), %rcx
	movq %rcx, 24(%rdx)
	movq 32(%rax), %rcx
	movq %rcx, 32(%rdx)
	movq 40(%rax), %rcx
	movq %rcx, 40(%rdx)
	movq 48(%rax), %rcx
	movq %rcx, 48(%rdx)
	movq 56(%rax), %rcx
	movq %rcx, 56(%rdx)

	movq $8, buffer_length(%rip)

	popq %rcx
	popq %rdx

	ret
.globl random
# get a random quad in %rax
random:
	pushq %rdx

	movq buffer_length(%rip), %rax
	leaq buffer(%rip), %rdx
	decq %rax
	movq %rax, buffer_length(%rip)
	movq (%rdx, %rax, 8), %rax

	test %rax, %rax
	jz random_buffer_empty

	popq %rdx
	ret

	random_buffer_empty:
	call fill_buffer

	popq %rdx
	ret
.globl random_peek
# get the next value to be generated in %rax
random_peek:
	pushq %rdx
	movq buffer_length(%rip), %rax
	leaq buffer(%rip), %rdx
	decq %rax
	movq (%rdx, %rax, 8), %rax
	popq %rdx
	ret
