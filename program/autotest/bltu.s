# TAG = bltu
	.text
	addi x1, x0, 11
	addi x31, x0, 2042
	bltu x1, x31, goto_a # jcond valide car 11 < 2042
	addi x31, x0, 1
goto_a:
	lui x1, 0xFFFFF
	addi x31, x0, 42
	bltu x1, x31, goto_b # jcond invalide car (x1) >= 42
	addi x31, x0, 6
goto_b:
	addi x31, x0, 0
	
	# max_cycle 50
	# pout_start
	# 000007FA
	# 0000002A
	# 00000006
	# 00000000
	# pout_end
