-- IM : Instruction Memory --

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity IM is
    port(
        CLK : in std_logic;
        IMA : in std_logic_vector(31 downto 0);
        IMOut : out std_logic_vector(31 downto 0)
    );
end IM;

architecture RTL of IM is

begin
                  -- R Type : < op ><rs ><rt ><rd ><sha><func>
                  -- I Type : < op ><rs ><rt ><   imm/addr   >
                  -- J Type : < op ><          addr          >
    IMo : process(IMA(7 downto 2))
    begin
        case (IMA(7 downto 2)) is
            when "000000" =>  -- addi(1) rt(1),rs(0),4
                    IMOut <= "00000100000000010000000000000100";
            when "000001" =>  -- add(0) rd(2),rs(1),rt(1)
                    IMOut <= "00000000001000010001000000000000";
            when "000010" =>  -- sw(3) rt(1),rs(2),-4
                    IMOut <= "00001100010000011111111111111100";
            when "000011" =>  -- lw(2) rt(2),rs(1),0
                    IMOut <= "00001000001000100000000000000000";
            when "000100" =>  -- beq(4) rs(1),rt(2),1
                    IMOut <= "00010000001000100000000000000001";
            when "000101" =>  -- jr(7) rs(31)
                    IMOut <= "00011111111000000000000000000000";
            when "000110" =>  -- jal(6) 101
                    IMOut <= "00011000000000000000000000000101";
            when "000111" =>  -- j(5) 0
                    IMOut <= "00010100000000000000000000000000";
            when others =>  -- nop : add $0,$0,$0
                    IMOut <= "00000000000000000000000000000000";
        end case;
    end process;

end RTL;