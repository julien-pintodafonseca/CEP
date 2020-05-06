# TAG = ori
	.text
	addi x1, x0, 1
	ori x31, x0, 0  #Test registre 0 ORI 0  / 0 ORI 0 = 0
	ori x31, x1, 1  #Test registre 1 ORI 1  / 1 ORI 1 = 1
	ori x31, x0, 1  #Test registre 0 ORI 1  / 0 ORI 1 = 1
	ori x31, x1, 0  #Test registre 1 ORI 0  / 1 ORI 0 = 1
	ori x31, x31, 0 #Test registre 31 ORI 0 / 1 ORI 0 = 1
	ori x31, x0, 0  #Test registre 0 ORI 0  / 0 ORI 0 = 0
	ori x31, x31, 1 #Test registre 31 ORI 1 / 0 ORI 1 = 1

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
