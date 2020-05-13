# TAG = sub
    .text
	addi x1, x0, -1
	addi x2, x0, 9
	addi x3, x0, -15
	addi x7, x0, 0x7FF
	addi x8, x0, -0x800
	addi x9, x0, -0x7FF
	sub x31, x0, x0     # rd <- registre 0 - registre 0  / 0 - 0 = 0
	sub x31, x31, x0    # rd <- registre 31 - registre 0 / 0 - 0 = 0
	sub x31, x0, x2     # rd <- registre 0 - registre 2  / 0 - 9 = -9
	sub x31, x31, x3    # rd <- registre 31 - registre 3 / -9 - -15 = 6
	sub x31, x1, x7     # rd <- registre 1 - registre 7  / -1 - 0x7FF = -0x800
	sub x31, x0, x9     # rd <- registre 0 - registre 9  / 0 - -0x7FF = 0x7FF
	sub x31, x8, x9     # rd <- registre 8 - registre 8  / -0x800 - -0x7FF = -1
	sub x31, x1, x31    # rd <- registre 1 - registre 31 / 1 - -1 = 0

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# FFFFFFF7
	# 00000006
	# FFFFF800
	# 000007FF
	# FFFFFFFF
	# 00000000
	# pout_end
