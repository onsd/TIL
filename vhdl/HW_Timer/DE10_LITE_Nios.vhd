-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_SDRAM_Nios_Test
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
 
entity DE10_LITE_Nios is
	port (
	-- Clocks
		ADC_CLK_10 			: in std_logic;
		MAX10_CLK1_50 		: in std_logic;
		MAX10_CLK2_50 		: in std_logic;
	-- KEY
		KEY 					: in std_logic_vector(1 downto 0);
	-- SW
		SW 					: in std_logic_vector(31 downto 0);
	-- LEDR
		LEDR 					: out std_logic_vector(9 downto 0);
	-- HEX
		HEX0 					: out std_logic_vector(7 downto 0);
		HEX1 					: out std_logic_vector(7 downto 0);
		HEX2 					: out std_logic_vector(7 downto 0);
		HEX3					: out std_logic_vector(7 downto 0);
		HEX4					: out std_logic_vector(7 downto 0);
		HEX5 					: out std_logic_vector(7 downto 0);
	-- SDRAM
		DRAM_CLK 			: out std_logic;
		DRAM_CKE 			: out std_logic;
		DRAM_ADDR 			: out std_logic_vector(12 downto 0);
		DRAM_BA 				: out std_logic_vector(1 downto 0);
		DRAM_DQ 				: inout std_logic_vector(15 downto 0);
		DRAM_LDQM 			: out std_logic;
		DRAM_UDQM 			: out std_logic;
		DRAM_CS_N 			: out std_logic;
		DRAM_WE_N 			: out std_logic;
		DRAM_CAS_N 			: out std_logic;
		DRAM_RAS_N 			: out std_logic;
	-- VGA
		VGA_HS 				: out std_logic;
		VGA_VS 				: out std_logic;
		VGA_R 				: out std_logic_vector(3 downto 0);
		VGA_G 				: out std_logic_vector(3 downto 0);
		VGA_B 				: out std_logic_vector(3 downto 0);
	-- Clock Generator I2C
		CLK_I2C_SCL			: out std_logic;
		CLK_I2C_SDA			: inout std_logic;
	-- GSENSOR
		GSENSOR_SCLK 		: out std_logic;
		GSENSOR_SDO 		: inout std_logic;
		GSENSOR_SDI 		: inout std_logic;
		GSENSOR_INT 		: in std_logic_vector(2 downto 1);
		GSENSOR_CS_N 		: out std_logic;	
	-- GPIO
		GPIO 					: inout std_logic_vector(35 downto 0);
	-- ARDUINO
		ARDUINO_IO 			: inout std_logic_vector(15 downto 0);
		ARDUINO_RESET_N 	: inout std_logic
    );
end DE10_LITE_Nios;
 
architecture RTL of DE10_LITE_Nios is

component DE10_LITE_Qsys is
	port (
		altpll_0_areset_conduit_export    : in    std_logic                     := 'X';             -- export
		altpll_0_locked_conduit_export    : out   std_logic;                                        -- export
		clk_clk                           : in    std_logic                     := 'X';             -- clk
		clk_sdram_clk                     : out   std_logic;                                        -- clk
		hex_external_connection_export    : out   std_logic_vector(31 downto 0);                    -- export
		key_external_connection_export    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
		ledr_external_connection_export   : out   std_logic_vector(9 downto 0);                     -- export
		reset_reset_n                     : in    std_logic                     := 'X';             -- reset_n		key_external_connection_export    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
		sdram_wire_addr                   : out   std_logic_vector(12 downto 0);                    -- addr
		sdram_wire_ba                     : out   std_logic_vector(1 downto 0);                     -- ba
		sdram_wire_cas_n                  : out   std_logic;                                        -- cas_n
		sdram_wire_cke                    : out   std_logic;                                        -- cke
		sdram_wire_cs_n                   : out   std_logic;                                        -- cs_n
		sdram_wire_dq                     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
		sdram_wire_dqm                    : out   std_logic_vector(1 downto 0);                     -- dqm
		sdram_wire_ras_n                  : out   std_logic;                                        -- ras_n
		sdram_wire_we_n                   : out   std_logic;                                        -- we_n
		sw_external_connection_export     : in    std_logic_vector(31 downto 0) := (others => 'X')  -- export
	);
end component DE10_LITE_Qsys;

COMPONENT UDCounter IS
PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	EN : IN std_logic;
	UD : IN std_logic;
	SET : IN std_logic;
	Cin : IN std_logic_vector(3 DOWNTO 0);
	Cout : OUT std_logic_vector(3 DOWNTO 0);
	CB : OUT std_logic;
	STOP : IN std_logic
);
END COMPONENT;

COMPONENT SegmentDecoder IS
PORT (
	Din : IN std_logic_vector(3 DOWNTO 0);
	decode : OUT std_logic_vector(7 DOWNTO 0)
);
END COMPONENT;

signal pll_a, pll_l, reset : std_logic;
signal hex : std_logic_vector(31 downto 0);
--signal key4 : std_logic_vector(3 downto 0);
signal dram_dqm : std_logic_vector(1 downto 0);

-- add signal for HW Timer
signal clk, isStop, isSet, SET, START: std_logic;
signal ZERO, Cout0, Cout1, Cout2, Cout3, Cout4, Cout5: std_logic_vector(3 downto 0);
signal CB0, CB1, CB2, CB3, CB4, CB5: std_logic;
signal EN0, EN1, EN2, EN3, EN4, EN5: std_logic;
signal Dout0, Dout1, Dout2, Dout3, Dout4, Dout5: std_logic_vector(7 downto 0);
-- signal end
begin
	-- Clock Generater 0.01 Second (10 ms)
	PROCESS (MAX10_CLK2_50, reset)
		VARIABLE i : INTEGER;
	BEGIN
		IF (reset = '0') THEN
			i := 0;
			clk <= '0';
		ELSIF (MAX10_CLK2_50'event AND MAX10_CLK2_50 = '1') THEN
			-- if (i < 25000000) then
			IF (i < 250000) THEN
				i := i + 1;
			ELSE
				i := 0;
				clk <= NOT clk;
			END IF;
		END IF;
	END PROCESS;
	reset <= not SW(9);


	-- hex(15 downto 0) -> counter value
	-- hex(16) -> START
	
	-- hex(0) == 0 or 1
	-- TODO:
	-- 	1. set UDCounter 
	-- 	2. set SegmentDecoder
	-- 	3. IO_WRITE: 0 : start/stop
	--  			 1 : set	
	--               2 :clear 
	--				 31 downto 16 : counter value


	Nios: DE10_LITE_Qsys port map (
		pll_a, pll_l, MAX10_CLK2_50, DRAM_CLK,
		hex, KEY, LEDR, reset,  
		DRAM_ADDR, DRAM_BA, DRAM_CAS_N, DRAM_CKE,
		DRAM_CS_N, DRAM_DQ, dram_dqm, DRAM_RAS_N, DRAM_WE_N,
		SW
	); 
	
	START <= '1';
	
	isStop <= '0';
	ZERO <= "0000";
	C0 : UDCounter PORT MAP(clk, reset, START, isSET, SET, ZERO, Cout0, CB0, isStop);
	EN1 <= CB0 AND START;
	C1 : UDCounter PORT MAP(clk, reset, EN1, isSET, SET, ZERO, Cout1, CB1, isStop);
	EN2 <= CB1 AND CB0 AND START;
	C2 : UDCounter PORT MAP(clk, reset, EN2, isSET, SET, ZERO, Cout2, CB2, isStop);
	EN3 <= CB2 AND CB1 AND CB0 AND START;
	C3 : UDCounter PORT MAP(clk, reset, EN3, isSET, SET, ZERO, Cout3, CB3, isStop);
	EN4 <= CB3 AND CB2 AND CB1 AND CB0 AND START;
	C4 : UDCounter PORT MAP(clk, reset, EN4, isSET, SET, ZERO, Cout4, CB4, isStop);
	EN5 <= CB4 AND CB3 AND CB2 AND CB1 AND CB0 AND START;
	C5 : UDCounter PORT MAP(clk, reset, EN5, isSET, SET, ZERO, Cout5, CB5, isStop);
	
	D0 : SegmentDecoder PORT MAP(Cout0, Dout0);
	D1 : SegmentDecoder PORT MAP(Cout1, Dout1);
	D2 : SegmentDecoder PORT MAP(Cout2, Dout2);
	D3 : SegmentDecoder PORT MAP(Cout3, Dout3);
	D4 : SegmentDecoder PORT MAP(Cout4, Dout4);
	D5 : SegmentDecoder PORT MAP(Cout5, Dout5);

	HEX0 <= Dout0;
	HEX1 <= Dout1;
	HEX2 <= Dout2;
	HEX3 <= Dout3;
	HEX4 <= Dout4;
	HEX5 <= Dout5;

--	key4 <= "00" & KEY;  -- Compatible to the Other Board
	DRAM_UDQM <= dram_dqm(1);
	DRAM_LDQM <= dram_dqm(0);

end RTL;
