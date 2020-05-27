# TAG = pgcd2
    .text
        # PGCD(306,758) = 2 (0x2)
        # --------------------

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

        beq x11, x22, end_while # if (A == B) then goto end_while
    while:
        bge x11, x22, else      # if (A <= B) then goto else
        sub x22, x22, x11       # B <- (B - A)
        sw x22, 0(x2)           # store(B)
        jal x0, end_if          # goto end_if
    else:
        sub x11, x11, x22       # A <- (A - B)
        sw x11, 0(x1)           # store(A)
    end_if:
        bne x11, x22, while     # if (A != B) then goto while
    end_while:

        lw x31, 0(x1)           # x31 <- load(B)
    .data
        var_a: .word 306 # var A
        var_b: .word 758 # var B

    # max_cycle 400
    # pout_start
    # 00000002
    # pout_end
