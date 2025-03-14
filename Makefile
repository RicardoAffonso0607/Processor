# Nome do executável de simulação
TESTBENCH = processador_tb

# Arquivos VHDL
VHDL_FILES = \
	ULA.vhd ULA_tb.vhd \
	reg16bits.vhd reg16bits_tb.vhd \
	reg_bank.vhd reg_bank_tb.vhd \
	ROM.vhd ROM_tb.vhd \
	reg1bit.vhd reg1bit_tb.vhd \
	PC.vhd PC_tb.vhd \
	PC_adder.vhd PC_adder_tb.vhd \
	maquina_estados.vhd maquina_estados_tb.vhd \
	UC.vhd UC_tb.vhd \
	instruction_reg.vhd \
	ram.vhd \
	processador.vhd processador_tb.vhd

# Arquivo de dump de simulação
GHW_FILE = $(TESTBENCH).ghw

# Comando GHDL
GHDL = ghdl

# Comando GTKWave
GTKWAVE = gtkwave

# Flags de compilação
GHDL_FLAGS = --std=08

# Regra padrão
all: $(TESTBENCH)

# Regra para compilar e elaborar
$(TESTBENCH): $(VHDL_FILES)
	$(GHDL) -a ULA.vhd
	$(GHDL) -e ULA
#	$(GHDL) -a ULA_tb.vhd
#	$(GHDL) -e ULA_tb
	$(GHDL) -a reg16bits.vhd
	$(GHDL) -e reg16bits
#	$(GHDL) -a reg16bits_tb.vhd
#	$(GHDL) -e reg16bits_tb
	$(GHDL) -a reg_bank.vhd
	$(GHDL) -e reg_bank
#	$(GHDL) -a reg_bank_tb.vhd
#	$(GHDL) -e reg_bank_tb
	$(GHDL) -a ROM.vhd
	$(GHDL) -e ROM
#	$(GHDL) -a ROM_tb.vhd
#	$(GHDL) -e ROM_tb
	$(GHDL) -a reg1bit.vhd
	$(GHDL) -e reg1bit
#	$(GHDL) -a reg1bit_tb.vhd
#	$(GHDL) -e reg1bit_tb
	$(GHDL) -a PC.vhd
	$(GHDL) -e PC
#	$(GHDL) -a PC_tb.vhd
#	$(GHDL) -e PC_tb
	$(GHDL) -a PC_adder.vhd
	$(GHDL) -e PC_adder
#	$(GHDL) -a PC_adder_tb.vhd
#	$(GHDL) -e PC_adder_tb
	$(GHDL) -a maquina_estados.vhd
	$(GHDL) -e maquina_estados
#	$(GHDL) -a maquina_estados_tb.vhd
#	$(GHDL) -e maquina_estados_tb
	$(GHDL) -a UC.vhd
	$(GHDL) -e UC
#	$(GHDL) -a UC_tb.vhd
#	$(GHDL) -e UC_tb
	$(GHDL) -a instruction_reg.vhd
	$(GHDL) -e instruction_reg
	$(GHDL) -a ram.vhd
	$(GHDL) -e ram
	$(GHDL) -a processador.vhd
	$(GHDL) -e processador
	$(GHDL) -a processador_tb.vhd
	$(GHDL) -e processador_tb



# Regra para executar a simulação e gerar o arquivo GHW
run: $(TESTBENCH)
	$(GHDL) -r $(TESTBENCH) --wave=$(GHW_FILE)
	$(GTKWAVE) $(GHW_FILE)

# Regra para limpar os arquivos gerados
clean:
	@if [ -f work-obj*.cf ]; then rm -f work-obj*.cf; fi
	@if [ -f $(GHW_FILE) ]; then rm -f *.ghw; fi
	@if exist work-obj*.cf del /Q work-obj*.cf
	@if exist $(GHW_FILE) del /Q $(GHW_FILE)


.PHONY: all run clean