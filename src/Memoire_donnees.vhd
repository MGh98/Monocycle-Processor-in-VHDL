library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memoire_donnees is port(
    CLK     : IN  std_logic;  -- Horloge 
    Reset	: IN  std_logic; -- reset asynchrone (actif à l’état haut)
    DataIn  : IN  std_logic_vector(31 downto 0); -- bus 32 bits en écriture
	Addr	: IN  std_logic_vector(5 downto 0); -- Bus d’adresses en lecture et écriture sur 6 bits
	WrEn    : IN std_logic; -- Write Enable sur 1 bit
	DataOut : OUT std_logic_vector(31 downto 0)); -- Bus de données en lecture sur 32 bits
	
END entity Memoire_donnees;


ARCHITECTURE RTL OF Memoire_donnees IS

--Declaration Type Tableau Memoire
type table is array(63 downto 0) of std_logic_vector(31 downto 0);
--Fonction d'Initialisation du Banc de Registres
function init_banc return table is 
variable result : table;
begin
for i in 62 downto 0 loop
	result(i) := (others=>'0');
end loop;
	result(63):=X"00000030";
	
-- pour instruction_memory3
result(32) :=X"00000003"; -- 3
result(33) :=X"0000006B"; -- 107
result(34) :=X"0000001B"; -- 27
result(35) :=X"0000000C"; -- 12
result(36) :=X"00000142"; -- 322
result(37) :=X"0000009B"; -- 155
result(38) :=X"0000003F"; -- 63

-- pour instruction_memory2
result(16) :=X"00000001";
result(17) :=X"00000002";
result(18) :=X"00000003";
result(19) :=X"00000004";
result(20) :=X"00000005";
result(21) :=X"00000006";
result(22) :=X"00000007";
result(23) :=X"00000008";
result(24) :=X"00000009";
result(25) :=X"0000000A";
result(26) :=X"0000000B";
--for i in 26 downto 16 loop -- pour instruction_memory
	--result(i):=X"00000001";
--end loop;

	
	return result;
	end init_banc;
--Déclaration et Initialisation du Banc de Registres 16x32 bits
signal Banc: table:= init_banc;

BEGIN


DataOut <= Banc(To_integer(Unsigned(Addr))) when Reset = '0' else
     (others => '0');


process(Reset,CLK)
begin
	
	if Reset = '1' then
	
		Banc <= init_banc;
		
	elsif rising_edge(CLK) then
		if WrEn = '1' then 
			Banc(To_integer(Unsigned(Addr))) <= DataIn;
		
			
		
		end if;
	end if;
end process;

END ARCHITECTURE;