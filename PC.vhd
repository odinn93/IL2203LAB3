library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity PC is
    generic( M,N : INTEGER); 
    port( 
        clk, reset, en  :   in std_logic;
        BypassB         :   in std_logic;
        ReadA_out       :   out std_logic_vector (m-1 downto 0);
        RA_out          :   out std_logic
    );

end PC;

architecture behavior of PC is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                ReadA_out <= (others => '1');
                RA_out <= '1';
            end if;
        end if;

            --elsif BypassB = '0' then
              --  ReadA_out 

        --end if;

    end process;

end behavior;
