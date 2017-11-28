library ieee;
use ieee.std_logic_1164.all;

entity logikfunktion is
	port (
			X		: in std_logic_vector(2 downto 0);
			Y		: out std_logic
			);
end logikfunktion;

architecture verhalten of logikfunktion is
begin 

	Y <= NOT X(1) AND (X(2) OR X(0));

end verhalten;