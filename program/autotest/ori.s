# TAG = ori
	.text
	addi x1, x0, 1
	ori x31, x0, 0  #Test registre 0 OR valeur 0  / 0 OR 0 = 0
	ori x31, x1, 1  #Test registre 1 OR valeur 1  / 1 OR 1 = 1
	ori x31, x0, 1  #Test registre 0 OR valeur 1  / 0 OR 1 = 1
	ori x31, x1, 0  #Test registre 1 OR valeur 0  / 1 OR 0 = 1
	ori x31, x31, 0 #Test registre 31 OR valeur 0 / 1 OR 0 = 1
	ori x31, x0, 0  #Test registre 0 OR valeur 0  / 0 OR 0 = 0
	ori x31, x31, 1 #Test registre 31 OR valeur 1 / 0 OR 1 = 1

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
