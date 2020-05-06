library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
    generic(
        mutant: integer := 0
    );
    Port (
        -- Clock/Reset
        clk    : in  std_logic ;
        rst    : in  std_logic ;

        -- Interface PC to PO
        cmd    : out PO_cmd ;
        status : in  PO_status
    );
end entity;

architecture RTL of CPU_PC is
    type State_type is (
        S_Error,
        S_Init,
        S_Pre_Fetch,
        S_Fetch,
        S_Decode,
        S_LUI,
        S_ADDI,
        S_ADD,
        S_AND
    );

    signal state_d, state_q : State_type;


begin

    FSM_synchrone : process(clk)
    begin
        if clk'event and clk='1' then
            if rst='1' then
                state_q <= S_Init;
            else
                state_q <= state_d;
            end if;
        end if;
    end process FSM_synchrone;

    FSM_comb : process (state_q, status)
    begin

        -- Valeurs par défaut de cmd à définir selon les préférences de chacun
        cmd.ALU_op            <= UNDEFINED;
        cmd.LOGICAL_op        <= UNDEFINED;
        cmd.ALU_Y_sel         <= UNDEFINED;

        cmd.SHIFTER_op        <= UNDEFINED;
        cmd.SHIFTER_Y_sel     <= UNDEFINED;

        cmd.RF_we             <= '0';
        cmd.RF_SIZE_sel       <= UNDEFINED;
        cmd.RF_SIGN_enable    <= '0';
        cmd.DATA_sel          <= UNDEFINED;

        cmd.PC_we             <= '0';
        cmd.PC_sel            <= UNDEFINED;

        cmd.PC_X_sel          <= UNDEFINED;
        cmd.PC_Y_sel          <= UNDEFINED;

        cmd.TO_PC_Y_sel       <= UNDEFINED;

        cmd.AD_we             <= '0';
        cmd.AD_Y_sel          <= UNDEFINED;

        cmd.IR_we             <= '0';

        cmd.ADDR_sel          <= UNDEFINED;
        cmd.mem_we            <= '0';
        cmd.mem_ce            <= '0';

        cmd.cs.CSR_we            <= UNDEFINED;

        cmd.cs.TO_CSR_sel        <= UNDEFINED;
        cmd.cs.CSR_sel           <= UNDEFINED;
        cmd.cs.MEPC_sel          <= UNDEFINED;

        cmd.cs.MSTATUS_mie_set   <= 'U';
        cmd.cs.MSTATUS_mie_reset <= 'U';

        cmd.cs.CSR_WRITE_mode    <= UNDEFINED;

        state_d <= state_q;

        case state_q is
            when S_Error =>
                -- Etat transitoire en cas d'instruction non reconnue 
                -- Aucune action
                state_d <= S_Init;

            when S_Init =>
                -- PC <- RESET_VECTOR
                cmd.PC_we <= '1';
                cmd.PC_sel <= PC_rstvec;
                state_d <= S_Pre_Fetch;

            when S_Pre_Fetch =>
                -- mem[PC]
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                cmd.ADDR_sel <= ADDR_from_pc;
                state_d <= S_Fetch;

            when S_Fetch =>
                -- IR <- mem_datain
                cmd.IR_we <= '1';
                state_d <= S_Decode;

            when S_Decode =>
                -- (prévoir cas spéciaux pour les branchements et auipc)

                --- PC <- PC + 4
                cmd.TO_PC_Y_sel <= To_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                --- Changement d'etat
                case status.IR(6 downto 0) is
                    when "0110111" =>
                        -- LUI
                        state_d <= S_LUI;
                    when "0010011" =>
                        -- ADDI
                        state_d <= S_ADDI;
                    when "0110011" =>
                        case status.IR(14 downto 12) is
                            when "000" =>
                                -- ADD
                                state_d <= S_ADD;
                            when "111" =>
                                -- AND
                                state_d <= S_AND;
                            when others =>
                                -- Pour détecter les ratés du décodage
                                state_d <= S_Error;
                        end case;
                    when others =>
                        -- Pour détecter les ratés du décodage
                        state_d <= S_Error;
                end case;

            ---------- Instructions avec immediat de type U ----------
            when S_LUI =>
                -- rd <- immU + 0
                cmd.PC_X_sel <= PC_X_cst_x00;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;

            ---------- Instructions arithmétiques et logiques ----------
            when S_ADDI | S_ADD | S_AND =>
                if state_q = S_ADDI then
                    -- rd <- rs1 + immI
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                    cmd.ALU_op <= ALU_plus;
                    cmd.DATA_sel <= DATA_from_alu;
                elsif state_q = S_ADD then
                    -- rd <- rs1 + rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.ALU_op <= ALU_plus;
                    cmd.DATA_sel <= DATA_from_alu;
                elsif state_q = S_AND then
                    -- rd <- rs1 and rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.LOGICAL_op <= LOGICAL_and;
                    cmd.DATA_sel <= DATA_from_logical;
                end if;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;

            ---------- Instructions de saut ----------

            ---------- Instructions de chargement à partir de la mémoire ----------

            ---------- Instructions de sauvegarde en mémoire ----------

            ---------- Instructions d'accès aux CSR ----------

            when others => null;
        end case;
        
    end process FSM_comb;

end architecture;
