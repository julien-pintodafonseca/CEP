# TAG = lhu
    .text
        lui  x1, %hi(var1)     # x1 <- 0x?????000
        addi x1, x1, %lo(var1) # x1 <- addr[var1]
        lhu x31, 0(x1)         # rd <- mem[addr[var1]]
        lhu x31, 2(x1)         # rd <- mem[addr[var2]] / addr[var1] + 2 = addr[var2]
        addi x1, x1, 2         # x1 <- addr[var2]      / addr[var1] + 2 = addr[var2]
        lhu x31, 0(x1)         # rd <- mem[addr[var2]]
        lhu x31, -2(x1)        # rd <- mem[addr[var1]] / addr[var2] - 2 = addr[var1]
        lhu x31, 2(x1)         # rd <- mem[addr[var3]] / addr[var2] + 2 = addr[var3]
        lhu x31, 6(x1)         # rd <- mem[addr[var4]] / addr[var2] + 6 = addr[var4]

    .data
        var1: .hword 1
        var2: .hword 0x2222
        var3: .word  0xCDFE3333
        var4: .hword -2048

    # max_cycle 50
    # pout_start
    # 00000001
    # 00002222
    # 00002222
    # 00000001
    # 00003333
    # 0000F800
    # pout_end
