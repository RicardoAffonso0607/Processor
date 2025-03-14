library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
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
end entity;

architecture a_processador of processador is

    component ram
        port(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0)
        );
    end component;

    component reg1bit
        port( 
           clk      : in std_logic;
           rst      : in std_logic;
           wr_en    : in std_logic;
           data_in  : in std_logic;
           data_out : out std_logic
        );
     end component;

    component instruction_reg
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(18 downto 0);
            data_out : out unsigned(18 downto 0)
        );
    end component;

    component ROM
        port( 
            clk      : in std_logic;
            endereco : in unsigned(15 downto 0);
            dado     : out unsigned(18 downto 0)
        );
    end component;

    component PC_adder
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
    end component;

    component UC
        port(
            clk                 : in std_logic;
            rst                 : in std_logic;
            instruction         : in unsigned(18 downto 0);
            flagNegativeFF_in   : in std_logic;
            flagZeroFF_in       : in std_logic;
            flagOverflowFF_in   : in std_logic;
            PC_wr_en_o          : out std_logic;
            jump_abs_o          : out std_logic;
            jump_rel_o          : out std_logic;
            jump_addr_o         : out unsigned(15 downto 0);
            op_ULA              : out unsigned(2 downto 0);
            wr_addr_o           : out unsigned(2 downto 0);
            rd_addr1_o          : out unsigned(2 downto 0);
            rd_addr2_o          : out unsigned(2 downto 0);
            cte_LD_o            : out unsigned(15 downto 0);
            regs_en_o           : out std_logic;
            acumulador_en_o     : out std_logic;
            flags_en            : out std_logic;
            mov_en_o            : out std_logic;
            cmpi_en_o           : out std_logic;
            ld_en_o             : out std_logic;
            sw_en_o             : out std_logic;
            lw_en_o             : out std_logic;
            cte_ram             : out unsigned(6 downto 0);
            estado              : out unsigned(1 downto 0)
        );
    end component;

    component reg_bank
        port(
            clk             : in std_logic;
            rst             : in std_logic;
            reg_wr_en       : in std_logic;
            selec_reg_wr    : in unsigned(2 downto 0);
            selec_reg_rd1    : in unsigned(2 downto 0);
            selec_reg_rd2  : in unsigned(2 downto 0);
            data_wr         : in unsigned(15 downto 0);
            data_r1         : out unsigned(15 downto 0);
            data_r2       : out unsigned(15 downto 0);
            saida_r0        : out unsigned(15 downto 0);
            saida_r1        : out unsigned(15 downto 0)
        );
    end component;

    component ULA
        port(
            A           : in unsigned(15 downto 0);
            B           : in unsigned(15 downto 0);
            Op          : in unsigned(2 downto 0);
            Result      : out unsigned(15 downto 0);
            Zero        : out std_logic;
            Negative    : out std_logic;
            Overflow    : out std_logic
        );
    end component;

    component reg16bits
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;


    signal ULA_in_A             : unsigned(15 downto 0) := (others => '0');
    signal ULA_in_B             : unsigned(15 downto 0) := (others => '0');

    signal ula_result_s         : unsigned(15 downto 0) := (others => '0');

    signal acumulador_in_s      : unsigned(15 downto 0) := (others => '0');
    signal acumulador_out_s     : unsigned(15 downto 0) := (others => '0');

    -- SINAIS PARA A INSTRUÇÃO

    signal address_instruction  : unsigned(15 downto 0) := (others => '0');     -- ENDEREÇO DA ROM
    signal instruction_s        : unsigned(18 downto 0) := (others => '0');     -- SAÍDA DA ROM
    signal instruction_reg_s    : unsigned(18 downto 0) := (others => '0');     -- SAÍDA DO REGISTRADOR DE INSTRUÇÃO

    -- SINAIS PARA A INSTRUÇÕES DE MEMÓRIA

    signal data_in_ram : unsigned(15 downto 0) := (others => '0');
    signal regAdress_ram : unsigned(6 downto 0) := (others => '0');
    signal endereco_ram : unsigned(6 downto 0) := (others => '0');
    signal sw_en_s   : std_logic := '0';
    signal lw_en_s : std_logic := '0';
    signal data_out_ram : unsigned(15 downto 0) := (others => '0');
    signal cte_ram_s : unsigned(6 downto 0) := (others => '0');

    -- SINAIS PARA A INSTRUÇÃO DE JUMP

    signal jump_abs     : std_logic := '0';
    signal jump_rel     : std_logic := '0';
    signal jump_addr    : unsigned(15 downto 0) := (others => '0');

    -- SINAIS ENABLERS

    signal regs_en_s        : std_logic := '0';
    signal acumulador_en_s  : std_logic := '0';
    signal PC_wr_en_s       : std_logic := '0';
    signal op_ULA_s         : unsigned(2 downto 0) := (others => '0');
    signal flags_en_s       : std_logic := '0';
    signal mov_en_s         : std_logic := '0';
    signal cmpi_en_s        : std_logic := '0';
    signal ld_en_s          : std_logic := '0';

    -- SINAIS PARA AS FLAGS

    signal flagZero_s_in        : std_logic := '0';
    signal flagZero_s_out       : std_logic := '0';

    signal flagNegative_s_in    : std_logic := '0';
    signal flagNegative_s_out   : std_logic := '0';

    signal flagOverflow_s_in    : std_logic := '0';
    signal flagOverflow_s_out   : std_logic := '0';

    -- SINAIS PARA OS ENDEREÇOS NO BANCO DE REGISTRADORES

    signal wr_addr_s : unsigned(2 downto 0) := (others => '0');
    signal rd_addr1_s : unsigned(2 downto 0) := (others => '0');
    signal rd_addr2_s : unsigned(2 downto 0) := (others => '0');

    -- SINAL PARA A CONSTANTE NA INSTRUÇÃO

    signal data_in_regbank_s    : unsigned(15 downto 0) := (others => '0');
    signal cte_LD               : unsigned(15 downto 0) := (others => '0');

    -- DADO DO REGISTRADOR LIDO NO BANCO DE REGISTRADORES

    signal regBank_out1_s   : unsigned(15 downto 0) := (others => '0');
    signal regBank_out2_s   : unsigned(15 downto 0) := (others => '0');
    signal saida_r0_s       : unsigned(15 downto 0) := (others => '0');
    signal saida_r1_s       : unsigned(15 downto 0) := (others => '0');

    -- MAQUINA DE ESTADOS

    signal estado_s : unsigned(1 downto 0) := (others => '0');

begin

    ----------------------------------------------------------- FLAGS ----------------------------------------------------------------

    flagZero_reg: reg1bit
        port map (
            clk => clk,
            rst => rst,
            wr_en => flags_en_s,
            data_in => flagZero_s_in,
            data_out => flagZero_s_out
        );

    flagNegative_reg: reg1bit
        port map (
            clk => clk,
            rst => rst,
            wr_en => flags_en_s,
            data_in => flagNegative_s_in,
            data_out => flagNegative_s_out
        );

    flagOverflow_reg: reg1bit
        port map (
            clk => clk,
            rst => rst,
            wr_en => flags_en_s,
            data_in => flagOverflow_s_in,
            data_out => flagOverflow_s_out
        );

    ----------------------------------------------------------- FLAGS ----------------------------------------------------------------


    ------------------------------------------------------------- PC -----------------------------------------------------------------

    PC_inst: PC_adder
        port map (
            clk         => clk,
            PC_rst      => rst,
            PC_wr_en_i  => PC_wr_en_s,
            jump_abs_i  => jump_abs,
            jump_rel_i  => jump_rel,
            jump_addr_i => jump_addr,
            data_in     => (others => '0'),
            data_out    => address_instruction
        );

    ------------------------------------------------------------- PC -----------------------------------------------------------------


    ------------------------------------------------------------ ROM -----------------------------------------------------------------

    ROM_inst: ROM
        port map (
            clk        => clk,
            endereco   => address_instruction,
            dado       => instruction_s
        );
    
    ------------------------------------------------------------ ROM -----------------------------------------------------------------

    
    ------------------------------------------------------------ RAM -----------------------------------------------------------------

    -- MUX PARA DECIDIR QUAL DADO SERÁ ESCRITO NA RAM (acumulador ou registrador normal)
    data_in_ram <= acumulador_out_s when (rd_addr2_s = "110") else regBank_out2_s;

    -- MUX PARA DECIDIR QUAL ENDEREÇO SERÁ LIDO NA RAM (acumulador ou registrador normal)
    regAdress_ram <= acumulador_out_s(6 downto 0) when (rd_addr1_s = "110") else regBank_out1_s(6 downto 0);

    -- SOMA DO ENDEREÇO DA RAM COM A CONSTANTE
    endereco_ram <= regAdress_ram + cte_ram_s;

    ram_inst: ram
        port map (
            clk      => clk,
            endereco => endereco_ram,
            wr_en    => sw_en_s,
            dado_in  => data_in_ram,
            dado_out => data_out_ram
        );

    ------------------------------------------------------------ RAM -----------------------------------------------------------------


    -------------------------------------------------------- INSTRUCTION -------------------------------------------------------------
    
    instruction_reg_inst: instruction_reg
        port map (
            clk      => clk,
            rst      => rst,
            wr_en    => '1',
            data_in  => instruction_s,
            data_out => instruction_reg_s
        );

    -------------------------------------------------------- INSTRUCTION -------------------------------------------------------------


    ------------------------------------------------------------- UC -----------------------------------------------------------------

    UC_inst: UC
        port map (
            clk                 => clk,
            rst                 => rst,
            instruction         => instruction_reg_s,
            flagNegativeFF_in   => flagNegative_s_out,
            flagZeroFF_in       => flagZero_s_out,
            flagOverflowFF_in   => flagOverflow_s_out,
            PC_wr_en_o          => PC_wr_en_s,
            jump_abs_o          => jump_abs,
            jump_rel_o          => jump_rel,
            jump_addr_o         => jump_addr,
            op_ULA              => op_ULA_s,
            wr_addr_o           => wr_addr_s,
            rd_addr1_o          => rd_addr1_s,
            rd_addr2_o          => rd_addr2_s,
            cte_LD_o            => cte_LD,
            regs_en_o           => regs_en_s,
            acumulador_en_o     => acumulador_en_s,
            flags_en            => flags_en_s,
            mov_en_o            => mov_en_s,
            cmpi_en_o           => cmpi_en_s,
            ld_en_o             => ld_en_s,
            sw_en_o             => sw_en_s,
            lw_en_o             => lw_en_s,
            cte_ram             => cte_ram_s,
            estado              => estado_s
        );

    ------------------------------------------------------------- UC -----------------------------------------------------------------


    -- MUX PARA DECIDIR QUAL DADO SERÁ ESCRITO NO BANCO DE REGISTRADORES
    data_in_regbank_s <= regBank_out1_s     when (mov_en_s = '1' and rd_addr1_s /= "110") else  -- SE A INSTRUÇÃO FOR MOV E NÃO FOR DO ACUMULADOR PARA OUTRO REGISTRADOR (MOV Rn, Rm)
                         acumulador_out_s   when (mov_en_s = '1' and rd_addr1_s = "110")  else  -- SE A INSTRUÇÃO FOR MOV E FOR DO ACUMULADOR PARA OUTRO REGISTRADOR (MOV Rn, A)
                         data_out_ram       when (lw_en_s = '1') else                           -- SE A INSTRUÇÃO FOR LW
                         cte_LD;


    ---------------------------------------------------------- REG_BANK --------------------------------------------------------------

    reg_bank_inst: reg_bank
        port map (
            clk => clk,
            rst => rst,
            reg_wr_en => regs_en_s,
            selec_reg_wr => wr_addr_s,
            selec_reg_rd1 => rd_addr1_s,
            selec_reg_rd2 => rd_addr2_s,
            data_wr => data_in_regbank_s,
            data_r1 => regBank_out1_s,
            data_r2 => regBank_out2_s,
            saida_r0 => saida_r0_s,
            saida_r1 => saida_r1_s
        );
    
    ---------------------------------------------------------- REG_BANK --------------------------------------------------------------

    
    -- GAMBIARRA PARA A COMPARAÇÃO COM A CONSTANTE
    ULA_in_A <= regBank_out1_s  when (cmpi_en_s = '1') else acumulador_out_s;
    ULA_in_B <= acumulador_out_s    when (cmpi_en_s = '1') else regBank_out1_s;
    saida_reg_r0 <= saida_r0_s;
    saida_reg_r1 <= saida_r1_s;
    
    ------------------------------------------------------------- ULA ----------------------------------------------------------------

    ula_inst: ULA
        port map (
            A => ULA_in_A,
            B => ULA_in_B,
            Op => op_ULA_s,
            Result => ula_result_s,
            Zero => flagZero_s_in,
            Negative => flagNegative_s_in,
            Overflow => flagOverflow_s_in
        );

    ------------------------------------------------------------- ULA ----------------------------------------------------------------


    -- MUX PARA DECIDIR QUAL DADO SERÁ ESCRITO NO ACUMULADOR
    acumulador_in_s <= regBank_out1_s   when (mov_en_s = '1' and wr_addr_s = "110") else    -- SE A INSTRUÇÃO FOR MOV E FOR DO REGISTRADOR PARA O ACUMULADOR (MOV A, Rn)
                       cte_LD           when (ld_en_s =  '1' and wr_addr_s = "110") else    -- SE A INSTRUÇÃO FOR LD E FOR PARA O ACUMULADOR (LD A, cte)
                       data_out_ram     when (lw_en_s =  '1' and wr_addr_s = "110") else    -- SE A INSTRUÇÃO FOR LW E FOR PARA INSERIR NO ACUMULADOR (LW A, cte (Rm))
                       ula_result_s;


    --------------------------------------------------------- ACUMULADOR -------------------------------------------------------------

    acumulador_inst: reg16bits
        port map (
            clk => clk,
            rst => rst,
            wr_en => acumulador_en_s,
            data_in => acumulador_in_s,
            data_out => acumulador_out_s
        );

    --------------------------------------------------------- ACUMULADOR -------------------------------------------------------------


    -- SAÍDAS DO PROCESSADOR
    instruction_o <= instruction_reg_s;
    estado_o <= estado_s;
    acumulador_out <= acumulador_out_s;
    regBank_out <= regBank_out1_s;
    result_ula_o <= ula_result_s;
    data_out_PC_o <= address_instruction;

end architecture;
