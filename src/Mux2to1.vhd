library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2to1 is 
generic (N : integer := 32);
port(
    COM     : IN  std_logic;  -- Signal de commande sur 1 bit 
    A	    : IN   std_logic_vector((N-1) downto 0); -- bus N bits en entrée
    B  		: IN  std_logic_vector((N-1) downto 0); -- bus N bits en entrée
	S 		: OUT  std_logic_vector((N-1) downto 0)); -- bus N bits en sortie
END entity ;


ARCHITECTURE RTL OF Mux2to1 IS

BEGIN
with COM select
	S <= A when '0',
	     B when '1',
		 (others => '-') when others;

END ARCHITECTURE;