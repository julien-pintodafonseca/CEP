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

    -- Variables
    signal TO_CSR : w32;
    signal mstatus : w32;

begin
    -- Registres
    registers : process (all)
    begin
        -- Gestion TO_CSR_sel
        if cmd.TO_CSR_Sel = TO_CSR_from_rs1 then
            TO_CSR <= rs1;
        elsif cmd.TO_CSR_Sel = TO_CSR_from_imm then
            TO_CSR <= imm;
        end if;

        -- Gestion CSR_sel
        if cmd.CSR_sel = CSR_from_mcause then
            csr <= mcause;
        elsif cmd.CSR_sel = CSR_from_mip then
            -- csr <= mip;
        elsif cmd.CSR_sel = CSR_from_mie then
            -- csr <= mie;
        elsif cmd.CSR_sel = CSR_from_mstatus then
            csr <= mstatus;
        elsif cmd.CSR_sel = CSR_from_mtvec then
            -- csr <= mtvec;
        elsif cmd.CSR_sel = CSR_from_mepc then
            -- csr <= mepc;
        end if;

        -- mstatus[MIE] <- 0
        if cmd.MSTATUS_mie_reset = '1' then
            mstatus(3) <= '0';
        end if;

        -- mstatus[MIE] <- 1
        if cmd.MSTATUS_mie_set = '1' then
            mstatus(3) <= '1';
        end if;

        -- Interruption timer
        mip(7) <= mtip;
        -- Interruption externe
        mip(11) <= meip;
    end process registers;

    it <= irq AND mstatus(3);
end architecture;
