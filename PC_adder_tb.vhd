library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_adder_tb is
end entity;

architecture a_PC_adder_tb of PC_adder_tb is

    component PC_adder
    port( 
        clk         : in std_logic;
        PC_rst      : in std_logic;
        PC_wr_en_i  : in std_logic;
        jump_abs_i  : in std_logic;
        jump_rel_i  : in std_logic;
        jump_addr_i : in unsigned(6 downto 0);
        data_in     : in unsigned(6 downto 0);
        data_out    : out unsigned(6 downto 0)
    );
    end component;

    signal clk         : std_logic := '0';
    signal PC_rst      : std_logic := '0';
    signal PC_wr_en_s    : std_logic := '0';
    signal jump_abs    : std_logic := '0';
    signal jump_rel    : std_logic := '0';
    signal jump_addr   : unsigned(6 downto 0) := (others => '0');
    signal data_in     : unsigned(6 downto 0) := (others => '0');
    signal data_out    : unsigned(6 downto 0) := (others => '0');

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

    begin 

    -- Instanciação da UUT (Unit Under Test)
    uut: PC_adder
        port map (
            clk         => clk,
            PC_rst      => PC_rst,
            PC_wr_en_i  => PC_wr_en_s,
            jump_abs_i  => jump_abs,
            jump_rel_i  => jump_rel,
            jump_addr_i => jump_addr,
            data_in     => data_in,
            data_out    => data_out
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
        PC_rst <= '1';
        wait for 2 * clk_period;
        PC_rst <= '0';
        wait;
    end process;

    sim_time_proc : process
    begin
        wait for 2 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    stim_proc: process
    begin
        wait for 2 * clk_period;

        -- Teste 1: write_enable desabilitado
        PC_wr_en_s <= '0';
        jump_abs <= '0';
        jump_rel <= '0';
        data_in <= (others => '0');
        wait for clk_period;

        -- Teste 2: write_enable habilitado
        PC_wr_en_s <= '1';
        data_in <= (others => '0');
        wait for clk_period;

        -- Teste 3: Verificar se está incrementando certo
        wait for clk_period*3;

        -- Teste 4: Verificar se o jump absolute está funcionando
        jump_abs <= '1';
        jump_addr <= to_unsigned(2,7);
        wait for clk_period*2;

        -- Teste 5: Verficar se o jump relativo está funcionando
        jump_rel <= '1';
        jump_abs <= '0';
        jump_addr <= to_unsigned(2,7);
        wait for clk_period*2;

        -- Teste 6: Verifica se está pulando 1 até o final
        jump_rel <= '0';
        jump_abs <= '0';

        wait;
    end process;
end architecture;