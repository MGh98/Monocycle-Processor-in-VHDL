library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Unite_controle is port(
    DataIn : IN std_logic_vector(31 downto 0);
	CLK    : IN std_logic;
	Reset  : IN std_logic;
	RegWr  : OUT  std_logic; -- WE du banc de registre 16 x 32
	nPCsel 	: OUT std_logic; -- Le multiplexeur d’entrée du registre PC
	Offset	: OUT std_logic_vector(23 downto 0); -- signal Offset (PC Extender/ CompteurMiseAJour)
	Rn      : OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	Rd		: OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	Rm 		: OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	ALUSrc	: OUT std_logic; -- COM1 - Multiplexeur avant ALU
	ALUCtr	: OUT std_logic_vector(1 downto 0); -- Signal de controle de l'ALU
	Imm		: OUT std_logic_vector(7 downto 0); -- Imm -> Imm extender then ALU
	MemWr	: OUT std_logic; -- WE de la memory data
	WrSrc	: OUT std_logic; -- COM2 -- Multiplexeur après ALU
	DataZIn : IN std_logic_vector(31 downto 0);
	RegSel	: OUT std_logic; -- MUX de rd / Rm -> rb pour le banc de registres
	Instruction : IN std_logic_vector(31 downto 0)); -- Sort de l'instruction memory
	
	
END entity ;


ARCHITECTURE struct OF Unite_controle IS
signal DataOut,DataZOut: std_logic_vector(31 downto 0);
signal PSREN: std_logic;

   
BEGIN


Registre32C: entity work.registre32Commande port map
									( CLK => CLK,
									RST => Reset,
									WE => PSREN,
									DataIn => DataIn,
									DataZIn => DataZIn,
									DataZOut => DataZOut,
									DataOut => DataOut);
						
									
decodeur: entity work.DecodeurInstructions port map
								(nPCsel => nPCsel,
								  PSREN => PSREN,
								   Offset => Offset,
								   RegWr => RegWr,
								  Rn => Rn,
								  Rd => Rd,
								  Rm => Rm,
								  ALUSrc => ALUSrc,
								  ALUCtr => ALUCtr,
								  Imm => Imm,
								  MemWr => MemWr,
								  WrSrc => WrSrc,
								  RegSel => RegSel,
								  Instruction => Instruction,
								  Zero => DataZOut,
								  Data => DataOut);
							   


END architecture;