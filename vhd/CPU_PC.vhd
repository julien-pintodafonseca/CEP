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
        S_ANDI,
        S_AND,
        S_ORI,
        S_OR,
        S_XORI,
        S_XOR,
        S_SUB,
        S_AUIPC,
        S_SLL,
        S_SRL,
        S_SRA,
        S_SLLI,
        S_SRLI,
        S_SRAI,
        S_BEQ,
        S_BNE,
        S_BLT,
        S_BLTU,
        S_BGE,
        S_BGEU,
        S_SLT,
        S_SLTU,
        S_SLTI,
        S_SLTIU
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
        cmd.ALU_op               <= UNDEFINED;
        cmd.LOGICAL_op           <= UNDEFINED;
        cmd.ALU_Y_sel            <= UNDEFINED;

        cmd.SHIFTER_op           <= UNDEFINED;
        cmd.SHIFTER_Y_sel        <= UNDEFINED;

        cmd.RF_we                <= '0';
        cmd.RF_SIZE_sel          <= UNDEFINED;
        cmd.RF_SIGN_enable       <= '0';
        cmd.DATA_sel             <= UNDEFINED;

        cmd.PC_we                <= '0';
        cmd.PC_sel               <= UNDEFINED;

        cmd.PC_X_sel             <= UNDEFINED;
        cmd.PC_Y_sel             <= UNDEFINED;

        cmd.TO_PC_Y_sel          <= UNDEFINED;

        cmd.AD_we                <= '0';
        cmd.AD_Y_sel             <= UNDEFINED;

        cmd.IR_we                <= '0';

        cmd.ADDR_sel             <= UNDEFINED;
        cmd.mem_we               <= '0';
        cmd.mem_ce               <= '0';

        cmd.cs.CSR_we            <= UNDEFINED;

        cmd.cs.TO_CSR_sel        <= UNDEFINED;
        cmd.cs.CSR_sel           <= UNDEFINED;
        cmd.cs.MEPC_sel          <= UNDEFINED;

        cmd.cs.MSTATUS_mie_set   <= '0';
        cmd.cs.MSTATUS_mie_reset <= '0';

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
                --- Instruction /= (AUIPC, {instructions de branchement})
                if (status.IR(6 downto 0) /= "0010111" AND status.IR(6 downto 0) /= "1100011") then
                    -- PC <- PC + 4
                    cmd.TO_PC_Y_sel <= To_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                end if;

                --- Changement d'etat
                case status.IR(6 downto 0) is
                    when "0110111" =>
                        -- LUI
                        state_d <= S_LUI;
                    when "0010111" =>
                        -- AUIPC
                        state_d <= S_AUIPC;
                    when "0010011" =>
                        case status.IR(14 downto 12) is
                            when "000" =>
                                -- ADDI
                                state_d <= S_ADDI;
                            when "111" =>
                                -- ANDI
                                state_d <= S_ANDI;
                            when "110" =>
                                -- ORI
                                state_d <= S_ORI;
                            when "100" =>
                                -- XORI
                                state_d <= S_XORI;
                            when "101" =>
                                case status.IR(31 downto 25) is
                                    when "0000000" =>
                                        -- SRLI
                                        state_d <= S_SRLI;
                                    when "0100000" =>
                                        -- SRAI
                                        state_d <= S_SRAI;
                                    when others =>
                                        -- Pour détecter les ratés du décodage
                                        state_d <= S_Error;
                                    end case;
                            when "001" =>
                                -- SLLI
                                state_d <= S_SLLI;
                            when "010" =>
                                -- SLTI
                                state_d <= S_SLTI;
                            when "011" =>
                                -- SLTIU
                                state_d <= S_SLTIU;
                            when others =>
                                -- Pour détecter les ratés du décodage
                                state_d <= S_Error;
                        end case;
                    when "0110011" =>
                        case status.IR(14 downto 12) is
                            when "000" =>
                                case status.IR(31 downto 25) is
                                    when "0000000" =>
                                        -- ADD
                                        state_d <= S_ADD;
                                    when "0100000" =>
                                        -- SUB
                                        state_d <= S_SUB;
                                    when others =>
                                        -- Pour détecter les ratés du décodage
                                        state_d <= S_Error;
                                    end case;
                            when "111" =>
                                -- AND
                                state_d <= S_AND;
                            when "110" =>
                                -- OR
                                state_d <= S_OR;
                            when "100" =>
                                -- XOR
                                state_d <= S_XOR;
                            when "001" =>
                                -- SLL
                                state_d <= S_SLL;
                            when "101" =>
                                case status.IR(31 downto 25) is
                                    when "0000000" =>
                                        -- SRL
                                        state_d <= S_SRL;
                                    when "0100000" =>
                                        -- SRA
                                        state_d <= S_SRA;
                                    when others =>
                                        -- Pour détecter les ratés du décodage
                                        state_d <= S_Error;
                                    end case;
                            when "010" =>
                                -- SLT
                                state_d <= S_SLT;
                            when "011" =>
                                -- SLTU
                                state_d <= S_SLTU;
                            when others =>
                                -- Pour détecter les ratés du décodage
                                state_d <= S_Error;
                        end case;
                    when "1100011" =>
                        case status.IR(14 downto 12) is
                            when "000" =>
                                -- BEQ
                                state_d <= S_BEQ;
                            when "001" =>
                                -- BNE
                                state_d <= S_BNE;
                            when "100" =>
                                -- BLT
                                state_d <= S_BLT;
                            when "101" =>
                                -- BGE
                                state_d <= S_BGE;
                            when "110" =>
                                -- BLTU
                                state_d <= S_BLTU;
                            when "111" =>
                                -- BGEU
                                state_d <= S_BGEU;
                            when others =>
                                -- Pour détecter les ratés du décodage
                                state_d <= S_Error;
                        end case;
                    when others =>
                        -- Pour détecter les ratés du décodage
                        state_d <= S_Error;
                end case;

            ---------- Instructions arithmétiques ----------
            when S_ADDI | S_ADD | S_SUB =>
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
                elsif state_q = S_SUB then
                    -- rd <- rs1 - rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.ALU_op <= ALU_minus;
                    cmd.DATA_sel <= DATA_from_alu;
                end if;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;

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
            
            when S_AUIPC =>
                -- rd <- immU + pc
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- PC <- PC + 4
                cmd.TO_PC_Y_sel <= To_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;
            
            ---------- Instructions logiques ----------
            when S_ANDI | S_AND | S_ORI | S_OR | S_XORI | S_XOR =>
                if state_q = S_ANDI then
                    -- rd <- rs1 and immI
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                    cmd.LOGICAL_op <= LOGICAL_and;
                    cmd.DATA_sel <= DATA_from_logical;
                elsif state_q = S_AND then
                    -- rd <- rs1 and rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.LOGICAL_op <= LOGICAL_and;
                    cmd.DATA_sel <= DATA_from_logical;
                elsif state_q = S_ORI then
                    -- rd <- rs1 or immI
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                    cmd.LOGICAL_op <= LOGICAL_or;
                    cmd.DATA_sel <= DATA_from_logical;
                elsif state_q = S_OR then
                    -- rd <- rs1 or rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.LOGICAL_op <= LOGICAL_or;
                    cmd.DATA_sel <= DATA_from_logical;
                elsif state_q = S_XORI then
                    -- rd <- rs1 xor immI
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                    cmd.LOGICAL_op <= LOGICAL_xor;
                    cmd.DATA_sel <= DATA_from_logical;
                elsif state_q = S_XOR then
                    -- rd <- rs1 xor rs2
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                    cmd.LOGICAL_op <= LOGICAL_xor;
                    cmd.DATA_sel <= DATA_from_logical;
                end if;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;
            
            ---------- Instructions avec décalage ----------
            when S_SLL | S_SRL | S_SRA | S_SRAI | S_SLLI | S_SRLI =>
                if state_q = S_SLL then
                    -- rd <- sll(rs1,rs2)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                    cmd.SHIFTER_op <= SHIFT_ll;
                elsif state_q = S_SRL then
                    -- rd <- srl(rs1,rs2)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                    cmd.SHIFTER_op <= SHIFT_rl;
                elsif state_q = S_SRA then
                    -- rd <- sra(rs1,rs2)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                    cmd.SHIFTER_op <= SHIFT_ra;
                elsif state_q = S_SLLI then
                    -- rd <- slli(rs1,shamt)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                    cmd.SHIFTER_op <= SHIFT_ll;
                elsif state_q = S_SRLI then
                    -- rd <- srli(rs1,shamt)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                    cmd.SHIFTER_op <= SHIFT_rl;
                elsif state_q = S_SRAI then
                    -- rd <- srai(rs1,shamt)
                    cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                    cmd.SHIFTER_op <= SHIFT_ra;
                end if;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;

            ---------- Instructions avec set ----------
            when S_SLT | S_SLTU | S_SLTI | S_SLTIU =>
                if state_q = S_SLT OR state_q = S_SLTU then
                    -- rd <- slt(rs1,rs2)
                    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                elsif state_q = S_SLTI OR state_q = S_SLTIU then
                    -- rd <- slti(rs1,immI)
                    cmd.ALU_Y_sel <= ALU_Y_immI;
                end if;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_we <= '0';
                cmd.mem_ce <= '1';
                -- next state
                state_d <= S_Fetch;


            ---------- Instructions de branchement ----------
            when S_BEQ | S_BNE | S_BLT | S_BGE | S_BLTU | S_BGEU =>
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                if status.jcond then
                    -- PC <- PC + immB
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
                else
                    -- PC <- PC + 4
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                end if;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;
            
            ---------- Instructions de saut ----------

            ---------- Instructions de chargement à partir de la mémoire ----------

            ---------- Instructions de sauvegarde en mémoire ----------

            ---------- Instructions d'accès aux CSR ----------

            when others => null;
        end case;
        
    end process FSM_comb;

end architecture;
