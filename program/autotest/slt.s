# TAG = slt
    .text
        slt x31, x0, x0    # 0 >= 0         / rd <- 1
        addi x1, x0, 2042
        addi x2, x0, -2042
        slt x31, x1, x2    # 2042 >= -2042  / rd <- 1
        slt x31, x2, x1    # -2042 < 2042   / rd <- 0
        addi x1, x0, -2002
        addi x2, x0, -1999
        slt x31, x1, x2    # -2002 < -1999  / rd <- 0
        slt x31, x2, x1    # -1999 >= -2002 / rd <- 1
        addi x1, x0, 42
        addi x2, x0, 92
        slt x31, x1, x2    # 42 < 92        / rd <- 0
        slt x31, x2, x1    # 92 >= 42       / rd <- 1

    # max_cycle 50
    # pout_start
    # 00000001
    # 00000001
    # 00000000
    # 00000000
    # 00000001
    # 00000000
    # 00000001
    # pout_end
