library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    Port (
        A           : in unsigned(15 downto 0);
        B           : in unsigned(15 downto 0);
        Op          : in unsigned(2 downto 0);
        Result      : out unsigned(15 downto 0);
        -- Flags
        Zero       : out std_logic;
        Negative    : out std_logic;
        Overflow    : out std_logic
    );
end entity;

architecture a_ULA of ULA is
    -- Operações
    signal soma : unsigned(16 downto 0) := (others => '0');
    signal subtracao : unsigned(16 downto 0) := (others => '0');
    signal notA : unsigned(15 downto 0) := (others => '0');
    signal A_and_B : unsigned (16 downto 0) := (others => '0');
    -- Resultado
    signal resultadoParcial : unsigned(16 downto 0) := (others => '0');

begin

    -- OPERAÇÕES

        soma        <=  ('0' & A) + ('0' & B);      -- SOMA
        subtracao   <=  ('0' & A) - ('0' & B);      -- SUBTRAÇÃO
        notA        <=  not A;                      -- NEGAÇÃO DE A
        A_and_B     <=  ('0' & A) and ('0' & B);    -- AND
        
        -- MULTIPLEXADOR 2x4 PARA ESCOLHA DA OPERAÇÃO
        
        resultadoParcial <= soma            when Op="000" else
                            subtracao       when Op="001" else
                            ('0' & notA)    when Op="010" else
                            A_and_B         when Op="011" else
                            "00000000000000001";
        
        -- FLAGS           

        Overflow <= '1' when (Op = "000" and A(15) = B(15) and resultadoParcial(15) /= A(15)) else
                    '1' when (Op = "001" and A(15) /= B(15) and resultadoParcial(15) /= A(15)) else
                    '0';
                        
        Negative <= resultadoParcial(15);

        Zero <= '1' when resultadoParcial = to_unsigned(0,16) else '0';

    -- RESULTADO

        Result <=  resultadoParcial (15 downto 0); 

end architecture;