library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is
    
    component ULA is
        Port (
            A : in unsigned(15 downto 0);
            B : in unsigned(15 downto 0);
            Op : in unsigned(2 downto 0);
            Result : out unsigned(15 downto 0);
            Zero : out std_logic;
            Negative : out std_logic;
            Overflow : out std_logic
        );
    end component;

    signal A : unsigned(15 downto 0) := (others => '0');
    signal B : unsigned(15 downto 0) := (others => '0');
    signal Op : unsigned(2 downto 0) := (others => '0');
    signal Result : unsigned(15 downto 0);
    signal Zero : std_logic;
    signal Negative : std_logic;
    signal Overflow : std_logic;

begin

    uut: ULA
        Port map (
            A => A,
            B => B,
            Op => Op,
            Result => Result,
            Zero => Zero,
            Negative => Negative,
            Overflow => Overflow
        );

    stim_proc: process
    begin

    -- Test case 1: A = 3, B = 2, Op = "000" (Adição) - Resultado esperado: 5
        A <= to_unsigned(3, 16);
        B <= to_unsigned(2, 16);
        Op <= "000";
        wait for 10 ns;

    -- Test case 2: A = -3, B = 2, Op = "000" (Adição) - Resultado esperado: -1
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2, 16);
        Op <= "000";
        wait for 10 ns;

    -- Test case 3: A = 3, B = -2, Op = "000" (Adição) - Resultado esperado: 1
        A <= to_unsigned(3, 16);
        B <= to_unsigned(2**16 - 2, 16);
        Op <= "000";
        wait for 10 ns;

    -- Test case 4: A = -3, B = -2, Op = "000" (Adição) - Resultado esperado: -5
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2**16 - 2, 16);
        Op <= "000";
        wait for 10 ns;

    -- Test case 5: A = 2^15 - 1, B = 1, Op = "000" (Adição) - Resultado esperado: Overflow
        A <= to_unsigned(2**15 - 1, 16);
        B <= to_unsigned(1, 16);
        Op <= "000";
        wait for 10 ns;

    -- Test case 6: A = -2^15, B = -1, Op = "000" (Adição) - Considerando como signed, resultado esperado: Overflow
        A <= to_unsigned(2**15, 16);
        B <= to_unsigned(2**16 - 1, 16);
        Op <= "000";
        wait for 10 ns;
    

    -- Test case 7: A = 5, B = 3, Op = "001" (Subtração) - Resultado esperado: 2
        A <= to_unsigned(5, 16);
        B <= to_unsigned(3, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 8: A = 8, B = 9, Op = "001" (Subtração) - Resultado esperado: -1
        A <= to_unsigned(8, 16);
        B <= to_unsigned(9, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 9: A = -3, B = 2, Op = "001" (Subtração) - Resultado esperado: -5
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 10: A = 3, B = -2, Op = "001" (Subtração) - Resultado esperado: 5
        A <= to_unsigned(3, 16);
        B <= to_unsigned(2**16 - 2, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 11: A = -3, B = -2, Op = "001" (Subtração) - Resultado esperado: -1
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2**16 - 2, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 12: A = -2^15, B = 1, Op = "001" (Subtração) - Considerando como signed, resultado esperado: Overflow
        A <= to_unsigned(2**15, 16);
        B <= to_unsigned(1, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 13: A = 2^15 - 1, B = -1, Op = "001" (Subtração) - Considerando como signed, resultado esperado: Overflow
        A <= to_unsigned(2**15 - 1, 16);
        B <= to_unsigned(2**16 - 1, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 14: A = -3, Op = "010" (NOT)
        A <= to_unsigned(2**16 - 3, 16);
        B <= (others => '0');
        Op <= "010";
        wait for 10 ns;

    -- Test case 15: A = 3, Op = "010" (NOT)
        A <= to_unsigned(3, 16);
        B <= (others => '0');
        Op <= "010";
        wait for 10 ns;

    -- Test case 16: A = 7, B = 8, Op = "011" (Igualdade) 
        A <= to_unsigned(7, 16);
        B <= to_unsigned(8, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 17: A = 2^14, B = 2^14, Op = "011" (Igualdade)
        A <= to_unsigned(2**14, 16);
        B <= to_unsigned(2**14, 16);
        Op <= "001";
        wait for 10 ns;

    -- Test case 18: A = -3, B = 3, Op = "011" (Igualdade)
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(3, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 19: A = 2, B = -2, Op = "011" (Igualdade)
        A <= to_unsigned(2, 16);
        B <= to_unsigned(2**16 - 2, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 20: A = -3, B = -3, Op = "011" (Igualdade)
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2**16 - 3, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 21: A = -3, B = -5, Op = "011" (Igualdade)
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2**16 - 5, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 22: A = 0, B = 0, Op = "011" (AND)
        A <= to_unsigned(0, 16);
        B <= to_unsigned(0, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 23: A = 1, B = 0, Op = "011" (AND)
        A <= to_unsigned(1, 16);
        B <= to_unsigned(0, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 24: A = 1, B = 1, Op = "011" (AND)
        A <= to_unsigned(1, 16);
        B <= to_unsigned(1, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 25: A = 124, B = 12, Op = "011" (AND)
        A <= to_unsigned(124, 16);
        B <= to_unsigned(12, 16);
        Op <= "011";
        wait for 10 ns;

    -- Test case 26: A = -3, B = -3, Op = "011" (AND)
        A <= to_unsigned(2**16 - 3, 16);
        B <= to_unsigned(2**16 - 3, 16);
        Op <= "011";
        wait for 10 ns;

        wait;
    end process;
end architecture;
