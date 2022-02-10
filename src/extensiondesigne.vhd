library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extensiondesigne is 
generic (N : integer := 8);
port(
    E    	: IN  std_logic_vector((N-1) downto 0);  -- bus N bits en entrée
    S	    : OUT   std_logic_vector(31 downto 0)); -- bus 32 bits en sortie

END entity extensiondesigne;


ARCHITECTURE Behavorial OF extensiondesigne IS
signal transfo: integer;

BEGIN

transfo <= TO_INTEGER(SIGNED(E));
S <= STD_LOGIC_VECTOR(to_signed(transfo,32));



END ARCHITECTURE;