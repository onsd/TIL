-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_Default
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
 
entity DE10_LITE_Default is
	port (
	-- CLOCK
		ADC_CLK_10 			: in std_logic;
		MAX10_CLK1_50 		: in std_logic;
		MAX10_CLK2_50 		: in std_logic;
	-- SDRAM
		DRAM_ADDR 			: out std_logic_vector(12 downto 0);
		DRAM_BA 				: out std_logic_vector(1 downto 0);
		DRAM_CAS_N 			: out std_logic;
		DRAM_CKE 			: out std_logic;
		DRAM_CLK 			: out std_logic;
		DRAM_CS_N 			: out std_logic;
		DRAM_DQ 				: inout std_logic_vector(15 downto 0);
		DRAM_LDQM 			: out std_logic;
		DRAM_RAS_N 			: out std_logic;
		DRAM_UDQM 			: out std_logic;
		DRAM_WE_N 			: out std_logic;
	-- SEG7S
		HEX0 					: out std_logic_vector(7 downto 0);
		HEX1 					: out std_logic_vector(7 downto 0);
		HEX2 					: out std_logic_vector(7 downto 0);
		HEX3					: out std_logic_vector(7 downto 0);
		HEX4					: out std_logic_vector(7 downto 0);
		HEX5 					: out std_logic_vector(7 downto 0);
	-- KEY
		KEY 					: in std_logic_vector(1 downto 0);
	-- LED
		LEDR 					: out std_logic_vector(9 downto 0);
	-- SW
		SW 					: in std_logic_vector(9 downto 0);
	-- VGA
		VGA_B 				: out std_logic_vector(3 downto 0);
		VGA_G 				: out std_logic_vector(3 downto 0);
		VGA_HS 				: out std_logic;
		VGA_R 				: out std_logic_vector(3 downto 0);
		VGA_VS 				: out std_logic;
	-- Accelerometer
		GSENSOR_INT 		: in std_logic_vector(2 downto 1);
		GSENSOR_CS_N 		: out std_logic;	
		GSENSOR_SCLK 		: out std_logic;
		GSENSOR_SDI 		: inout std_logic;
		GSENSOR_SDO 		: inout std_logic;
	-- Arduino
		ARDUINO_IO 			: inout std_logic_vector(15 downto 0);
		ARDUINO_RESET_N 	: inout std_logic;
	-- GPIO, GPIO connect to GPIO Default
		GPIO 					: inout std_logic_vector(35 downto 0)
    );
end DE10_LITE_Default;
 
architecture RTL of DE10_LITE_Default is
signal clk, reset : std_logic;
signal EN, SET, UD, CB : std_logic;  -- Enable, Set, Up/Down, Carry/Borrow
signal Cin, Cout : std_logic_vector(3 downto 0);  -- Counter In/Out
signal decode1 : std_logic_vector(7 downto 0);  -- Decoder
signal decode2: std_logic_vector(7 downto 0);
signal DLY_RST : std_logic;

signal Cout1: std_logic_vector(3 downto 0);
signal CB1: std_logic;
signal Cout2: std_logic_vector(3 downto 0);
signal CB2: std_logic;

component Reset_Delay is
	port (
		iCLK		: in std_logic;
		oRESET	: out std_logic
	);
end component;

component UDCounter is
   port (
		clk		: in std_logic;
		reset	: in std_logic;
		EN		: in std_logic;
		UD		: in std_logic;
		SET		: in std_logic;
		Cin		: in std_logic_vector(3 downto 0);
       	Cout	: out std_logic_vector(3 downto 0);
       	CB		: out std_logic
   );
end component;

begin

RESETDelay: Reset_Delay port map (MAX10_CLK1_50, DLY_RST); 

-- IO test
	LEDR(8 downto 0) <= SW(8 downto 0);
	reset <= key(0);

-- Clock Generater 1 Second
	process(MAX10_CLK2_50, reset)
	variable i : integer;
	begin
		if (reset = '0') then
			i := 0;
			clk <= '0';
		elsif (MAX10_CLK2_50'event and MAX10_CLK2_50 = '1') then
			if (i < 25000000) then
				i := i + 1;
			else
				i := 0;
				clk <= not clk;
			end if;
		end if;
	end process;

-- component UDCounter
-- Signal of Up/Down Counter	
	EN <= '1';  -- Enable=1(Up/Down)
	UD <= SW(9);  -- Up/Down=0/1 
	SET <= SW(8) ;  -- Set Initial Value=1
	Cin <= SW(3 downto 0);  -- Countet In
	LEDR(9) <= CB;  -- LED Display Carry/Borrow

	C1: UDCounter port map (clk, reset, EN, UD, SET, Cin,  Cout1, CB1);
	
-- component SegmentDecoder is
--     port (
--         Din		: in std_logic_cbvector(3 downto 0);
--         Dout	: out std_logic_vector(7 downto 0)
--     );
-- end component;	
	
-- Decoder
	process(Cout1)
	begin
		case Cout1 is
			when "0000" => decode1 <= "11000000";
			when "0001" => decode1 <= "11111001";
			when "0010" => decode1 <= "10100100";
			when "0011" => decode1 <= "10110000";
			when "0100" => decode1 <= "10011001";
			when "0101" => decode1 <= "10010010";
			when "0110" => decode1 <= "10000010";
			when "0111" => decode1 <= "11111000";
			when "1000" => decode1 <= "10000000";
			when "1001" => decode1 <= "10010000";
			when "1010" => decode1 <= "00001000";
			when "1011" => decode1 <= "00000011";
			when "1100" => decode1 <= "01000110";
			when "1101" => decode1 <= "00100001";
			when "1110" => decode1 <= "00000110";
			when "1111" => decode1 <= "00001110";
			when others => decode1 <= "11111111";
		end case;
	end process;
-- End
	-- Decoder
	-- process(Cout2)
	-- begin
	-- 	case Cout2 is
	-- 		when "0000" => decode2 <= "11000000";
	-- 		when "0001" => decode2 <= "11111001";
	-- 		when "0010" => decode2 <= "10100100";
	-- 		when "0011" => decode2 <= "10110000";
	-- 		when "0100" => decode2 <= "10011001";
	-- 		when "0101" => decode2 <= "10010010";
	-- 		when "0110" => decode2 <= "10000010";
	-- 		when "0111" => decode2 <= "11111000";
	-- 		when "1000" => decode2 <= "10000000";
	-- 		when "1001" => decode2 <= "10010000";
	-- 		when "1010" => decode2 <= "00001000";
	-- 		when "1011" => decode2 <= "00000011";
	-- 		when "1100" => decode2 <= "01000110";
	-- 		when "1101" => decode2 <= "00100001";
	-- 		when "1110" => decode2 <= "00000110";
	-- 		when "1111" => decode2 <= "00001110";
	-- 		when others => decode2 <= "11111111";
	-- 	end case;
	-- end process;
-- End
	
	HEX5 <= decode1;
	HEX4 <= decode1;
	HEX3 <= decode1;
	HEX2 <= decode1;
	HEX1 <= decode1;
	HEX0 <= decode1;

end RTL;