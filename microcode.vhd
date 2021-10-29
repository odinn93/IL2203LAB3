library IEEE;
use IEEE.std_logic_1164.all;

package microcode is

    subtype opcode is std_logic_vector(3 downto 0);
    subtype reg_code is std_logic_vector(2 downto 0);
    subtype immediate is std_logic_vector(8 downto 0);
    subtype instruction is std_logic_vector(15 downto 0); --16bits instruction

    --type uPC_substate_type is (S_BASIC, S_PC, S_PCinc, S_NOP, S_LD, S_ST);
    --subtype uPC_state_type is std_logic_vector(1 downto 0);

    type program is array(natural range <>) of Instruction; --M registers each of N bits (2^M addresses)
    --constant uPC0 : uPC_state_type := "00";
   -- constant uPC1 : uPC_state_type := "01";
   -- constant uPC2 : uPC_state_type := "10";
   -- constant uPC3 : uPC_state_type := "11";
   
    
    
    --constant Tail3 : reg_code := (others => '0');   
    
    --opcodes for instructions

    constant iADD : opcode := "0000";   --R1    R2  R3  N.U
    constant iSUB : opcode := "0001";   --R1    R2  R3  N.U
    constant iAND : opcode := "0010";   --R1    R2  R3  N.U
    constant iOR : opcode := "0011";    --R1    R2  R3  N.U
    constant iXOR : opcode := "0100";   --R1    R2  R3  N.U
    constant iNOT : opcode := "0101";   --R1    R2  N.U N.U
    constant iMOV: opcode := "0110";    --R1    R2  R3  N.U
    constant iNOP : opcode := "0111";   --R1    R2  R3  N.U
    constant iLD : opcode := "1000";
    constant iST : opcode := "1001";
    constant iLDI : opcode := "1010";
    constant iNU : opcode := "1011";
    constant iBRZ : opcode := "1100";
    constant iBRN : opcode := "1101";
    constant iBRO : opcode := "1110";
    constant iBRA : opcode := "1111";
    
    --register macrod
    constant Rx : reg_code := "000";
    constant R0 : reg_code := "000";
    constant R1 : reg_code := "001";
    constant R2 : reg_code := "010";
    constant R3 : reg_code := "011";
    constant R4 : reg_code := "100";
    constant R5 : reg_code := "101";
    constant R6 : reg_code := "110";
    constant R7 : reg_code := "111";

    constant NU:reg_code:= "000";
    --constant opSUM : op_alu := "000";
    --constant opSUB : op_alu := "001";
    --constant opAND : op_alu := "010";
    --constant opOR : op_alu := "011";
    --constant opXOR : op_alu := "100";
	--constant opNOT : op_alu := "101";
    --constant opA : op_alu := "110";
    --constant opINC : op_alu := "111";

    

end microcode;