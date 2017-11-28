library ieee;
use ieee.std_logic_1164.all;

entity hexadezimal is
	port (
	S0,S1,S2,S3		: in std_logic;
	OUTPUT			: out std_logic	
	);
end hexadezimal;

architecture verhalten of hexadezimal is
begin
	
	OUTPUT <= S3 OR (S2 and S1 and S0);
	
end verhalten;