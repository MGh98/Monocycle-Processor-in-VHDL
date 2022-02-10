library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mise_a_jour_compteur is 
port(
    nPCsel  : IN  std_logic;  -- Signal de commande sur 1 bit 
    PC	    : IN   std_logic_vector(31 downto 0); -- bus N bits en entrée
    SignExt : IN  std_logic_vector(31 downto 0); -- bus N bits en entrée
	DataIn  : OUT  std_logic_vector(31 downto 0)); -- bus N bits en sortie
END entity ;


ARCHITECTURE behav OF mise_a_jour_compteur IS
signal zero: integer;
signal one: integer;
BEGIN

zero <= (to_integer(signed(PC))+1);
one <= (to_integer(signed(PC))) + (to_integer(signed(SignExt))) + 1;

with nPCsel select
	DataIn <= std_logic_vector(to_signed(zero,32)) when '0',
	          std_logic_vector(to_signed(one,32)) when '1',
		      (others => '-') when others;

END ARCHITECTURE;