# TAG = csr_pgcd
    .text
        # PGCD(624,408) = 24 (0x18)
        # Le calcul PGCD s'exécute uniquement lorsque le programme principale est interrompu et
        # que l'interruption est traitée
        # ------------------------------------------------------------------------------------------
        
        # x1 <- addr[A]
        lui x1, %hi(var_a)
        addi x1, x1, %lo(var_a)
        # x2 <- addr[B]
        lui x2, %hi(var_b)
        addi x2, x2, %lo(var_b)

        # x11 <- load(A)
        lw x11, 0(x1)
        # x22 <- load(B)
        lw x22, 0(x2)

        # --- On va autoriser les interruptions externes et permettre de les traiter
        
        lui   x5, %hi(traitant)     # charge mtvec avec l'adresse du traitant
        addi  x5, x5, %lo(traitant) # les deux lignes sont équivalentes à li x5,traitant
        csrrw x0, mtvec, x5

        addi  x5, x0, 1 << 3        # rend globalemement sensible aux interruptions
        csrrs x0, mstatus, x5       # Machine Interrupt Enable bit (MIE de mstatus) à 1
        addi  x5, x0, 1 << 2        # rend sensible à l'interruption des poussoirs dans le PLIC
        lui   x6, 0x0C002           # *(0xC002000) = 2
        sw    x5, 0(x6)

        addi  x5, x0, 0x7FF         # autorise des interruptions venant du PLIC
        addi  x5, x5, 1             # bit 11 = 0x800 => 0x7ff + 1, car constante 12 bits signée pour addi
                                    # les deux lignes précédentes étant équivalente à li x5,0x800
        csrrs x0, mie, x5           # Machine Extern Interrupt Enable bit (MEIE de mie) à 1

        addi  x6, x0, 0

    attente:
        beq   x6, x0, attente       # tourne tant que x6 vaut 0
        # --- On a reçu et traité l'interruption, on lance le programme de calcul de PGCD
        beq x11, x22, end_while     # if (A == B) then goto end_while
    while:
        bge x11, x22, else          # if (A <= B) then goto else
        sub x22, x22, x11           # B <- (B - A)
        sw x22, 0(x2)               # store(B)
        jal x0, end_if              # goto end_if
    else:
        sub x11, x11, x22           # A <- (A - B)
        sw x11, 0(x1)               # store(A)
    end_if:
        bne x11, x22, while         # if (A != B) then goto while
    end_while:
        # --- On boucle sur le résultat du PGCD
        lw x31, 0(x1)               # x31 <- load(B)
        j end_while                 # boucle infinie

    traitant:
        # --- On traite l'interruption
        addi  x6, x0, 1             # change x6 pour sortir de la boucle infinie
        lui   x7, 0x0C200           # acquitte l'interruption dans le plic
        addi  x7, x7, 4             # les deux lignes sont équivalentes à li x7,0x0C200004
        lw    x5, 0(x7)             # par lecture de l'adresse 0x0c2000004
        mret                        # retour d'interruption

    .data
        var_a: .word 624 # var A
        var_b: .word 408 # var B

    # irq_start
    # 200
    # irq_end

    # max_cycle 5000
    # pout_start
    # 00000018
    # 00000018
    # 00000018
    # 00000018
    # 00000018
    # pout_end
