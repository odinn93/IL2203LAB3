 --Import library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
--use IEEE.std_logic_unsigned.all;
use work.all;

entity lab3testing is
end lab3testing;

architecture test_datapath of lab3testing is
    --component declaration for the DUT
    constant ClockFreq : integer := 100e6; --100MHz
    constant ClockPeriod : time := 1000 ms / Clockfreq;
    constant M: integer:=3;
    constant N: integer:=4; --same as ALU bits
    
component datapath_structural is
    generic (M         : positive:=M;
            N          : positive:=N);
    port (IE                      : in  std_logic; 
          Input1                  : in signed(n-1 downto 0);
          OE                      : in  std_logic;
          rst,clk,en              : in  std_logic;  
          WAddr                   : in std_logic_vector (M-1 downto 0);
          Write                   : in std_logic;
          RA                      : in std_logic_vector (M-1 downto 0);
          ReadA                   : in std_logic; 
          RB                      : in std_logic_vector (M-1 downto 0);      
          ReadB                   : in std_logic;
          Z_flag,N_flag,O_flag    : out std_logic;
          Output                  : out signed(M-1 downto 0);
          op                      : in std_logic_vector (2 downto 0);

        --mux components (L3)
          Offset                  : in SIGNED (N-1 downto 0);
          BypassA                 : in std_logic;
          BypassB                 : in std_logic
         
      );
end component;

component clockdiv
    port (         
        clk,rst    :   IN   STD_LOGIC;
        clock_out  :   OUT  STD_LOGIC
        );
end component;


component register_file is
    generic (M                  : positive:=M;
             N                  : positive:=N);
    port (    WD            : in Signed (N-1 downto 0);        --Write Data (N bits wide)
              WAddr         : in std_logic_vector (M-1 downto 0);     --Write Address (M bits wide)
              Write         : in std_logic;                           --Write='1' writes register pointed to by Write Address.
              -- Registers should be written on positive flank

              RA            : in std_logic_vector (M-1 downto 0);        --Read Address A (M bits wide)
              ReadA         : in std_logic;                            --ReadA='1' reads register pointed to by Read Address A. 
              -- Output should be updated immediately. ReadA='0' should output a 0.
              QA            : out Signed (n-1 downto 0);         --Outputs a value from the register pointed to by RA

              RB             : in std_logic_vector (M-1 downto 0);        --------------------
              ReadB          : in STD_LOGIC;                            -- SAME AS WITH A --
              QB             : out Signed (N-1 downto 0);      --------------------
              rst            : in std_logic;
              clk            : in std_logic;
              sum            : out signed (N-1 downto 0)      
          );
end component;
component ALU is 
    port (      a,b                   : in signed (N-1 downto 0);          --Two signed inputs
                op                    : in std_logic_vector (2 downto 0);
                rst                   : in std_logic;
                clk,en                : in std_logic;
                sum                   : out signed (N-1 downto 0);       --The output sum has to be defined as INOUT because we have to be able to check its value.                      
                Z_flag,N_flag,O_flag  : out std_logic                     --The flags are simple std_logic outputs
            ); 
end component;



--DEFINE INPUTS
signal IE       :       std_logic:='0';
signal Input1   :       signed(n-1 downto 0) := (others => '0');
signal OE       :       std_logic:='1';
signal clk      :       std_logic :=  '1';
signal WAddr    :       std_logic_vector(n-1 downto 0) := (others => '0');
signal Write    :       std_logic:='1';
signal RA       :       std_logic_vector(n-1 downto 0) := (others => '0');
signal ReadA    :       std_logic:= '1';
signal RB       :       std_logic_vector(n-1 downto 0) := (others => '0');
signal ReadB    :       std_logic:= '1';
signal rst      :       std_logic:='1';
signal en       :       std_logic:='1';
signal op       :       std_logic_vector (2 downto 0) := "000";

signal Final_Input  :   signed(N-1 downto 0);
signal WD           :   std_logic_vector(N-1 downto 0):=(others=>'0');

--L3 inputs
signal Offset       :  SIGNED (N-1 downto 0) := (others => '0');
signal BypassA      :  std_logic := '0';
signal BypassB      :  std_logic := '0';


--DEFINE OUTPUTS
signal Output           :   signed(n-1 downto 0):=(others=>'0');
signal First_Output     :    signed(n-1 downto 0):=(others=>'0');
signal clock_out        : STD_LOGIC:='0';

begin
    --Instantiate the Device Under Test (DUT)
    
    DUT: datapath_structural port map(
        clk     =>   clk,
        rst     =>   rst,
        input1  =>  input1,
        IE      =>  IE,
        WAddr   =>  WAddr,
        Write   =>  Write,
        RA      =>  RA,
        ReadA   =>  ReadA,
        RB      =>  RB,
        ReadB   =>  ReadB,
        Output  =>  Output,
        OE      =>  OE,
        en      =>  en,
        op      =>  op,
        Offset  =>  Offset,
        BypassA =>  BypassA,
        BypassB =>  BypassB
    );
    --Clock process definition
    clk <=  not clk after ClockPeriod/2;
    --Stimulus process
stim_proc:  process
begin
    --hold reset state for 10 ns
    rst<='1';
    wait for 1 ns;
    rst<='0';
    Ie<='1';
    BypassA <= '0';
    BypassB <= '0';
    op <= "111";

    wait until rising_edge(clk);
    wait for 1 ns;
    Input1 <= "1111";
    WAddr <= "0000"; 
          
    wait until rising_edge(clk);
    wait for 1 ns;     
    RA <= "0000"; 
    RB <= "0001"; 
    wait;
end process;  
end;
