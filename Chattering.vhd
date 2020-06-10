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
signal old_in: std_logic;
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if(Cin = '0' and old_in = '0') then
                Cout <= '0';
            end if;
            old_in <= Cin;
        end if;
        Cout <= '1';
    end process;
        

end RTL;