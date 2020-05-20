# TAG = lb
    .text
        lui   x1, %hi(var1)     # x1 <- 0x?????000
        addi  x1, x1, %lo(var1) # x1 <- addr[var1]
        lb   x31, 0(x1)         # rd <- mem[addr[var1]]
        lb   x31, 4(x1)         # rd <- mem[addr[var2]] / addr[var1] + 4 = addr[var2]
        addi  x1, x1, 4         # x1 <- addr[var2]      / addr[var1] + 4 = addr[var2]
        lb   x31, 0(x1)         # rd <- mem[addr[var2]]
        lb   x31, -4(x1)        # rd <- mem[addr[var1]] / addr[var2] - 4 = addr[var1]
        lb   x31, 4(x1)         # rd <- mem[addr[var3]] / addr[var2] + 4 = addr[var3]
        lb   x31, 8(x1)         # rd <- mem[addr[var4]] / addr[var2] + 8 = addr[var4]

    .data
        var1: .byte 1
        var2: .byte 0x22
        var3: .byte 0x33
        var4: .byte -16

    # max_cycle 50
    # pout_start
    # 00000001
    # 00000022
    # 00000022
    # 00000001
    # 00000033
    # 000000F0
    # pout_end
