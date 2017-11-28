-- 1:8 DEMUX
-- Ergänzen Sie die fehlenden Programmteile

library ieee;
use ieee.std_logic_1164.all;


entity demultiplexer is 

	port(
		a:		in std_logic;							-- a = SW0 (rechter Schalter) 
		s:		in std_logic_vector(2 downto 0); -- s2 = KEY2 ..... s0 = KEY0			
		x:		out std_logic_vector(7 downto 0) -- LEDG7....LEDG0
	);

end demultiplexer;

architecture behavior of demultiplexer is
begin
	x(0)<= a when s="000";
	x(1)<= a when s="001";
	x(2)<= a when s="010";
	x(3)<= a when s="011";
	x(4)<= a when s="100";
	x(5)<= a when s="101";
	x(6)<= a when s="110";
	x(7)<= a when s="111";
end behavior;


