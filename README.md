# Projeto MIPS RISC em FPGA

## Descrição

Este projeto envolve a implementação de uma arquitetura RISC baseada em CPUs MIPS em FPGA, utilizando uma família Cyclone IV GX. O instruction set é modificado de acordo com as especificações de cada grupo, e a arquitetura é implementada com uma word de 32 bits e estrutura pipeline.

## Objetivo

O objetivo deste projeto é desenvolver e testar uma CPU baseada em MIPS com um conjunto de instruções personalizado, utilizando uma abordagem hierárquica. Cada módulo é criado e testado individualmente, e depois integrado para formar a CPU completa.

## Características Principais

- Arquitetura de 32 bits
- Implementação em pipeline com estágios: Instruction Fetch, Instruction Decode, Execute, Memory e Write Back
- Memória de programa e dados com 1kWord cada, alocadas em endereços específicos
- Testes realizados em nível de gate com simulação em FPGA

## Componentes Principais

- **DataMemory**: Módulo de memória de dados
- **InstructionMemory**: Módulo de memória de instruções
- **ALU**: Unidade Lógica e Aritmética
- **Control**: Unidade de controle da CPU
- **RegisterFile**: Banco de registradores
- **Multiplicador**: Módulo de multiplicação
- **MUX, PC, Adder, Counter**: Outros módulos de suporte

## TestBench

O TestBench da CPU executa a expressão matemática `(B-A) * (C-D)` com valores predefinidos para A, B, C e D, salvando o resultado na última posição da memória de dados interna.
