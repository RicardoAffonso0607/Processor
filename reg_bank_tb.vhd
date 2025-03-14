library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_bank_tb is
end entity;

architecture a_reg_bank of reg_bank_tb is
    component reg_bank
        port(
            clk           : in std_logic;
            rst           : in std_logic;
            reg_wr_en     : in std_logic;
            selec_reg_wr  : in unsigned(2 downto 0);
            selec_reg_rd  : in unsigned(2 downto 0);
            data_wr       : in unsigned(15 downto 0);
            data_r1       : out unsigned(15 downto 0)
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal reg_wr_en    : std_logic := '0';
    signal selec_reg_wr  : unsigned(2 downto 0) := (others => '0');
    signal selec_reg_rd  : unsigned(2 downto 0) := (others => '0');
    signal data_wr       : unsigned(15 downto 0) := (others => '0');
    signal data_r1 : unsigned(15 downto 0);

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

begin
    
    uut: reg_bank
        port map (
            clk => clk,
            rst => rst,
            reg_wr_en => reg_wr_en,
            selec_reg_wr => selec_reg_wr,
            selec_reg_rd => selec_reg_rd,
            data_wr => data_wr,
            data_r1 => data_r1
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
        wait for 3 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    stim_proc: process
    begin
        -- Esperar o reset
        wait for 2 * clk_period;

        -- ESCRITA NOS REGISTRADORES

        -- Escrever no registrador 0
        reg_wr_en <= '1';
        selec_reg_wr <= "000";
        selec_reg_rd <= "000";
        data_wr <= to_unsigned(12345, 16);
        wait for clk_period*2;

        -- Escrever no registrador 1
        selec_reg_wr <= "001";
        selec_reg_rd <= "001";
        data_wr <= to_unsigned(54321, 16);
        wait for clk_period*2;

        -- Escrever no registrador 2
        selec_reg_wr <= "010";
        selec_reg_rd <= "010";
        data_wr <= to_unsigned(21354, 16);
        wait for clk_period*2;

        -- Escrever no registrador 3
        selec_reg_wr <= "011";
        selec_reg_rd <= "011";
        data_wr <= to_unsigned(11111, 16);
        wait for clk_period*2;

        -- Escrever no registrador 4
        selec_reg_wr <= "100";
        selec_reg_rd <= "100";
        data_wr <= to_unsigned(22222, 16);
        wait for clk_period*2;

        -- Escrever no registrador 5
        selec_reg_wr <= "101";
        selec_reg_rd <= "101";
        data_wr <= to_unsigned(33333, 16);
        wait for clk_period*2;

        -- LEITURA DOS REGISTRADORES

        -- Ler do registrador 0
        reg_wr_en <= '0';
        selec_reg_rd <= "000";
        wait for clk_period*2;

        -- Ler do registrador 1
        selec_reg_rd <= "001";
        wait for clk_period*2;

        -- Ler do registrador 2
        selec_reg_rd <= "010";
        wait for clk_period*2;

        -- Ler do registrador 3
        selec_reg_rd <= "011";
        wait for clk_period*2;

        -- Ler do registrador 4
        selec_reg_rd <= "100";
        wait for clk_period*2;

        -- Ler do registrador 5
        selec_reg_rd <= "101";
        wait for clk_period*2;

        wait;
    end process;
end architecture;