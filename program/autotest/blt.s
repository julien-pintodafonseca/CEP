# TAG = blt
    .text
	addi x1, x0, -11
	addi x31, x0, 9
	blt x1, x31, goto_a # jcond valide car -11 < 9
	addi x31, x0, 1
goto_a:
	addi x1, x0, -42
	addi x31, x0, -42
	blt x31, x1, goto_b # jcond invalide car -42 >= -42
	addi x31, x0, 6
goto_b:
	addi x31, x0, 0
	
    # max_cycle 50
    # pout_start
    # 00000009
    # FFFFFFD6
    # 00000006
    # 00000000
    # pout_end
