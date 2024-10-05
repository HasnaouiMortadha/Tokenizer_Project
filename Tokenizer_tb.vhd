
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Tokenizer_tb is
end Tokenizer_tb;

architecture Behavioral of Tokenizer_tb is

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '1';
    signal char_in     : std_logic_vector(7 downto 0);
    signal valid_in    : std_logic;
    signal token_out   : std_logic_vector(7 downto 0);
    signal token_valid : std_logic;

    constant clk_period : time := 10 ns;
    
begin

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Instantiate the Tokenizer
    uut: entity work.Tokenizer
        port map (
            clk => clk,
            reset => reset,
            char_in => char_in,
            valid_in => valid_in,
            token_out => token_out,
            token_valid => token_valid
        );
    
    -- Test Process
    process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- Input a simple sentence: "Hi GPT"
        valid_in <= '1';
        char_in <= "01001000"; -- 'H'
        wait for clk_period;
        char_in <= "01101001"; -- 'i'
        wait for clk_period;
        char_in <= "00100000"; -- Space
        wait for clk_period;
        char_in <= "01000111"; -- 'G'
        wait for clk_period;
        char_in <= "01110000"; -- 'P'
        wait for clk_period;
        char_in <= "01010100"; -- 'T'
        wait for clk_period;
        valid_in <= '0';
        
        wait;
    end process;

end Behavioral;
