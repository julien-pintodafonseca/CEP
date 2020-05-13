library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        rs1         : in w32;
        alu_y       : in w32;
        IR          : in w32;
        slt         : out std_logic;
        jcond       : out std_logic
    );
end entity;

architecture RTL of CPU_CND is
    signal cond1_sign, cond2_sign, ext_sign : std_logic;
    signal rs1_32, rs2_32 : signed(31 downto 0);
    signal rs1_33, rs2_33, sub : signed(32 downto 0);
    signal z, cond1_z, cond2_z : std_logic;
    signal s, cond1_s, cond2_s : std_logic;

begin
    -- extension de signe
    cond1_sign <= not(IR(12)) and not(IR(6));
    cond2_sign <= IR(6) and not(IR(13));
    ext_sign <= cond1_sign or cond2_sign;

    -- gestion du signe
    rs1_32 <= signed(rs1);
    rs2_32 <= signed(alu_y);
    rs1_33 <= rs1_32(31) & rs1_32 when (ext_sign = '1') else
        '0' & rs1_32;
    rs2_33 <= rs2_32(31) & rs2_32 when (ext_sign = '1') else
        '0' & rs2_32;

    -- soustraction
    sub <= rs1_33 - rs2_33;

    -- z vaut 1 quand rs1 = rs2
    z <= '1' when (sub = 0) else
        '0';
    cond1_z <= IR(12) xor z;
    cond2_z <= not(IR(14)) and cond1_z;

    -- s vaut 1 quand rs1 < ALU_Y
    s <= '1' when (sub(32) = '1') else
        '0';
    cond1_s <= s xor IR(12);
    cond2_s <= cond1_s and IR(14);

    -- sorties
    jcond <= cond2_z or cond2_s; -- condition de saut
    slt <= s; -- s

end architecture;
