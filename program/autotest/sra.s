# TAG = sra
	.text
	addi x1, x0, 1
	addi x2, x0, 2
	addi x3, x0, 3
	addi x4, x0, 4
	addi x5, x0, 7
	addi x6, x0, 10
	addi x7, x0, 11
	addi x8, x0, 16
	addi x9, x0, 31
	addi x19, x0, 32
	addi x10, x0, 0x7FF
	addi x11, x0, -0x800
	sra x31, x0, x1   #Test décalage 0x00000000 de 1  vers la gauche = 0x00000000
	sra x31, x10, x0  #Test décalage 0x000007FF de 0  vers la gauche = 0x000007FF
	sra x31, x10, x1  #Test décalage 0x000007FF de 1  vers la gauche = 0x000003FF
	sra x31, x10, x2  #Test décalage 0x000007FF de 2  vers la gauche = 0x000001FF
	sra x31, x10, x3  #Test décalage 0x000007FF de 3  vers la gauche = 0x000000FF
	sra x31, x10, x4  #Test décalage 0x000007FF de 4  vers la gauche = 0x0000007F
	sra x31, x10, x5  #Test décalage 0x000007FF de 7  vers la gauche = 0x0000000F
	sra x31, x10, x6  #Test décalage 0x000007FF de 10 vers la gauche = 0x00000001
	sra x31, x10, x7  #Test décalage 0x000007FF de 11 vers la gauche = 0x00000000
	sra x31, x11, x2  #Test décalage 0xFFFFF800 de 2  vers la gauche = 0xFFFFFE00
	sra x31, x11, x7  #Test décalage 0xFFFFF800 de 11 vers la gauche = 0xFFFFFFFF
	sra x31, x11, x8  #Test décalage 0xFFFFF800 de 16 vers la gauche = 0xFFFFFFFF
	sra x31, x11, x9  #Test décalage 0xFFFFF800 de 31 vers la gauche = 0xFFFFFFFF
	sra x31, x11, x19 #Test décalage 0xFFFFF800 de 32 vers la gauche = 0xFFFFF800

	# max_cycle 100
	# pout_start
	# 00000000
	# 000007FF
	# 000003FF
	# 000001FF
	# 000000FF
	# 0000007F
	# 0000000F
	# 00000001
	# 00000000
	# FFFFFE00
	# FFFFFFFF
	# FFFFFFFF
	# FFFFFFFF
	# FFFFF800
	# pout_end
