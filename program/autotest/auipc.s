# TAG = auipc
    .text
	auipc x31, 0x00000 # rd <- 0x00001000 + 0x00000 = 0x00001000 | pc <- pc+4
	auipc x31, 0x00000 # rd <- 0x00001004 + 0x00000 = 0x00001004 | pc <- pc+4
	auipc x31, 0x00002 # rd <- 0x00001008 + 0x00002 = 0x00003008 | pc <- pc+4
	auipc x31, 0x12345 # rd <- 0x0000100C + 0x12345 = 0x1234600C | pc <- pc+4

	# max_cycle 50
	# pout_start
	# 00001000
	# 00001004
	# 00003008
	# 1234600C
	# pout_end
