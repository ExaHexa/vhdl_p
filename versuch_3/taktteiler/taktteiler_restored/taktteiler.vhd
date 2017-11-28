library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity taktteiler is 


	port (
      clk         : in std_logic; --50 MHz
		clk_10Hz		: out std_logic			
		
		);
end entity taktteiler;

architecture arch of taktteiler is
	
		signal count : unsigned(21 downto 0) := "0000000000000000000000";
		signal clk_10HzS : std_logic := '1';
	begin
	
	taktteiler : process (clk)
		begin
			if(rising_edge(clk)) then		
				if count = "1001100010010110100000" then
					count <= "0000000000000000000000";
					clk_10HzS <= not clk_10HzS;
				else
					count <= count + 1;
				end if;
			end if;
			clk_10Hz <= clk_10HzS;
		end process;


end architecture arch;
	
	
	
	
	
	
	
	