# TAG = lb
    .text
        lui  x1, %hi(var1)     # x1 <- 0x?????000
        addi x1, x1, %lo(var1) # x1 <- addr[var1]
        lb  x31, 0(x1)         # rd <- mem[addr[var1]]
        lb  x31, 1(x1)         # rd <- mem[addr[var2]] / addr[var1] + 1 = addr[var2]
        addi x1, x1, 1         # x1 <- addr[var2]      / addr[var1] + 1 = addr[var2]
        lb  x31, 0(x1)         # rd <- mem[addr[var2]]
        lb  x31, -1(x1)        # rd <- mem[addr[var1]] / addr[var2] - 1 = addr[var1]
        lb  x31, 2(x1)         # rd <- mem[addr[var3]] / addr[var2] + 2 = addr[var3]
        lb  x31, 6(x1)         # rd <- mem[addr[var4]] / addr[var2] + 6 = addr[var4]

    .data
        var1: .byte  1
        var2: .hword 0xAB22
        var3: .word  0xABCDEF33
        var4: .byte  -16

    # max_cycle 50
    # pout_start
    # 00000001
    # 00000022
    # 00000022
    # 00000001
    # 00000033
    # 000000F0
    # pout_end
