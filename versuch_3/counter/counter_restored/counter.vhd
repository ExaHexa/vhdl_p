library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 



	port (
		reset_n     : in std_logic; -- Key 3
      clk         : in std_logic; --50 MHz
		switches		: in std_logic_vector(7 downto 0); -- zur Übernahme des ofl-values
		cnt_enable	: in std_logic; -- SW9
		ofl_rd		: in std_logic; -- read and store ofl-value, KEY0
		cnt_rd		: in std_logic; -- read and store the actual count-value, KEY1
		cnt_val_act : out std_logic_vector(7 downto 0); -- aktueller Zählwert
		cnt_val_stored_out : out std_logic_vector(7 downto 0) -- gespeicherter Zählwert
		
		
		);
end entity counter;

architecture arch of counter is
		
		signal temp : unsigned(22 downto 0) := "00000000000000000000000";	
		signal count : unsigned(7 downto 0) := "00000000";
		signal overflow : unsigned(7 downto 0) := "11111111";
		signal cnt_enableBool : boolean := true;
		
	begin
		
		counter : process(clk, reset_n)
			begin
				if reset_n = '0' then
					count <= "00000000";
				elsif rising_edge(clk) then
					if temp >= "10011000100101101000000" then
						if(count >= overflow) then 
							count <= "00000000";
						elsif(cnt_enableBool) then
							count <= count + 1;
						end if;
						cnt_val_act <= std_logic_vector(unsigned(count));
						temp <= "00000000000000000000000";
					else 
						temp <= temp + 1;
					end if;
				end if;
			end process;
			
		
		saveCurValue : process(clk, cnt_rd)
		begin
			if rising_edge(clk) then
				if cnt_rd = '0' then
					cnt_val_stored_out <= std_logic_vector(unsigned(count));
				end if;
			end if;
		end process;

		saveOverflow : process(clk)
			begin
				if rising_edge(clk) then
					if ofl_rd = '0' then
						overflow <= unsigned(switches);
					end if;
				end if;
			end process;
			
		startStopCnt : process(clk)
			begin	
				if rising_edge(clk) then
					if cnt_enable = '1' then
						cnt_enableBool <= true;
					elsif cnt_enable = '0' then
						cnt_enableBool <= false;
					end if;
				end if;
			end process;

end architecture arch;
	
	
	
	
	
	
	
	