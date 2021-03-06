library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancregistre is port(
    CLK     : IN  std_logic;  -- Horloge 
    Reset	: IN  std_logic; -- reset asynchrone (actif à l’état haut)
    W  		: IN  std_logic_vector(31 downto 0); -- bus 32 bits en écriture
	RA 		: IN  std_logic_vector(3 downto 0); -- Bus d’adresses en lecture du port A 
	RB      : IN std_logic_vector(3 downto 0); -- Bus d’adresses en lecture du port B
	RW		: IN std_logic_vector(3 downto 0); -- Bus d’adresses en écriture
	WE      : IN std_logic; -- Write Enable sur 1 bit
	A       : OUT std_logic_vector(31 downto 0); -- Bus de données en lecture du port A
	B       : OUT std_logic_vector(31 downto 0)); -- Bus de données en lecture du port B
	
END entity bancregistre;


ARCHITECTURE RTL OF bancregistre IS

--Declaration Type Tableau Memoire
type table is array(15 downto 0) of std_logic_vector(31 downto 0);
--Fonction d'Initialisation du Banc de Registres
function init_banc return table is 
variable result : table;
begin
for i in 14 downto 0 loop
	result(i) := (others=>'0');
end loop;
	result(15):= X"00000030";
	return result;
end init_banc;
--Déclaration et Initialisation du Banc de Registres 16x32 bits
signal Banc: table:= init_banc;

BEGIN

-- On assigne le Reset de A et B en dehors du process pour éviter les X (forced unknown) 

A <= Banc(To_integer(Unsigned(RA))) when Reset = '0' else
     (others => '0');
     
B <= Banc(To_integer(Unsigned(RB))) when Reset = '0' else
     (others => '0');


process(Reset,CLK)
begin
	
	if Reset = '1' then
	
		Banc <= init_banc;
		
		
	elsif rising_edge(CLK) then
		if WE = '1' then 
			Banc(To_integer(Unsigned(RW))) <= W;
		else
			
		
		end if;
	end if;
end process;

END ARCHITECTURE;