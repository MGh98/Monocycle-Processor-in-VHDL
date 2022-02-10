library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registre32 is port(
    CLK     : IN  std_logic;  -- Horloge 
    Reset	: IN  std_logic; -- reset asynchrone (actif à l’état haut)
    DataIn  : IN  std_logic_vector(31 downto 0); -- bus 32 bits en écriture
	DataOut : OUT std_logic_vector(31 downto 0)); -- Bus de données en lecture sur 32 bits
	
END entity registre32;


ARCHITECTURE behav OF registre32 IS

BEGIN


process(Reset,CLK)
begin
	
	if Reset = '1' then
		DataOut <= x"00000000";
		
	elsif rising_edge(CLK) then
	    DataOut <= DataIn;
		
			
	end if;
end process;

END ARCHITECTURE;