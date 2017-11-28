library ieee;
use ieee.std_logic_1164.all;


entity bcd_to_sieben_segment is 
	port
		( 																		
			bcd_a		:	in std_logic_vector(3 downto 0);	
			bcd_b		:	in std_logic_vector(3 downto 0);	
			bcd_c		:	in std_logic_vector(3 downto 0);	
			bcd_d		:	in std_logic_vector(3 downto 0);	

			led_hex_a	:	out std_logic_vector(6 downto 0);			-- Bitmuster für 7-Segmentanzeige				
			led_hex_b	:	out std_logic_vector(6 downto 0);			-- Bitmuster für 7-Segmentanzeige				
			led_hex_c	:	out std_logic_vector(6 downto 0);			-- Bitmuster für 7-Segmentanzeige				
			led_hex_d	:	out std_logic_vector(6 downto 0)			-- Bitmuster für 7-Segmentanzeige				

			
			
			
		);
end bcd_to_sieben_segment;

architecture verhalten of bcd_to_sieben_segment is

begin
	with bcd_a select
		led_hex_a <= 
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
			"0001110" when "1111",
			"1000000" when others;
		
	with bcd_b select
		led_hex_b <= 
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
			"0001110" when "1111",
			"1000000" when others;

	with bcd_c select
		led_hex_c <= 
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
			"0001110" when "1111",
			"1000000" when others;

	with bcd_d select
		led_hex_d <= 
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
			"0001110" when "1111",
			"1000000" when others;
			
			
		
end verhalten;