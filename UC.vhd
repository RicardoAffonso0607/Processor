library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is 
    port(
        clk                 : in std_logic;
        rst                 : in std_logic;
        instruction         : in unsigned(18 downto 0);
        flagNegativeFF_in   : in std_logic;
        flagZeroFF_in       : in std_logic;
        flagOverflowFF_in   : in std_logic;
        -- PC adder:
        PC_wr_en_o          : out std_logic;
        jump_abs_o          : out std_logic;
        jump_rel_o          : out std_logic;
        jump_addr_o         : out unsigned(15 downto 0);
        -- ULA:
        op_ULA              : out unsigned(2 downto 0);
        -- reg_bank:
        wr_addr_o           : out unsigned(2 downto 0);
        rd_addr1_o          : out unsigned(2 downto 0);
        rd_addr2_o          : out unsigned(2 downto 0);
        cte_LD_o            : out unsigned(15 downto 0);
        regs_en_o           : out std_logic;
        acumulador_en_o     : out std_logic;
        flags_en            : out std_logic;
        -- MOV:
        mov_en_o            : out std_logic;
        -- CMPI:
        cmpi_en_o           : out std_logic;
        -- LD:
        ld_en_o             : out std_logic;
        -- RAM:
        sw_en_o             : out std_logic;
        lw_en_o             : out std_logic;
        cte_ram             : out unsigned(6 downto 0);
        -- maquina_estados:
        estado              : out unsigned(1 downto 0)
    );
end entity;

architecture a_UC of UC is

    component maquina_estados
        port( 
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0)
        );
     end component;

    signal opcode       : unsigned(3 downto 0) := (others => '0');
    signal funct        : unsigned(2 downto 0) := (others => '0');
    signal estado_s     : unsigned(1 downto 0) := (others => '0');
    signal exten_sinal  : unsigned(6 downto 0) := (others => '0');
    signal is_for_acumulator   : boolean := false;
    signal execute          : boolean := false;
    signal eh_ld            : boolean := false;
    signal eh_mov           : boolean := false;
    signal eh_lw            : boolean := false;
    signal ble : std_logic := '0';
    signal bmi : std_logic := '0';

begin

    maq_estados: maquina_estados
        port map (
            clk => clk,
            rst => rst,
            estado => estado_s
        );

        execute <= (estado_s = "10");
    
    ------------------------------------------- DECODIFICAÇÃO DA INSTRUÇÃO ----------------------------------------------------------
    

    funct <= instruction(6 downto 4);
    opcode <= instruction(3 downto 0);


    -- OPERAÇÕES DE ULA
                -- OPERAÇÕES ARITMÉTICAS
    op_ULA <=   "000" when (opcode = "0001" and funct = "000") else         -- ADD A, Rn    A = A + Rn
                "001" when (opcode = "0001" and funct = "001") else         -- SUB A, Rn    A = A - Rn
                "001" when (opcode = "0101" and funct = "000") else         -- CMPI Rn, cte
                
                -- OPERAÇÕES LÓGICAS
                "010" when (opcode = "0010" and funct = "000") else         -- NEG A       A = ~A
                "011" when (opcode = "0010" and funct = "001") else "100";  -- AND A, Rn   A = A & Rn

    -- ENABLE PARA SABER SE É UMA OPERAÇÃO QUE PODE ALTERAR AS FLAGS
    flags_en <= '1' when (opcode = "0001" and funct = "000" and execute) else       -- ADD A, Rn
                '1' when (opcode = "0001" and funct = "001" and execute) else       -- SUB A, Rn
                '1' when (opcode = "0010" and funct = "000" and execute) else       -- NEG A
                '1' when (opcode = "0010" and funct = "001" and execute) else       -- AND A, Rn
                '1' when (opcode = "0101" and funct = "000" and execute) else '0';  -- CMPI Rn, cte
       
     -- ENABLE PARA SABER SE É CMPI
     cmpi_en_o  <= '1' when (opcode = "0101" and funct = "000") else '0';


     -- ENABLE PARA SABER SE É LD
     eh_ld <= (opcode = "0011" and funct = "000");
     ld_en_o    <= '1' when eh_ld else '0';


    is_for_acumulator <= true when (instruction(12 downto 10) = "110" and eh_mov) else  -- MOV A, Rm
                         true when (instruction(9 downto 7) = "110" and eh_ld) else     -- LD A, cte
                         true when (instruction(12 downto 10) = "110" and eh_lw) else     -- LW Rn, cte (Rm)
                         false;

    -- HABILITA O ACUMULADOR PARA AS OPERAÇÕES DE ULA e LD
    acumulador_en_o <= '1' when (opcode = "0001" and funct = "000" and execute) else        -- ADD A, Rn
                       '1' when (opcode = "0001" and funct = "001" and execute) else        -- SUB A, Rn
                       '1' when (opcode = "0010" and funct = "000" and execute) else        -- NEG A
                       '1' when (opcode = "0010" and funct = "001" and execute) else        -- AND A, Rn
                       '1' when (opcode = "0011" and funct = "000" and execute and is_for_acumulator) else -- LD A, cte  A = cte
                       '1' when (opcode = "0100" and funct = "000" and execute and is_for_acumulator) else -- MOV A, Rm  A = Rm
                       '1' when (opcode = "0110" and funct = "001" and execute and is_for_acumulator) else -- LW Rn, cte (Rm)  A = Rm
                       '0';


    -- HABILITA A ESCRITA NO BANCO DE REGISTRADORES
    regs_en_o <= '1' when (opcode = "0011" and funct = "000") else          -- LD Rn, cte   Rn = cte
                 '1' when (opcode = "0100" and funct = "000") else          -- MOV Rn, Rm
                 '1' when (opcode = "0110" and funct = "001") else '0';     -- LW Rn, cte (Rm)
    

    -- ENDEREÇO DO REGISTRADOR A SER ESCRITO
    wr_addr_o <= instruction(9 downto 7)    when (opcode = "0011" and funct = "000") else   -- LD Rn, cte  (PEGANDO O ENDEREÇO DO Rn)
                 instruction(12 downto 10)  when (opcode = "0100" and funct = "000") else   -- MOV Rn, Rm  (PEGANDO O ENDEREÇO DO Rn)
                 instruction(12 downto 10)  when (opcode = "0110" and funct = "001") else   -- LW Rn, cte (Rm) (PEGANDO O ENDEREÇO DO Rn)
                 (others => '0');

    
    -- ENDEREÇO DO REGISTRADOR 1 A SER LIDO
    rd_addr1_o <= instruction(9 downto 7) when (opcode = "0001" and funct = "000") else             -- ADD A, Rn    (LENDO Rn)
                 instruction(9 downto 7) when (opcode = "0001" and funct = "001") else              -- SUB A, Rn    (LENDO Rn)
                 instruction(9 downto 7) when (opcode = "0010" and funct = "001") else              -- AND A, Rn    (LENDO Rn)
                 instruction(9 downto 7) when (opcode = "0100" and funct = "000") else              -- MOV Rn, Rm   (LENDO Rm)
                 instruction(9 downto 7) when (opcode = "0101" and funct = "000") else              -- CMPI Rn, cte (LENDO Rn)
                 instruction(9 downto 7) when (opcode = "0110" and funct = "000") else              -- SW Rn, cte (Rm) (LENDO Rm)
                 instruction(9 downto 7) when (opcode = "0110" and funct = "001") else "111";       -- LW Rn, cte (Rm) (LENDO Rm)


    -- ENDEREÇO DO REGISTRADOR 2 A SER LIDO
    rd_addr2_o <= instruction(12 downto 10) when (opcode = "0110" and funct = "000") else "111";    -- SW Rn, cte (Rm) (LENDO Rn)

    
    -- EXTENSÃO DE SINAL DA CONSTANTE PARA OPERAÇÕES DE LD
    exten_sinal <= "1111111" when instruction(18) = '1' else (others => '0');

    cte_LD_o <= exten_sinal & instruction(18 downto 10) when (opcode = "0011" and funct = "000") else  -- LD Rn, cte (LENDO A CONSTANTE)
                         (others => '0');


    -- MOV Rn, Rm   Rn = Rm (QUANDO 1 FAZ A SAIDA DO BANCO DE REGISTRADORES QUE SERÁ Rm SE TORNAR A ENTRADA DO BANCO DE REGISTRADORES)
    mov_en_o <= '1' when (opcode = "0100" and funct = "000") else '0';
    eh_mov <= (opcode = "0100" and funct = "000");


    -- INSTRUÇÕES DE MEMÓRIA
    sw_en_o <= '1' when (opcode = "0110" and funct = "000") else '0';  -- SW Rn, cte (Rm)   
    lw_en_o <= '1' when (opcode = "0110" and funct = "001") else '0';  -- LW Rn, cte (Rm)
    eh_lw <= (opcode = "0110" and funct = "001");

    cte_ram <= '0' & instruction(18 downto 13) when (opcode = "0110" and instruction(18) = '0') else
               '1' & instruction(18 downto 13) when (opcode = "0110" and instruction(18) = '1') else
               (others => '0');                                                          

    -- JUMPS
    jump_abs_o <=   '1' when (opcode = "1111" and funct = "000") else '0';          -- Pula para a instrução jump_addr_o
    jump_rel_o <=   '1' when (opcode = "1111" and funct = "001" and ble = '1') else       -- Pula jump_addr_o instruções (SE Rn <= A == cte)
                    '1' when (opcode = "1111" and funct = "010" and bmi = '1') else '0';  -- Pula jump_addr_o instruções (SE Rn < A == cte)

    jump_addr_o <=  "1111" & instruction(18 downto 7) when (opcode = "1111" and instruction(18) = '1' ) else 
                    "0000" & instruction(18 downto 7) when (opcode = "1111" and instruction(18) = '0' ) else
                    (others => '0');

    -- BRANCHES
    ble <= '1' when (flagZeroFF_in = '1' or flagNegativeFF_in /= flagOverflowFF_in) else '0';
    bmi <= '1' when (flagNegativeFF_in = '1') else '0';

    ------------------------------------------- DECODIFICAÇÃO DA INSTRUÇÃO ----------------------------------------------------------
    


    -- ATUALIZAR PC
    PC_wr_en_o <= '1' when estado_s = "10" else '0';

    estado <= estado_s;

end architecture;
 