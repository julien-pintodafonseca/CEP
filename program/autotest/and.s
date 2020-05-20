# TAG = and
    .text
        addi x1,  x0, 1
        and x31,  x0, x0  # rd <- registre 0  AND registre 0  / 0 AND 0 = 0
        and x31,  x1, x1  # rd <- registre 1  AND registre 1  / 1 AND 1 = 1
        and x31,  x0, x1  # rd <- registre 0  AND registre 1  / 0 AND 1 = 0
        and x31,  x1, x0  # rd <- registre 1  AND registre 0  / 1 AND 0 = 0
        and x31, x31, x0  # rd <- registre 31 AND registre 0  / 0 AND 0 = 0
        and x31,  x1, x1  # rd <- registre 1  AND registre 1  / 1 AND 1 = 1
        and x31,  x1, x31 # rd <- registre 1  AND registre 31 / 1 AND 1 = 1

    # max_cycle 50
    # pout_start
    # 00000000
    # 00000001
    # 00000000
    # 00000000
    # 00000000
    # 00000001
    # 00000001
    # pout_end
