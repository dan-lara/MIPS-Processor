module cpu 
(
	input  CLK, RST, 
	inout  [31:0] Data_BUS_READ,
	inout  [31:0] Prog_BUS_READ,
	output [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog
	output CS, WR_RD, CS_P
);

/* 

	Respostas das perguntas:

	a) Qual a latência do sistema?
		
		A latência do sistema é de 5 pulsos de clock, ou seja, cada instrução precisa
		de 5 pulsos de clock para ser executada, uma vez que a arquitetura MIPS possui 
		5 estágios de pipeline.

		
	b) Qual o throughput do sistema?
			
		O Throughput do sistema é de 1 instrução por ciclo de clock, ou seja, uma vez que
		o pipeline está cheio, cada instrução termina de ser executada em um pulso de clock.

	
	c) Qual a máxima frequência operacional entregue pelo Time Quest Timing 
		Analizer para o multiplicador e para o sistema? (Indique a FPGA utilizada)
		
		FPGA utilizada: Cyclone IV GX - EP4CGX150DFF31I7AD (última)		
		Foi utilizado a opção "Slow 1200mV 100C Model" para realizar análises (pior cenário).
		Frequência máxima operacional para o Multiplicador: 314,47 MHz
		Frequência máxima operacional para o Sistema (sem o multiplicador): 67,09 MHz
		
		Observação: As análises pelo Time Quest Timing Analizer foram realizadas
		em projetos separados, como recomendado pelo FAQ.
		
	d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)
		
		FPGA utilizada: Cyclone IV GX - EP4CGX150DFF31I7AD (última)
			
		A máxima frequência de operação do sistema MIPS total (com multiplicador) é dada pela 
		máxima frequência reportada pelo TimeQuest para o multiplicador dividido pela quantidade 
		de pulsos de clock necessários para que o multiplicador processe os operando e entregue o 
		produto. Essa quantidade de pulsos de clock é dado por 2N+2, no qual N é o número de bits 
		dos operandos do multiplicador, assim 2*16+2 = 34 pulsos de clock. Portanto:

		Frequência máxima de operação do sistema = 314,47 MHz / 34 = 9,24 MHz

		
	e) Com a arquitetura implementada, a expressão (A*B) – (C+D) é executada corretamente 
		(se executada em sequência ininterrupta)? Por quê? O que pode ser feito para que a 
		expressão seja calculada corretamente?
	
		A expressão NÃO será executada corretamente se executada em sequência de forma ininterrupta. 
		Isso ocorre porque no momento da execução das instruções matemáticas, os operandos não estarão 
		disponíveis no RegisterFile devido a arquitetura do MIPS, provocando os chamados Pipelines Hazzards. 
		Uma solução para resolver esse problema é utilizar instruções sem impacto no algoritmo (Bolhas) antes 
		de instruções em que podem ocorrer Pipelines Hazzards, dessa forma é possível atrasar a instrução, para 
		que os operandos sejam armazenados e estejam disponíveis no RegisterFile a tempo, assim evitando a ocorrência 
		deste problema. Outra solução é implementar no módulo "Controle" uma máquina de estados que conseguiria 
		prever e resolver os Pipelines Hazzards, entretanto isso aumentaria a complexidade, a área e a potência do circuito.
						
				
	 f) Analisando a sua implementação de dois domínios de clock diferentes, haverá 
		 problemas com metaestabilidade? Por que?
 	
		 Apesar da utilização de dois domínios de clock diferentes, o sistema não haverá problemas com metaestabilidade, 
		 uma vez que os pulsos de clock necessários para realizar a multiplicação se encaixam dentro de um período de clock 
		 do sistema MIPS, além de ambos clocks não estarem defasados entre si, ou seja, possuem zero graus de defasagem, 
		 algo que é garantido devido a utilização da PLL. É importante ressaltar que o Time Quest Timing Analyzer foi 
		 utilizado para resolver a questão da metaestabilidade para o MIPS e para o multiplicador separadamente.
	
	
	 g) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido, 
		 é eficiente em termos de velocidade? Por que?
	
		 A aplicação desse multiplicador desloca e soma no sistema MIPS não é eficiente em termos de velocidade. O motivo disso 
		 é pelo fato do multiplicador possuir uma latência muito alta, de 34 pulsos de clock para realizar uma multiplicação, isso 
		 tem como consequência uma redução brusca na máxima frequência do sistema MIPS. Isso pode ser visto pelas informações 
		 obtidas anteriormente, a frequência máxima de operação do sistema de 67,09 MHz caiu para 9,24 MHz ao aplicar o multiplicador.

		 
	 h) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema 
		 mais rápido (frequência de operação maior). Para cada modificação sugerida, qual 
	    a nova latência e throughput do sistema?
	 
		Sabemos que o multiplicador utilizado no sistema possui uma latência alta e necessita de 34 pulsos de clock para finalizar 
		uma multiplicação, isso tem como consequência uma redução na máxima frequência de operação do sistema (MIPS + multiplicador). 
		Uma modificação cabível seria segmentar o terceiro estágio de pipeline (Execute) em 34 subestágios, fazendo com que a arquitetura 
		do sistema possua 38 estágios de pipeline no total. Essa modificação não afetaria o Throughput do sistema e aumentaria a máxima 
		frequência de operação, visto que não seria necessário dividir o clock do sistema por 34 como anteriormente, utilizando assim um 
		único clock com frequência de operação maior. Para a modificação sugerida, como já citado, o Throughput será mantido em uma instrução 
		por clock, entretanto, a latência sofreria um acréscimo para 38 pulsos de clock, o que demandaria uma maior complexidade do circuito 
		e consequentemente um custo mais elevado. É importante ressaltar também que para realizar essa modificação seria necessário alterar 
		a arquitetura de pipeline enrolado do multiplicador para pipeline desenrolado.

		Outra modificação possível, seria substituir o multiplicador que está sendo utilizado por um outro com latência menor e 
		maior frequência máxima de operação, assim ainda que necessário a utilização de dois clocks, a frequência de operação máxima 
		do sistema seria proporcionalmente maior. O Throughput permaneceria como 1 instrução de clock e a latência do MIPS permaneceria 
		em 5 pulsos de clock.

*/
 
	(*keep=1*) wire CLK_SYS, CLK_MUL;
	(*keep=1*) wire [31:0] writeBack;
	wire [11:0] fio_Address;
	wire [31:0] fio_produto_saida, fio_A, fio_B, fio_instruction, fio_D_saida,
	fio_M_entrada, fio_reg_cs, fio_memoria, fio_D_entrada, fio_Alu, fio_mux_alu_entrada, fio_imm,
	fio_ctrl1, fio_ctrl2, fio_ctrl3, fio_ctrl4, fio_offset_ext, addressCorrigido, addressCorrigidoInst,
	fio_mux_DataMemory, fio_saida_mux_inst;
	
	assign addressCorrigido = ADDR - 32'hD40; // Correção do endereço que chega no DataMemory
	assign addressCorrigidoInst = ADDR - 32'h940; // Correção do endereço que chega no InstructionMemory
	
	
	// Descrição estrutural do MIPS:
	
	// PLL (Divisão do clock)
	// O CLK_MUL deve ser 34 vezes mais rápido do que o CLK_SYS.
	PLL PLL
	( 
		.areset(RST),
		.inclk0(CLK),
		.c0(CLK_MUL), // CLK / 1
		.c1(CLK_SYS)  // CLK / 34
	);

	// Primeiro estagio - (Instruction Fetch)
	instructionmemory ProgramMemory //OK
	(
		.address(addressCorrigidoInst),
		.clk(CLK_SYS),
		.dataOut(fio_instruction)
	);
	assign ADDR_Prog = fio_Address;
	pc PC  //OK
	(
		.reset(RST),
		.clk(CLK_SYS),
		.Address(fio_Address)
	);
	
	ADDRDecoding_Prog ADDRDecoding_Prog //OK
	(
		.ADDR(fio_Address),
		.CS(CS_P)
	);
	
	mux MUX_SAIDA_Instruction 
	(
		.EntradaA(fio_instruction),
		.EntradaB(Prog_BUS_READ),
		.SEL(CS_P),
		.Saida(fio_saida_mux_inst)
	);

	// Segundo estagio - (Instruction Decode) //OK
	registerfile RegisterFile //OK
	(
		.din(writeBack),
		.writeEnable(fio_ctrl4[23]),
		.clk(CLK_SYS),
		.rst(RST),
		.rs(fio_ctrl1[14:10]),
		.rt(fio_ctrl1[9:5]),
		.rd(fio_ctrl4[4:0]),
		.regA(fio_A),
		.regB(fio_B)
	);	

	control Control //OK
	(
		.instrucao(fio_saida_mux_inst),  
		.controle(fio_ctrl1)
	);

	extend Extend //OK
	(
		.Entrada(fio_saida_mux_inst[15:0]),
		.Saida(fio_offset_ext),
		.Enable(fio_ctrl1[20])
	);

	Register IMM //OK
	(
		.rst(RST), 
		.clk(CLK_SYS),
		.Entrada(fio_offset_ext),      
		.Saida(fio_imm)	
	);

	Register CRTL1 //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada({8'b0,fio_ctrl1}),      
		.Saida(fio_ctrl2)	
	);

	// Terceiro estagio - Execute //OK
	mux MUX_ALU_Entrada //OK
	(
		.EntradaA(fio_imm),
		.EntradaB(fio_B),
		.SEL(fio_ctrl2[19]),
		.Saida(fio_mux_alu_entrada)
	);

	Register CRTL2 //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_ctrl2),      
		.Saida(fio_ctrl3)	
	);

	alu ALU //OK
	(
		.EntradaA(fio_A),
		.EntradaB(fio_mux_alu_entrada),
		.OP(fio_ctrl2[22:21]),
		.Saida(fio_Alu)
	);

	mux MUX_ALU_Saida //OK
	(
		.EntradaA(fio_Alu),
		.EntradaB(fio_produto_saida),
		.SEL(fio_ctrl2[18]),
		.Saida(fio_D_entrada)
	);
	
	Multiplicador MULT //OK
	(
		.St(fio_ctrl2[15]), 
		.Clk(CLK_MUL), 
		.Reset(RST),
		.Produto(fio_produto_saida),
		.Multiplicador(fio_A),
		.Multiplicando(fio_B)
	);

	Register D //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_D_entrada),      
		.Saida(ADDR)	
	);

	Register Reg_B2 //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_B),      
		.Saida(Data_BUS_WRITE)	
	);

	// Quarto estagio - (Memory) //OK
	assign WR_RD = fio_ctrl3[16]; 
		
	datamemory DataMemory //OK
	(
		.address(addressCorrigido[9:0]),
		.dataIn(Data_BUS_WRITE),
		.we(fio_ctrl3[16]),
		.clk(CLK_SYS),
		.dataOut(fio_memoria)
	);

	mux Saida_DataMemory //OK
	(
		.EntradaA(fio_memoria),
		.EntradaB(Data_BUS_READ),
		.SEL(fio_reg_cs),
		.Saida(fio_mux_DataMemory)
	);


	ADDRDecoding ADDRDecoding //OK
	(
		.ADDR(ADDR),
		.CS(CS)
	);

	Register Reg_CS //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(CS),      
		.Saida(fio_reg_cs)	
	);

	Register D2 //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(ADDR),      
		.Saida(fio_D_saida)	
	);

	Register CRTL3 //OK
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_ctrl3),      
		.Saida(fio_ctrl4)	
	);

	// Quinto estagio - (Write Back) //OK
	mux MUX_WB //OK
	(
		.EntradaA(fio_mux_DataMemory),
		.EntradaB(fio_D_saida),
		.SEL(fio_ctrl4[17]),
		.Saida(writeBack)
	);

endmodule
