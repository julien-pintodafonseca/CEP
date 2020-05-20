# TAG = jal
    .text
        addi x31, x0, 1   # [Adresse 0x1000] ok
        addi x31, x0, 2   # [Adresse 0x1004] ok
        addi x31, x0, 3   # [Adresse 0x1008] ok
        jal  x31, goto_a  # {Adresse 0x100C} / rd <- 0x1010
        addi x31, x0, 4   # [Adresse 0x1010] !ok
    goto_a:
        jal  x31, goto_b  # {Adresse 0x1014} / rd <- 0x1018
        addi x31, x0, 5   # [Adresse 0x1018] !ok
        addi x31, x0, 6   # [Adresse 0x101C] !ok
        addi x31, x0, 7   # [Adresse 0x1020] !ok
    goto_b:
        addi x31, x0, 8   # [Adresse 0x1024] ok
        addi x31, x0, 9   # [Adresse 0x1028] ok
        jal  x31, goto_c  # {Adresse 0x102C} / rd <- 0x1030
    goto_c:
        addi x31, x0, 0xA # [Adresse 0x1030] ok
        addi x31, x0, 0xB # [Adresse 0x1034] ok
        jal  x31, goto_c  # {Adresse 0x1038} / rd <- 0x103C
        addi x31, x0, 0xC # !ok
        addi x31, x0, 0xD # !ok
        addi x31, x0, 0xE # !ok
        addi x31, x0, 0xF # ...
    
    # max_cycle 100
    # pout_start
    # 00000001
    # 00000002
    # 00000003
    # 00001010
    # 00001018
    # 00000008
    # 00000009
    # 00001030
    # 0000000A
    # 0000000B
    # 0000103C
    # 0000000A
    # 0000000B
    # 0000103C
    # 0000000A
    # 0000000B
    # 0000103C
    # 0000000A
    # 0000000B
    # pout_end
