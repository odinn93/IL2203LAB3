
--date: 14/10/21
--update
--the error we are getting now is with the ADD process. the previous error regarding the LDI was fixed by
--changing values in ALU file. in the process of rst we included more variables.
--now the error is that we are adding a positive and negative number r(0)+r(1) and the result is r(0) which is wrong.

-- be aware! ALL INPUTS ARE STD LOGIC VECTOR ATM. IN CASE SOMETHING STILL DEPENDS ON SIGNED.




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--use ieee.numeric_std_unsigned.all;
use work.microcode.all;
--use work.all;

entity FSM is
    generic (
                N: INTEGER:=16;
                M: INTEGER :=3
    );
    Port (
        clk, rst : in std_logic;
        Din : in std_logic_vector(N-1 downto 0);
        Dout, address : out std_logic_vector (n-1 downto 0);
        RW : out std_logic
    );
end FSM;

architecture behave of FSM is
    signal uPC                  :   std_logic_vector(2 downto 0);
    signal Instruction_Register :   std_logic_vector (15 downto 0):=(others=>'0');

    --DATAPATH FILE
    signal IE,OE                        :   std_logic;
    signal OP                           :   std_logic_vector(2 downto 0 );
    signal BypassA,BypassB              :   std_logic;   
    signal ReadA, ReadB, Write          :   std_logic;
    signal Z_Flag, N_Flag, O_Flag,Flag  :   std_logic; --extra flag for what??
    signal RA,RB                        :   std_logic_vector(M-1 downto 0);
    signal WAddr                        :   std_logic_vector(M-1 downto 0);
    signal Offset                       :   std_logic_vector (11 downto 0);   
    signal Z_flag_Latch,N_flag_Latch    :   std_logic;
    signal O_Flag_Latch                 :   std_logic;
    signal ALU_Output                   :   std_logic_vector (n-1 downto 0);
    signal ALU_Enable                   :   std_logic;

    --signal clk_out : std_logic;   WHERE??REGISTER FILE?? 
begin
    datapath_file :  entity work.datapath_structural
        generic map (
                    N => N,
                    M => M
                    )
        port    map (
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
                    input1 => Din,--
                    output => ALU_output,--
                    en => ALU_Enable  --
                );
    --end component;
    --try uncommenting all changes to these (except the ones in 000) and reset the values in the 100 case, maybe 011 case
    WAddr<=Din(11 downto 9);
    RA <=Din(8 downto 6);       --Load RA
    RB <=Din(5 downto 3);       --Load RB
    process (clk, rst)
    begin
        if (rst='1') then --let time for the memory to fetch first instruction
            upc<="100";
            address<=(others=>'0');
            Dout <= (others=>'0');
            instruction_register<=(others=>'0');
            Z_flag_latch<='0';
            N_flag_latch<='0';
            O_flag_latch<='0';
            bypassA<='0';
            bypassB<='0';
            offset<=(others=>'0');
            rw<='1'; 
            ie <= '0';
            oe <= '0';
            readA <= '0';
            readB <= '0';
            write <= '1';
            rw<='1';
            --WAddr <= (others => '0');
            --ra <= (others => '0');
            --rb <= (others => '0');
            alu_enable <= '0';
            Op <= "000";
        elsif rising_edge(clk) then
                RW<='1';
                oe <= '1';
                upc<= upc+1;
                case upc is
                    when "000" =>
                        Instruction_Register <= Din;
                        case Din(15 downto 12) is
                            when iADD =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                --RA <=Din(8 downto 6);       --Load RA
                                --RB <=Din(5 downto 3);       --Load RB
                                --Waddr <=Din(11 downto 9);   --Load WA
                                op <= "000";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iSUB =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                --RA <=Din(8 downto 6);    --Load RA
                                --RB <=Din(5 downto 3);    --Load RB
                                --Waddr <=Din(11 downto 9);   --Load WA
                                op <= "001";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iAND =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                --RA <=Din(8 downto 6);    --Load RA
                                --RB <=Din(5 downto 3);    --Load RB
                                --Waddr <=Din(11 downto 9);   --Load WA
                                op <= "010";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iOR =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                --RA <=Din(8 downto 6);    --Load RA
                                --RB <=Din(5 downto 3);    --Load RB
                                --Waddr <=Din(11 downto 9);   --Load WA
                                op <= "011";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iXOR =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '1';               --Enable ReadB
                                --RA <=Din(8 downto 6);    --Load RA
                                --RB <=Din(5 downto 3);    --Load RB
                                --Waddr <=Din(11 downto 9);   --Load WA
                                op <= "100";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iNOT =>
                                Write <= '1';               --Disable Write
                                --Waddr <=Din(11 downto 9);   --Load WA
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                --RA <=Din(8 downto 6);    --Load RA
                                op <= "101";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                               -- upc <= "01"; 

                            when iMOV =>
                                Write <= '1';               --Disable Write
                                --Waddr <=Din(11 downto 9);   --Load WA
                                ALU_Enable <= '1';          --Enable ALU
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                --RA <=Din(8 downto  6);    --Load RA
                                
                                op <= "110";                --Load operant value
                                IE <= '0';                  --Input Enable
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iNOP =>
                                Write <= '1';               --Disable Write
                                ALU_Enable <= '1';           --Enable ALU
                                ie <= '0';                  --Input Enable
                                bypassB <= '1';              --Enable BypassB
                                bypassA <= '0';             --Disable BypassA
                                op <= "111";                --set operant value
                                --WAddr <= R7;                --set write address to pc register
                            
                                --NOT SURE

                            when iLD =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                OE <= '1';                  --Output Enable
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                --RA <=Din(8 downto  6);    --Load RA
                                --WAddr <=Din(11 downto  9);    --Load Waddr
                                op <= "110";                   --Load operant value
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 

                                -- NOT SURE
                            when iST =>
                                Write <= '0';               --Disable Write
                                ALU_Enable <= '1';          --Enable ALU
                                OE <= '1';                  --Output Enable
                                readA <= '1';               --Enable ReadA
                                readB <= '0';               --Disable ReadB
                                --a <=Din(5 downto  3);    --Load RB
                                --WAddr <=Din(11 downto  9);    --Load Waddr
                                op <= "110";                   --Load operant value
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                --wait for 1 ns;
                                --upc <= "01"; 


                            when iLDI =>
                                Write <= '1';               --ENable Write
                                --Waddr <= Din(11 downto 9);  --Set write address
                                ALU_Enable <= '1';          --Enaable ALU
                                readA <= '0';               --Disable ReadA
                                readB <= '0';               --Disable ReadB
                                op <= "110";                --Load operant value
                                ie <= '0';                  -- Input Enable
                                BypassA <= '1';             --Enable BypassA 
                                BypassB <= '0';             --Disable BypassB
                                offset<= std_logic_vector(resize(signed (Din(8 downto 0)),offset'length));
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iBRZ =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                --Waddr <= R7;                --??set write address to pc register
                                if (Z_Flag_Latch = '1') then
                                    bypassB <= '1';         --Enable bypassB
                                    bypassA <= '0';         --Disable bypassA
                                    op <= "000";             --set opcode
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                else        --increment PC                      
                                    bypassA <= '0';         
                                    bypassB <= '1';
                                    Op <= "111";
                                end if;
                                --wait for 1 ns;
                                --upc <= "01"; 

                            when iBRN =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                --Waddr <= R7;                --??set write address to pc register
                                if (O_Flag_Latch = '1') then
                                    bypassB <= '1';         --Enable bypassB
                                    bypassA <= '0';         --Disable bypassA
                                    op <= "000";             --set opcode
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));                       --set offset
                                else        --increment PC                      
                                    bypassA <= '0';         
                                    bypassB <= '1';
                                    Op <= "111";
                                end if;
                                --wait for 1 ns;
                                --upc <= "01"; 


                            when iBRO =>
                                ALU_Enable <= '1';          --Enable ALU
                                Write <= '1';               --Enable Write
                                IE <= '0';                  --Input Enable
                                --Waddr <= R7;                --??set write address to pc register
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
                               -- wait for 1 ns;
                                --upc <= "01"; 

                            when iBRA =>
                                    ALU_enable <='1';       --Enable ALU
                                    Write <= '1';           --Enable Write
                                  --  Waddr <= R7;            --Set write address to pc register
                                    BypassA <= '0';         --Disable BypassA
                                    BypassB <= '1';         --Enable BypassB
                                    op <="000";             --set op code
                                    offset <= std_logic_vector(resize(signed(Din(11 downto 0)), offset'length));    --set offset                       --set offset
                                    --wait for 1 ns;
                                    --upc <= "01"; 

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
                                --WAddr <= "000";
                                oe <= '0';
                               -- wait for 1 ns;
                                --upc <= "01"; 
                        end case;

                    when "001" =>
                        case Din(15 downto 12) is
                            when iADD =>
                                --ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                op <= "111";
                                Waddr <= R2; --?                 --set write address to the register
                                
                                --wait for 1 ns;
                                --upc <= "10"; 

                            when iSUB =>
                                --ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                op <= "111";
                                --Waddr <= R2; --?                 --set write address to the register
                               
                               -- wait for 1 ns;
                                --upc <= "10"; 

                            when iAND =>
                                --ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                --Waddr <= R2; --?
                                op <= "111";
                               -- wait for 1 ns;
                                --upc <= "10";   
                                
                            when iOR =>
                                --ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                --Waddr <= R2; --?
                                op <= "111";
                              --  wait for 1 ns;
                                --upc <= "10"; 

                            when iXOR =>
                                --ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                --Waddr <= R2; --?
                                op <= "111";
                               -- wait for 1 ns;
                                --upc <= "10"; 

                            when iNOT =>
                               -- ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                --Waddr <= R7; --?
                                op <= "111";
                                --wait for 1 ns;
                                --upc <= "10"; 

                            when iMOV =>
                               -- ALU_Enable <= '1';
                                Z_flag_Latch <= Z_flag;         --Latch flags
                                N_flag_Latch <= N_flag;         --Latch flags
                                O_flag_Latch <= O_flag;         --Latch flags
                                bypassB <= '1';                 --Enable bypassB - increment PC
                                bypassA <= '0';                 --Disable bypassA
                                --Waddr <= R7; --?
                                --opcode do we need it??
                                --wait for 1 ns;
                                --upc <= "10"; 

                            when iNOP =>
                                address <= alu_output;          --Set address register to new pc
                                --set everything to 0
                                readA <= '0';               --Disable ReadA
                                readB <= '0';               --Disable ReadB
                                ALU_Enable <= '0';          --Disable ALU
                                Write <= '0';               --Disable Write
                                --WAddr <= "000"; 
                                BypassA <= '0';             --Disable BypassA
                                BypassB <= '0';             --Disable BypassB
                                 IE <= '0';                  --Disable Enable
                                oe <= '0';
                               -- wait for 1 ns;
                                --upc <= "10"; 

                            when iLD =>        
                                --ADDRESS = R2, READ
                                address <=ALU_output;
                                --increment pc ???
                                --WAddr <= R7;
                                Write <= '1';
                                ie <= '0';
                                bypassB<= '1';
                                bypassA<= '0';
                                op <= "111";
                                --upc <= "10"; 
                                
                            when iST =>
                                --Write R2 to Dout
                                Dout <= alu_output;
                                --increment pc
                                --WAddr <= R7;
                                write <= '1';
                                ie <= '0';
                                bypassB <= '1';
                                bypassA <= '0';
                                op <= "111";
                                --upc <= "10"; 

                            when iLDI =>
                                --Increment PC
                                --Write<='1';
                                --Waddr <= R7;
                                bypassB <= '1';
                                bypassA <= '0';
                                op <= "111";
                                --upc <= "10"; 

                            when iBRZ | iBRN | iBRO | iBRA =>
                             --set address register to new pc
                                address <= alu_output;
                                --disable all
                                readA <= '0';
                                readB <= '0';
                                alu_enable <= '0';
                                write <= '0';
                                bypassA <= '0';
                                --Waddr <= "000";
                                bypassB <= '0';
                                ie <= '0';
                                oe <= '0';
                                --upc <= "10"; 
                                
                            when others =>
                                --disable all
                                readA <= '0';
                                readB <= '0';
                                alu_enable <= '0';
                                write <= '0';
                                --Waddr <= "000";
                                bypassA <= '0';
                                bypassB <= '0';
                                ie <= '0';
                                oe <= '0';
                        end case;
                    when "010" =>
                            case instruction_Register (15 downto 12) is
                                when iADD | iSUB | iAND | iOR | iXOR | iNOT | iLDI | iMOV =>
                                    address <= ALU_output;   --Set address register to new pc
                                    --disable all
                                    readA <= '0';
                                    readB <= '0';
                                    ALU_enable <= '0';
                                    write <= '0';
                                    --WAddr <= rx;
                                    bypassA <= '0';
                                    bypassB <= '0';
                                    ie <= '0';
                                    oe <= '0';
                                    --ra<= rx;
                                    --rb<= rx;
                                    --upc <= "11"; 
                                
                                when iLD => 
                                    --Latch data
                                    ie <= '1';
                                    --WAddr <= instruction_register (11 downto 9);
                                    write <= '1';
                                    address <= ALU_output;
                                    --disable all. keep write on to register
                                    readA <= '0';
                                    readB <= '0';
                                    ALU_Enable <= '0';
                                    bypassA <='0';
                                    bypassB <='0';
                                    oe<= '0';
                                    --upc <= "11";  
                                when iST =>
                                    write <= '0';           --disable wrote
                                    address <= ALU_output;  --latch pc to address
                                    --ra<=instruction_register(8 downto 6); --RA register
                                    op <= "110";            --set opcode
                                    bypassA <= '0';         --disable bypassA
                                    bypassB <= '0';         --disable bypassB
                                    --upc <= "11";

                                when others =>
                                    --disable all
                                    readA <= '0';
                                    readB <= '0';
                                    ALU_enable <= '0';
                                    write <= '0';
                                    --WAddr <= rx;
                                    bypassA <= '0';
                                    bypassB <= '0';
                                    ie <= '0';
                                    oe <= '0';
                                    --ra<=rx;
                                    --rb<=rx;
                            end case;
                        
                    when "011"=>
                        case instruction_register (15 downto 12) is
                            when iST =>
                            RW<='0';
                                --ADdress = R1
                                address <= ALU_output;
                                --Disable all;
                                readA <= '0';
                                readB <= '0';
                                ALU_enable <= '0';
                                write <= '0';
                                --WAddr <= rx;
                                bypassA <= '0';
                                bypassB <= '0';
                                ie <= '0';
                                oe <= '0';
                                --ra<=rx;
                                --rb<=rx;

                            when others=>
                                --Disable all;
                                readA <= '0';
                                readB <= '0';
                                ALU_enable <= '0';
                                write <= '0';
                                --WAddr <= rx;
                                bypassA <= '0';
                                bypassB <= '0';
                                ie <= '0';
                                oe <= '0';
                                --ra<=rx;
                                --rb<=rx;
                        end case;
                        upc <= "000";
                    when "100" =>
                        upc <= "000";
                when others=>
                    upc<= "000";
                end case;
            --upc <= upc +1;
        end if;               
    end process;
end architecture;
