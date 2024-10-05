library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Tokenizer is
    Port (
        clk         : in std_logic;
        reset       : in std_logic;
        char_in     : in std_logic_vector(7 downto 0);  -- ASCII character input
        valid_in    : in std_logic;                     -- Input is valid
        token_out   : out std_logic_vector(7 downto 0); -- ASCII character of current token
        token_valid : out std_logic                     -- Token output is valid
    );
end Tokenizer;

architecture Behavioral of Tokenizer is

    type state_type is (IDLE, IN_WORD, OUT_WORD);  -- States for FSM
    signal state, next_state : state_type;
    signal buffer : std_logic_vector(7 downto 0);  -- Store current character
    signal char_ready : std_logic;  -- Flag indicating character is ready to output
    
begin

    -- FSM Process
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Next state logic and output generation
    process(state, char_in, valid_in)
    begin
        -- Default values
        next_state <= state;
        char_ready <= '0';
        token_valid <= '0';
        token_out <= (others => '0');
        
        case state is
            -- IDLE: Wait for valid input character
            when IDLE =>
                if valid_in = '1' then
                    if char_in /= "00100000" then -- Not a space
                        next_state <= IN_WORD;
                        buffer <= char_in;  -- Store character in buffer
                    end if;
                end if;
            
            -- IN_WORD: We are reading a token (word), output each character
            when IN_WORD =>
                char_ready <= '1';
                token_out <= buffer;  -- Output current character
                token_valid <= '1';
                if valid_in = '1' then
                    if char_in = "00100000" then -- Space detected, end of word
                        next_state <= OUT_WORD;
                    else
                        buffer <= char_in;  -- Store next character
                    end if;
                end if;
                
            -- OUT_WORD: Token finished, wait for space to end
            when OUT_WORD =>
                token_valid <= '0';  -- No valid output here
                if valid_in = '1' and char_in /= "00100000" then -- New word starts
                    next_state <= IN_WORD;
                    buffer <= char_in;  -- Store the new character
                elsif valid_in = '1' and char_in = "00100000" then
                    next_state <= IDLE;  -- Stay in idle for next token
                end if;
                
        end case;
    end process;

end Behavioral;

