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
signal START, SET, UD, CB : std_logic;  -- Enable, Set, Up/Down, Carry/Borrow
signal Cout, Zero : std_logic_vector(3 downto 0);  -- Counter In/Out
signal Cin, decode1, decode2 : std_logic_vector(7 downto 0);  -- Decoder
signal DLY_RST : std_logic;

signal ChatteringOut0: std_logic;
signal ChatteringOut1: std_logic;

signal Switch0Out: std_logic;
signal Switch1Out: std_logic;

signal Cout0: std_logic_vector(3 downto 0);
signal Cout1: std_logic_vector(3 downto 0);
signal Cout2: std_logic_vector(3 downto 0);
signal Cout3: std_logic_vector(3 downto 0);
signal Cout4: std_logic_vector(3 downto 0);
signal Cout5: std_logic_vector(3 downto 0);

signal CB0: std_logic;
signal CB1: std_logic;
signal CB2: std_logic;
signal CB3: std_logic;
signal CB4: std_logic;
signal CB5: std_logic;

signal Dout0: std_logic_vector(7 downto 0);
signal Dout1: std_logic_vector(7 downto 0);
signal Dout2: std_logic_vector(7 downto 0);
signal Dout3: std_logic_vector(7 downto 0);
signal Dout4: std_logic_vector(7 downto 0);
signal Dout5: std_logic_vector(7 downto 0);
signal UpperSet: std_logic_vector(3 downto 0);
signal LowerSet: std_logic_vector(3 downto 0);


component Reset_Delay is
	port (
		iCLK		: in std_logic;
		oRESET	: out std_logic
	);
end component;

component ChatteringButton is 
    port (
        clk : in std_logic;
        Cin : in std_logic;
        Cout: out std_logic
    );
end component;

component Switch is 
    port(
        clk : in std_logic;
        Cin: in std_logic;
        Cout: out std_logic
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

component UD6Counter is 
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

component SegmentDecoder is
    port (
        Din		: in std_logic_vector(3 downto 0);
        decode	: out std_logic_vector(7 downto 0)
    );
end component;	

-- component BCDDecoder is
-- 	port(
-- 		Din:in std_logic_vector(7 downto 0);
-- 		Upper : out std_logic_vector(3 downto 0);
-- 		Lower : out std_logic_vector(3 downto 0)
-- 	);
-- end component;

begin

RESETDelay: Reset_Delay port map (MAX10_CLK1_50, DLY_RST); 

-- IO test
	LEDR(7 downto 0) <= SW(7 downto 0);



-- Clock Generater 0.01 Second (10 ms)
	process(MAX10_CLK2_50, reset)
	variable i : integer;
	begin
		if (reset = '0') then
			i := 0;
			clk <= '0';
		elsif (MAX10_CLK2_50'event and MAX10_CLK2_50 = '1') then
			-- if (i < 25000000) then
			if (i < 250000) then
				i := i + 1;
			else
				i := 0;
				clk <= not clk;
			end if;
		end if;
	end process;

	-- Chattering0: Chattering port map(clk, key(0), ChatteringOut0);
	-- reset <=  ChatteringOut0;
	reset <= '1';
				
-- component UDCounter
-- Signal of Up/Down Counter	
	Chattering0 : ChatteringButton port map(clk, key(0), ChatteringOut0);
	Chattering1 : ChatteringButton port map(clk, key(1), ChatteringOut1);

	-- S0: Switch port map(clk, key(0), Switch0Out);
	S1: Switch port map(clk, key(1), Switch1Out);

	SET <= not ChatteringOut0 ;  -- Set Initial Value=1
	START <= Switch1Out;  -- Enable=key(9)(Up/Down)
	
	UD <= '1';  -- Up/Down=0/1 
	
	Cin <= SW(7 downto 0);  -- Countet In
	UpperSet <= SW(7 downto 4);
	LowerSet <= SW(3 downto 0);
	LEDR(8) <= SET;
	LEDR(9) <= START;  -- LED Display Carry/Borrow

	ZERO <= "0000";
	-- B0: BCDDecoder port map(Cin, Dout_Lower, Dout_Upper);
	C0: UDCounter port map  (clk, reset, START, UD, SET, ZERO, Cout0, CB0);
	C1: UDCounter port map  (clk, reset, CB0, UD, SET, ZERO,  Cout1, CB1);
	C2: UDCounter port map  (clk, reset, CB1 and CB0, UD, SET, ZERO,  Cout2, CB2);
	C3: UD6Counter port map (clk, reset, CB2 and CB1 and CB0, UD, SET, ZERO,  Cout3, CB3);
	C4: UDCounter port map  (clk, reset, CB3 and CB2 and CB1 and CB0, UD, SET, LowerSet,  Cout4, CB4);
	C5: UDCounter port map  (clk, reset, CB4 and CB3 and CB2 and CB1 and CB0, UD, SET, UpperSet,  Cout5, CB5); 

	-- TODO: 1. ストップできるカウンタをつくる DONE
	-- TODO: 2. 時間をセットできるようにする
	-- TODO: 3. チャタリングやる

-- Decoder
	D0: SegmentDecoder port map(Cout0, Dout0);
	D1: SegmentDecoder port map(Cout1, Dout1);
	D2: SegmentDecoder port map(Cout2, Dout2);
	D3: SegmentDecoder port map(Cout3, Dout3);
	D4: SegmentDecoder port map(Cout4, Dout4);
	D5: SegmentDecoder port map(Cout5, Dout5);
	
	HEX5 <= Dout5;
	HEX4 <= Dout4;
	HEX3 <= Dout3;
	HEX2 <= Dout2;
	HEX1 <= Dout1;
	HEX0 <= Dout0;

end RTL;