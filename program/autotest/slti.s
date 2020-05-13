# TAG = slti
	.text
    slti x31, x0, 0     # 0 >= 0         / rd vaut 1
	addi x1, x0, 2042
	addi x2, x0, -2042
    slti x31, x1, -2042 # 2042 >= -2042  / rd vaut 1
    slti x31, x2, 2042  # -2042 < 2042   / rd vaut 0
	addi x1, x0, -2002
	addi x2, x0, -1999
    slti x31, x1, -1999 # -2002 < -1999  / rd vaut 0
    slti x31, x2, -2002 # -1999 >= -2002 / rd vaut 1
	addi x1, x0, 42
	addi x2, x0, 92
    slti x31, x1, 92    # 42 < 92        / rd vaut 0
    slti x31, x2, 42    # 92 >= 42       / rd vaut 1

	# max_cycle 50
	# pout_start
	# 00000001
	# 00000001
	# 00000000
	# 00000000
	# 00000001
	# 00000000
	# 00000001
	# pout_end
