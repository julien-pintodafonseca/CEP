# TAG = sb
    .text
        lui  x1,  %hi(var1)     # x1 <- 0x?????000
        addi x1,  x1, %lo(var1) # x1 <- addr[var1]
        lui  x2,  0x10101       # x2 <- 0x10101000
        addi x2,  x2, 0x010     # x2 <- 0x00000010
        sb   x2,  0(x1)         # mem[addr[var1]] <- x2
        lbu x31, 0(x1)          # rd <- mem[addr[var1]]

        lui  x3,  %hi(var2)     # x3 <- 0x?????000
        addi x3,  x3, %lo(var2) # x3 <- addr[var2]
        lui  x4,  0x21212       # x4 <- 0x21212000
        addi x4,  x4, 0x121     # x4 <- 0x00000121
        sb   x4,  0(x3)         # mem[addr[var2]] <- x4
        lbu x31, 0(x3)          # rd <- mem[addr[var2]]

        lui  x5,  %hi(var3)     # x5 <- 0x?????000
        addi x5,  x5, %lo(var3) # x5 <- addr[var3]
        lui  x6,  0x32323       # x6 <- 0x32323000
        addi x6,  x6, 0x232     # x6 <- 0x00000232
        sb   x6,  0(x5)         # mem[addr[var3]] <- x6
        lbu x31, 0(x5)          # rd <- mem[addr[var3]]

        lui  x7,  0x77777       # x6 <- 0x77777000
        addi x7,  x7, 0x177     # x6 <- 0x00000177
        sb   x7,  -4(x5)        # mem[addr[var1]] <- x7 / addr[var3] - 4 = addr[var1]
        lbu x31, 0(x1)          # rd <- mem[addr[var1]]

        lui  x8,  0x88888       # x6 <- 0x88888000
        addi x8,  x8, 0x188     # x6 <- 0x00000188
        sb   x8,  2(x1)         # mem[addr[var2]] <- x8 / addr[var1] + 2 = addr[var2]
        lbu x31, 0(x3)          # rd <- mem[addr[var2]]

        lui  x9,  0x99999       # x6 <- 0x99999000
        addi x9,  x9, 0x199     # x6 <- 0x00000199
        sb   x9,  4(x1)         # mem[addr[var3]] <- x9 / addr[var1] + 4 = addr[var3]
        lbu x31, 0(x5)          # rd <- mem[addr[var3]]

    .data
        var1: .hword 0x1111
        var2: .hword 0x2222
        var3: .word 0xABCD3333

    # max_cycle 150
    # pout_start
    # 00000010
    # 00000021
    # 00000032
    # 00000077
    # 00000088
    # 00000099
    # pout_end
