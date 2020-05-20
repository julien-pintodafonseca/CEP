# TAG = lw
    .text
        lui  x1, %hi(var1)     # x1 <- 0x?????000
        addi x1, x1, %lo(var1) # x1 <- addr[var1]
        lw  x31, 0(x1)         # rd <- mem[addr[var1]]
        lw  x31, 4(x1)         # rd <- mem[addr[var2]] / addr[var1] + 4 = addr[var2]
        addi x1, x1, 4         # x1 <- addr[var2]      / addr[var1] + 4 = addr[var2]
        lw  x31, 0(x1)         # rd <- mem[addr[var2]]
        lw  x31, -4(x1)        # rd <- mem[addr[var1]] / addr[var2] - 4 = addr[var1]
        lw  x31, 4(x1)         # rd <- mem[addr[var3]] / addr[var2] + 4 = addr[var3]
        lw  x31, 8(x1)         # rd <- mem[addr[var4]] / addr[var2] + 8 = addr[var4]

    .data
        var1: .word 0x11111111
        var2: .word 0x22222222
        var3: .word 0x33333333
        var4: .word 0x44444444

    # max_cycle 50
    # pout_start
    # 11111111
    # 22222222
    # 22222222
    # 11111111
    # 33333333
    # 44444444
    # pout_end
