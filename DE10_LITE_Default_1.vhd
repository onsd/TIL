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
signal EN, SET, UD, CB : std_logic;  -- Enable, Set, Up/Down, Carry/Borrow
signal Cin, Cout : std_logic_vector(3 downto 0);  -- Counter In/Out
signal decode : std_logic_vector(7 downto 0);  -- Decoder
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

-- component UpDownCounter is
--    port (
--        clk		: in std_logic;
--        reset	: in std_logic;
--        EN		: in std_logic;
--        UD		: in std_kogic;
--        SET		: in std_logic;
--			 Cin		: in std_logic_vector(3 downto 0);
--        Cout		: out std_logic_vector(3 downto 0);
--        CB		: out std_logic
--    );
-- End component;
	
-- Signal of Up/Down Counter	
	EN <= '1';  -- Enable=1(Up/Down)
	UD <= SW(9);  -- Up/Down=0/1
	SET <= SW(8) ;  -- Set Initial Value=1
	Cin <= SW(3 downto 0);  -- Countet In
	LEDR(9) <= CB;  -- LED Display Carry/Borrow
	
-- Up/Down Counter with Carry/Borrow and Enable
	process(clk, reset)
	variable c : integer;
	begin
		if (reset = '0') then
			c := 0;
		elsif (clk'event and clk = '1') then
			if (SET = '1') then
				c := conv_integer(Cin);
			elsif (EN = '1') then
				if (UD = '0') then  -- Up
					if (c = 9) then
						c := 0;
					else
						c := c + 1;
					end if;
				else  -- Down
					if (c = 0) then
						c := 9;
					else
						c := c - 1;
					end if;
				end if;
			end if;
		end if;
		Cout <= conv_std_logic_vector(c, 4);
	end process;
	-- Carry/Borrow
	CB <= '1' when (UD = '0') and (Cout = "1001") else  -- Up Carry
         '1' when (UD = '1') and (Cout = "0000") else  -- Down Borrow
			'0';
-- End
						
-- component SegmentDecoder is
--     port (
--         Din		: in std_logic_cbvector(3 downto 0);
--         Dout	: out std_logic_vector(7 downto 0)
--     );
-- end component;	
	
-- Decoder
	process(Cout)
	begin
		case Cout is
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
-- End
	
	HEX5 <= decode;
	HEX4 <= decode;
	HEX3 <= decode;
	HEX2 <= decode;
	HEX1 <= decode;
	HEX0 <= decode;

end RTL;