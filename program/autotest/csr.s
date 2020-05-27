# TAG = csr
    .text
        # Programme de test permettant d'autoriser les interruptions externes et de les traiter
        # Source : CEP_cdc.pdf - page 15
        # ------------------------------------------------------------------------------------------

        lui x30, 0x12341
        addi x31, x30, 0x234        # x31 <- 0x12341234 : on indique que le programme commence

        lui   x1, %hi(traitant)     # charge mtvec avec l'adresse du traitant
        addi  x1, x1, %lo(traitant) # les deux lignes sont équivalentes à li x1,traitant
        csrrw x0, mtvec, x1

        addi  x1, x0, 1 << 3        # rend globalemement sensible aux interruptions
        csrrs x0, mstatus, x1       # Machine Interrupt Enable bit (MIE de mstatus) à 1
        addi  x1, x0, 1 << 2        # rend sensible à l'interruption des poussoirs dans le PLIC
        lui   x2, 0x0C002           # *(0xC002000) = 2
        sw    x1, 0(x2)

        addi  x1, x0, 0x7FF         # autorise des interruptions venant du PLIC
        addi  x1, x1, 1             # bit 11 = 0x800 => 0x7ff + 1, car constante 12 bits signée pour addi
                                    # les deux lignes précédentes étant équivalente à li x1,0x800
        csrrs x0, mie, x1           # Machine Extern Interrupt Enable bit (MEIE de mie) à 1

        addi  x2, x0, 0

    attente:
        beq   x2, x0, attente       # tourne tant que x2 vaut 0
        addi x31, x0, 0x5AD         # x31 <- 0x5AD : on indique que l'on a reçu et traité l'interruption
        j attente                   # boucle infinie

    traitant:
        lui  x30, 0x87654
        addi x31, x30, 0x321        # x31 <- 0x87654321 : on indique que l'on traite l'interruption

        addi  x2, x0, 1             # change x2 pour sortir de la boucle infinie
        lui   x3, 0x0C200           # acquitte l'interruption dans le plic
        addi  x3, x3, 4             # les deux lignes sont équivalentes à li x3,0x0C200004
        lw    x1, 0(x3)             # par lecture de l'adresse 0x0c2000004
        mret                        # retour d'interruption

    # irq_start
    # 50
    # irq_end

    # max_cycle 200
    # pout_start
    # 12341234
    # 87654321
    # 000005AD
    # 000005AD
    # 000005AD
    # pout_end
