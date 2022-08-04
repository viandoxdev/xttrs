.bss
	.lcomm current_width, 8
	.lcomm current_height, 8
	.lcomm playfield_top_padding, 10 * 16
	.lcomm playfield, 10 * 40 * 1
	.balign 8
	.lcomm current_piece_pos, 16
	.lcomm current_piece_rotation, 1
	.balign 8
	.lcomm current_piece, 1
	.lcomm next_piece, 1
	.balign 8
	.lcomm paused, 1
	.lcomm soft_drop, 1
	.lcomm setup_completed, 1
	.balign 8
	.lcomm level, 8
	.lcomm gravity, 8
	.lcomm score, 8
	.lcomm best_score, 8
	.lcomm line_count, 8
	.lcomm tetris_line_count, 8
	.lcomm tetris_rate, 8
	.lcomm burn_count, 8
	.lcomm drought_count, 8
	.lcomm soft_drop_counter, 8

	.lcomm row_cleared, 8
	.lcomm row_cleared_length, 8

	.lcomm counter_drop, 8
	.lcomm counter_entry_delay, 8
	.lcomm counter_line_clear, 8
	.lcomm counter_death, 8

	.lcomm next_update, 8
	.lcomm next_sync, 8

	.lcomm input_buf, 8
	.lcomm input_length, 8
	.lcomm pollfd, 8

	.lcomm next_level, 8

	.lcomm argv, 8
	.lcomm envp, 8

	.lcomm path_buf, 512 # buffer for path
	.lcomm file_path, 8 # path to best score file, i.e /home/.../.local/share/xttrs/best_score
	.lcomm best_score_fd, 8
.text
	panic_msg: .ascii "\033[90m[\033[31mFATAL\033[90m] \033[0m\033[1mAborted with error\033[0m: "
	panic_too_small: .asciz "Screen is too small to play\n"
	panic_wrong_next: .asciz "Next piece doesn't match generated piece\n\n"
	panic_args: .asciz "Error when parsing arguments\n"
	frame:
		.ascii "╔════════════════════╦════════╗"
		.ascii "║                    ║ SCORE  ║"
		.ascii "║                    ║  00000 ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║  NEXT  ║"
		.ascii "║                    ║        ║"
		.ascii "║                    ║        ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║  BEST  ║"
		.ascii "║                    ║ ?????? ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║ BRN 00 ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║ DRT 00 ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║ TT 00% ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║ LVL 00 ║"
		.ascii "║                    ╠════════╣"
		.ascii "║                    ║ LINES  ║"
		.ascii "║                    ║  00000 ║"
		.ascii "╚════════════════════╩════════╝"
	.balign 8
	frame_length: # length in bytes of the frame's rows
		.quad 93 # ══
		.quad 37 #  S
		.quad 37 #  0
		.quad 53 #  ═
		.quad 37 #  N
		.quad 37 #  N
		.quad 37 #  N
		.quad 53 #  ═
		.quad 37 #  O
		.quad 37 #  0
		.quad 53 #  ═
		.quad 37 #  B
		.quad 53 #  ═
		.quad 37 #  B
		.quad 53 #  ═
		.quad 37 #  T
		.quad 53 #  ═
		.quad 37 #  L
		.quad 53 #  ═
		.quad 37 #  L
		.quad 37 #  0
		.quad 93 # ══
	paused_msg:    .ascii "\033[0;1m== PAUSED =="      # len: (18, 12), offset: 0
	paused_help_1: .ascii "\033[0;1mr\033[2m: restart" # len: (20, 10), offset: 1
	paused_help_2: .ascii "\033[0;1mq\033[2m: quit"    # len: (17,  7), offset: 1
	env_xdg_data_home_str: .asciz "XDG_DATA_HOME="
	env_home_str: .asciz "HOME="
	path_xttrs: .asciz "/xttrs"
	path_local: .asciz "/.local/share"
	path_bfile: .asciz "/best_score"
	exe_path: .asciz "/proc/self/exe"
	line_clear_fill:        .ascii "\033[0m                    "
	line_clear_fill_tetris: .ascii "\033[0;100m"
	arg_short: .asciz "-l"
	arg_long: .asciz "--level"
	.balign 8 # just in case
	pieces:
		# No piece
		.byte 0, 0,  0,  0,  0,  0,  0,  0
		.byte 0, 0,  0,  0,  0,  0,  0,  0
		.byte 0, 0,  0,  0,  0,  0,  0,  0
		.byte 0, 0,  0,  0,  0,  0,  0,  0
		.quad 0
		# I   [x,y] [x,  y] [x,  y] [x,  y]
		.byte 0, 0, -1,  0, -2,  0,  1,  0 # North
		.byte 0, 0,  0, -1,  0, -2,  0,  1 # East
		.byte 0, 0, -1,  0, -2,  0,  1,  0 # South
		.byte 0, 0,  0, -1,  0, -2,  0,  1 # West
		.quad 1 # style
		# O
		.byte 0, 0, -1,  0,  0,  1, -1,  1
		.byte 0, 0, -1,  0,  0,  1, -1,  1
		.byte 0, 0, -1,  0,  0,  1, -1,  1
		.byte 0, 0, -1,  0,  0,  1, -1,  1 
		.quad 2
		# J
		.byte 0, 0, -1,  0,  1,  0,  1,  1
		.byte 0, 0,  0, -1,  0,  1, -1,  1
		.byte 0, 0, -1,  0,  1,  0, -1, -1
		.byte 0, 0,  0, -1,  1, -1,  0,  1
		.quad 3
		# L
		.byte 0, 0, -1,  0,  1,  0, -1,  1
		.byte 0, 0, -1, -1,  0, -1,  0,  1
		.byte 0, 0, -1,  0,  1,  0,  1, -1
		.byte 0, 0,  0, -1,  0,  1,  1,  1
		.quad 4
		# S
		.byte 0, 0,  1,  0,  0,  1, -1,  1
		.byte 0, 0,  1,  0,  0, -1,  1,  1
		.byte 0, 0,  1,  0,  0,  1, -1,  1
		.byte 0, 0,  1,  0,  0, -1,  1,  1
		.quad 5
		# Z
		.byte 0, 0, -1,  0,  0,  1,  1,  1
		.byte 0, 0, -1,  0,  0, -1, -1,  1
		.byte 0, 0, -1,  0,  0,  1,  1,  1
		.byte 0, 0, -1,  0,  0, -1, -1,  1
		.quad 6
		# T
		.byte 0, 0, -1,  0,  1,  0,  0,  1
		.byte 0, 0, -1,  0,  0, -1,  0,  1
		.byte 0, 0,  0, -1, -1,  0,  1,  0
		.byte 0, 0,  0, -1,  0,  1,  1,  0
		.quad 7

	styles:
		.ascii "\033[0000000m\033[002C" # Empty
		.ascii "\033[96;46m[]\033[000m" # I      
		.ascii "\033[93;43m[]\033[000m" # O
		.ascii "\033[94;44m[]\033[000m" # J
		.ascii "\033[97;47m[]\033[000m" # L
		.ascii "\033[92;42m[]\033[000m" # S
		.ascii "\033[91;41m[]\033[000m" # Z
		.ascii "\033[95;45m[]\033[000m" # T
		# TODO: more color schemes
	gravity_map:
		.space  1, 48 # level 0
		.space  1, 43 # level 1
		.space  1, 38 # level 2
		.space  1, 33 # level 3
		.space  1, 28 # level 4
		.space  1, 23 # level 5
		.space  1, 18 # level 6
		.space  1, 13 # level 7
		.space  1, 8  # level 8
		.space  1, 6  # level 9
		.space  3, 5  # level 10-12
		.space  3, 4  # level 13-15
		.space  3, 3  # level 16-18
		.space 10, 2  # level 19-28
		.space  3, 1  # level 29-31 (anything past 31 is clamped to 31)
	multipliers: .quad 40, 100, 300, 1200

.set SYS_READ, 0
.set SYS_WRITE, 1
.set SYS_OPEN, 2
.set SYS_CLOSE, 3
.set SYS_POLL, 7
.set SYS_LSEEK, 8
.set SYS_ACCESS, 21
.set SYS_EXECVE, 59
.set SYS_EXIT, 60
.set SYS_FSYNC, 7
.set SYS_MKDIR, 83
.set STDOUT, 1
.set STDIN, 0
.set POLLIN, 1

.set KEY_ESC,   0x0000001B # begining goes at the end (endianness ?)
.set KEY_UP,    0x00415B1B # \x1b[A
.set KEY_LEFT,  0x00445B1B # \x1b[D
.set KEY_DOWN,  0x00425B1B # \x1b[B
.set KEY_RIGHT, 0x00435B1B # \x1b[C
.set KEY_Q,     0x00000071 # q
.set KEY_R,     0x00000072 # r
.set KEY_X,     0x00000078 # x

.set FRAME_DURATION, 16639267 # 60.0988 fps
.set SYNC_DELAY, 937500000 # 1min (divided by 64 for reasons)

.set SOFT_DROP_GRAVITY, 2

.set MIN_WIDTH, 31
.set MIN_HEIGHT, 22

.set PLAYFIELD_VISIBLE_HEIGHT, 20
.set PLAYFIELD_VISIBLE_OFFSET_ROWS, 20
.set PLAYFIELD_VISIBLE_OFFSET_AREA, 200
.set PLAYFIELD_WIDTH, 10
.set PLAYFIELD_HEIGHT, 40
.set PLAYFIELD_AREA, 400
.set PLAYFIELD_PIECE_START_X, 5
.set PLAYFIELD_PIECE_START_Y, 20

.set STYLES_MASK, 0b111

.globl _start
.globl panic
# print the null terminated string in %rax (fails for 0 length strings)
print:
	movq %rax, %rdx
	print_loop:
		incq %rdx
		movb (%rdx), %sil
		cmpb $0, %sil
		jne print_loop
	subq %rax, %rdx
	movq %rax, %rsi
	movq $STDOUT, %rdi
	movq $SYS_WRITE, %rax
	syscall
	ret
nl:
	subq $1, %rsp
	movb $'\n', (%rsp)
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq %rsp, %rsi
	movq $1, %rdx
	syscall
	addq $1, %rsp
	ret
# exit with an error, %rax is a pointer to a null terminated string
panic:
	pushq %rax
	cmpb $1, setup_completed(%rip)
	jne panic_next
	call cleanup
	panic_next:
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq panic_msg(%rip), %rsi
	movq $55, %rdx
	syscall

	popq %rax

	call print
	call nl

	movq $SYS_EXIT, %rax
	movq $1, %rdi
	syscall
	ret
check_size:
	call get_size

	movq width(%rip), %rax
	movq height(%rip), %rdi

	cmpq $MIN_WIDTH, %rax
	jb assert_size_failed
	cmpq $MIN_HEIGHT, %rdi
	jb assert_size_failed

	jmp assert_size_succeded
	
	assert_size_failed:
	leaq panic_too_small(%rip), %rax
	call panic

	assert_size_succeded:
	movq current_width(%rip), %rcx
	cmpq %rax, %rcx
	jne assert_size_changed
	movq current_height(%rip), %rcx
	cmpq %rdi, %rcx
	jne assert_size_changed

	ret

	assert_size_changed:
	movq %rax, current_width(%rip)
	movq %rdi, current_height(%rip)
	call draw_full

	ret
reset_playfield:
	movq $PLAYFIELD_AREA, %rax
	movq %rax, %rdx
	movq %rax, %rcx

	shrq $3, %rdx # rdx has the number of 8 bytes moves needed
	shrq $3, %rcx
	shlq $3, %rcx
	subq %rcx, %rax # rax has the number of 1 byte moves needed

	leaq playfield(%rip), %rcx

	_rl0:
		movq $0, (%rcx)
		addq $8, %rcx
		decq %rdx
		jnz _rl0
	test %rax, %rax
	jnz _rl1
	ret
	_rl1:
		movb $0, (%rcx)
		incq %rcx
		decq %rax
		jnz _rl1
	ret
# draw piece %rax with rotation %rdi at position %rsi, %rdx
# rbx serves as a way to offset the position by a half a horizontal tile
# expects stack to have:
# - top left corner of playfield y (quad)
# - top left corner of playfield x (quad)
draw_piece:
	pushq %rsi # push piece pos x
	pushq %rdx # push piece pos y
	pushq %rdi

	# get address of current piece (all 4 lines)
	leaq pieces(%rip), %rdi
	movq %rax, %rcx
	shlq $3, %rcx
	shlq $5, %rax
	addq %rcx, %rax
	addq %rax, %rdi
	# get style of current piece
	movq 32(%rdi), %rax
	andq $STYLES_MASK, %rax # just in case
	shlq $4, %rax
	leaq styles(%rip), %rsi
	addq %rax, %rsi

	subq $PLAYFIELD_VISIBLE_OFFSET_ROWS, 8(%rsp) # make PP y relative to top of frame
	movq 32(%rsp), %rcx
	addq %rcx, 8(%rsp) # make PP y relative to terminal
	shlq $1, 16(%rsp) # double PP x (one cell -> two terminal characters)
	movq 40(%rsp), %rcx
	addq %rcx, 16(%rsp) # make PP x relative to terminal
	addq %rbx, 16(%rsp)
	
	popq %rax # get rotation in rax
	shlq $3, %rax
	addq %rax, %rdi
	movq %rdi, %r10

	# r10: address of piece rotation (4 pair of 1 byte coordinates )
	# rsi: address of style
	# (rsp): y position of piece's center (terminal)
	# 8(rsp): same for x
	# 16(rsp): y of the frame (terminal)
	# 24(rsp): same for x
	.macro DRAW_FULL_CURRENT_PIECE_BLOCK
	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	movsxb (%r10), %rcx
	shlq $1, %rcx
	addq %rcx, %rax
	movsxb 1(%r10), %rcx
	addq %rcx, %rdx
	pushq %rsi
	call set_cursor
	popq %rsi

	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq $16, %rdx
	syscall
	addq $2, %r10
	.endm

	DRAW_FULL_CURRENT_PIECE_BLOCK
	DRAW_FULL_CURRENT_PIECE_BLOCK
	DRAW_FULL_CURRENT_PIECE_BLOCK
	DRAW_FULL_CURRENT_PIECE_BLOCK

	addq $16, %rsp
	ret
# synchronizes the best_score file and the stored best score
sync_best:
	# seek to the start of the file needed after every read/write
	# cobblers: rax, rdi, rsi, rdx, rcx
	.macro SEEKSTART
	movq $SYS_LSEEK, %rax
	movq best_score_fd(%rip), %rdi
	xorq %rsi, %rsi
	xorq %rdx, %rdx
	syscall
	.endm

	pushq $0

	movq $SYS_READ, %rax
	movq best_score_fd(%rip), %rdi
	movq %rsp, %rsi
	movq $8, %rdx
	syscall
	
	test %rax, %rax
	js sync_best_fail # if negative, read failed (fd is probably -1)

	SEEKSTART

	movq (%rsp), %rax
	movq best_score(%rip), %rdx
	cmpq %rdx, %rax
	cmovb %rdx, %rax # rax: max(local_best_score, stored_best_score)

	incq %rax

	movq %rax, best_score(%rip)
	movq %rax, (%rsp)

	movq $SYS_WRITE, %rax
	movq best_score_fd(%rip), %rdi
	movq %rsp, %rsi
	movq $8, %rdx
	syscall

	SEEKSTART
	addq $8, %rsp

	# because why not
	movq $SYS_FSYNC, %rax
	movq best_score_fd(%rip), %rdi
	syscall

	ret
	sync_best_fail:
	addq $8, %rsp
	ret
draw_full:
	cmpq $4, row_cleared_length(%rip)
	jne draw_clear
	testq $4, counter_line_clear(%rip)
	je draw_clear

	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq line_clear_fill_tetris(%rip), %rsi
	movq $8, %rdx
	syscall

	draw_clear:
	call clear_screen
	movq current_width(%rip), %rax
	movq current_height(%rip), %rdx
	
	cmpb $1, paused(%rip)
	jne draw_unpaused
	draw_paused:
	subq $18, %rax
	subq $3, %rdx
	shrq $1, %rax
	shrq $1, %rdx

	pushq %rax
	pushq %rdx

	call set_cursor
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq paused_msg(%rip), %rsi
	movq $18, %rdx
	syscall

	incq 8(%rsp)
	incq (%rsp)

	movq (%rsp), %rdx
	movq 8(%rsp), %rax
	call set_cursor
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq paused_help_1(%rip), %rsi
	movq $20, %rdx
	syscall

	movq (%rsp), %rdx
	movq 8(%rsp), %rax
	incq %rdx
	call set_cursor
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq paused_help_2(%rip), %rsi
	movq $17, %rdx
	syscall

	addq $16, %rsp
	ret

	draw_unpaused:
	subq $MIN_WIDTH, %rax
	subq $MIN_HEIGHT, %rdx
	shrq $1, %rax
	shrq $1, %rdx

	pushq %rax
	pushq %rdx
	leaq frame(%rip), %rax
	pushq %rax
	leaq frame_length(%rip), %rax
	pushq %rax

	movq $0, %r10
	draw_frame_loop:
		movq 24(%rsp), %rax
		movq 16(%rsp), %rdx
		addq %r10, %rdx
		call set_cursor

		movq $SYS_WRITE, %rax
		movq $STDOUT, %rdi
		movq 8(%rsp), %rsi
		movq (%rsp), %rdx
		movq (%rdx), %rdx
		syscall

		addq %rdx, 8(%rsp) # go to next row
		addq $8, (%rsp) # go to next raw length

		incq %r10
		cmpq $22, %r10
		jbe draw_frame_loop
	addq $16, %rsp

	movq score(%rip), %rax
	cmpq $1000000, %rax
	jae _dscoream

	_dscorebm:
	call qstring_unsigned
	movq 8(%rsp), %rax
	addq $29, %rax
	subq qstrl(%rip), %rax
	movq (%rsp), %rdx
	addq $2, %rdx
	call set_cursor
	movq score(%rip), %rax
	call qprint_unsigned
	jmp _dscoredone
	
	_dscoream:
	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	addq $24, %rax
	addq $2, %rdx
	call set_cursor

	movq score(%rip), %rax
	xorq %rdx, %rdx
	movq $1000000, %rcx
	divq %rcx
	pushq %rdx
	call qprint_unsigned
	
	decq %rsp
	movb $'.', (%rsp)
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq %rsp, %rsi
	movq $1, %rdx
	syscall
	incq %rsp

	movq (%rsp), %rax
	call qstring_unsigned
	popq %rdx
	cmpq $10000, %rdx
	setb %cl
	cmpq $1000, %rdx
	setb %al
	addb %al, %cl # cl is 0, 1 or 2
	movzxb %cl, %rax
	leaq qstr(%rip), %rsi
	subq %rax, %rsi
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq $2, %rdx
	syscall

	decq %rsp
	movb $'M', (%rsp)
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq %rsp, %rsi
	movq $1, %rdx
	syscall
	incq %rsp
	_dscoredone:

	.macro QPRINT_PAD sym, x, y, len
	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	addq $\x, %rax
	addq $\y, %rdx
	call set_cursor
	movq \sym(%rip), %rax
	call qstring_unsigned
	movq $\len, %rdx
	subq qstrl(%rip), %rdx
	leaq qstr(%rip), %rsi
	subq %rdx, %rsi
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq $\len, %rdx
	syscall
	.endm

	.macro QPRINT_PAD2 sym, x, y
	movq \sym(%rip), %rax
	xorq %rcx, %rcx
	cmpq $100, %rax
	setae %cl

	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	addq $\x, %rax
	subq %rcx, %rax
	addq $\y, %rdx
	call set_cursor

	decq %rsp
	movb $' ', (%rsp)
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	movq %rsp, %rsi
	movq $1, %rdx
	syscall
	incq %rsp

	movq \sym(%rip), %rax
	call qstring_unsigned
	movq $2, %rdx
	xorq %rcx, %rcx
	subq qstrl(%rip), %rdx
	cmovs %rcx, %rdx
	leaq qstr(%rip), %rsi
	subq %rdx, %rsi
	addq qstrl(%rip), %rdx
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	syscall
	.endm

	movq best_score(%rip), %rax
	test %rax, %rax
	jz _dbscoredone
	cmpq $1000000, %rax
	jae _dbscoream
	_dbscorebm:
	QPRINT_PAD best_score, 23, 9, 6
	jmp _dbscoredone
	_dbscoream:
	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	addq $22, %rax
	addq $9, %rdx
	call set_cursor

	movq $SYS_WRITE, %rax
	movq $STDOUT, %rdi
	leaq qstrpad, %rsi
	movq $1, %rdx
	syscall
	movq best_score(%rip), %rax
	call qprint_unsigned
	_dbscoredone:

	QPRINT_PAD line_count, 24, 20, 5
	QPRINT_PAD2 level, 26, 17
	QPRINT_PAD2 burn_count, 26, 11
	QPRINT_PAD drought_count, 27, 13, 2
	QPRINT_PAD2 tetris_rate, 25, 15

	incq 8(%rsp)
	incq (%rsp)

	movzxb next_piece(%rip), %rax
	movq $0, %rdi
	movq $12, %rsi
	xorq %rbx, %rbx
	cmpq $3, %rax
	setb %bl
	movq $24, %rdx
	call draw_piece

	movzxb current_piece(%rip), %rax
	movzxb current_piece_rotation(%rip), %rdi
	leaq current_piece_pos(%rip), %rsi
	movq 8(%rsi), %rdx
	movq (%rsi), %rsi
	xorq %rbx, %rbx
	call draw_piece

	xorq %r10, %r10
	movq counter_death(%rip), %r9
	shrq $3, %r9
	imull $PLAYFIELD_WIDTH, %r9d
	negq %r9
	addq $PLAYFIELD_VISIBLE_OFFSET_AREA, %r9
	_dl0:
		pushq %r9
		movq 16(%rsp), %rax
		movq 8(%rsp), %rdx
		addq %r10, %rdx
		call  set_cursor
		popq %r9
		
		movq $PLAYFIELD_WIDTH, %r8
		_dl1:
			leaq playfield(%rip), %rsi
			movzxb (%rsi, %r9, 1), %rax
			leaq styles(%rip), %rsi
			andq $STYLES_MASK, %rax
			shlq $4, %rax
			addq %rax, %rsi

			movq $SYS_WRITE, %rax
			movq $STDOUT, %rdi
			movq $16, %rdx
			syscall

			incq %r9
			decq %r8
			jnz _dl1

		incq %r10
		cmpq $PLAYFIELD_VISIBLE_HEIGHT, %r10
		jb _dl0

	cmpq $0, counter_line_clear(%rip)
	jz _dlcdone

	movq row_cleared_length(%rip), %r10
	leaq row_cleared(%rip), %rsi
	_dlcl:
		movq counter_line_clear(%rip), %rax
		decq %rax
		shrq $1, %rax
		addq 8(%rsp), %rax
		movzxb (%rsi), %rdx
		subq $PLAYFIELD_VISIBLE_OFFSET_ROWS, %rdx
		addq (%rsp), %rdx
		pushq %rsi
		call set_cursor
		
		movq $25, %rdx
		subq counter_line_clear(%rip), %rdx
		movq $SYS_WRITE, %rax
		movq $STDOUT, %rdi
		leaq line_clear_fill, %rsi
		syscall

		popq %rsi
		incq %rsi
		decq %r10
		jnz _dlcl

	_dlcdone:

	addq $16, %rsp
	ret
# check if string in rax == rdx
strcmp:
	pushq %rax
	pushq %rdx
	pushq %rcx
	
	strcmp_l:
		movb (%rax), %cl
		cmpb %cl, (%rdx)
		jne strcmp_fail
		cmpb $0, (%rax)
		je strcmp_end
		cmpb $0, (%rdx)
		je strcmp_end
		incq %rax
		incq %rdx
		jmp strcmp_l
	strcmp_end:
		movb (%rax), %cl
		cmpb %cl, (%rdx)
		jne strcmp_fail
		popq %rcx
		popq %rdx
		popq %rax
		cmpq %rcx, %rcx # set ZF
		ret
	strcmp_fail:
		popq %rcx
		popq %rdx
		popq %rax
		test %rdx, %rdx # unset ZF (rdx != 0)
		ret
# parse unsigned number from null terminated string in rax -> rax
parse_number:
	xorq %rdx, %rdx
	parse_number_l:
		cmpb $0, (%rax)
		jz parse_number_succeded
		cmpb $'0', (%rax)
		jb parse_number_failed
		cmpb $'9', (%rax)
		ja parse_number_failed

		# rdx *= 10
		movq %rdx, %rcx
		shlq $3, %rdx
		addq %rcx, %rdx
		addq %rcx, %rdx
		# rdx += (rax) - 48
		movzxb (%rax), %rcx
		subq $48, %rcx
		addq %rcx, %rdx
		inc %rax
		jmp parse_number_l
	parse_number_succeded:
		movq %rdx, %rax
		cmpq %rcx, %rcx # set ZF
		ret
	parse_number_failed:
		xorq %rax, %rax
		orq $-1, %rax # unset ZF
		ret
# setup the file to store the best score
# rcx is envp (char**)
setup_data:
	pushq $0 # 8(rsp): char* to value of XDG_DATA_HOME
	pushq $0 # (rsp):  char* to value of HOME

	cmpq $0, (%rcx)
	jz setup_data_giveup # abort if no environment variables
	setup_data_el:
		# check if string at rax starts with string at rdx
		.macro STARTWITH suf
		_sdel_l\suf\():
			cmpb $0, (%rdx)
			jz _sdel_s\suf
			cmpb $0, (%rax)
			jz _sdel_f\suf
			movb (%rax), %dil
			cmpb %dil, (%rdx)
			jne _sdel_f\suf
			incq %rax
			incq %rdx
			jmp _sdel_l\suf
		_sdel_s\suf\():
			cmpq %rsp, %rsp # set ZF
			jmp _sdel_e\suf
		_sdel_f\suf\():
			orq $-1, %rax # unset ZF
		_sdel_e\suf\():
		.endm

		movq (%rcx), %rax
		movq (%rsp), %rbx
		leaq env_home_str(%rip), %rdx
		STARTWITH 0
		cmove %rax, %rbx
		movq %rbx, (%rsp)

		movq (%rcx), %rax
		movq 8(%rsp), %rbx
		leaq env_xdg_data_home_str(%rip), %rdx
		STARTWITH 1
		cmove %rax, %rbx
		movq %rbx, 8(%rsp)

		addq $8, %rcx
		cmpq $0, (%rcx)
		jnz setup_data_el
	setup_data_eend:
	# (%rsp):  char* to HOME or null
	# 8(%rsp): char* to XDG_DATA_HOME, or null
	# rcx: char* to buffer for path
	leaq path_buf(%rip), %rcx
	cmpq $0, 8(%rsp)
	jz setup_data_path_home # if xdg isn't set: default to home
	movq 8(%rsp), %rax
	cmpb $0, (%rax)
	jz setup_data_path_home # if xdg is set but empty: default to home

	# copy string in rax to buf
	.macro STRPUSH suf
	_sdcp_l\suf\():
		movb (%rax), %dl
		movb %dl, (%rcx)
		incq %rcx
		incq %rax
		cmpb $0, (%rax)
		jnz _sdcp_l\suf
	.endm

	setup_data_path_xdg:
	pushq %rax
	STRPUSH 0 # put XDG_DATA_HOME at the begining of the path
	leaq path_xttrs(%rip), %rax
	STRPUSH 1 # path to directory is done
	# inc to skip a byte (null terminator)
	incq %rcx
	movq %rcx, file_path(%rip) # store address of new path
	popq %rax # get back XDG_DATA_HOME
	STRPUSH 2 # push it (ex: "/home/.../.local/share")
	leaq path_xttrs(%rip), %rax
	STRPUSH 3 # (ex: "/home/.../.local/share/xttrs")
	leaq path_bfile(%rip), %rax
	STRPUSH 4 # (ex: "/home/.../.local/share/xttrs/best_score")
	jmp setup_data_cont

	setup_data_path_home:
	cmpq $0, (%rsp)
	jz setup_data_giveup # home is unset: giveup
	movq (%rsp), %rax
	cmpb $0, (%rax)
	jz setup_data_giveup # home is empty: giveup

	pushq %rax
	STRPUSH 5 # push home (ex: "/home/...")
	leaq path_local(%rip), %rax
	STRPUSH 6 # push local (ex: "/home/.../.local/share")
	leaq path_xttrs(%rip), %rax
	STRPUSH 7 # push "/xttrs"

	incq %rcx
	movq %rcx, file_path(%rip)
	popq %rax
	STRPUSH 8 # push home (ex: "/home/...")
	leaq path_local(%rip), %rax
	STRPUSH 10 # push local (ex: "/home/.../.local/share")
	leaq path_xttrs(%rip), %rax
	STRPUSH 11 # push "/xttrs"
	leaq path_bfile(%rip), %rax
	STRPUSH 12

	setup_data_cont:
	addq $16, %rsp

	movq $SYS_ACCESS, %rax
	movq file_path(%rip), %rdi
	xorq %rsi, %rsi # F_OK
	syscall
	test %rax, %rax
	jz setup_data_file_exist
	# if were still here, the file doesn't exist
	# try mkdir
	movq $SYS_MKDIR, %rax
	leaq path_buf(%rip), %rdi
	movq $493, %rsi # drwxr-xr-x
	syscall

	movq $SYS_OPEN, %rax
	movq file_path(%rip), %rdi
	# O_RDWR | O_CREAT | O_CLOEXEC | O_SYNC
	movq $0x181042, %rsi
	# 0644
	movq $420, %rdx
	syscall
	movq %rax, best_score_fd(%rip)

	# write zero
	pushq $0
	movq $SYS_WRITE, %rax
	movq best_score_fd(%rip), %rdi
	movq %rsp, %rsi
	movq $8, %rdx
	syscall
	addq $8, %rsp

	SEEKSTART
	ret

	setup_data_file_exist:

	movq $SYS_OPEN, %rax
	movq file_path(%rip), %rdi
	# O_RDWR | O_CLOEXEC
	movq $0x80002, %rsi
	# 0644
	movq $420, %rdx
	syscall
	movq %rax, best_score_fd(%rip)
	call sync_best
	ret

	setup_data_giveup:
	addq $16, %rsp
	movq $-1, best_score_fd(%rip)
	ret
# rax is char** to args (argv), rdi has arg count, rcx is envp
setup:
	pushq %rcx

	xorq %r8, %r8
	cmpq $2, %rdi
	jb setup_start
	cmpq $3, %rdi
	jne setup_arg_failed

	addq $8, %rax # skip arg 0
	movq %rax, %rcx
	movq (%rax), %rax
	leaq arg_short(%rip), %rdx
	call strcmp
	je setup_arg
	leaq arg_long(%rip), %rdx
	call strcmp
	je setup_arg
	jmp setup_start

	setup_arg:
	addq $8, %rcx
	movq (%rcx), %rax # rax: char* to second arg
	call parse_number
	jnz setup_arg_failed
	movq $999, %r8
	cmpq %rax, %r8
	cmova %rax, %r8
	jmp setup_start
	setup_arg_failed:
	leaq panic_args(%rip), %rax
	call panic

	setup_start:
	popq %rcx # rcx has envp (a char**)
	pushq %r8
	call setup_data
	popq %r8

	# TODO: remove this for zeroed ?
	movq $0, current_width(%rip)
	movq $0, current_height(%rip)
	movb $0, current_piece(%rip)
	movb $0, current_piece_rotation(%rip)
	movq %r8, level(%rip)
	pushq %r8
	movq $31, %rcx
	cmpq %rcx, %r8
	cmova %rcx, %r8 # min(start_level, 31)
	leaq gravity_map(%rip), %rax
	movb (%rax, %r8, 1), %cl
	movzxb %cl, %rcx
	movq %rcx, gravity(%rip)
	popq %r8
	movq $0, counter_drop(%rip)
	movq $0, counter_entry_delay(%rip)
	movb $0, paused(%rip)
	movb $0, soft_drop(%rip)
	movb $0, next_piece(%rip)
	movq $0, score(%rip)
	movq $0, line_count(%rip)
	movq $0, tetris_rate(%rip)
	movq $0, burn_count(%rip)
	movq $0, drought_count(%rip)
	movq $0, soft_drop_counter(%rip)
	leaq current_piece_pos(%rip), %rax
	movq $0, (%rax)
	movq $0, 8(%rax)
	movq %r8, %rax # start level
	# * 10
	movq %rax, %rdx
	shlq $3, %rax
	addq %rdx, %rax
	addq %rdx, %rax

	movq %rax, %rdx
	addq $10, %rax # rax: start_level * 10 + 10
	subq $50, %rdx # rdx: start_level * 10 - 50
	movq $100, %rcx
	cmpq %rcx, %rdx
	cmovl %rcx, %rdx # rdx: max(100, start_level * 10 - 50)

	cmpq %rdx, %rax
	cmovg %rdx, %rax # rax: min(start_level * 10 + 10, max(100, start_level * 10 - 50))
	movq %rax, next_level(%rip)

	leaq pollfd(%rip), %rax
	movl $STDIN, (%rax)
	movl $POLLIN, 4(%rax)

	call get_time
	call merge_timestamp
	movq %rax, %rdx
	addq $100000000, %rax
	movq %rax, next_update(%rip)

	movq $SYNC_DELAY, %rdx
	shlq $6, %rdx
	addq %rdx, %rax # 1 min
	movq %rax, next_sync(%rip)

	call random_init
	
	# the first call to random should be a number in [1-7]
	_sl1:
	call random
	andq $0b111, %rax
	jz _sl1
	movb %al, next_piece(%rip)

	call reset_playfield
	call hide_cursor
	call enter_alt
	call set_raw
	call check_size

	movb $1, setup_completed(%rip)
	
	ret
cleanup:
	call unset_raw
	call leave_alt
	call show_cursor

	movq $SYS_CLOSE, %rax
	movq best_score_fd(%rip), %rdi
	syscall

	ret
# test if the current piece collides with anything
# puts 0 in rax if it doesn't, otherwise 1
collision:
	leaq current_piece_pos(%rip), %rax
	pushq (%rax)
	pushq 8(%rax)
	
	movzxb current_piece(%rip), %rsi
	leaq pieces(%rip), %rdi
	# rsi *= 40
	movq %rsi, %rcx
	shlq $5, %rsi
	shlq $3, %rcx
	addq %rcx, %rsi
	# rdi + rsi: address of current piece
	addq %rsi, %rdi
	movzxb current_piece_rotation(%rip), %rsi
	shlq $3, %rsi
	# rdi + rsi: address of current piece rotation
	addq %rsi, %rdi

	# rax: current piece pos x
	# rdx: current piece pos y
	# rdi: address of piece
	.macro CHECK_TILE
	movq 8(%rsp), %rax
	movq (%rsp), %rdx
	movsxb (%rdi), %rcx
	addq %rcx, %rax
	movsxb 1(%rdi), %rcx
	addq %rcx, %rdx
	cmpq $0, %rax
	jl _cl0
	cmpq $PLAYFIELD_WIDTH, %rax
	jge _cl0
	cmpq $0, %rdx
	jl _cl0
	cmpq $PLAYFIELD_HEIGHT, %rdx
	jge _cl0
	movq %rax, %rcx # x -> rcx
	movq %rdx, %rax # y -> rax
	movq $PLAYFIELD_WIDTH, %rdx # width -> rdx
	mulq %rdx # y * width -> rdx:rax
	addq %rcx, %rax # x + y * width -> rax
	leaq playfield(%rip), %rdx
	movb (%rdx, %rax, 1), %dl
	test %dl, %dl
	jnz _cl0 # jump if playfield isn't empty at that pos
	addq $2, %rdi
	.endm

	CHECK_TILE
	CHECK_TILE
	CHECK_TILE
	CHECK_TILE

	addq $16, %rsp
	xorq %rax, %rax
	ret

	_cl0:

	addq $16, %rsp
	xorq %rax, %rax
	incq %rax # do it this way to set the correct flags
	ret
update:
	cmpq $0, counter_death(%rip)
	je _uld

	_uldeath:
	incq counter_death(%rip)
	movq counter_death(%rip), %rax
	shrq $3, %rax
	cmpq $PLAYFIELD_VISIBLE_HEIGHT + 10, %rax
	jge exit
	ret

	_uld:
	cmpb $1, paused(%rip)
	jne _uls
	ret
	
	# set the best_score to max(best_score, score)
	# cobblers: rax, rdx
	.macro SETBESTSCORE
	movq score(%rip), %rax
	movq best_score(%rip), %rdx
	cmpq %rdx, %rax
	cmovb %rdx, %rax
	movq %rax, best_score(%rip)
	.endm

	_uls:
	movq counter_line_clear(%rip), %rax
	test %rax, %rax
	jz _ule
	decq counter_line_clear(%rip)
	cmpq $0, counter_line_clear(%rip)
	jz _ullc
	ret

	_ullc:

	movq $PLAYFIELD_HEIGHT, %rcx
	xorq %rax, %rax # offset
	leaq playfield(%rip), %rdx
	addq $PLAYFIELD_AREA, %rdx
	decq %rdx
	leaq row_cleared(%rip), %rbx
	_ullcrl:
		decq %rcx

		cmpb %cl, (%rbx)
		sete %r8b
		movzxb %r8b, %r8
		addq %r8, %rax
		addq %r8, %rbx
		negq %r8
		movq $PLAYFIELD_WIDTH, %rsi
		andq %r8, %rsi
		subq %rsi, %rdx
		cmpq $0, %r8
		js _ullcrltend

		movq $PLAYFIELD_WIDTH, %rsi
		_ullcrlt:
			movl $PLAYFIELD_WIDTH, %edi
			imull %eax, %edi
			movb (%rdx), %r8b
			movb %r8b, (%rdx, %rdi, 1)
			decq %rdx
			decq %rsi
			jnz _ullcrlt
		_ullcrltend:

		test %rcx, %rcx
		jnz _ullcrl
	movq row_cleared_length(%rip), %rax
	addq %rax, line_count(%rip)
	subq %rax, next_level(%rip)
	pushq %rax
	jg _ullcend
	
	addq $10, next_level(%rip)
	incq level(%rip)
	movq level(%rip), %rax
	leaq gravity_map(%rip), %rdx
	movb (%rdx, %rax, 1), %cl
	movb %cl, gravity(%rip)

	_ullcend:
	movq (%rsp), %rax
	decq %rax
	leaq multipliers(%rip), %rdx
	movq (%rdx, %rax, 8), %rdx
	movq level(%rip), %rax
	incq %rax
	mulq %rdx

	addq %rax, score(%rip)

	movq (%rsp), %rax
	shrq $2, %rax
	notq %rax
	andq $1, %rax
	addq %rax, burn_count(%rip)
	negq %rax
	andq %rax, burn_count(%rip)

	popq %rax
	shrq $2, %rax
	negq %rax
	andq $4, %rax
	addq %rax, tetris_line_count(%rip)

	movq tetris_line_count(%rip), %rax
	movq $100, %rdx
	mulq %rdx
	movq line_count(%rip), %rcx
	divq %rcx
	movq %rax, tetris_rate(%rip)

	SETBESTSCORE

	ret

	_ule:
	movq counter_entry_delay(%rip), %rax
	test %rax, %rax
	jz _ul0
	decq counter_entry_delay(%rip)
	ret

	_ul0:
	movb current_piece(%rip), %al
	test %al, %al
	jnz _ul1

	movb next_piece(%rip), %al
	movb %al, current_piece(%rip)

	cmpb $1, %al
	setne %al
	movzxb %al, %rax
	addq %rax, drought_count(%rip)
	negq %rax
	andq %rax, drought_count(%rip)

	_ulr1:
	call random
	andq $0b111, %rax
	jz _ulr1
	movb %al, next_piece(%rip)
	movb $0, current_piece_rotation(%rip)
	
	leaq current_piece_pos(%rip), %rax
	movq $PLAYFIELD_PIECE_START_X, (%rax)
	movq $PLAYFIELD_PIECE_START_Y, 8(%rax)

	call collision
	setnz %al
	movb %al, counter_death(%rip)
	negb %al
	notb %al
	andb %al, current_piece(%rip)

	ret
	
	_ul1:
	incq counter_drop(%rip)
	movq gravity(%rip), %rax # rax: gravity
	movq $SOFT_DROP_GRAVITY, %rcx # rcx: soft gravity
	movq %rax, %rdx # rdx: gravity
	cmpq %rax, %rcx
	cmovb %rcx, %rdx # rdx min(gravity, soft gravity)
	cmpb $1, soft_drop(%rip)
	cmove %rdx, %rax # rax: soft_drop ? min(gravity, soft gravity) : gravity
	cmpq %rax, counter_drop(%rip)
	jae _ul2
	
	ret

	_ul2:
	movq $0, counter_drop(%rip)
	leaq current_piece_pos(%rip), %rax
	incq 8(%rax)

	call collision
	jnz _ul3

	cmpb $1, soft_drop(%rip)
	sete %al
	movzxb %al, %rax
	addq %rax, soft_drop_counter(%rip)

	ret

	_ul3:
	leaq current_piece_pos(%rip), %rax
	decq 8(%rax)
	pushq (%rax)
	pushq 8(%rax)
	
	movzxb current_piece(%rip), %rsi
	leaq pieces(%rip), %rdi
	# rsi *= 40
	movq %rsi, %rcx
	shlq $5, %rsi
	shlq $3, %rcx
	addq %rcx, %rsi
	# rdi + rsi: address of current piece
	addq %rsi, %rdi
	movq 32(%rdi), %rbx
	andq $STYLES_MASK, %rbx # rbx: style
	movzxb current_piece_rotation(%rip), %rsi
	shlq $3, %rsi
	# rdi + rsi: address of current piece rotation
	addq %rsi, %rdi

	.macro PUT_BLOCK
	movq 8(%rsp), %rcx
	movq (%rsp), %rax
	movsxb (%rdi), %rdx
	addq %rdx, %rcx
	movsxb 1(%rdi), %rdx
	addq %rdx, %rax
	movq $PLAYFIELD_WIDTH, %rdx # width -> rdx
	mulq %rdx # y * width -> rdx:rax
	addq %rcx, %rax # x + y * width -> rax
	leaq playfield(%rip), %rdx
	movb %bl, (%rdx, %rax, 1)
	addq $2, %rdi
	.endm

	PUT_BLOCK
	PUT_BLOCK
	PUT_BLOCK
	PUT_BLOCK

	movq (%rsp), %rax
	addq $2, %rax
	shrq $2, %rax
	shlq $1, %rax
	movq $30, %rcx
	subq %rax, %rcx
	movq $20, %rax
	cmpq %rax, %rcx
	cmova %rax, %rcx
	# rcx has the computed ARE
	movq %rcx, counter_entry_delay(%rip)

	movb $0, soft_drop(%rip)

	addq $16, %rsp

	movb $0, current_piece(%rip)
	movq $0, row_cleared(%rip)
	# check for cleared rows
	movq $PLAYFIELD_HEIGHT, %rcx
	movq $PLAYFIELD_AREA, %rdi
	leaq playfield(%rip), %rdx
	leaq row_cleared(%rip), %r9
	decq %rdi
	decq %rsp
	movb $0, (%rsp)
	_ulcrl:
		xorq %rax, %rax # count of number of non empty tiles in the row
		movq $PLAYFIELD_WIDTH, %rsi
		_ulcrt:
			xorq %r8, %r8
			cmpb $0, (%rdx, %rdi, 1)
			setnz %r8b
			addq %r8, %rax
			decq %rdi
			decq %rsi
			jnz _ulcrt
		cmpq $10, %rax
		setae %bl
		movzxb %bl, %rbx

		addb %bl, (%rsp)

		movq %rbx, %r8
		negq %r8
		decq %rcx
		andq %rcx, %r8
		movb %r8b, (%r9)
		addq %rbx, %r9

		test %rcx, %rcx
		jnz _ulcrl
	movzxb (%rsp), %rcx
	incq %rsp
	movq $20, %rax
	xorq %rdx, %rdx
	cmpq $0, %rcx
	cmova %rax, %rdx
	movq %rdx, counter_line_clear(%rip)
	movq %rcx, row_cleared_length(%rip)

	movq soft_drop_counter(%rip), %rax
	addq %rax, score(%rip)
	movq $0, soft_drop_counter(%rip)

	SETBESTSCORE

	ret
# restart the current process
restart:
	call sync_best
	# exec ourselves with the same arguments and environment
	movq $SYS_EXECVE, %rax
	leaq exe_path(%rip), %rdi
	movq argv(%rip), %rsi
	movq envp(%rip), %rdx
	syscall
	# no ret since execve doesn't return
handle_input:
	cmpq $1, input_length(%rip)
	je hi_1
	cmpq $3, input_length(%rip)
	je hi_3

	# if message isn't 1 or 3 bytes long, ignore,
	# as it isn't something we care about
	jmp hi_end

	hi_1:
		movzxb paused(%rip), %rax
		cmpq $1, %rax
		jne hi_unpaused

		hi_paused:
		cmpb $KEY_Q, input_buf(%rip)
		je exit

		cmpb $KEY_R, input_buf(%rip)
		je restart

		xorq %rdx, %rdx
		cmpb $KEY_ESC, input_buf(%rip)
		cmove %rdx, %rax
		movb %al, paused(%rip)
		jmp hi_end

		hi_unpaused:
		cmpb $KEY_X, input_buf(%rip)
		je hi_rotate

		cmpb $KEY_ESC, input_buf(%rip)
		movq $1, %rdx
		cmove %rdx, %rax
		movb %al, paused(%rip)
		jmp hi_end
	hi_3:
		# ingnore if paused
		cmpb $1, paused(%rip)
		je hi_end

		cmpl $KEY_LEFT, input_buf(%rip)
		je hi_left

		cmpl $KEY_RIGHT, input_buf(%rip)
		je hi_right

		cmpl $KEY_DOWN, input_buf(%rip)
		je hi_down

		jmp hi_end
	hi_left:
		movq current_piece_pos(%rip), %r10
		decq current_piece_pos(%rip)
		call collision
		movq current_piece_pos(%rip), %rax
		cmovnz %r10, %rax
		movq %rax, current_piece_pos(%rip)
		jmp hi_end
	hi_right:
		movq current_piece_pos(%rip), %r10
		incq current_piece_pos(%rip)
		call collision
		movq current_piece_pos(%rip), %rax
		cmovnz %r10, %rax
		movq %rax, current_piece_pos(%rip)
		jmp hi_end
	hi_rotate:
		movzxb current_piece_rotation(%rip), %r10
		incb current_piece_rotation(%rip)
		andb $0b11, current_piece_rotation(%rip)
		call collision
		movzxb current_piece_rotation(%rip), %rax
		cmovnz %r10, %rax
		movb %al, current_piece_rotation(%rip)
		jmp hi_end
	hi_down:
		movq $0, soft_drop_counter(%rip)
		xorq $1, soft_drop(%rip)
		jmp hi_end # for symetry
	hi_end:
		# clear inpupt buffer, this ensures that after each read,
		# all bytes past the read length are 0.
		movq $0, input_buf(%rip)
	ret
_start:
	popq %rax # rax has number of arguments
	movq %rax, %rdi # rdi too
	incq %rax # +1 (to account for the NULL at the end of argv)
	shlq $3, %rax # rax now has offset from argv (ptr) to envp (ptr)
	movq %rsp, %rcx # rcx has argv
	movq %rsp, %rdx # rdx has argv
	addq %rax, %rdx # rdx has envp
	movq %rcx, argv(%rip)
	movq %rdx, envp(%rip)
	
	movq %rcx, %rax
	movq %rdx, %rcx
	movq %rdi, %rdx
	call setup

	loop:
		call get_time
		call merge_timestamp
		movq %rax, %rdx
		
		movq next_sync(%rip), %rax
		subq %rdx, %rax
		jns loop_s

		pushq %rdx
		call sync_best
		popq %rdx
		movq $SYNC_DELAY, %rax
		shlq $6, %rax
		addq %rdx, %rax
		movq %rax, next_sync(%rip)

		loop_s:
		movq next_update(%rip), %rax
		subq %rdx, %rax
		js _mll0 # cut to update if deadline has been passed
		xorq %rdx, %rdx
		movq $1000000, %rdi
		divq %rdi

		movq %rax, %rdx
		movq $SYS_POLL, %rax
		leaq pollfd(%rip), %rdi
		movq $1, %rsi
		syscall

		test %rax, %rax
		jz _mll0

		# there is input to be read
		movq $SYS_READ, %rax
		movq $STDIN, %rdi
		leaq input_buf(%rip), %rsi
		movq $8, %rdx
		syscall

		movq %rax, input_length(%rip)

		call handle_input
		jmp loop # go back in case there is more input

		_mll0:
		call check_size
		call update
		call draw_full
		addq $FRAME_DURATION, next_update(%rip)
		jmp loop

	exit:
	call sync_best
	call cleanup

	movq $SYS_EXIT, %rax
	movq $0, %rdi
	syscall

