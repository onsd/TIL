library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Switch is 
    port(
        clk : in std_logic;
        reset : in std_logic;
        Cin: in std_logic;
        Cout: out std_logic
    );
end Switch;

architecture RTL of Switch is
signal old_in: std_logic := '1';
begin
    process(clk)
    begin
        if reset = '0' then
            Cout <= '1';
            old_in <= '1';
        elsif (clk'event and clk = '1') then
            -- 押下
            if(Cin = '0') then
                old_in <= not old_in;
                Cout <= old_in;
            else
                Cout <= old_in;
            end if;
        end if;
    end process;
    
end RTL ; -- RTL