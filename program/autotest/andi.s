# TAG = andi
	.text
	addi x1, x0, 1
	andi x31, x0, 0  #Test registre 0 AND valeur 0  / 0 AND 0 = 0
	andi x31, x1, 1  #Test registre 1 AND valeur 1  / 1 AND 1 = 1
	andi x31, x0, 1  #Test registre 0 AND valeur 1  / 0 AND 1 = 0
	andi x31, x1, 0  #Test registre 1 AND valeur 0  / 1 AND 0 = 0
	andi x31, x31, 0 #Test registre 31 AND valeur 0 / 0 AND 0 = 0
	andi x31, x1, 1  #Test registre 1 AND valeur 1  / 1 AND 1 = 1
	andi x31, x31, 1 #Test registre 31 AND valeur 1 / 1 AND 1 = 1

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# 00000000
	# 00000000
	# 00000001
	# 00000001
	# pout_end
