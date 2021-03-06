library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is port(
    OP     	: IN  std_logic_vector(1 downto 0);  -- Signal de commande sur 2 bits  
    A	    : IN   std_logic_vector(31 downto 0); -- bus 32 bits en entrée
    B  		: IN  std_logic_vector(31 downto 0); -- bus 32 bits en entrée
	S 		: OUT  std_logic_vector(31 downto 0); -- bus 32 bits en sortie
	N       : OUT std_logic;    -- drapeau de sortie sur 1 bit
	Z 		: OUT std_logic);
END entity ALU;


ARCHITECTURE RTL OF ALU IS
signal Y: integer ;
signal plus: integer ;
signal moins: integer ;
BEGIN

plus <= TO_INTEGER(SIGNED(A) + SIGNED(B));
moins <= TO_INTEGER(SIGNED(A) - SIGNED(B));

process(OP,Y,A,B,plus,moins)
begin

case(OP) is 


	when "00" => Y <= plus; 
	when "01" => Y <= TO_INTEGER(SIGNED(B)); 
	when "10" => Y <= moins; 
    when "11" => Y <= TO_INTEGER(SIGNED(A)); 
						 
	when others => Y <= 0;
	
end case;


if (Y < 0 ) then
	N <= '1';
else
	N <= '0';

end if;

if (Y = 0) then
	Z <= '1';
else 
	Z <= '0';
end if;

S <= std_logic_vector(TO_SIGNED (Y,32));

end process;


END ARCHITECTURE;