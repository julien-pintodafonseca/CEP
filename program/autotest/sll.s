# TAG = sll
    .text
        addi  x1,  x0, 1
        addi  x2,  x0, 2
        addi  x3,  x0, 3
        addi  x4,  x0, 4
        addi  x5,  x0, 16
        addi  x6,  x0, 21
        addi  x7,  x0, 31
        addi  x8,  x0, 32
        addi  x9,  x0, 63
        addi x10,  x0, 0x7FF
        addi x11,  x0, -0x800
        sll  x31,  x0, x1     # rd <- décalage 0x00000000 de 1  vers la gauche = 0x00000000
        sll  x31, x10, x0     # rd <- décalage 0x000007FF de 0  vers la gauche = 0x000007FF
        sll  x31, x10, x1     # rd <- décalage 0x000007FF de 1  vers la gauche = 0x00000FFE
        sll  x31, x10, x2     # rd <- décalage 0x000007FF de 2  vers la gauche = 0x00001FFC
        sll  x31, x10, x3     # rd <- décalage 0x000007FF de 3  vers la gauche = 0x00003FF8
        sll  x31, x10, x4     # rd <- décalage 0x000007FF de 4  vers la gauche = 0x00007FF0
        sll  x31, x10, x5     # rd <- décalage 0x000007FF de 16 vers la gauche = 0x07FF0000
        sll  x31, x10, x6     # rd <- décalage 0x000007FF de 21 vers la gauche = 0xFFE00000
        sll  x31, x10, x7     # rd <- décalage 0x000007FF de 31 vers la gauche = 0x80000000
        sll  x31, x10, x8     # rd <- décalage 0x000007FF de 32 vers la gauche = 0x000007FF
        sll  x31, x10, x9     # rd <- décalage 0x000007FF de 63 vers la gauche = 0x80000000
        sll  x31, x11, x4     # rd <- décalage 0xFFFFF800 de 4  vers la gauche = 0xFFFF8000
        sll  x31, x11, x5     # rd <- décalage 0xFFFFF800 de 16 vers la gauche = 0xF8000000
        sll  x31, x11, x7     # rd <- décalage 0xFFFFF800 de 31 vers la gauche = 0x00000000
        sll  x31, x11, x8     # rd <- décalage 0xFFFFF800 de 32 vers la gauche = 0xFFFFF800

    # max_cycle 100
    # pout_start
    # 00000000
    # 000007FF
    # 00000FFE
    # 00001FFC
    # 00003FF8
    # 00007FF0
    # 07FF0000
    # FFE00000
    # 80000000
    # 000007FF
    # 80000000
    # FFFF8000
    # F8000000
    # 00000000
    # FFFFF800
    # pout_end
