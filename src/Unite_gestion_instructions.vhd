library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Unite_gestion_instructions is port(
    nPCsel : IN std_logic;
	CLK    : IN std_logic;
	Reset  : IN std_logic;
	Instruction : OUT std_logic_vector(31 downto 0);
	Offset  : IN std_logic_vector(23 downto 0 ));
	
END entity ;


ARCHITECTURE struct OF Unite_gestion_instructions IS
   signal PC, DataIn, SignExt : std_logic_vector(31 downto 0);

   
BEGIN

PCextender: entity work.extensiondesigne generic map (N => 24) port map
									( E => Offset,
									S => SignExt);
						
									
compteurmaj: entity work.mise_a_jour_compteur port map
								(nPCsel => nPCsel,
								  PC => PC,
								  SignExt => SignExt,
								  DataIn => DataIn);

RegistrePC: entity work.registre32 port map
						( CLK => CLK,
						  Reset => Reset,
						  DataIn => DataIn,
						  DataOut => PC);
						  
							  
InstructionMemory: entity work.instruction_memory3 port map 
							  (PC => PC,
							   Instruction => Instruction);
							   


END architecture;