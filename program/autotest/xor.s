# TAG = xor
    .text
	addi x1, x0, 1
	xor x31, x0, x0  # rd <- registre 0  XOR registre 0 / 0 XOR 0 = 0
	xor x31, x1, x1  # rd <- registre 1  XOR registre 1 / 1 XOR 1 = 0
	xor x31, x0, x1  # rd <- registre 0  XOR registre 1 / 0 XOR 1 = 1
	xor x31, x1, x0  # rd <- registre 1  XOR registre 0 / 1 XOR 0 = 1
	xor x31, x31, x0 # rd <- registre 31 XOR registre 0 / 1 XOR 0 = 1
	xor x31, x0, x1  # rd <- registre 0  XOR registre 1 / 0 XOR 1 = 1
	xor x31, x31, x1 # rd <- registre 31 XOR registre 1 / 1 XOR 1 = 0

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# 00000001
	# 00000001
	# 00000001
	# 00000001
	# 00000000
	# pout_end
