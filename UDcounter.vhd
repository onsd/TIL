library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity UDCounter is 
    port (
        clk		: in std_logic;
        reset	: in std_logic;
        EN		: in std_logic;
        UD		: in std_logic;
        SET		: in std_logic;
    	  Cin		: in std_logic_vector(3 downto 0);
        Cout	: inout std_logic_vector(3 downto 0);
        CB		: out std_logic
    );
end UDCounter;

architecture RTL of UDCounter is
begin
    -- signal cnt: std_logic_vector(3 downto 0);
    process(clk, reset)
    begin
        if (reset = '0') then
            Cout <= "0000";
        elsif (clk'event and clk = '1') then
            if (SET = '1') then
                Cout <= Cin;
            -- elsif (EN = '1') then
            else
                if (UD = '0') then  -- Up
                    if (Cout = "1001") then
                        Cout <= "0000";
                    else
                        Cout <= Cout + 1;
                    end if;
                else  -- Down
                    if (Cout = "0000") then
                        Cout <= "1001";
                    else
                        Cout <= Cout - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    -- Carry/Borrow
    CB <= '1' when (UD = '0') and (Cout = "1001") else  -- Up Carry
        '1' when (UD = '1') and (Cout = "0000") else  -- Down Borrow
            '0';
end RTL;