library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    component processador
        port(
            clk             : in std_logic;
            rst             : in std_logic;
            data_out_PC_o   : out unsigned(15 downto 0);
            result_ula_o    : out unsigned(15 downto 0);
            regBank_out     : out unsigned(15 downto 0);
            acumulador_out  : out unsigned(15 downto 0);
            instruction_o   : out unsigned(18 downto 0);
            estado_o        : out unsigned(1 downto 0);
            saida_reg_r0    : out unsigned(15 downto 0);
            saida_reg_r1    : out unsigned(15 downto 0)
        );
    end component;

    signal clk             : std_logic := '0';
    signal rst             : std_logic := '0';
    signal data_out_PC_o   : unsigned(15 downto 0) := (others => '0');
    signal result_ula_o    : unsigned(15 downto 0) := (others => '0');
    signal regBank_out     : unsigned(15 downto 0) := (others => '0');
    signal acumulador_out  : unsigned(15 downto 0) := (others => '0');
    signal instruction_o   : unsigned(18 downto 0) := (others => '0');
    signal estado          : unsigned(1 downto 0) := (others => '0');
    signal saida_reg_r0    : unsigned(15 downto 0) := (others => '0');
    signal saida_reg_r1    : unsigned(15 downto 0) := (others => '0');

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

begin
    -- Instanciação da UUT (Unit Under Test)
    uut: processador
        port map (
            clk => clk,
            rst => rst,
            data_out_PC_o => data_out_PC_o,
            result_ula_o => result_ula_o,
            regBank_out => regBank_out,
            acumulador_out => acumulador_out,
            instruction_o => instruction_o,
            estado_o => estado,
            saida_reg_r0 => saida_reg_r0,
            saida_reg_r1 => saida_reg_r1
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

    -- Processo de reset global
    reset_global : process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait;
    end process;

    -- Processo para definir o tempo de simulação
    sim_time_proc : process
    begin
        wait for 323 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Estímulos de teste
    stim_proc: process
    begin
        -- Esperar o reset
        wait for clk_period;

        -- Simulação
        wait for 3230*clk_period;

        -- Stop simulation
        wait;
    end process;
end architecture;