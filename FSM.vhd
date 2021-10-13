library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.microcode.all;

entity FSM is
    generic (
        M,N : integer
    );
    Port (
        clk, reset : in std_logic;
        Din : in std_logic_vector(N-1 downto 0);
        Dout, address : out std_logic_vector (n-1 downto 0);
        RW : out std_logic
    );
end FSM;

architecture behavior of FSM is
    signal uPC                  :   std_logic_vector(1 downto 0);
    signal Instruction_Register :   std_logic_vector (15 downto 0):=(others=>'0');

    --DATAPATH FILE
    signal IE,OE                        :   std_logic;
    signal OP                           :   std_logic_vector(2 downto 0 );
    signal BypassA,BypassB              :   std_logic;   
    signal ReadA, ReadB, Write          :   std_logic;
    signal Z_Flag, N_Flag, O_Flag,Flag  :   std_logic; --extra flag for what??
    signal RA,RB                        :   std_logic_vector(M-1 downto 0);
    signal WAddr                        :   std_logic_vector(M-1 downto 0);
    signal Offset                       :   signed (n-1 downto 0);   
    signal Z_flag_Latch,N_flag_Latch    :   std_logic;
    signal O_Flag_Latch                 :   std_logic;
    signal ALU_Output                   :   std_logic_vector (n-1 downto 0);
    signal ALU_Enable                   :   std_logic;

    --signal clk_out : std_logic;   WHERE??REGISTER FILE??
    
    component DATAPATH 
        generic (
                    M => M,
                    N => N
                );
        port    (
                    ie => ie,--
                    oe => oe,   -- 
                    clk => clk,--
                    rst => rst,--
                    offset => offset,--
                    bypassA => bypassA,--
                    bypassB => bypassB,--
                    write => write,--
                    readA => readA,--
                    readB => readB,--
                    Z_Flag => Z_Flag,--
                    O_Flag => O_Flag,--
                   -- clk_out = >clk_out --
                    Op => Op,--
                    WAddr => WAddr,--
                    RA => RA,--
                    RB => RB,--
                    input => Din,--
                    output => output_alu,--
                    en => ALU_Enable  --
                );
        end component;
begin 
    process (clk, rst)
    begin
        if (reset='1') then
            upc<="00";
            address<=(others=>'0');
            elsif rising_edge(clk) then
                
                upc<= upc+1;
                case upc is

                    when "00" =>
                        Instruction_Register <= Din;
                        case Din(15 downto 12) is
                            when i_ADD =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                RB <=Din(5 downto to 3);    --Load RB
                                op <= "000";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_SUB =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                RB <=Din(5 downto to 3);    --Load RB
                                op <= "001";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_AND =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                RB <=Din(5 downto to 3);    --Load RB
                                op <= "010";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_OR =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                RB <=Din(5 downto to 3);    --Load RB
                                op <= "011";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_XOR =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                RB <=Din(5 downto to 3);    --Load RB
                                op <= "100";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_NOT =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                op <= "101";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_MOV =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                --RB <=Din(5 downto to 3);    --Load RB
                                op <= "110";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_NOP =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '0';          --Disable ALU
                                readA <= '0';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 


                            --NOT SURE

                            when i_LD =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Disable ALU
                                OE <= '1';                  --Output Enable
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                RA <=Din(8 downto to 6);    --Load RA
                                op <= "110";                   --Load operant value
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 

                            -- NOT SURE
                            when i_ST =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                OE <= '1';                  --Output Enable
                                readA <= '0';               --Enable ReadA
                                readB <= '1';               --Disable ReadB
                                Rb <=Din(5 downto to 3);    --Load RB
                                op <= "110";                   --Load operant value
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                delay for 1 ns;
                                upc <= "01"; 


                            when i_LDI =>
                                Write <= '1';               --ENable Write
                                Waddr <= Din(11 downto 9);  --Set write address
                                ALU_Enable <= '1';          --Disable ALU
                                readA <= '0';               --Disable ReadA
                                readB <= '0';               --Disable ReadB
                                ie <= '0';                  -- Input Enable

                                op <= "110";                --Load operant value
                                BypassA <= '1';             --Enable BypassA 
                                BypassB <= '0';             --Disable BypassB
                                offset<= std_logic_vector(resize(signed (Din(8 downto 0)),ofsset'lenght));
                                delay for 1 ns;
                                upc <= "01"; 


                            when i_BRZ =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                Waddr <= R7;                --??set write address to pc register
                                if (Z_Flag_Latch = '1') then
                                    bypassB <= '1';         --Enable bypassB
                                    bypassA <= '0';         --Disable bypassA
                                    op <= "000"             --set opcode
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                else        --increment PC                      
                                    bypassA <= '0';         
                                    bypassB <= '1';
                                    Op <= "111";
                                end if;
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_BRN =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                Waddr <= R7;                --??set write address to pc register
                                if (O_Flag_Latch = '1') then
                                    bypassB <= '1';         --Enable bypassB
                                    bypassA <= '0';         --Disable bypassA
                                    op <= "000"             --set opcode
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                else        --increment PC                      
                                    bypassA <= '0';         
                                    bypassB <= '1';
                                    Op <= "111";
                                end if;
                                delay for 1 ns;
                                upc <= "01"; 


                            when i_BRO =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                Waddr <= R7;                --??set write address to pc register
                                if (O_Flag_Latch = '1') then
                                    bypassB <= '1';         --Enable bypassB
                                    bypassA <= '0';         --Disable bypassA
                                    op <= "000"  ;           --set opcode
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                else        --increment PC                      
                                    bypassA <= '0';         
                                    bypassB <= '1';
                                    Op <= "111";
                                end if;
                                delay for 1 ns;
                                upc <= "01"; 

                            when i_BRA =>
                                    ALU_enable <='1';
                                    Write <= '0';
                                    Waddr <= R7;
                                    BypassA <= '0';
                                    BypassB <= '1';
                                    op <="000";
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                    delay for 1 ns;
                                    upc <= "01"; 

                            when others =>                  --DISABLE ALL

                                Write <= '0';               --Disable Write
                                ALU_Enable <= '0';          --Disable ALU
                                readA <= '0';               --Disable ReadA
                                readB <= '0';               --Disable ReadB
                                op <= "000";                --Load operant value
                                IE <= '0';                  --Disable Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB   
                                ie <= '0';
                                oe <= '0';
                                delay for 1 ns;
                                upc <= "01"; 
                            
                        end case;
                    when "01" =>
                        
                        case Din(15 downto 12) is
                            when i_ADD =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_SUB =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_AND =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10";   
                                
                            when i_OR =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_XOR =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_NOT =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_MOV =>
                                ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                Waddr <= R7 --?
                                --opcode do we need it??
                                delay for 1 ns;
                                upc <= "10"; 

                            when I_NOP =>
                                address <= output_alu;          --Set address register to new pc
                                --set everything to 0
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '0';          --Disable ALU
                                readA <= '0';               --Disable ReadA
                                readB <= '0';               --Disable ReadB
                                op <= "000";                --Load operant value
                                IE <= '0';                  --Disable Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB   
                                ie <= '0';
                                oe <= '0';
                                delay for 1 ns;
                                upc <= "10"; 

                            when i_LD =>        
                                --address=R2 (r2->RA)
                                address <=ALU_output;
                                --increment pc ???
                                Write <= '1';
                                bypassB<= '1';
                                bypassA<= '0';
                                Waddr<= R7;



                            
            
                    when "10" =>
                    
                    when "11" =>
                        
                   






    end process;
end architecture;
