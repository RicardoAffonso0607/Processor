library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits of reg16bits_tb is
    component reg16bits
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal data_in  : unsigned(15 downto 0) := (others => '0');
    signal data_out : unsigned(15 downto 0);

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

begin
    -- Instanciação da UUT (Unit Under Test)
    uut: reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
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

        -- Escrever no registrador
        wr_en <= '1';
        data_in <= to_unsigned(12345, 16);
        wait for clk_period;

        -- Desabilitar escrita
        wr_en <= '0';
        wait for clk_period;

        -- Escrever novo valor no registrador
        wr_en <= '1';
        data_in <= to_unsigned(54321, 16);
        wait for clk_period;

        -- Desabilitar escrita
        wr_en <= '0';
        wait for clk_period;

        wait;
    end process;
end architecture;