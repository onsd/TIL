-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_Default
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY DE10_LITE_Default IS
	PORT (
		-- CLOCK
		ADC_CLK_10 : IN std_logic;
		MAX10_CLK1_50 : IN std_logic;
		MAX10_CLK2_50 : IN std_logic;
		-- SDRAM
		DRAM_ADDR : OUT std_logic_vector(12 DOWNTO 0);
		DRAM_BA : OUT std_logic_vector(1 DOWNTO 0);
		DRAM_CAS_N : OUT std_logic;
		DRAM_CKE : OUT std_logic;
		DRAM_CLK : OUT std_logic;
		DRAM_CS_N : OUT std_logic;
		DRAM_DQ : INOUT std_logic_vector(15 DOWNTO 0);
		DRAM_LDQM : OUT std_logic;
		DRAM_RAS_N : OUT std_logic;
		DRAM_UDQM : OUT std_logic;
		DRAM_WE_N : OUT std_logic;
		-- SEG7
		HEX0 : OUT std_logic_vector(7 DOWNTO 0);
		HEX1 : OUT std_logic_vector(7 DOWNTO 0);
		HEX2 : OUT std_logic_vector(7 DOWNTO 0);
		HEX3 : OUT std_logic_vector(7 DOWNTO 0);
		HEX4 : OUT std_logic_vector(7 DOWNTO 0);
		HEX5 : OUT std_logic_vector(7 DOWNTO 0);
		-- KEY
		KEY : IN std_logic_vector(1 DOWNTO 0);
		-- LED
		LEDR : OUT std_logic_vector(9 DOWNTO 0);
		-- SW
		SW : IN std_logic_vector(9 DOWNTO 0);
		-- VGA
		VGA_B : OUT std_logic_vector(3 DOWNTO 0);
		VGA_G : OUT std_logic_vector(3 DOWNTO 0);
		VGA_HS : OUT std_logic;
		VGA_R : OUT std_logic_vector(3 DOWNTO 0);
		VGA_VS : OUT std_logic;
		-- Accelerometer
		GSENSOR_INT : IN std_logic_vector(2 DOWNTO 1);
		GSENSOR_CS_N : OUT std_logic;
		GSENSOR_SCLK : OUT std_logic;
		GSENSOR_SDI : INOUT std_logic;
		GSENSOR_SDO : INOUT std_logic;
		-- Arduino
		ARDUINO_IO : INOUT std_logic_vector(15 DOWNTO 0);
		ARDUINO_RESET_N : INOUT std_logic;
		-- GPIO, GPIO connect to GPIO Default
		GPIO : INOUT std_logic_vector(35 DOWNTO 0)
	);
END DE10_LITE_Default;

ARCHITECTURE RTL OF DE10_LITE_Default IS

	COMPONENT Reset_Delay IS
		PORT (
			iCLK : IN std_logic;
			oRESET : OUT std_logic
		);
	END COMPONENT;
	COMPONENT ClkGen IS
		GENERIC (N : INTEGER);
		PORT (
			CLK, RESET : IN std_logic;
			CLKout : OUT std_logic
		);
	END COMPONENT;
	COMPONENT UpDownCounter IS
		PORT (
			CLK, RESET : IN std_logic;
			EN, UD, SET : IN std_logic;
			Cin : IN std_logic_vector(3 DOWNTO 0);
			Cout : OUT std_logic_vector(3 DOWNTO 0);
			CB : OUT std_logic
		);
	END COMPONENT;
	COMPONENT SegmentDecoder IS
		PORT (
			Din : IN std_logic_vector(3 DOWNTO 0);
			Dout : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MIPSnp IS
		PORT (
			CLK, RESET : IN std_logic;
			PCOut : OUT std_logic_vector(7 DOWNTO 0);
			EN : in std_logic;
			RegN: in std_logic_vector(2 downto 0);
			RegD: out std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	COMPONENT Switch is
		PORT (
			clk: in std_logic;
			reset : in std_logic;
			Cin: in std_logic;
			Cout: out std_logic
		);
	END COMPONENT;

	SIGNAL DLY_RST : std_logic;
	SIGNAL clk, clk1, reset : std_logic;
	SIGNAL PC : std_logic_vector(7 DOWNTO 0);
	SIGNAL EN0, EN1, EN2, EN3, EN4, EN5, ENABLE : std_logic; -- Enable
	SIGNAL UD, SET : std_logic; -- Up/Down, Set
	SIGNAL Cin : std_logic_vector(3 DOWNTO 0); -- Counter In
	SIGNAL Cout0, Cout1, Cout2, Cout3, Cout4, Cout5 : std_logic_vector(3 DOWNTO 0); -- Counter Out
	SIGNAL CB0, CB1, CB2, CB3, CB4, CB5, S0 : std_logic; -- Carry/Borrow

	-- add signal
	SIGNAL RegN: std_logic_vector(2 downto 0);
	SIGNAL RegD: std_logic_vector(15 downto 0);
	SIGNAL TMP: std_logic_vector(15 downto 0);
	SIGNAL STOP_FLAG : std_logic;
	SIGNAL STOP_ADDR : std_logic_vector(5 downto 0);
BEGIN


	-- Reset Delay
	RD0 : Reset_Delay PORT MAP(MAX10_CLK1_50, DLY_RST);

	-- Reset
	reset <= KEY(0) AND DLY_RST;

	-- Switch
	SW0 : Switch PORT MAP(clk, reset, KEY(1), S0);

	-- Clock Generater at 1s(25000000)
	CG0 : ClkGen GENERIC MAP(25000000) PORT MAP(MAX10_CLK1_50, reset, clk1);
	clk <= clk1;


	LEDR(5 DOWNTO 0) <= PC(7 downto 2);
	LEDR(8) <= S0;

	-- Signal of Up/Down Counter	
	EN0 <= S0; -- Enable=1(It stops when EN0='0')
	EN1 <= CB0; -- 9
	EN2 <= CB1 AND EN1; -- 99
	EN3 <= CB2 AND EN2; -- 999
	EN4 <= CB3 AND EN3; -- 9999
	EN5 <= CB4 AND EN4; -- 99999

	UD <= '0';
	SET <= '0';
	Cin <= SW(3 DOWNTO 0); -- Countet In
	LEDR(9) <= CB0; -- LED Display Carry/Borrow

	STOP_FLAG <= SW(6);
	STOP_ADDR <= SW(5 downto 0);

	-- MIPS Non Pipeline	(Assignments>Settings>Files Add Components)
	RegN <= SW(9 downto 7);
	MIPSnp0 : MIPSnp PORT MAP(clk, reset, PC, EN0 AND ENABLE, RegN, TMP);
	
	-- Up/Down Counter 00 to 99
	UDC0 : UpDownCounter PORT MAP(clk, reset, EN0 AND ENABLE, UD, SET, Cin, Cout0, CB0);
	UDC1 : UpDownCounter PORT MAP(clk, reset, EN1 AND ENABLE, UD, SET, Cin, Cout1, CB1);
	UDC3 : UpDownCounter PORT MAP(clk, reset, EN3 AND ENABLE, UD, SET, Cin, Cout3, CB3);
	UDC4 : UpDownCounter PORT MAP(clk, reset, EN4 AND ENABLE, UD, SET, Cin, Cout4, CB4);

	-- select shown data
	RegD <= (Cout3 & Cout2 & Cout1 & Cout0) when (RegN = "000") else TMP;
	ENABLE <= '0' when (STOP_FLAG = '1') AND (PC = (STOP_ADDR & "00")) else '1';
	-- HEX Segment Display
	HSD0 : SegmentDecoder PORT MAP(RegD(3 downto 0), HEX0);
	HSD1 : SegmentDecoder PORT MAP(RegD(7 downto 4), HEX1);
	HSD2 : SegmentDecoder PORT MAP(RegD(11 downto 8), HEX2);
	HSD3 : SegmentDecoder PORT MAP(RegD(15 downto 12), HEX3);
	HSD4 : SegmentDecoder PORT MAP(PC(3 downto 0), HEX4);
	HSD5 : SegmentDecoder PORT MAP(PC(7 downto 4), HEX5);

END RTL;

-- Component

-- Clock Generater
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

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

-- UpDownCounter

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY UpDownCounter IS
	PORT (
		CLK, RESET : IN std_logic;
		EN, UD, SET : IN std_logic;
		Cin : IN std_logic_vector(3 DOWNTO 0);
		Cout : OUT std_logic_vector(3 DOWNTO 0);
		CB : OUT std_logic
	);
END UpDownCounter;

ARCHITECTURE RTL OF UpDownCounter IS
	SIGNAL c : std_logic_vector(3 DOWNTO 0);
BEGIN
	-- Up/Down Counter with Carry/Borrow and Enable
	PROCESS (CLK, RESET)
	BEGIN
		IF (RESET = '0') THEN
			c <= "0000";
		ELSIF (CLK'event AND CLK = '1') THEN
			IF (SET = '1') THEN
				c <= Cin;
			ELSIF (EN = '1') THEN
				IF (UD = '0') THEN -- Up
					IF (c = "1001") THEN
						c <= "0000";
					ELSE
						c <= c + 1;
					END IF;
				ELSE -- Down
					IF (c = "0000") THEN
						c <= "1001";
					ELSE
						c <= c - 1;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	Cout <= c;
	-- Carry/Borrow
	CB <= '1' WHEN (UD = '0') AND (c = "1001") ELSE -- Up Carry
		'1' WHEN (UD = '1') AND (c = "0000") ELSE -- Down Borrow
		'0';
END RTL;

-- Segment Decoder

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY SegmentDecoder IS
	PORT (
		Din : IN std_logic_vector(3 DOWNTO 0);
		Dout : OUT std_logic_vector(7 DOWNTO 0)
	);
END SegmentDecoder;

ARCHITECTURE RTL OF SegmentDecoder IS
BEGIN
	PROCESS (Din)
	BEGIN
		CASE Din IS
			WHEN "0000" => Dout <= "11000000"; -- 0
			WHEN "0001" => Dout <= "11111001"; -- 1
			WHEN "0010" => Dout <= "10100100"; -- 2
			WHEN "0011" => Dout <= "10110000"; -- 3
			WHEN "0100" => Dout <= "10011001"; -- 4
			WHEN "0101" => Dout <= "10010010"; -- 5
			WHEN "0110" => Dout <= "10000010"; -- 6
			WHEN "0111" => Dout <= "11111000"; -- 7
			WHEN "1000" => Dout <= "10000000"; -- 8
			WHEN "1001" => Dout <= "10010000"; -- 9
			WHEN "1010" => Dout <= "00001000"; -- A.
			WHEN "1011" => Dout <= "00000011"; -- b.
			WHEN "1100" => Dout <= "01000110"; -- C.
			WHEN "1101" => Dout <= "00100001"; -- d.
			WHEN "1110" => Dout <= "00000110"; -- E.
			WHEN "1111" => Dout <= "00001110"; -- F.
			WHEN OTHERS => Dout <= "11111111"; -- No Disp
		END CASE;
	END PROCESS;
END RTL;