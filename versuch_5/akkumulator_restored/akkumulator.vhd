library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity akkumulator is 

	port (
		d	: in std_logic_vector(3 downto 0); -- Daten-Eingang
      ld : in std_logic; -- MUX Steuereingang: 0(gedrückt)=Ergebnis durchschalten, 1(nicht gedrückt)= Dateneingang durchschalten
		sub : in std_logic; -- 0=+, 1=-
		e	: in std_logic; -- enable Auffangregister 0(gedrückt)= enabled
		clk : in std_logic; -- Takt

		c : out std_logic; -- LEDG(4) carry out
		q : out std_logic_vector(3 downto 0); -- LEDG(3..0) Daten-Ausgang
		
		-- debug pins:
		z_out : out std_logic_vector(4 downto 0)	-- LEDR(4..0), z4 = carry
		
	
		);
end entity akkumulator;

architecture arc of akkumulator is
	
	signal d_int : std_logic_vector(4 downto 0);
	signal x : std_logic_vector(4 downto 0);
	signal z : std_logic_vector(4 downto 0);

begin

-- MUX select data input
	with ld select d_int <= 
				'0' & d when '1',
						z when '0'; 
	
-- auffangregister
	registerProc : process(clk) is
	begin
			
		if rising_edge(clk) and e='1' then
				x <= d_int;
		end if;
			
		q <= x(3 downto 0);
		c <= x(4);
		
	end process registerProc;
		
	--Addierer
	addierer : process(d, x) is
	begin
			if sub = '0' then
				z <= std_logic_vector(signed('0' & x(3 downto 0)) + signed('0' & d));
			elsif sub = '1' then
				z <= std_logic_vector(signed('0' & x(3 downto 0)) - signed('0' & d));
			end if;
	end process addierer;
	
	z_out <= z;	
	
end architecture arc;
