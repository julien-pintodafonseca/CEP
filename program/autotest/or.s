# TAG = or
    .text
	addi x1, x0, 1
	or x31, x0, x0  # rd <- registre 0  OR registre 0 / 0 OR 0 = 0
	or x31, x1, x1  # rd <- registre 1  OR registre 1 / 1 OR 1 = 1
	or x31, x0, x1  # rd <- registre 0  OR registre 1 / 0 OR 1 = 1
	or x31, x1, x0  # rd <- registre 1  OR registre 0 / 1 OR 0 = 1
	or x31, x31, x0 # rd <- registre 31 OR registre 0 / 1 OR 0 = 1
	or x31, x0, x0  # rd <- registre 0  OR registre 0 / 0 OR 0 = 0
	or x31, x31, x1 # rd <- registre 31 OR registre 1 / 0 OR 1 = 1

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000001
	# 00000001
	# 00000001
	# 00000000
	# 00000001
	# pout_end
