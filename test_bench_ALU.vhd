
--Import library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
--use ieee.std_logic_arith.all;
use work.all;


--Declare the Test Bench entity
entity ALUtestbench is
end ALUtestbench;

architecture ALU_Auto_testbench of ALUtestbench is
    
    constant ClockFreq : integer := 100e6; --100MHz
    constant ClockPeriod : time := 1000 ms / Clockfreq;
     
    component ALU is
        port( 
            a,b :in signed (3 downto 0);          --Two signed inputs
            op:in std_logic_vector (2 downto 0);  --One std_logic operator vector
            sum: inout signed (3 downto 0);       --The output sum has to be defined as INOUT because we have to be able to check its value.
            en,rst,clk: in std_logic;              --NEW REGISTERS 
            newsum: inout signed (3 downto 0);
            Z_flag,N_flag,O_flag: out std_logic); --The flags are simple std_logic outputs
    end component;
    --Inputs
    signal a : signed(3 downto 0) := (others => '0');
    signal b : signed(3 downto 0) := (others => '0');
    signal op : std_logic_vector(2 downto 0) := "000";
    signal clk : std_logic:='0';
    signal rst: std_logic:='1';
    signal en: std_logic:='1';
    --Outputs
    signal sum : signed(3 downto 0);
    signal newsum :signed (3 downto 0);
    signal Z_flag: std_logic;
    signal N_flag: std_logic;
    signal O_flag: std_logic;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ALU port map (a=>a,
                       b=>b,
                       op=>op,
                       newsum=>newsum,
                       sum=>sum,
                       Z_flag=>Z_flag,
                       N_flag=>N_flag,
                       O_flag=>O_flag,
                       en=>en,
                       rst=>rst,
                       clk=>clk);
    --PROCESS FOR GENERATING THE CLOCK
    clk <= not clk after ClockPeriod/2; 
    -- Stimulus process
    stim_proc: process
    begin
        -- TAKE THE UUT OUT OF RESET
        rst <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        a <= "0110"; 
        b <= "1100"; 
        wait until rising_edge(clk);
        wait for 1 ns;
        op <= "000"; --Add     
        wait until rising_edge(clk);
        wait for 1 ns;
            assert (Z_flag='0')
                report "All bits of sum are 0"
                severity warning;
            assert (N_flag='0')
                report "The result is negative"
                severity warning;
            assert (O_flag='0')
                report "Overflow in the result"
                severity warning;
        op <= "001"; --Sub   
        wait until rising_edge(clk);
        wait for 1 ns;
           
        op <= "010"; --AND     
            wait until rising_edge(clk);
            wait for 1 ns;
            
            
        op <= "011"; --OR
            wait until rising_edge(clk);
            wait for 1 ns;
           
        op <= "100"; --XOR    
            wait until rising_edge(clk);
            wait for 1 ns;
           
        op <= "101"; --NOT     
        wait for 10 ns;
        op <= "110"; --MOV    
        wait for 10 ns;
        op <= "111"; --Zero   
        wait for 10 ns;
       --for i in 0 to 8 loop
            
       --end loop;   
        en<='0';
        --RESET THE UUT
        rst <= '1';
        wait;
    end process;   
end;

