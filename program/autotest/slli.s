# TAG = slli
    .text
        addi x10,  x0, 0x7FF
        addi x11,  x0, -0x800
        slli x31,  x0, 1      # rd <- décalage 0x00000000 de 1  vers la gauche = 0x00000000
        slli x31, x10, 0      # rd <- décalage 0x000007FF de 0  vers la gauche = 0x000007FF
        slli x31, x10, 1      # rd <- décalage 0x000007FF de 1  vers la gauche = 0x00000FFE
        slli x31, x10, 2      # rd <- décalage 0x000007FF de 2  vers la gauche = 0x00001FFC
        slli x31, x10, 3      # rd <- décalage 0x000007FF de 3  vers la gauche = 0x00003FF8
        slli x31, x10, 4      # rd <- décalage 0x000007FF de 4  vers la gauche = 0x00007FF0
        slli x31, x10, 16     # rd <- décalage 0x000007FF de 16 vers la gauche = 0x07FF0000
        slli x31, x10, 21     # rd <- décalage 0x000007FF de 21 vers la gauche = 0xFFE00000
        slli x31, x10, 31     # rd <- décalage 0x000007FF de 31 vers la gauche = 0x80000000
        slli x31, x11, 4      # rd <- décalage 0xFFFFF800 de 4  vers la gauche = 0xFFFF8000
        slli x31, x11, 16     # rd <- décalage 0xFFFFF800 de 16 vers la gauche = 0xF8000000
        slli x31, x11, 31     # rd <- décalage 0xFFFFF800 de 31 vers la gauche = 0x00000000

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
    # FFFF8000
    # F8000000
    # 00000000
    # pout_end
