# Multi-Cycle Microprocessor with Accumulator and 6 Registers

This project is a multi-cycle microprocessor designed with an accumulator and 6 registers. It was developed as part of a course project for **Computer Architecture and Organization**. The microprocessor follows a multi-cycle design approach, where each instruction is executed over several clock cycles. The microprocessor includes key components such as an accumulator and a set of six general-purpose registers, making it suitable for various basic computational tasks.

## Features

- **Accumulator-based architecture**: The microprocessor uses an accumulator to hold intermediate data and results.
- **6 General-purpose Registers**: The design includes 6 registers to hold temporary data during computations.
- **Multi-cycle Execution**: Each instruction is processed over multiple clock cycles for better control and efficiency.
- **Simple Instruction Set**: The microprocessor supports a set of basic instructions for arithmetic, logic, and control operations.
- **Clock-controlled design**: The microprocessor operates under a clock-driven control unit that dictates the cycle-by-cycle execution.

## Project Components

- **Accumulator**: Holds data that is being processed, such as intermediate results.
- **Registers (R0-R5)**: A set of 6 registers for data storage and manipulation.
- **Control Unit**: A finite state machine that controls the sequencing of instruction execution over multiple cycles.
- **ALU (Arithmetic Logic Unit)**: Performs arithmetic and logical operations on data.
- **Instruction Set**: A basic set of instructions like ADD, SUB, MOV, etc., that can be executed by the microprocessor.

## Getting Started

To get started with the project, follow these steps:

1. Please make sure to have Make (or follow the commands in the Makefile), GHDL, and GTKWAVE installed.
   
3. Clone this repository to your local machine:
    ```bash
    [git clone https://github.com/RicardoAffonso0607/Processor.git
    ```
4. Navigate into the project directory:
    ```bash
    cd Processor
    ```

## Project Structure

/processor <br>
  ├── control_unit.v # Verilog code for the control unit <br>
  ├── alu.v # Verilog code for the ALU <br>
  ├── registers.v # Verilog code for the registers <br>
  ├── processor.v # Top-level microprocessor module  <br>
  └── processor_tb.v # Testbench for the microprocessor <br>
  
## Instructions

- The processor executes instructions in a multi-cycle manner. Each instruction involves several stages:
  1. **Fetch**: The instruction is fetched from memory.
  2. **Decode**: The instruction is decoded to determine the operation and operands.
  3. **Execute**: The operation is performed.
  4. **Memory Access**: Data is read/written from/to memory if required.
  5. **Write Back**: Results are written back to registers or memory.

## Simulation and Testing

1. Compile the Verilog files.
2. Run the testbench for simulation:
    ```bash
    vcom tests/processor_tb.v
    vsim work.processor_tb
    run -all
    ```
3. If it goes wrong, run this in the console and try again:
   ```bash
    unset GTK_PATH
    ```

## Acknowledgements

- This project was developed as part of the **Computer Architecture** course.
- Special thanks to the course instructor and peers for feedback and support.
