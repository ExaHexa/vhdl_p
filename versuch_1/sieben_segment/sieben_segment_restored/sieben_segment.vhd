library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------------------------
-- Programm dient zur Darstellung der Bitfolge aus 4 Bits in Form einer hexadezimalen Zahl
-- auf der 7-Segmentanzeige
---------------------------------------------------------------------------------------------------

entity sieben_segment is 
	port
		( 																		-- Schnittstelle-Beschreibung						-- Vorschlag zur Pinbelegung
--	 																			-------------------------------------------------------------------------
			bin		:	in std_logic_vector(3 downto 0);			-- Bitfolge aus 4 Bits								-- V12..L22 (SW3..SW0)
			led_hex	:	out std_logic_vector(6 downto 0)			-- Bitmuster für 7-Segmentanzeige				-- E2..J2 (HEX0)
		);
end sieben_segment;

architecture verhalten of sieben_segment is
begin
	with bin select led_hex <=
		"1000000" when "0000",
		"1111001" when "0001",
		"0100100" when "0010",
		"0110000" when "0011",
		"0011001" when "0100",
		"0010010" when "0101",
		"0000010" when "0110",
		"1111000" when "0111",
		"0000000" when "1000",
		"0010000" when "1001",
		"0001000" when "1010",
		"0000011" when "1011",
		"1000110" when "1100",
		"0100001" when "1101",
		"0000110" when "1110",
		"0001110" when "1111";
end verhalten;