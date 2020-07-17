library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity ChatteringButton is 
    port (
        clk : in std_logic;
        Cin : in std_logic;
        Cout: out std_logic
    );
end ChatteringButton;

architecture RTL of ChatteringButton is
signal old_in: std_logic := '1';
signal oldest_in : std_logic := '1';
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if(Cin = '0' and old_in = '0' and oldest_in = '0') then
                Cout <= '0';
            else
                Cout <= '1';
            end if;
            oldest_in <= old_in;
            old_in <= Cin;
        end if;
    end process;
end RTL;