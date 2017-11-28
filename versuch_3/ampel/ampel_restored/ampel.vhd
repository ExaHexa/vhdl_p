-- Anmerkung: 
-- In der Praxis würde man diese Ampelsteuerung eher komplett in einem getakteten Prozess implementieren, 
-- anstatt die Logik in zwei Prozesse (1x getaktet und 1x ungetaktet) aufzusplitten.
-- Durch diese hier gewählte Aufsplittung können einige Probleme entstehen ("race-conditions", "hazards").  
-- gez. Udo Siebertz


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ampel is 
	generic (
		CNT_OFL : positive := 50000000-1 -- Sekundentakt ofl  	
	
	);

	port (
      reset_n	: in std_logic; -- Key3
		clk   	: in std_logic; --50 MHz
		taste		: in std_logic; -- Key0: Taste an Fussgaengerampel
		
		ledg7_out	: out std_logic; --LEDG[7] 
		ledg30_out	: out std_logic_vector(3 downto 0); -- LEDG[3…0]
 
		ledr93_out	: out std_logic_vector(9 downto 3); -- LEDR[9…3] 	
		ledr0_out	: out std_logic -- LEDR[0]	
		
		
		);
end entity ampel;

architecture arch of ampel is 

-- signals

signal cnt : unsigned(25 downto 0);
signal time_s : unsigned(4 downto 0); 


type main_state_t is (wait_for_idle, idle, r_g_r, r_o_r, r_r_r, r_r_g, r_ro_r, reset);
-- Bsp: r_g_r bedeutet: timer run, Verkehrsampel: grün, Fußgängerampel: rot
signal main_state, next_main_state : main_state_t;

type ampel_colour_t is (rot, gruen, orange, rot_orange);
signal fa_colour, va_colour : ampel_colour_t; -- Fussgaengerampel, Verkehrsampel


signal ledg7 : std_logic;	
signal ledg30 : std_logic_vector(3 downto 0);	
signal ledr93 : std_logic_vector(9 downto 3);
signal ledr0 : std_logic;	


begin

z_reg : process (clk, reset_n)--ERGÄNZE Sensitivitätsliste
begin
	if (reset_n = '0') then	
		cnt <= (others => '0');
		time_s <= (others => '0');	
		main_state <= reset;
	elsif rising_edge(clk) then
		-- Update State Register
		main_state <= next_main_state;
	
			-- fast counter, overflow = 1s 
		if cnt = to_unsigned(CNT_OFL, cnt'length) or main_state = idle then
			cnt <= (others => '0');
		else
			cnt <= cnt + 1;			
		end if;
		
		-- Sekunden timer		
		if main_state = reset then -- reset timer
			time_s <= (others => '0');	
		elsif main_state /= idle and cnt = CNT_OFL then
			time_s <= time_s + 1;
		end if;

	end if;
	
	
end process z_reg;





ampel_control : process(main_state, taste) is --ERGÄNZE Sensitivitätsliste

begin

		
	case main_state is						-- timer				VA				FA		
													-----------------------------------
							
		when reset =>  						-- reset timer 	rot/orange	rot
			va_colour <= rot_orange;
			fa_colour <= rot;
			next_main_state <= wait_for_idle;
		when wait_for_idle =>				-- run				grün			rot
			va_colour <= gruen;
			fa_colour <= rot;
			if time_s < "00111" and taste = '1' then 
				next_main_state <= wait_for_idle;
			elsif time_s = "00111" then
				next_main_state <= idle;
			elsif time_s < "00111" and taste = '0' then
				next_main_state <= r_g_r;
			end if;
		when idle =>							-- stop				grün			rot
				va_colour <= gruen;
				fa_colour <= rot;
				if taste = '1' then
					next_main_state <= idle;
				elsif taste = '0' then
					next_main_state <= r_g_r;
				end if;
		when r_g_r =>							-- run				grün			rot
				va_colour <= gruen;
				fa_colour <= rot;
				if time_s < "01010" then
					next_main_state <= r_g_r;
				elsif time_s = "01010" then
					next_main_state <= r_o_r;
				end if;
		when r_o_r =>							-- run				orange		rot
			va_colour <= orange;
			fa_colour <= rot;
			if time_s < "01100" then
				next_main_state <= r_o_r;
			elsif time_s = "01100" then
				next_main_state <= r_r_r;
			end if;
		when r_r_r =>							-- run				rot			rot
			va_colour <= rot;
			fa_colour <= rot;
			if time_s < "01101" then
				next_main_state <= r_r_r;
			elsif time_s = "01101" then
				next_main_state <= r_r_g;
			elsif time_s < "10100" then
				next_main_state <= r_r_r;
			elsif time_s = "10100" then
				next_main_state <= r_ro_r;
			end if;
		when r_r_g =>							-- run				rot			grün
			va_colour <= rot;
			fa_colour <= gruen;
			if time_s < "10010" then
				next_main_state <= r_r_g;
			elsif time_s = "10010" then
				next_main_state <= r_r_r;
			end if;
		when r_ro_r => 						-- run				rot/orange	rot
			va_colour <= rot_orange;
			fa_colour <= rot;
			if time_s < "10101" then
				next_main_state <= r_ro_r;
			elsif time_s = "10101" then
				next_main_state <= reset;
			end if;
	end case;															

	-- Fussgaengerampel
	if fa_colour = rot then
		ledr0 <= '1';
		ledg7 <= '0';
	elsif fa_colour = gruen then
		ledr0 <= '0';
		ledg7 <= '1';
	end if;

	-- Verkehrsampel
	if va_colour = rot then
		ledr93(9) <= '1';
		ledr93(8) <= '1';
		ledr93(7) <= '1';
		ledr93(6) <= '1';
		ledr93(5) <= '1';
		ledr93(4) <= '1';
		ledr93(3) <= '0';
		ledg30 <= (others => '0');			
	elsif va_colour = orange then
		ledr93(9) <= '1';
		ledr93(8) <= '0';
		ledr93(7) <= '1';
		ledr93(6) <= '0';
		ledr93(5) <= '1';
		ledr93(4) <= '0';
		ledr93(3) <= '0';
		ledg30 <= (others => '0');
	elsif va_colour = rot_orange then
		ledr93(9) <= '1';
		ledr93(8) <= '1';
		ledr93(7) <= '1';
		ledr93(6) <= '0';
		ledr93(5) <= '1';
		ledr93(4) <= '0';
		ledr93(3) <= '1';
		ledg30 <= (others => '0');						
	elsif va_colour = gruen then
		ledr93 <= (others => '0');
		ledg30 <= (others => '1');				
	end if;
				
	
	ledg7_out <= ledg7;		
	ledg30_out <= ledg30;	
	ledr93_out <= ledr93;	
	ledr0_out <= ledr0;	
	
end process ampel_control;

end architecture arch;
	
	
	
	
	
	
	
	