library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
end entity;

architecture a_UC_tb of UC_tb is
    component UC
        port (
            clk                 : in std_logic;
            instruction         : in unsigned(18 downto 0);
            flagNegativeFF_in   : in std_logic;
            flagZeroFF_in       : in std_logic;
            flagOverflowFF_in   : in std_logic;
            PC_wr_en_o          : out std_logic;
            jump_abs_o          : out std_logic;
            jump_rel_o          : out std_logic;
            jump_addr_o         : out unsigned(6 downto 0);
            op_ULA              : out unsigned(2 downto 0);
            wr_addr_o           : out unsigned(2 downto 0);
            rd_addr_o           : out unsigned(2 downto 0);
            data_in_regbank_o   : out unsigned(15 downto 0);
            regs_en_o           : out std_logic;
            acumulador_en_o     : out std_logic;
            flags_en            : out std_logic;
            mov_instruction_o   : out std_logic;
            cmpi_instruction_o  : out std_logic;
            estado              : out unsigned(1 downto 0)
        );
    end component;

    signal clk           : std_logic := '0';
    signal instruction   : unsigned(18 downto 0) := (others => '0');
    signal PC_wr_en_s    : std_logic := '0';
    signal jump_abs      : std_logic := '0';
    signal jump_rel      : std_logic := '0';
    signal jump_addr     : unsigned(6 downto 0) := (others => '0');
    signal estado        : unsigned(1 downto 0) := (others => '0');

    constant clk_period : time := 100 ns;
    signal finished : std_logic := '0';

begin

    uut: UC
        port map(
            clk => clk,
            instruction => instruction,
            PC_wr_en_o => PC_wr_en_s,
            jump_abs_o => jump_abs,
            jump_rel_o => jump_rel,
            jump_addr_o => jump_addr,
            op_ULA => open,
            wr_addr_o => open,
            rd_addr_o => open,
            data_in_regbank_o => open,
            regs_en_o => open,
            acumulador_en_o => open,
            flags_en => open,
            flagNegativeFF_in => open,
            flagZeroFF_in => open,
            flagOverflowFF_in => open,
            mov_instruction_o => open,
            cmpi_instruction_o => open,
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

    -- Processo para definir o tempo de simulação
    sim_time_proc : process
    begin
        wait for 1200 ns;
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Estímulos de teste
    stim_proc: process
    begin
        
        wait for clk_period*2;
        instruction <= b"00000010_0000011_1111"; -- jump absolute 
        wait for clk_period*2;
        instruction <= b"00000010_0000111_1111"; -- jump absolute

        wait;
    end process;
end architecture;