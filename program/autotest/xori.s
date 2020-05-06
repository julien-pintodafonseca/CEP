# TAG = xori
	.text
	addi x1, x0, 1
	xori x31, x0, 0  #Test registre 0 XOR valeur 0  / 0 XOR 0 = 0
	xori x31, x1, 1  #Test registre 1 XOR valeur 1  / 1 XOR 1 = 0
	xori x31, x0, 1  #Test registre 0 XOR valeur 1  / 0 XOR 1 = 1
	xori x31, x1, 0  #Test registre 1 XOR valeur 0  / 1 XOR 0 = 1
	xori x31, x31, 0 #Test registre 31 XOR valeur 0 / 1 XOR 0 = 1
	xori x31, x0, 1  #Test registre 0 XOR valeur 1  / 0 XOR 1 = 1
	xori x31, x31, 1 #Test registre 31 XOR valeur 1 / 1 XOR 1 = 0

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
