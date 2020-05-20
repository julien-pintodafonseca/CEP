# TAG = srai
    .text
        addi x1, x0, 0x7FF
        addi x2, x0, -0x800
        sra x31, x0, 1      # rd <- décalage 0x00000000 de 1  vers la gauche = 0x00000000
        sra x31, x1, 0      # rd <- décalage 0x000007FF de 0  vers la gauche = 0x000007FF
        sra x31, x1, 1      # rd <- décalage 0x000007FF de 1  vers la gauche = 0x000003FF
        sra x31, x1, 2      # rd <- décalage 0x000007FF de 2  vers la gauche = 0x000001FF
        sra x31, x1, 3      # rd <- décalage 0x000007FF de 3  vers la gauche = 0x000000FF
        sra x31, x1, 4      # rd <- décalage 0x000007FF de 4  vers la gauche = 0x0000007F
        sra x31, x1, 7      # rd <- décalage 0x000007FF de 7  vers la gauche = 0x0000000F
        sra x31, x1, 10     # rd <- décalage 0x000007FF de 10 vers la gauche = 0x00000001
        sra x31, x1, 11     # rd <- décalage 0x000007FF de 11 vers la gauche = 0x00000000
        sra x31, x2, 2      # rd <- décalage 0xFFFFF800 de 2  vers la gauche = 0xFFFFFE00
        sra x31, x2, 11     # rd <- décalage 0xFFFFF800 de 11 vers la gauche = 0xFFFFFFFF
        sra x31, x2, 16     # rd <- décalage 0xFFFFF800 de 16 vers la gauche = 0xFFFFFFFF
        sra x31, x2, 31     # rd <- décalage 0xFFFFF800 de 31 vers la gauche = 0xFFFFFFFF

    # max_cycle 100
    # pout_start
    # 00000000
    # 000007FF
    # 000003FF
    # 000001FF
    # 000000FF
    # 0000007F
    # 0000000F
    # 00000001
    # 00000000
    # FFFFFE00
    # FFFFFFFF
    # FFFFFFFF
    # FFFFFFFF
    # pout_end
