library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Assemblage is port(
	CLK    : IN std_logic;
	Reset  : IN std_logic);
	
END entity ;


ARCHITECTURE struct OF Assemblage IS
signal flag,RegWr,nPCsel,RegSel,ALUSrc,MemWr,WrSrc,Z: std_logic;
signal DataIn,DataZin: std_logic_vector(31 downto 0);
signal Offset: std_logic_vector(23 downto 0);
signal Rn,Rd,Rm,RB: std_logic_vector(3 downto 0);
signal ALUCtr: std_logic_vector(1 downto 0);
signal Imm: std_logic_vector(7 downto 0);
signal Instruction: std_logic_vector(31 downto 0);
   
BEGIN
DataIn <= "0000000000000000000000000000000" & flag;
DataZin <= "0000000000000000000000000000000" & Z;

Unite_controle: entity work.Unite_controle  port map
									( DataIn => DataIn,
									  DataZIn => DataZin,
									  CLK => CLK,
									  Reset => Reset,
									  RegWr => RegWr,
									  nPCsel => nPCsel,
									  Offset => Offset,
									  Rn => Rn,
									  Rd => Rd,
									  Rm => Rm,
									  RegSel => RegSel,
									  ALUSrc => ALUSrc,
									  ALUCtr => ALUCtr,
									  Imm => Imm,
									  MemWr => MemWr,
									  WrSrc => WrSrc,
									  Instruction => Instruction);
						
									
Unite_gestion_instructions: entity work.Unite_gestion_instructions port map
								( nPCsel => nPCsel,
								  Offset => Offset,
								  Instruction => Instruction,
								  CLK => CLK,
								  Reset => Reset );

Unite_de_Traitement: entity work.Unite_de_Traitement port map
						( CLK => CLK,
						  Reset => Reset,
						  flag => flag,
						  RegW => RegWr,
						  RA => Rn,
						  RW => Rd,
						  RB => RB,
						  COM1 => ALUSrc,
						  OP => ALUCtr,
						  Imm => Imm,
						  Zout => Z,
						  WrEn => MemWr,
						  COM2 => WrSrc );
						  
							  
MuxRegSel: entity work.MuxRegSel port map 
							  (RegSel => RegSel,
							  Rm => Rm,
							  Rd => Rd,
							  RB => RB );
							   


END architecture;