LIBRARY ieee;
    USE ieee.std_logic_1164.ALL;
 
ENTITY tb_clockdiv IS
END tb_clockdiv;
 
ARCHITECTURE test_clock OF tb_clockdiv IS
    COMPONENT clockdiv
        PORT(
                clk,rst     : IN std_logic;
                clock_out   : OUT std_logic
            );
    END COMPONENT;
 
    --Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
 
    --Outputs
    signal clock_out : std_logic;
 
    -- Clock period definitions
    constant clk_period : time := 10 ns;
 
    BEGIN
    -- Instantiate the DUT
    DUT: clockdiv PORT MAP 
            (
                clk => clk,
                rst => rst,
                clock_out => clock_out
            );
 
    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 
    -- Stimulus process
    stim_proc: process
    begin
        wait for 100 ns;
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;
END;

