-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_SDRAM_Nios_Test
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
 
entity DE10_LITE_SDRAM_Nios_Test is
	port (
	-- Clocks
		ADC_CLK_10 			: in std_logic;
		MAX10_CLK1_50 		: in std_logic;
		MAX10_CLK2_50 		: in std_logic;
	-- KEY
		KEY 					: in std_logic_vector(1 downto 0);
	-- SW
		SW 					: in std_logic_vector(9 downto 0);
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
end DE10_LITE_SDRAM_Nios_Test;
 
architecture RTL of DE10_LITE_SDRAM_Nios_Test is

component DE10_LITE_Qsys is
	port (
		altpll_0_areset_conduit_export    : in    std_logic                     := 'X';             -- export
		altpll_0_locked_conduit_export    : out   std_logic;                                        -- export
		clk_clk                           : in    std_logic                     := 'X';             -- clk
		clk_sdram_clk                     : out   std_logic;                                        -- clk
		key_external_connection_export    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
		reset_reset_n                     : in    std_logic                     := 'X';             -- reset_n
		sdram_wire_addr                   : out   std_logic_vector(12 downto 0);                    -- addr
		sdram_wire_ba                     : out   std_logic_vector(1 downto 0);                     -- ba
		sdram_wire_cas_n                  : out   std_logic;                                        -- cas_n
		sdram_wire_cke                    : out   std_logic;                                        -- cke
		sdram_wire_cs_n                   : out   std_logic;                                        -- cs_n
		sdram_wire_dq                     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
		sdram_wire_dqm                    : out   std_logic_vector(1 downto 0);                     -- dqm
		sdram_wire_ras_n                  : out   std_logic;                                        -- ras_n
		sdram_wire_we_n                   : out   std_logic                                         -- we_n
	);
end component DE10_LITE_Qsys;

signal pll_a, pll_l, reset : std_logic;
signal key4 : std_logic_vector(3 downto 0);
signal dram_dqm : std_logic_vector(1 downto 0);

begin
	reset <= not SW(9);

	Nios: DE10_LITE_Qsys port map (
		pll_a, pll_l,MAX10_CLK2_50, DRAM_CLK,
		key4, reset,  
		DRAM_ADDR, DRAM_BA, DRAM_CAS_N, DRAM_CKE,
		DRAM_CS_N, DRAM_DQ, dram_dqm, DRAM_RAS_N, DRAM_WE_N
	); 

	key4 <= "00" & KEY;
	DRAM_UDQM <= dram_dqm(1);
	DRAM_LDQM <= dram_dqm(0);

end RTL;
