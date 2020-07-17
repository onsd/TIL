-------------------------------------------------------
-- Auto-generated module template: DE10_LITE_Default
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.ALL;

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
		-- SEG7S
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
	SIGNAL clk, reset : std_logic;
	SIGNAL START, SET, isSet, UD, CB, isStop : std_logic; -- Enable, Set, Up/Down, Carry/Borrow
	SIGNAL Cout, Zero : std_logic_vector(3 DOWNTO 0); -- Counter In/Out
	SIGNAL Cin, decode1, decode2 : std_logic_vector(7 DOWNTO 0); -- Decoder
	SIGNAL DLY_RST : std_logic;

	SIGNAL ChatteringOut0 : std_logic;
	SIGNAL ChatteringOut1 : std_logic;

	SIGNAL Switch0Out : std_logic;
	SIGNAL Switch1Out : std_logic;

	SIGNAL Cout0 : std_logic_vector(3 DOWNTO 0);
	SIGNAL Cout1 : std_logic_vector(3 DOWNTO 0);
	SIGNAL Cout2 : std_logic_vector(3 DOWNTO 0);
	SIGNAL Cout3 : std_logic_vector(3 DOWNTO 0);
	SIGNAL Cout4 : std_logic_vector(3 DOWNTO 0);
	SIGNAL Cout5 : std_logic_vector(3 DOWNTO 0);

	SIGNAL CB0 : std_logic;
	SIGNAL CB1 : std_logic;
	SIGNAL CB2 : std_logic;
	SIGNAL CB3 : std_logic;
	SIGNAL CB4 : std_logic;
	SIGNAL CB5 : std_logic;

	SIGNAL EN0 : std_logic;
	SIGNAL EN1 : std_logic;
	SIGNAL EN2 : std_logic;
	SIGNAL EN3 : std_logic;
	SIGNAL EN4 : std_logic;
	SIGNAL EN5 : std_logic;

	SIGNAL Dout0 : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout1 : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout2 : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout3 : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout4 : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout5 : std_logic_vector(7 DOWNTO 0);
	SIGNAL UpperSet : std_logic_vector(3 DOWNTO 0);
	SIGNAL LowerSet : std_logic_vector(3 DOWNTO 0);
	COMPONENT Reset_Delay IS
		PORT (
			iCLK : IN std_logic;
			oRESET : OUT std_logic
		);
	END COMPONENT;

	COMPONENT ChatteringButton IS
		PORT (
			clk : IN std_logic;
			Cin : IN std_logic;
			Cout : OUT std_logic
		);
	END COMPONENT;

	COMPONENT Switch IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			Cin : IN std_logic;
			Cout : OUT std_logic
		);
	END COMPONENT;

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

	COMPONENT UD6Counter IS
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

BEGIN

	RESETDelay : Reset_Delay PORT MAP(MAX10_CLK1_50, DLY_RST);

	-- IO test
	LEDR(7 DOWNTO 0) <= SW(7 DOWNTO 0);

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
	reset <= NOT SW(9);
	isStop <= NOT (CB0 AND CB1 AND CB2 AND CB3 AND CB4 AND CB5 AND '1');
	
	Chattering0 : ChatteringButton PORT MAP(clk, key(0), ChatteringOut0);
	Chattering1 : ChatteringButton PORT MAP(clk, key(1), ChatteringOut1);

	S0 : Switch PORT MAP(clk, reset, key(0), Switch0Out);
	S1 : Switch PORT MAP(clk, reset, key(1), Switch1Out);

	SET <= NOT ChatteringOut0; -- Set Initial Value=1
	isSet <= NOT Switch0Out;
	START <= NOT Switch1Out; -- Enable=key(9)(Up/Down)

	UD <= '1'; -- Up/Down=0/1 

	UpperSet <= SW(7 DOWNTO 4);
	LowerSet <= SW(3 DOWNTO 0);

	LEDR(8) <= isSET;
	LEDR(9) <= START; -- LED Display Carry/Borrow

	ZERO <= "0000";
	C0 : UDCounter PORT MAP(clk, reset, START, isSET, SET, ZERO, Cout0, CB0, isStop);

	EN1 <= CB0 AND START;
	C1 : UDCounter PORT MAP(clk, reset, EN1, isSET, SET, ZERO, Cout1, CB1, isStop);

	EN2 <= CB1 AND CB0 AND START;
	C2 : UDCounter PORT MAP(clk, reset, EN2, isSET, SET, ZERO, Cout2, CB2, isStop);

	EN3 <= CB2 AND CB1 AND CB0 AND START;
	C3 : UD6Counter PORT MAP(clk, reset, EN3, isSET, SET, ZERO, Cout3, CB3, isStop);

	EN4 <= CB3 AND CB2 AND CB1 AND CB0 AND START;
	C4 : UDCounter PORT MAP(clk, reset, EN4, isSET, SET, LowerSet, Cout4, CB4, isStop);

	EN5 <= CB4 AND CB3 AND CB2 AND CB1 AND CB0 AND START;
	C5 : UDCounter PORT MAP(clk, reset, EN5, isSET, SET, UpperSet, Cout5, CB5, isStop);

	-- TODO: 1. ストップできるカウンタをつくる DONE
	-- TODO: 2. 時間をセットできるようにする DONE
	-- TODO: 3. チャタリングやる DONE
	-- TODO: 4. SETしたときにスタートしてしまう DONE
	-- TODO: 5. カウントアップ・ダウンの実装　DONE

	-- Decoder
	D0 : SegmentDecoder PORT MAP(Cout0, Dout0);
	D1 : SegmentDecoder PORT MAP(Cout1, Dout1);
	D2 : SegmentDecoder PORT MAP(Cout2, Dout2);
	D3 : SegmentDecoder PORT MAP(Cout3, Dout3);
	D4 : SegmentDecoder PORT MAP(Cout4, Dout4);
	D5 : SegmentDecoder PORT MAP(Cout5, Dout5);

	HEX5 <= Dout5;
	HEX4 <= Dout4;
	HEX3 <= Dout3;
	HEX2 <= Dout2;
	HEX1 <= Dout1;
	HEX0 <= Dout0;

END RTL;