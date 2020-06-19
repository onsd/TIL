library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity SegmentDecoder is
    port (
        Din		: in std_logic_vector(3 downto 0);
        decode	: out std_logic_vector(7 downto 0)
    );
end SegmentDecoder;

architecture RTL of SegmentDecoder is
begin
	process(Din)
	begin
		 case Din is
			  when "0000" => decode <= "11000000";
			  when "0001" => decode <= "11111001";
			  when "0010" => decode <= "10100100";
			  when "0011" => decode <= "10110000";
			  when "0100" => decode <= "10011001";
			  when "0101" => decode <= "10010010";
			  when "0110" => decode <= "10000010";
			  when "0111" => decode <= "11111000";
			  when "1000" => decode <= "10000000";
			  when "1001" => decode <= "10010000";
			  when "1010" => decode <= "00001000";
			  when "1011" => decode <= "00000011";
			  when "1100" => decode <= "01000110";
			  when "1101" => decode <= "00100001";
			  when "1110" => decode <= "00000110";
			  when "1111" => decode <= "00001110";
			  when others => decode <= "11111111";
		 end case;
	 end process;
end RTL;