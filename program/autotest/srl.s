# TAG = srl
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
	srl x31, x0, x1      # rd <- décalage 0x00000000 de 1  vers la gauche = 0x00000000
	srl x31, x10, x0     # rd <- décalage 0x000007FF de 0  vers la gauche = 0x000007FF
	srl x31, x10, x1     # rd <- décalage 0x000007FF de 1  vers la gauche = 0x000003FF
	srl x31, x10, x2     # rd <- décalage 0x000007FF de 2  vers la gauche = 0x000001FF
	srl x31, x10, x3     # rd <- décalage 0x000007FF de 3  vers la gauche = 0x000000FF
	srl x31, x10, x4     # rd <- décalage 0x000007FF de 4  vers la gauche = 0x0000007F
	srl x31, x10, x5     # rd <- décalage 0x000007FF de 7  vers la gauche = 0x0000000F
	srl x31, x10, x6     # rd <- décalage 0x000007FF de 10 vers la gauche = 0x00000001
	srl x31, x10, x7     # rd <- décalage 0x000007FF de 11 vers la gauche = 0x00000000
	srl x31, x11, x2     # rd <- décalage 0xFFFFF800 de 2  vers la gauche = 0x3FFFFE00
	srl x31, x11, x7     # rd <- décalage 0xFFFFF800 de 11 vers la gauche = 0x001FFFFF
	srl x31, x11, x8     # rd <- décalage 0xFFFFF800 de 16 vers la gauche = 0x0000FFFF
	srl x31, x11, x9     # rd <- décalage 0xFFFFF800 de 31 vers la gauche = 0x00000001
	srl x31, x11, x19    # rd <- décalage 0xFFFFF800 de 32 vers la gauche = 0xFFFFF800

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
	# 3FFFFE00
	# 001FFFFF
	# 0000FFFF
	# 00000001
	# FFFFF800
	# pout_end
