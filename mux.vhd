library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity mux is
    generic(
        M,N :   Integer);
    Port(   
            RF_output_A   :   in std_logic_vector  (N-1 downto 0);
            RF_output_B   :   in std_logic_vector  (N-1 downto 0);
            Offset      :   in std_logic_vector (N-1 downto 0);
            BypassA     :   in std_logic;
            BypassB     :   in std_logic;
            MuxOut_A      :   out std_logic_vector (n-1 downto 0);
            MuxOut_B      :   out std_logic_vector (n-1 downto 0)
    );
end mux;

architecture behavior of mux is

begin
    process(RF_output_A,RF_output_B,Offset,BypassA,BypassB)
    begin
        if BypassA='0' then
            MuxOut_A <= RF_output_A;
        elsif BypassA = '1' then
            MuxOut_A <= Offset;
            end if;

        if BypassB ='0' then
            MuxOut_B <= RF_output_B;
        elsif BypassB = '1' then
            MuxOut_B <= Offset;
        end if;

    end process; 

end behavior;
