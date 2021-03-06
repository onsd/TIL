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
COMPONENT ClkGen IS
	GENERIC (N : INTEGER);
	PORT (
		CLK, RESET : IN std_logic;
		CLKout : OUT std_logic
	);
END COMPONENT;

SIGNAL START, SET, isSet, UD, CB, isStop : std_logic; -- Enable, Set, Up/Down, Carry/Borrow
signal pll_a, pll_l, reset,clk, clk1 : std_logic;
SIGNAL Cout0, Cout1, Cout2, Cout3, Cout4, Cout5 : std_logic_vector(3 DOWNTO 0); -- Counter Out
signal hex : std_logic_vector(31 downto 0);
signal ZERO : std_logic_vector(3 DOWNTO 0); --
--signal key4 : std_logic_vector(3 downto 0);
signal dram_dqm : std_logic_vector(1 downto 0);
signal INPUT: std_logic_vector(31 downto 0);

SIGNAL CB0 : std_logic;
SIGNAL CB1 : std_logic;
SIGNAL CB2 : std_logic;
SIGNAL CB3 : std_logic;
SIGNAL CB4 : std_logic;
SIGNAL CB5 : std_logic;
SIGNAL EN0, EN1, EN2, EN3, EN4, EN5, ENABLE : std_logic; -- Enable

begin
	-- Clock Generater at 1s(25000000)
	CG0 : ClkGen GENERIC MAP(25000000) PORT MAP(MAX10_CLK1_50, reset, clk1);
	clk <= clk1;
	reset <= not SW(9);

	LEDR(8) <= isSET;
	LEDR(9) <= START; -- LED Display Carry/Borrow
	
	ZERO <= "0000";
	C0 : UDCounter PORT MAP(clk, reset, START, isSET, SET, ZERO, Cout0, CB0, isStop);

	EN1 <= CB0 AND START;
	C1 : UDCounter PORT MAP(clk, reset, EN1, isSET, SET, ZERO, Cout1, CB1, isStop);

	EN2 <= CB1 AND CB0 AND START;
	C2 : UDCounter PORT MAP(clk, reset, EN2, isSET, SET, ZERO, Cout2, CB2, isStop);

	EN3 <= CB2 AND CB1 AND CB0 AND START;
	C3 : UDCounter PORT MAP(clk, reset, EN3, isSET, SET, ZERO, Cout3, CB3, isStop);

	Nios: DE10_LITE_Qsys port map (
		pll_a, pll_l,MAX10_CLK2_50, DRAM_CLK,
		hex, KEY, LEDR, reset,  
		DRAM_ADDR, DRAM_BA, DRAM_CAS_N, DRAM_CKE,
		DRAM_CS_N, DRAM_DQ, dram_dqm, DRAM_RAS_N, DRAM_WE_N,
		SW
	); 

	-- hex(15 downto 0) -> counter value
	-- hex(16) -> START
	
	-- hex(0) == 0 or 1
	-- TODO:
	-- 	1. set UDCounter 
	-- 	2. set SegmentDecoder
	-- 	3. IO_WRITE: 0 : start/stop
	--  					 1 : set	
	--                 2 :clear 
	--						 31 downto 16 : counter value
	
	HEX0 <= "0000" & hex(3 downto 0);
	HEX1 <= "0000" & hex(7 downto 4);
	HEX2 <= "0000" & hex(11 downto 8);
	HEX3 <= "0000" & hex(15 downto 12);
	HEX4 <= (others => '0');
	HEX5 <= (others => '0');
--	key4 <= "00" & KEY;  -- Compatible to the Other Board
	DRAM_UDQM <= dram_dqm(1);
	DRAM_LDQM <= dram_dqm(0);

end RTL;


-- Clock Generater
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
ENTITY ClkGen IS
	GENERIC (N : INTEGER := 25000000); -- 1s
	PORT (
		CLK, RESET : IN std_logic;
		CLKout : OUT std_logic
	);
END ClkGen;

ARCHITECTURE RTL OF ClkGen IS
	SIGNAL c : std_logic;
BEGIN
	PROCESS (CLK, RESET)
		VARIABLE i : INTEGER;
	BEGIN
		IF (RESET = '0') THEN
			i := 0;
			c <= '0';
		ELSIF (CLK'event AND CLK = '1') THEN
			IF (i < N) THEN
				i := i + 1;
			ELSE
				i := 0;
				c <= NOT c;
			END IF;
		END IF;
	END PROCESS;
	CLKout <= c;
END RTL;
