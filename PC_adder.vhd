library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_adder is
    port( 
       clk         : in std_logic;
       PC_rst      : in std_logic;
       PC_wr_en_i  : in std_logic;
       jump_abs_i  : in std_logic;
       jump_rel_i  : in std_logic;
       jump_addr_i : in unsigned(15 downto 0);
       data_in     : in unsigned(15 downto 0);
       data_out    : out unsigned(15 downto 0)
    );
end entity;

architecture a_PC_adder of PC_adder is
    component PC
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal PC_data_in  : unsigned(15 downto 0) := (others => '0');
    signal PC_data_in_s: unsigned(15 downto 0) := (others => '0');
    signal PC_data_out : unsigned(15 downto 0) := (others => '0');

    begin
        PC_inst: PC
        port map(
            clk      => clk,
            rst      => PC_rst,
            wr_en    => PC_wr_en_i,
            data_in  => PC_data_in_s,
            data_out => PC_data_out
        );

        -- PARA QUANDO O ENDEREÇO DA ROM A SER PEGO FOR NEGATIVO (extesão de sinal)
        PC_data_in_s <= (others => '0') when PC_data_in(15) = '1' else
                        PC_data_in;

        -- ATUALIZAÇÃO DO PC
        PC_data_in <= jump_addr_i when jump_abs_i = '1' else
                      PC_data_out + jump_addr_i when jump_rel_i = '1' else
                      PC_data_out + "0000000000000001";

        data_out <= PC_data_out;

end architecture;