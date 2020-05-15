-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_Default
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
 
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
	-- SEG7
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
signal count : std_logic_vector(3 downto 0);
signal decode : std_logic_vector(7 downto 0);
signal DLY_RST : std_logic;

component Reset_Delay is
	port (
		iCLK		: in std_logic;
		oRESET	: out std_logic
	);
end component;

begin

RESETDelay: Reset_Delay port map (MAX10_CLK1_50, DLY_RST); 

-- IO test
	LEDR <= SW;
	reset <= key(0);

-- Clock Generater
	process(MAX10_CLK2_50, reset)
	variable i : integer;
	begin
		if (reset = '0') then
			i := 0;
			clk <= '0';
		elsif (MAX10_CLK2_50'event and MAX10_CLK2_50 = '1') then
			if (i < 250000) then
				i := i + 1;
			else
				i := 0;
				clk <= not clk;
			end if;
		end if;
	end process;
	
-- Counter
	process(clk, reset)
	variable i : integer;
	begin
		if (reset = '0') then
			i := 0;
			count <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (i < 100) then
				i := i + 1;
			else
				i := 0;
				count <= count + 1;
			end if;
		end if;
	end process;
	
-- Decoder
	process(count)
	begin
		case count is
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
	HEX5 <= decode;
	HEX4 <= decode;
	HEX3 <= decode;
	HEX2 <= decode;
	HEX1 <= decode;
	HEX0 <= decode;

end RTL;