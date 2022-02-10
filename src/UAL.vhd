library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UAL is port(
    Reset  : IN  std_logic;         -- reset de l'interface
    CLK	   : IN  std_logic;         -- horloge pixel
	
	W_out: Out std_logic_vector(31 downto 0);
    RA	   : IN std_logic_vector(3 downto 0); 
    RB	   : IN std_logic_vector(3 downto 0);     
    RW		: IN std_logic_vector(3 downto 0);  
	WE      : IN std_logic ;        
	OP      : IN std_logic_vector(1 downto 0) );        
END entity ;


ARCHITECTURE struct OF UAL IS
   signal A,B : std_logic_vector(31 downto 0);
   signal N: std_logic;
   signal W: std_logic_vector(31 downto 0);

   
BEGIN
W_out <= W;
Registers: entity work.bancregistre port map( Reset => Reset,
									CLK => CLK,
									WE => WE,
									RA => RA,
									RB => RB,
									RW => RW,
									W => W,
									A => A,
									B => B);

ALU: entity work.ALU port map (A => A,
							   B => B,
							   OP => OP,
							   N => N,
							   S => W);
											
	

END architecture;