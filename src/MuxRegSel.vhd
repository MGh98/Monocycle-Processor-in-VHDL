library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MuxRegSel is 
port(
    RegSel     : IN  std_logic;  -- Signal de commande sur 1 bit RegSel 
    Rm	    : IN   std_logic_vector(3 downto 0); -- bus 3 bits en entrée
    Rd  		: IN  std_logic_vector(3 downto 0); -- bus 3 bits en entrée
	RB		: OUT  std_logic_vector(3 downto 0)); -- registre en sortie
END entity ;


ARCHITECTURE RTL OF MuxRegSel IS

BEGIN
with RegSel select
	RB <= Rm when '0',
	     Rd when '1',
		 (others => '-') when others;

END ARCHITECTURE;