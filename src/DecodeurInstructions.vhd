library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecodeurInstructions is port(
    RegWr  : OUT  std_logic; -- WE du banc de registre 16 x 32
	nPCsel 	: OUT std_logic; -- Le multiplexeur d’entrée du registre PC
	PSREN	: OUT std_logic; -- La commande de chargement du registre PSR
	Offset	: OUT std_logic_vector(23 downto 0); -- signal Offset (PC Extender/ CompteurMiseAJour)
	Rn      : OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	Rd		: OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	Rm 		: OUT std_logic_vector(3 downto 0); -- banc de registres 16 * 32
	ALUSrc	: OUT std_logic; -- COM1 - Multiplexeur avant ALU
	ALUCtr	: OUT std_logic_vector(1 downto 0); -- Signal de controle de l'ALU
	Imm		: OUT std_logic_vector(7 downto 0); -- Imm -> Imm extender then ALU
	MemWr	: OUT std_logic; -- WE de la memory data
	WrSrc	: OUT std_logic; -- COM2 -- Multiplexeur après ALU
	RegSel	: OUT std_logic; -- MUX de rd / Rm -> rb pour le banc de registres
	Instruction : IN std_logic_vector(31 downto 0); -- Sort de l'instruction memory
	Data: IN std_logic_vector(31 downto 0); --  sort du PSR 
	Zero: IN std_logic_vector(31 downto 0)); -- sort du PSR
	


END entity DecodeurInstructions;


ARCHITECTURE behav OF DecodeurInstructions IS

type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT,CMPr,STRGT,ADDGT,BNE);
signal instr_courante: enum_instruction;

BEGIN


process(Instruction) -- rôle de donner des valeurs à instr_courante
begin
	if Instruction(31 downto 20) = "111000101000" then
		instr_courante <= ADDi;
	elsif Instruction(31 downto 20) = "111000001000" then
		instr_courante <= ADDr;
	elsif Instruction(31 downto 20) = "111000111010" then
		instr_courante <= MOV;
	elsif Instruction(31 downto 20) = "111000110101" then
		instr_courante <= CMP;
	elsif Instruction(31 downto 20) = "111001100001" then
		instr_courante <= LDR;
	elsif Instruction(31 downto 20) = "111001100000" then
		instr_courante <= STR;
	elsif Instruction(31 downto 24) = "11101010" then 
		instr_courante <= BAL;
	elsif Instruction(31 downto 24) = "10111010" then 
		instr_courante <= BLT;
	elsif Instruction(31 downto 20) = "111000010101" then 
		instr_courante <=  CMPr;
	elsif Instruction(31 downto 20) = "110001100000" then
		instr_courante <= STRGT;
	elsif Instruction(31 downto 20) = "110000101000" then
		instr_courante <= ADDGT;
	elsif Instruction(31 downto 24) = "00011010" then
		instr_courante <= BNE;
		
	end if;

end process;

process(instr_courante,Instruction,Zero,Data) -- Un process sensible sur le signal instructio nqui donnera la valeur des commandes des registres et opérateurs du processeur
begin
	if instr_courante = ADDi then
		nPCsel <= '0';
		RegWr <= '1';
		ALUSrc <= '1';
		ALUCtr <= "00";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '1';
		Rn <= Instruction(19 downto 16);
		Rd <= Instruction(15 downto 12);
		Imm <= Instruction(7 downto 0);
		
	elsif instr_courante = ADDGT then
		if Data = x"00000000" then
			nPCsel <= '0';
			RegWr <= '1';
			ALUSrc <= '1';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '1';
		else 
			nPCsel <= '0';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
		end if;	
			Rn <= Instruction(19 downto 16);
			Rd <= Instruction(15 downto 12);
			Imm <= Instruction(7 downto 0);
		
		
	elsif instr_courante = ADDr then
		nPCsel <= '0';
		RegWr <= '1';
		ALUSrc <= '0';
		ALUCtr <= "00";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '0';
		Rn <= Instruction(19 downto 16);
		Rd <= Instruction(15 downto 12);
		Rm <= Instruction(3 downto 0);
		
	elsif instr_courante = BNE then
		if Zero = x"00000000" then
			nPCsel <= '1';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "11";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '1';
		else 
			nPCsel <= '0';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
		end if;
		Offset <= Instruction(23 downto 0);
		
	elsif instr_courante = MOV then
		nPCsel <= '0';
		RegWr <= '1';
		ALUSrc <= '1';
		ALUCtr <= "01";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '1';
		Rd <= Instruction(15 downto 12);
		Imm <= Instruction(7 downto 0);
	elsif instr_courante = CMP then 
		nPCsel <= '0';
		RegWr <= '0';
		ALUSrc <= '1';
		ALUCtr <= "10";
		PSREN <= '1';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '1';
		Rn <= Instruction(19 downto 16);
		Imm <= Instruction(7 downto 0);
		
	elsif instr_courante = CMPr then
		nPCsel <= '0';
		RegWr <= '0';
		ALUSrc <= '0';
		ALUCtr <= "10";
		PSREN <= '1';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '0';
		Rn <= Instruction(19 downto 16);
		Rm <= Instruction(3 downto 0);
		
	elsif instr_courante = LDR then
		nPCsel <= '0';
		RegWr <= '1';
		ALUSrc <= '1';
		ALUCtr <= "00";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '1';
		RegSel <= '1';
		Rn <= Instruction(19 downto 16);
		Rd <= Instruction(15 downto 12);
		Imm <= Instruction(7 downto 0);
		
	elsif instr_courante = STR then
		nPCsel <= '0';
		RegWr <= '0';
		ALUSrc <= '1';
		ALUCtr <= "00";
		PSREN <= '0';
		MemWr <= '1';
		WrSrc <= '0';
		RegSel <= '1';
		Rn <= Instruction(19 downto 16);
		Rd <= Instruction(15 downto 12);
		Imm <= Instruction(7 downto 0);
		
	elsif instr_courante = STRGT then
	
		if Data = x"00000000" then
			nPCsel <= '0';
			RegWr <= '0';
			ALUSrc <= '1';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '1';
			WrSrc <= '0';
			RegSel <= '1';
		else 

			nPCsel <= '0';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '1';
			
		end if;
			Rn <= Instruction(19 downto 16);
			Rd <= Instruction(15 downto 12);
			Imm <= Instruction(7 downto 0);
		
	elsif instr_courante = BAL then
		nPCsel <= '1';
		RegWr <= '0';
		ALUSrc <= '0';
		ALUCtr <= "11";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '1';
		Offset <= Instruction(23 downto 0);
		
		
		
	elsif instr_courante = BLT then
	
		if Data = x"00000001" then 
			nPCsel <= '1';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "11";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '1';
		else 
			nPCsel <= '0';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtr <= "00";
			PSREN <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
		end if; 
		Offset <= Instruction(23 downto 0);
		
	else 
		nPCsel <= '0';
		RegWr <= '0';
		ALUSrc <= '0';
		ALUCtr <= "00";
		PSREN <= '0';
		MemWr <= '0';
		WrSrc <= '0';
		RegSel <= '0';
	
	
	end if;

end process;

END ARCHITECTURE;