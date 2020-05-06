# TAG = add
	.text
	addi x1, x0, 1
	addi x2, x0, 9
	addi x3, x0, -15
	addi x7, x0, 0x7FF
	addi x8, x0, -0x7FF
	addi x9, x0, -0x800
	add x31, x0, x0  #Test addition registre 0 + registre 0  / 0 + 0 = 0
	add x31, x31, x0 #Test addition registre 31 + registre 0 / 0 + 0 = 0
	add x31, x0, x2  #Test addition registre 0 + registre 2  / 0 + 9 = 9
	add x31, x31, x3 #Test addition registre 31 + registre 3 / 9 + (-15) = -4
	add x31, x0, x7  #Test addition registre 0 + registre 7  / 0 + 0x7FF = 0x7FF
	add x31, x7, x8  #Test addition registre 7 + registre 8  / 0x7FF + -0x7FF = 0
	add x31, x31, x9 #Test addition registre 31 + registre 9 / 0 + -0x800 = -0x800
	add x31, x9, x7  #Test addition registre 9 + registre 7  / -0x800 + 0x7FF = -1
	add x31, x1, x31 #Test addition registre 1 + registre 31 / 1 + -1 = 0

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# 00000009
	# FFFFFFFA
	# 000007FF
	# 00000000
	# FFFFF800
	# FFFFFFFF
	# 00000000
	# pout_end
