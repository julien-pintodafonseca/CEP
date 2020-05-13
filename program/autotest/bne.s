# TAG = bne
	.text
	addi x1, x0, 11
	addi x31, x0, 12
	bne x1, x31, goto_a # jcond valide car 11 != 12
	addi x31, x0, 1
goto_a:
	addi x1, x0, 42
	addi x31, x0, 42
	bne x1, x31, goto_b # jcond invalide car 42 == 42
	addi x31, x0, 6
goto_b:
	addi x31, x0, 0
	
	# max_cycle 50
	# pout_start
	# 0000000C
	# 0000002A
	# 00000006
	# 00000000
	# pout_end
