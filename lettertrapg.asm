# ============================================================
# Letter Trap - Pakistan Cities Edition (FINAL FIXED)
# MIPS Assembly - Hangman Game
# ============================================================
.data
bitmap_buffer: .space 16384

word1: .asciiz "karachi"
word2: .asciiz "lahore"
word3: .asciiz "quetta"
word4: .asciiz "multan"
word5: .asciiz "islamabad"
word6: .asciiz "peshawar"
word7: .asciiz "faisalabad"
word8: .asciiz "hyderabad"
word9: .asciiz "sialkot"
word10: .asciiz "rawalpindi"

hint1: .asciiz "HINT: Largest city, capital of Sindh (Port city on Arabian Sea)\n"
hint2: .asciiz "HINT: Cultural capital Punjab - City of Gardens\n"
hint3: .asciiz "HINT: Capital of Balochistan province\n"
hint4: .asciiz "HINT: City of Saints in Punjab - famous for mangoes\n"
hint5: .asciiz "HINT: Federal Capital of Pakistan (ICT)\n"
hint6: .asciiz "HINT: Capital of Khyber Pakhtunkhwa province\n"
hint7: .asciiz "HINT: Third largest city Punjab - Textile hub\n"
hint8: .asciiz "HINT: Second largest city of Sindh province\n"
hint9: .asciiz "HINT: City in Punjab - famous for sports goods exports\n"
hint10: .asciiz "HINT: City in Punjab - twin city of Islamabad\n"

word_addr: .word word1,word2,word3,word4,word5,word6,word7,word8,word9,word10
hint_addr: .word hint1,hint2,hint3,hint4,hint5,hint6,hint7,hint8,hint9,hint10

display: .space 32

msg_title: .asciiz "\n========================================\n LETTER TRAP - Pakistan Cities Edition\n========================================\n"
msg_menu: .asciiz "\nChoose a Word (1-9)\nYour choice: "
msg_invalid: .asciiz "Invalid choice. Using 1.\n"
msg_sep: .asciiz "----------------------------------------\n"
msg_word: .asciiz "Word: "
msg_prompt: .asciiz "Guess a letter: "
msg_correct: .asciiz "Correct!\n"
msg_wrong: .asciiz "Wrong guess!\n"
msg_att: .asciiz "Wrong: "
msg_of6: .asciiz " of 6\n"
msg_win: .asciiz "\n*** Congratulations! You guessed the city! ***\n"
msg_lose: .asciiz "\n*** GAME OVER! The city was: "
msg_nl: .asciiz "\n"
msg_bminfo: .asciiz "\n"

.text

main:
    li $v0, 4
    la $a0, msg_title
    syscall

    jal bitmap_clear
    jal draw_gallows

    li $v0, 4
    la $a0, msg_menu
    syscall

    li $v0, 12
    syscall
    move $t0, $v0
    li $v0, 12
    syscall

    li $t9, '1'
    li $t8, '9'
    li $t7, 'A'
    li $t6, 'a'

    blt $t0, $t9, _bad
    bgt $t0, $t8, _checkA
    sub $t0, $t0, $t9
    j _go

_checkA:
    beq $t0, $t7, _useR
    beq $t0, $t6, _useR
    j _bad

_useR:
    li $t0, 9
    j _go

_bad:
    li $v0, 4
    la $a0, msg_invalid
    syscall
    li $t0, 0

_go:
    sll $t1, $t0, 2
    la $t2, word_addr
    add $t2, $t2, $t1
    lw $s0, 0($t2)

    la $t2, hint_addr
    add $t2, $t2, $t1
    lw $a0, 0($t2)
    li $v0, 4
    syscall

    li $v0, 4
    la $a0, msg_bminfo
    syscall

    li $s2, 0
    la $s3, display
    jal str_len
    move $s1, $v0
    jal fill_underscores

game_loop:
    li $v0, 4
    la $a0, msg_sep
    syscall

    jal show_word

    li $v0, 4
    la $a0, msg_att
    syscall
    li $v0, 1
    move $a0, $s2
    syscall
    li $v0, 4
    la $a0, msg_of6
    syscall

    li $v0, 4
    la $a0, msg_prompt
    syscall

    li $v0, 12
    syscall
    move $s4, $v0
    li $v0, 12
    syscall

    jal match_letter
    beq $v0, 1, _hit

    li $v0, 4
    la $a0, msg_wrong
    syscall
    addi $s2, $s2, 1
    move $a0, $s2
    jal paint_part
    bge $s2, 6, do_lose
    j game_loop

_hit:
    li $v0, 4
    la $a0, msg_correct
    syscall
    jal all_revealed
    beq $v0, 1, do_win
    j game_loop

do_win:
    jal show_word
    jal paint_win
    li $v0, 4
    la $a0, msg_win
    syscall
    j exit_game

do_lose:
    jal show_word
    jal paint_all
    li $v0, 4
    la $a0, msg_lose
    syscall
    li $v0, 4
    move $a0, $s0
    syscall
    li $v0, 4
    la $a0, msg_nl
    syscall

exit_game:
    li $v0, 10
    syscall

# ============================================================
str_len:
    move $t0, $s0
    li $v0, 0
_sl_loop:
    lbu $t1, 0($t0)
    beq $t1, $zero, _sl_done
    addi $t0, $t0, 1
    addi $v0, $v0, 1
    j _sl_loop
_sl_done:
    jr $ra

fill_underscores:
    move $t0, $s3
    move $t1, $s1
    li $t2, '_'
_fu_loop:
    beq $t1, $zero, _fu_done
    sb $t2, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j _fu_loop
_fu_done:
    sb $zero, 0($t0)
    jr $ra

show_word:
    li $v0, 4
    la $a0, msg_word
    syscall
    move $t0, $s3
    move $t1, $s1
_sw_loop:
    beq $t1, $zero, _sw_done
    lbu $a0, 0($t0)
    li $v0, 11
    syscall
    li $a0, ' '
    li $v0, 11
    syscall
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j _sw_loop
_sw_done:
    li $v0, 4
    la $a0, msg_nl
    syscall
    jr $ra

match_letter:
    move $t0, $s0
    move $t1, $s3
    move $t2, $s1
    li $v0, 0
_ml_loop:
    beq $t2, $zero, _ml_done
    lbu $t3, 0($t0)
    bne $t3, $s4, _ml_next
    sb $t3, 0($t1)
    li $v0, 1
_ml_next:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t2, $t2, -1
    j _ml_loop
_ml_done:
    jr $ra

all_revealed:
    move $t0, $s3
    move $t1, $s1
    li $t2, '_'
_ar_loop:
    beq $t1, $zero, _ar_yes
    lbu $t3, 0($t0)
    beq $t3, $t2, _ar_no
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j _ar_loop
_ar_yes:
    li $v0, 1
    jr $ra
_ar_no:
    li $v0, 0
    jr $ra

# ============================================================
draw_pixel:
    lui $k0, 0x1001
    mul $k1, $a1, 64
    add $k1, $k1, $a0
    sll $k1, $k1, 2
    add $k0, $k0, $k1
    sw $a2, 0($k0)
    jr $ra

draw_box:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s6, 4($sp)
    sw $s7, 8($sp)
    sw $t4, 12($sp)
    sw $t5, 16($sp)
    sw $t6, 20($sp)
    sw $t7, 24($sp)
    sw $t8, 28($sp)

    move $s6, $a0
    move $s7, $a1
    move $t4, $a2
    move $t5, $a3

    li $t6, 0
_bx_row_loop:
    bge $t6, $t5, _bx_done
    li $t7, 0
_bx_col_loop:
    bge $t7, $t4, _bx_next_row
    add $t8, $s7, $t6
    lui $k0, 0x1001
    mul $k1, $t8, 64
    add $k1, $k1, $s6
    add $k1, $k1, $t7
    sll $k1, $k1, 2
    add $k0, $k0, $k1
    sw $v1, 0($k0)
    addi $t7, $t7, 1
    j _bx_col_loop
_bx_next_row:
    addi $t6, $t6, 1
    j _bx_row_loop
_bx_done:
    lw $ra, 0($sp)
    lw $s6, 4($sp)
    lw $s7, 8($sp)
    lw $t4, 12($sp)
    lw $t5, 16($sp)
    lw $t6, 20($sp)
    lw $t7, 24($sp)
    lw $t8, 28($sp)
    addi $sp, $sp, 32
    jr $ra

bitmap_clear:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v1, 0x1a1a2e
    li $a0, 0
    li $a1, 0
    li $a2, 64
    li $a3, 64
    jal draw_box
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_gallows:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v1, 0xd0d0d0

    # Base
    li $a0, 5
    li $a1, 55
    li $a2, 32
    li $a3, 3
    jal draw_box

    # Pole
    li $a0, 11
    li $a1, 8
    li $a2, 3
    li $a3, 48
    jal draw_box

    # Beam
    li $a0, 11
    li $a1, 8
    li $a2, 26
    li $a3, 3
    jal draw_box

    # Rope
    li $a0, 34
    li $a1, 11
    li $a2, 2
    li $a3, 7
    jal draw_box

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

paint_part:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    beq $a0, 1, _pp_head
    beq $a0, 2, _pp_body
    beq $a0, 3, _pp_larm
    beq $a0, 4, _pp_rarm
    beq $a0, 5, _pp_lleg
    beq $a0, 6, _pp_rleg
    j _pp_done

_pp_head:
    li $v1, 0xff4444
    li $a0, 31
    li $a1, 18
    li $a2, 7
    li $a3, 7
    jal draw_box
    j _pp_done

_pp_body:
    li $v1, 0xffd700
    li $a0, 34
    li $a1, 25
    li $a2, 3
    li $a3, 10
    jal draw_box
    j _pp_done

_pp_larm:
    li $v1, 0x44cc66
    li $a0, 26
    li $a1, 27
    li $a2, 8
    li $a3, 2
    jal draw_box
    j _pp_done

_pp_rarm:
    li $v1, 0x44cc66
    li $a0, 37
    li $a1, 27
    li $a2, 8
    li $a3, 2
    jal draw_box
    j _pp_done

_pp_lleg:
    li $v1, 0x44cc66
    li $a0, 30
    li $a1, 35
    li $a2, 4
    li $a3, 9
    jal draw_box
    j _pp_done

_pp_rleg:
    li $v1, 0x44cc66
    li $a0, 37
    li $a1, 35
    li $a2, 4
    li $a3, 9
    jal draw_box

_pp_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

paint_all:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $a0, 1
    jal paint_part
    li $a0, 2
    jal paint_part
    li $a0, 3
    jal paint_part
    li $a0, 4
    jal paint_part
    li $a0, 5
    jal paint_part
    li $a0, 6
    jal paint_part
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

paint_win:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v1, 0x00cc44
    li $a0, 0
    li $a1, 47
    li $a2, 64
    li $a3, 17
    jal draw_box
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra