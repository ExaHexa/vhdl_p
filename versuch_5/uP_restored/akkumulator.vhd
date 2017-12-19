library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity akkumulator is 

	port (
		reset_n : in std_logic;
		d	: in std_logic_vector(3 downto 0); -- Daten-Eingang
      ld : in std_logic; -- MUX Steuereingang: 0=Ergebnis durchschalten, 1= Dateneingang durchschalten
		sub : in std_logic; -- 0=+, 1=-
		e	: in std_logic; -- enable Auffangregister 0(gedrückt)= enabled
		clk : in std_logic; -- Takt

		c : out std_logic; -- LEDG(4) carry out
		q : out std_logic_vector(3 downto 0); -- LEDG(3..0) Daten-Ausgang
		
		-- debug pins:
		z_out : out std_logic_vector(4 downto 0)	-- LEDR(4..0), z4 = carry
		
	
		);
end entity akkumulator;

architecture arch of akkumulator is

-- signals
signal d_int : std_logic_vector (4 downto 0);	
signal z : std_logic_vector(4 downto 0);	-- z4 = carry
signal x : std_logic_vector(4 downto 0);	-- x4 = carry



begin

-- ****************** MUX **************************
with ld select
		d_int <= 
			'0' & d when '1',
			z when '0';

	
			
-- ***************** Auffangregister ******************			

reg_proc : process(clk, reset_n) is

begin

	if reset_n = '0' then
		x <= (others => '0');
	elsif rising_edge(clk) then
		if e = '1' then -- enabled
			x <= d_int;
		end if;
	end if;
	q <= x(3 downto 0);
	c <= x(4);

	
end process reg_proc;

-- ****************** Addierer / Subtrahierer ********************
add_sub : process(x, d) is

begin
	if sub = '0' then
		z <= std_logic_vector(signed('0' & x(3 downto 0)) + signed('0' & d));
	elsif sub = '1' then
		z <= std_logic_vector(signed('0' & x(3 downto 0)) - signed('0' & d));
	end if;
end process add_sub;	
z_out <= z;

end architecture arch;
	
	



