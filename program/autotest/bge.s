# TAG = bge
    .text
	addi x1, x0, -11
	addi x31, x0, 9
	bge x1, x31, goto_a # jcond invalide car -11 < 9
	addi x31, x0, 1
goto_a:
	addi x1, x0, -42
	addi x31, x0, -42
	bge x1, x31, goto_b # jcond valide car -42 >= -42
	addi x31, x0, 6
goto_b:
	addi x31, x0, 0
	
	# max_cycle 50
	# pout_start
	# 00000009
	# 00000001
	# FFFFFFD6
	# 00000000
	# pout_end
