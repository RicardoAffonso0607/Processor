library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_tb is
end entity;

architecture a_ROM_tb of ROM_tb is
   component ROM
      port( 
         clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(18 downto 0)
      );
   end component;

   signal clk      : std_logic := '0';
   signal endereco : unsigned(6 downto 0) := (others => '0');
   signal dado     : unsigned(18 downto 0) := (others => '0');

   constant clk_period : time := 100 ns;
   signal finished : std_logic := '0';

begin
   uut: ROM port map(
      clk      => clk,
      endereco => endereco,
      dado     => dado
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

   stim_proc : process
   begin
      wait for 2 * clk_period;
      
      --Testar alguns endereços definidos no ROM
      endereco <= "0000000"; 
      wait for clk_period;
      
      endereco <= "0000001"; 
      wait for clk_period;
      
      endereco <= "0000010"; 
      wait for clk_period;
      
      endereco <= "0000011"; 
      wait for clk_period;
      
      endereco <= "0000100"; 
      wait for clk_period;
      
      endereco <= "0000101"; 
      wait for clk_period;
      
      endereco <= "0000110"; 
      wait for clk_period;
      
      endereco <= "0000111"; 
      wait for clk_period;
      
      endereco <= "0001000"; 
      wait for clk_period;
      
      endereco <= "0001001"; 
      wait for clk_period;
      
      endereco <= "0001010"; 
      wait for clk_period;
      
      wait;
   end process;

end architecture;
