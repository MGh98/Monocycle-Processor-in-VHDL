library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Unite_de_Traitement is port(
    --busW : OUT std_logic_vector( 31 downto 0);
	RegW : IN std_logic;
	RW   : IN std_logic_vector( 3 downto 0 );
	RA   : IN std_logic_vector( 3 downto 0 );
	RB   : IN std_logic_vector( 3 downto 0 );
	COM1 : IN std_logic; -- controle du MUX2to1
	COM2 : IN std_logic; -- controle du MUX2to1 numéro 2
	flag : OUT std_logic;
	Imm  : IN std_logic_vector(7 downto 0);
	OP   : IN std_logic_vector(1 downto 0);
	WrEn : IN std_logic;
	Reset: IN std_logic;
	Zout : OUT std_logic;
	CLK  : IN std_logic);	
	
END entity ;


ARCHITECTURE struct OF Unite_de_Traitement IS
   signal busA, busB, S,Smux, AluOut, DataOut : std_logic_vector(31 downto 0);
   signal W: std_logic_vector(31 downto 0);

   
BEGIN
--busW <= W;

Registers: entity work.bancregistre port map( Reset => Reset,
									CLK => CLK,
									WE => RegW,
									RA => RA,
									RB => RB,
									RW => RW,
									W => W,
									A => busA,
									B => busB);
									
Ext: entity work.extensiondesigne port map(E => Imm,
								  S => S);

MUX1: entity work.Mux2to1 port map( COM => COM1,
						  A => busB,
						  B => S,
						  S => Smux);
						  
							  
ALU: entity work.ALU port map (A => busA,
							   B => Smux,
							   OP => OP,
							   N => flag,
							   S => AluOut,
							   Z => Zout);
							   
DataMemory: entity work.Memoire_donnees port map ( CLK => Clk,
										Reset => Reset,
										DataIn => busB,
										DataOut => DataOut,
										Addr => AluOut(5 downto 0),
										WrEn => WrEn);
							   
Mux2: entity work.Mux2to1 port map ( COM => COM2,
									A => AluOut,
									B => DataOut,
									S => W);
	

END architecture;