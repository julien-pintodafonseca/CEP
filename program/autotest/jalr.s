# TAG = jalr
    .text
        lui x10, 0x00001    # [Adresse 0x1000] ok
        addi x1, x10, 0x028 # [Adresse 0x1004] ok
        addi x2, x10, 0x044 # [Adresse 0x1008] ok
        addi x3, x10, 0x030 # [Adresse 0x100C] ok

        addi x31, x0, 1     # [Adresse 0x1010] ok
        addi x31, x0, 2     # [Adresse 0x1014] ok
        addi x31, x0, 3     # [Adresse 0x1018] ok
        jalr x31, 0(x1)     # {Adresse 0x101C} / rd <- 0x1020
        addi x31, x0, 4     # [Adresse 0x1020] !ok
        addi x31, x0, 5     # [Adresse 0x1024] !ok
        addi x31, x0, 6     # [Adresse 0x1028] ok
        addi x31, x0, 7     # [Adresse 0x102C] ok
        jalr x31, -8(x2)    # {Adresse 0x1030} / rd <- 0x1034
        addi x31, x0, 8     # [Adresse 0x1034] !ok
        addi x31, x0, 9     # [Adresse 0x1038] !ok
        addi x31, x0, 0xA   # [Adresse 0x103C] ok
        addi x31, x0, 0xB   # [Adresse 0x1040] ok
        addi x31, x0, 0xC   # [Adresse 0x1044] ok
        jalr x31, 16(x3)    # {Adresse 0x1048} / rd <- 0x104C
        addi x31, x0, 0xD   # !ok
        addi x31, x0, 0xE   # !ok
        addi x31, x0, 0xF   # ...
    
    # max_cycle 100
    # pout_start
    # 00000001
    # 00000002
    # 00000003
    # 00001020
    # 00000006
    # 00000007
    # 00001034
    # 0000000A
    # 0000000B
    # 0000000C
    # 0000104C
    # 0000000B
    # 0000000C
    # 0000104C
    # 0000000B
    # 0000000C
    # 0000104C
    # 0000000B
    # 0000000C
    # pout_end
