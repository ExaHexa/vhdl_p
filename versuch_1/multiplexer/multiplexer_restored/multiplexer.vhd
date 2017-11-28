-- 8:1 MUX
-- Ergänzen Sie die fehlenden Programmteile
library ieee;
use ieee.std_logic_1164.all;


entity multiplexer is 

	port(
		A:		in std_logic_vector(7 downto 0); -- A7 = SW7 (dritter Schalter von links).... A0 = SW0 (rechter Schalter)
		S:		in std_logic_vector(2 downto 0);	-- S2 = KEY2 ..... S0 = KEY0 			 
		X:		out std_logic 							-- LEDR0
	);
	
end multiplexer;

architecture behavior of multiplexer is
begin
	with S select
	X <= 	A(0) when "000",
			A(1) when "001",
			A(2) when "010",
			A(3) when "011",
			A(4) when "100",
			A(5) when "101",
			A(6) when "110",
			A(7) when "111";
			
end behavior;	
