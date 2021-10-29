library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity mux is
    generic(
        M,N :   Integer);
    Port(   
            RF_output_B   :   in std_logic_vector  (N-1 downto 0);
            Offset      :   in std_logic_vector (N-1 downto 0);
            --BypassA     :   in std_logic;
            BypassB     :   in std_logic;
            MuxOut      :   out std_logic_vector (n-1 downto 0)
    );
end mux;

architecture behavior of mux is

begin
    process(RF_output,Offset,BypassA)
    begin
        if BypassA='0' then
            MuxOut <= RF_output;
        elsif BypassA = '1' then
            MuxOut <= Offset;
        end if;

    end process; 

end behavior;

