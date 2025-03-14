library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            estado   : out unsigned(1 downto 0)
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal estado   : unsigned(1 downto 0) := (others => '0');

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

begin

    uut: maquina_estados
        port map (
            clk => clk,
            rst => rst,
            estado => estado
        );
    
    -- Geração do clock
    process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    reset_global : process
    begin
        rst <= '1';
        wait for 2 * clk_period;
        rst <= '0';
        wait;
    end process;

    sim_time_proc : process
    begin
        wait for 1 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Estímulos de teste
    stim_proc: process
    begin
        -- Esperar o reset
        wait for 2 * clk_period;

        wait for clk_period*5;

        wait;
    end process;
end architecture;