library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stoppuhr_bcd is 

	port (
		reset_n : in std_logic;
		clk: in std_logic;
		cnt_enable : in std_logic;
		
		
		bcd_a : out std_logic_vector(3 downto 0);
		bcd_b : out std_logic_vector(3 downto 0);
		bcd_c : out std_logic_vector(3 downto 0);
		bcd_d : out std_logic_vector(3 downto 0)
		);
end entity stoppuhr_bcd;

architecture arch of stoppuhr_bcd is

	signal temp : unsigned(18 downto 0) := "0000000000000000000";
	signal ms1 : unsigned(3 downto 0) := "0000";
	signal ms2 : unsigned(3 downto 0) := "0000";
	signal s1 : unsigned(3 downto 0) := "0000";
	signal s2 : unsigned(3 downto 0) := "0000";
	
	begin

		stopuhr : process(clk, reset_n)
		begin
			if reset_n = '0' then
				ms1 <= "0000";
				ms2 <= "0000";
				s1 <= "0000";
				s2 <= "0000";
			elsif rising_edge(clk) then
				if temp >= "1111010000100100000" then
						if cnt_enable = '1' then
							ms1 <= ms1 + 1;
							if ms1 >= "1001" then
								ms1 <= "0000";
								ms2 <= ms2 + 1;
								if ms2 >= "1001" then
									ms2 <= "0000";
									s1 <= s1 + 1;
									if s1 >= "1001" then
										s1 <= "0000";
										s2 <= s2 + 1;
										if s2 >= "0110" then
											s2 <= "0000";
										end if;
									end if;
								end if;	
							end if;
						bcd_a <= std_logic_vector(unsigned(s2));
						bcd_b <= std_logic_vector(unsigned(s1));
						bcd_c <= std_logic_vector(unsigned(ms2));
						bcd_d <= std_logic_vector(unsigned(ms1));
						end if;
					temp <= "0000000000000000000";
				else 
					temp <= temp + 1;
				end if;
			end if;

		end process;
		
		--reset : process(reset_n)
		--begin
			--if reset_n = '1' then
				--ms1 <= "0000";
				--ms2 <= "0000";
				--s1 <= "0000";
				--s2 <= "0000";
			--end if;
		--end process;


end architecture arch;

	