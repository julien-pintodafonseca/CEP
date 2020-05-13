# TAG = addi
    .text
	addi x31, x0, 0       # rd <- registre 0  + valeur nulle            / 0 + 0 = 0
	addi x31, x0, -99     # rd <- registre 0  + valeur négative         / 0 + 99 = 99
	addi x31, x0, 11      # rd <- registre 0  + valeur positive         / 0 + 11 = 11
	addi x31, x31, -5     # rd <- registre 31 + valeur négative         / 11 + -5 = 6
	addi x31, x31, 1993   # rd <- registre 31 + valeur quelconque       / 6 + 1993 = 1999
	addi x31, x31, 0      # rd <- registre 31 + valeur nulle            / 1999 + 0 = 1999
	addi x31, x31, -1999  # rd <- registre 31 + valeur négative inverse / 1999 + -1999 = 0
	addi x31, x31, 0x7FF  # rd <- registre 31 + valeur maximale         / 0 + 0x7FF = 0x7FF
	addi x31, x31, -0x7FF # rd <- registre 31 + valeur négative inverse / 0x7FF + -0x7FF = 0
	addi x31, x31, -0x800 # rd <- registre 31 + valeur minimale         / 0 + -0x800 = -0x800
	addi x31, x31, 0x7FF  # rd <- registre 31 + valeur positive inverse / -0x800 + 0x7FF = -1
	addi x31, x31, 1      # rd <- registre 31 + valeur 1                / -1 + 1 = 0

	# max_cycle 50
	# pout_start
	# 00000000
	# FFFFFF9D
	# 0000000B
	# 00000006
	# 000007CF
	# 000007CF
	# 00000000
	# 000007FF
	# 00000000
	# FFFFF800
	# FFFFFFFF
	# 00000000
	# pout_end
