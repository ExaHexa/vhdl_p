library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is 



	port (
		reset_n : in std_logic; -- Key3
		clk : in std_logic; -- Takt via Key0
		data_cmd : in std_logic_vector(7 downto 0);-- Datenbus
		c_out : out std_logic; -- LEDG(4) carry out
		q_out : out std_logic_vector(7 downto 0); -- LEDG(3..0) Daten-Ausgang
		led_hex_a	: out std_logic_vector(6 downto 0); -- Instruktionszähler
		led_hex_b	: out std_logic_vector(6 downto 0); -- cmd
		led_hex_c	: out std_logic_vector(6 downto 0); -- data
		led_hex_d	: out std_logic_vector(6 downto 0); -- adr
		status_z_out : out std_logic;
		status_c_out : out std_logic;
		status_n_out : out std_logic;
		adr_out : out std_logic_vector(3 downto 0);
	
		-- debug:
		e_out : out std_logic;
		ld_out : out std_logic;
		sub_out : out std_logic;
		s_out : out std_logic_vector(1 downto 0);
		we_out : out std_logic;
		m1_out : out std_logic;
		m2_out : out std_logic 
	
	
		);
end entity cpu;

architecture arch of cpu is
	
	
	-- commands
	constant dont_care : std_logic_vector(3 downto 0) := "----";
	constant NOP : std_logic_vector(3 downto 0) := x"0";
	constant LDA_n : std_logic_vector(3 downto 0) := x"1";
	constant LDA_pn : std_logic_vector(3 downto 0) := x"2";
	constant STA_pn : std_logic_vector(3 downto 0) := x"3";
	
	constant ADD_n : std_logic_vector(3 downto 0) := x"4";
	constant ADD_pn : std_logic_vector(3 downto 0) := x"5";
	constant SUB_n : std_logic_vector(3 downto 0) := x"6";
	constant SUB_pn : std_logic_vector(3 downto 0) := x"7";
	
	constant JMP_n : std_logic_vector(3 downto 0) := x"8";
	constant BRZ_n : std_logic_vector(3 downto 0) := x"9";
	constant BRC_n: std_logic_vector(3 downto 0) := x"A";
	constant BRN_n: std_logic_vector(3 downto 0) := x"B";
	

	-- signals
	signal d : std_logic_vector(3 downto 0); --Akkumulator: Daten-Eingang 
	signal c : std_logic; --Akkumulator: carry out
	signal q : std_logic_vector(3 downto 0); --Akkumulator: Daten-Ausgang
	
	alias data is data_cmd(7 downto 4);
	alias cmd is data_cmd(3 downto 0);
		
	
	signal data_reg : std_logic_vector(3 downto 0);-- Datenregister
	signal instr_reg : std_logic_vector(3 downto 0);-- Instruktionsregister
	signal status_reg : std_logic_vector(3 downto 0):= x"0";-- Statusregister
		alias status_z is status_reg(3);
		alias status_c is status_reg(2);
		alias status_n is status_reg(1);
		
	signal adr : std_logic_vector(3 downto 0); -- Adressbus
	signal prog_cnt : unsigned (3 downto 0);

	--				7 6  5   4  3  2  1    
	--cntrls:   e,ld,sub,s1,s0,we,m1 
	signal cntrls : std_logic_vector (7 downto 0):= x"FF"; 
	alias e is cntrls(7);
	alias ld is cntrls(6);
	alias sub is cntrls(5);
	alias s is cntrls(4 downto 3);
	alias we is cntrls(2);
	alias m1 is cntrls(1);
	alias m2 is cntrls(0);




	
	attribute keep: boolean;
	attribute keep of all : signal is true;
	
	
begin



status_z_out <= status_z;
status_c_out <= status_c;
status_n_out <= status_n;



e_out <= e;
ld_out <= ld;
sub_out <= sub;
s_out <= s;
we_out <= we;
m1_out <= m1;
m2 <= not clk;
m2_out <= m2;-- debug










hex7a_inst : entity work. hex_to_seven(arch) port map(
		hex => std_logic_vector(prog_cnt),
		seven_segment => led_hex_a 
		);
hex7b_inst : entity work. hex_to_seven(arch) port map(
		hex => std_logic_vector(cmd),
		seven_segment => led_hex_b 
		);
hex7c_inst : entity work. hex_to_seven(arch) port map(
		hex => std_logic_vector(data),
		seven_segment => led_hex_c 
		);
hex7d_inst : entity work. hex_to_seven(arch) port map(
		hex => std_logic_vector(adr),
		seven_segment => led_hex_d 
		);



akkumulator_inst : entity work.akkumulator(arch) port map(
	reset_n => reset_n,
	d => d,--in
	ld => ld,--in
	sub => sub,--in
	e => e,	--in
	clk => not clk, -- 
	c => c, --out
	q => q--out
		);
		
q_out(7 downto 4) <= q;
q_out(3 downto 0) <= x"0";
c_out <= c;


		
		
-- ****************** MUX 1 (vor Akkumulator) **************************
with m1 select
		d <= 
			data when '0',
			data_reg when '1';

-- ****************** MUX 2 (vor Adressbus) **************************
with m2 select
		adr <= 
			data_reg when '0',
			std_logic_vector(prog_cnt) when '1';
adr_out <= adr;
			
			
	
			
-- ***************** Datenregister / Instruktionsregister / Statusregister ******************			

p_regs : process(clk, reset_n) is

begin

	if reset_n = '0' then
		data_reg <= (others => '0');
		instr_reg <= (others => '0');
		status_c <= '0';
		status_z <= '0';
		status_n <= '0';
		
	elsif rising_edge(clk) then --  
		data_reg <= data;	
		
		instr_reg <= cmd;
		
		status_c <= c; -- carry
		if q = x"0" then
			status_z <= '1'; -- zero	
		else	
			status_z <= '0'; -- not zero	
		end if;
	
		if q(3) = '1' then
			status_n <= '1'; -- negative
		else		
			status_n <= '0'; -- positive
		end if;		
		
	end if;	
end process p_regs;






-- ***************** Instruktionszähler ******************			
p_prog_counter : process(clk, reset_n) is

begin
	if reset_n = '0' then
			prog_cnt <= (others => '0');
	elsif falling_edge(clk) then --  
		if s = "00" then -- indirekter Sprung
			prog_cnt <= prog_cnt + unsigned(data_reg);
		elsif s = "01" then -- direkter Sprung  
			prog_cnt <= unsigned(data_reg);	
		elsif s = "10" then -- hochzaehlen  
			prog_cnt <= prog_cnt + 1;
		elsif s = "11" then -- reset
			prog_cnt <= (others => '0');
		end if;		
	end if;	
end process p_prog_counter;


-- ***************** Steuerwerk ******************		

--				7 6  5   4  3  2  1    
--cntrls:   e,ld,sub,s1,s0,we,m1 

cntrls(7 downto 1) <= 
	--	 7654321
		"0--100-" when clk = '0' else -- fetch
		"0--100-" when (instr_reg = NOP and clk = '1') else
		"11-1001" when (instr_reg = LDA_n and clk = '1') else 
		"11-1000" when (instr_reg = LDA_pn and clk = '1') else 
		"0--101-" when (instr_reg = STA_pn and clk = '1') else
		"1001001" when (instr_reg = ADD_n and clk = '1') else
		"1001000" when (instr_reg = ADD_pn and clk = '1') else		
		"1011001" when (instr_reg = SUB_n and clk = '1') else
		"1011000" when (instr_reg = SUB_pn and clk = '1') else
		"0--010-" when (instr_reg = JMP_n and clk = '1') else
		"0--100-" when (instr_reg = BRZ_n and status_z = '0' and clk = '1') else
		"0--000-" when (instr_reg = BRZ_n and status_z = '1' and clk = '1') else
		"0--100-" when (instr_reg = BRC_n and status_c = '0' and clk = '1') else
		"0--000-" when (instr_reg = BRC_n and status_c = '1' and clk = '1') else
		"0--100-" when (instr_reg = BRN_n and status_n = '0' and clk = '1') else
		"0--000-" when (instr_reg = BRN_n and status_n = '1' and clk = '1');


end architecture arch;
	
	



