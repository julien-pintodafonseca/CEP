library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CSR is
    generic (
        INTERRUPT_VECTOR : waddr   := w32_zero;
        mutant           : integer := 0
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Interface de et vers la PO
        cmd         : in  PO_cs_cmd;
        it          : out std_logic;
        pc          : in  w32;
        rs1         : in  w32;
        imm         : in  W32;
        csr         : out w32;
        mtvec       : out w32;
        mepc        : out w32;

        -- Interface de et vers les IP d'interruption
        irq         : in  std_logic;
        meip        : in  std_logic;
        mtip        : in  std_logic;
        mie         : out w32;
        mip         : out w32;
        mcause      : in  w32
    );
end entity;

architecture RTL of CPU_CSR is
    -- Fonction retournant la valeur à écrire dans un csr en fonction
    -- du « mode » d'écriture, qui dépend de l'instruction
    function CSR_write (CSR        : w32;
                        CSR_reg    : w32;
                        WRITE_mode : CSR_WRITE_mode_type)
        return w32 is
        variable res : w32;
    begin
        case WRITE_mode is
            when WRITE_mode_simple =>
                res := CSR;
            when WRITE_mode_set =>
                res := CSR_reg or CSR;
            when WRITE_mode_clear =>
                res := CSR_reg and (not CSR);
            when others => null;
        end case;
        return res;
    end CSR_write;

    -- Signaux
    signal mcause_d, mcause_q : w32;
    signal mip_d, mip_q : w32;
    signal mie_d, mie_q : w32;
    signal mstatus_d, mstatus_q : w32;
    signal mtvec_d, mtvec_q : w32;
    signal mepc_d, mepc_q : w32;
    signal TO_CSR : w32;

begin
    -- Registre CSR, gestion de l'horloge
    csr_register_clock : process (clk)
    begin
        if clk'event and clk='1' then
            if rst ='1' then
                mcause_q  <= w32_zero;
                mip_q     <= w32_zero;
                mie_q     <= w32_zero;
                mstatus_q <= w32_zero;
                mtvec_q   <= w32_zero;
                mepc_q    <= w32_zero;
            else
                mcause_q  <= mcause_d;
                mip_q     <= mip_d;
                mie_q     <= mie_d;
                mstatus_q <= mstatus_d;
                mtvec_q   <= mtvec_d;
                mepc_q    <= mepc_d;
            end if;
        end if;
    end process csr_register_clock;

    -- Registre CSR, gestion principale
    csr_register_main : process (all)
    begin
        -- Les registres prennent leur ancienne valeur par défaut
        mcause_d  <= mcause_q;
        mip_d     <= mip_q;
        mie_d     <= mie_q;
        mstatus_d <= mstatus_q;
        mtvec_d   <= mtvec_q;
        mepc_d    <= mepc_q;

        -- Gestion mcause
        if irq = '1' then
            mcause_d <= mcause;
        end if;

        -- Gestion mip
        mip_d(7) <= mtip; -- Interruption timer
        mip_d(11) <= meip; -- Interruption externe

        -- Selection TO_CSR_sel / Gestion TO_CSR
        if cmd.TO_CSR_Sel = TO_CSR_from_rs1 then
            TO_CSR <= rs1;
        elsif cmd.TO_CSR_Sel = TO_CSR_from_imm then
            TO_CSR <= imm;
        end if;

        -- Gestion mie
        if cmd.CSR_we = CSR_mie then
            mie_d <= CSR_write(TO_CSR, mie_q, cmd.CSR_WRITE_mode);
        end if;

        -- Gestion mstatus_set
        if cmd.MSTATUS_mie_set = '1' then
            mstatus_d(3) <= '1';
        end if;

        -- Gestion mstatus
        if cmd.CSR_we = CSR_mstatus then
            mstatus_d <= CSR_write(TO_CSR, mstatus_q, cmd.CSR_WRITE_mode);
        end if;

        -- Gestion mstatus_reset
        if cmd.MSTATUS_mie_reset = '1' then
            mstatus_d(3) <= '0';
        end if;

        -- Gestion mtvec
        if cmd.CSR_we = CSR_mtvec then
            mtvec_d <= CSR_write(TO_CSR, mtvec_q, cmd.CSR_WRITE_mode);
            mtvec_d(0) <= '0';
            mtvec_d(1) <= '0';
        end if;

        -- Gestion mepc
        if cmd.CSR_we = CSR_mepc then
            if cmd.MEPC_sel = MEPC_from_pc then
                mepc_d <= CSR_write(pc, mepc_q, cmd.CSR_WRITE_mode);
            elsif cmd.MEPC_sel = MEPC_from_csr then
                mepc_d <= CSR_write(TO_CSR, mepc_q, cmd.CSR_WRITE_mode);
            end if;
            mepc_d(0) <= '0';
            mepc_d(1) <= '0';
        end if;

        -- Selection CSR_sel / Gestion sortie csr
        if cmd.CSR_sel = CSR_from_mcause then
            csr <= mcause_q;
        elsif cmd.CSR_sel = CSR_from_mip then
            csr <= mip_q;
        elsif cmd.CSR_sel = CSR_from_mie then
            csr <= mie_q;
        elsif cmd.CSR_sel = CSR_from_mstatus then
            csr <= mstatus_q;
        elsif cmd.CSR_sel = CSR_from_mtvec then
            csr <= mtvec_q;
        elsif cmd.CSR_sel = CSR_from_mepc then
            csr <= mepc_q;
        end if;
    end process csr_register_main;

    -- Sorties
    mip <= mip_q;
    mie <= mie_q;
    it <= irq AND mstatus_q(3);
    mtvec <= mtvec_q;
    mepc <= mepc_q;

end architecture;
