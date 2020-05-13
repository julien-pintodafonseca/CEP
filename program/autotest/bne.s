# TAG = bne
    .text
	lui x1, 11
	lui x31, 12
	bne x1, x31, goto_a 
	lui x31, 1
goto_a:
	lui x1, 42
	lui x31, 42
	bne x31, x1, goto_b
	lui x31, 6
goto_b:
	lui x31, 0
	
    # max_cycle 50
    # pout_start
    # 0000C000
    # 0002A000
    # 00006000
    # 00000000
    # pout_end
