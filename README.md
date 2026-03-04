# MIPS RISC Project on FPGA

## Description
This project involves the implementation of a RISC architecture based on MIPS CPUs on FPGA, using a Cyclone IV GX family. The instruction set is modified according to each group's specifications, and the architecture is implemented with a 32-bit word and a pipeline structure.

## Objective
The goal of this project is to develop and test a MIPS-based CPU with a custom instruction set, using a hierarchical approach. Each module is created and tested individually, then integrated to form the complete CPU.

## Key Features
- 32-bit architecture
- Pipeline implementation with stages: Instruction Fetch, Instruction Decode, Execute, Memory, and Write Back
- Program and data memory with 1kWord each, allocated at specific addresses
- Tests performed at gate level with FPGA simulation

## Main Components
- **DataMemory**: Data memory module
- **InstructionMemory**: Instruction memory module
- **ALU**: Arithmetic and Logic Unit
- **Control**: CPU control unit
- **RegisterFile**: Register bank
- **Multiplier**: Multiplication module
- **MUX, PC, Adder, Counter**: Other support modules

## TestBench
The CPU TestBench executes the mathematical expression `(B-A) * (C-D)` with predefined values for A, B, C, and D, saving the result in the last position of the internal data memory.
