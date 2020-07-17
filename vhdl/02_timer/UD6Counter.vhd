library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity UD6Counter is 
    port (
        clk		: in std_logic;
        reset	: in std_logic;
        EN		: in std_logic; 
        UD		: in std_logic;
        SET		: in std_logic;
        Cin		: in std_logic_vector(3 downto 0);
        Cout	: inout std_logic_vector(3 downto 0);
        CB		: out std_logic;
        STOP: in std_logic
    );
end UD6Counter;

architecture RTL of UD6Counter is
begin
    -- signal cnt: std_logic_vector(3 downto 0);
    process(clk, reset)
    begin
        if (reset = '0') then
            Cout <= "0000";
        elsif (STOP = '0') then
            Cout <= Cout;
        elsif (clk'event and clk = '1') then
            if (SET = '1') then
                Cout <= Cin;
            else
                if (UD = '0' and EN = '1') then  -- Up
                    if (Cout = "0101") then
                        Cout <= "0000";
                    else
                        Cout <= Cout + 1;
                    end if;
                elsif(UD = '1' and EN = '1') then -- Down
                    if (Cout = "0000") then
                        Cout <= "0101";-- 111
                    else
                        Cout <= Cout - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    -- Carry/Borrow
    CB <= '1' when (UD = '0') and (Cout = "0101") else  -- Up Carry
        '1' when (UD = '1') and (Cout = "0000") else  -- Down Borrow
            '0';
end RTL;