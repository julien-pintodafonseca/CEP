# TAG = lui
    .text
        lui x31, 0       # rd <- chargement d'une valeur nulle
        lui x31, 0xFFFFF # rd <- chargement d'une valeur maximal sur 20 bits
        lui x31, 0x12345 # rd <- chargement d'une valeur quelconque

    # max_cycle 50
    # pout_start
    # 00000000
    # FFFFF000
    # 12345000
    # pout_end
