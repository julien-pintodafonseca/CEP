# TAG = sltiu
    .text
	sltiu x31, x0, 0    # 0 >= 0     / rd <- 1
	addi x1, x0, 42
	addi x2, x0, 92
	sltiu x31, x1, 92   # 42 < 92    / rd <- 0
	sltiu x31, x2, 42   # 92 >= 42   / rd <- 1
	lui x3, 0xFFFFF
	sltiu x31, x3, 92   # (x3) >= 92 / rd <- 1
	sltiu x31, x2, 2042 # 92 < 2042  / rd <- 0

	# max_cycle 50
	# pout_start
	# 00000001
	# 00000000
	# 00000001
	# 00000001
	# 00000000
	# pout_end
