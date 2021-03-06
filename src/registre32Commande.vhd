library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registre32Commande is port(
    DataIn  : IN  std_logic_vector(31 downto 0);
	DataZin : IN std_logic_vector(31 downto 0);
	CLK 	: IN std_logic;
	WE		: IN std_logic;
    RST 	: IN  std_logic; -- reset asynchrone (actif à l’état haut)
	DataOut : OUT std_logic_vector(31 downto 0);
	DataZOut: OUT std_logic_vector(31 downto 0)); 
	
END entity registre32Commande;


ARCHITECTURE behav OF registre32Commande IS

BEGIN


process(RST,CLK)
begin
	
	if RST = '1' then
		DataOut <= x"00000000";
		DataZOut <= x"00000000";
		
	elsif rising_edge(CLK) then
		if WE = '1' then
	    DataOut <= DataIn;
		DataZOut <= DataZin;
		
		end if;	
	end if;
end process;

END ARCHITECTURE;