# Multi-Cycle Processor

This project is a multi-cycle processor designed with an accumulator and 6 registers. It was developed as part of a course project for **Computer Architecture**. The processor follows a multi-cycle design approach, where each instruction is executed over several clock cycles. The processor includes key components such as an accumulator and a set of six general-purpose registers, making it suitable for various basic computational tasks.

To test all the functions, we programmed the **Sieve of Eratosthenes** to find the prime numbers up to 32.

## Authors
- [Ricardo Affonso](https://github.com/RicardoAffonso0607)
- [Felipe Costa](https://github.com/FelipecSanto)

## Features

- **Accumulator-based architecture**: The processor uses an accumulator to hold intermediate data and results.
- **6 General-purpose Registers**: The design includes 6 registers to hold temporary data during computations.
- **Multi-cycle Execution**: Each instruction is processed over multiple clock cycles for better control and efficiency.
- **Simple Instruction Set**: The microprocessor supports a set of basic instructions for arithmetic, logic, and control operations.
- **Clock-controlled design**: The microprocessor operates under a clock-driven control unit that dictates the cycle-by-cycle execution.
- **Instruction Set**: A basic set of instructions like ADD, SUB, MOV, etc., that can be executed. They are all listed in the "instructions.xlsx" file.

## Getting Started

To get started with the project, follow these steps:

1. Please make sure to have Make (or follow the commands in the Makefile), GHDL, and GTKWAVE installed.
   
3. Clone this repository to your local machine:
    ```bash
    git clone https://github.com/RicardoAffonso0607/Processor.git
    ```
4. Navigate into the project directory:
    ```bash
    cd Processor
    ```

## Project Structure

/Processor <br>
  ├── UC.vhd                 # VHDL code for the control unit <br>
  ├── ULA.vhd                # VHDL code for the ALU <br>
  ├── reg_bank.vhd           # Registers bank <br>
  ├── PC.vhd                 # Special register to iterate over the instructions inside ROM <br>
  ├── ROM.vhd                # Contain the instruction set (It's the program memory) <br>
  ├── ram.vhd                # It's the data memory <br>
  ├── maquina_estados.vhd    # The state machine to control the multi-cycle processing <br>
  ├── processor.vhd          # Top-level processor module  <br>
  └── processor_tb.vhd       # Testbench for the processor <br>
  
## Instructions

- The processor executes instructions in a multi-cycle manner. Each instruction involves several stages:
  1. **Fetch**: The instruction is fetched from ROM.
  2. **Decode**: The instruction is decoded to determine the operation and operands.
  3. **Execute**: The operation is performed.

## Simulation and Testing

1. Compile the VHDL files:
   ```bash
    make
    ```
3. Run the testbench for simulation:
    ```bash
    make run
    ```
4. If it goes wrong, run this in the console and try again:
   ```bash
    unset GTK_PATH
    ```
5. When the program oppens, select the **Three Bars -> Time -> Zoom -> Zoom Full** to see the processor executing the Sieve of Eratosthenes.
6. Don't forget to add the outputs! You can see the operations, the state, the components working and in **saida_reg_r0**, the prime numbers.

## Other Files

- Assembly.txt -> Contains the code inside the ROM in Assembly format
- instructions.xlsx -> It's a guide to all the instructions programmed

## Acknowledgements

- This project was developed as part of the **Computer Architecture** course.
- Special thanks to the course instructor and peers for feedback and support.

## Original Repository

[Click here!](https://github.com/FelipecSanto/uProcessador_ArqComp)
