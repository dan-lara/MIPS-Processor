/* 

	Respostas das perguntas:
	a) Qual a latência do sistema?
		
		A latência do sistema é de 5 ciclos de clock, pois a arquitetura MIPS tem 5 estágios no pipeline.

		
	b) Qual o throughput do sistema?
			
		O throughput do sistema é de 1 instrução por ciclo de clock. Isso significa que, quando o pipeline está cheio, cada instrução é concluída a cada ciclo de clock.

	
	c) Qual a máxima frequência operacional entregue pelo Time Quest Timing 
		Analizer para o multiplicador e para o sistema? (Indique a FPGA utilizada)
		
		
		A FPGA utilizada foi a Cyclone IV GX - EP4CGX150DFF31I7AD.
		Para as análises de pior cenário, utilizou-se a opção "Slow 1200mV 100C Model".
		A frequência máxima operacional para o multiplicador é de 314,07 MHz, 
		enquanto a frequência máxima operacional para o sistema (sem o multiplicador) é de ??.
		
	d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)
		
		FPGA utilizada: Cyclone IV GX - EP4CGX150DFF31I7AD (última)
			
		A máxima frequência de operação do sistema MIPS total (com multiplicador) é dada pela 
		máxima frequência reportada pelo TimeQuest para o multiplicador dividido pela quantidade 
		de pulsos de clock necessários para que o multiplicador processe os operando e entregue o 
		produto. Essa quantidade de pulsos de clock é dado por 2N+2, no qual N é o número de bits 
		dos operandos do multiplicador, assim 2*16+2 = 34 pulsos de clock. Portanto:

		Frequência máxima de operação do sistema = 314,07 MHz / 34 = 9,237 MHz

		
	e) Com a arquitetura implementada, a expressão (A*B) – (C+D) é executada corretamente 
		(se executada em sequência ininterrupta)? Por quê? O que pode ser feito para que a 
		expressão seja calculada corretamente?
	
		A expressão não será executada corretamente se for executada de forma contínua. Isso ocorre porque, durante a execução das instruções matemáticas,
		os operandos não estarão disponíveis no RegisterFile devido à arquitetura MIPS, causando os chamados Pipeline Hazards. 
		Uma solução para esse problema é inserir instruções sem impacto no algoritmo (bolhas) antes das instruções onde podem ocorrer Pipeline Hazards. 
		Dessa forma, é possível atrasar a instrução para que os operandos sejam armazenados e estejam disponíveis no RegisterFile a tempo, evitando o problema. 
		Outra solução é implementar uma máquina de estados no módulo de controle que possa prever e resolver os Pipeline Hazards, 
		mas isso aumentaria a complexidade, a área e o consumo de energia do circuito.
						
				
	 f) Analisando a sua implementação de dois domínios de clock diferentes, haverá 
		 problemas com metaestabilidade? Por que?
 	
		 Apesar da utilização de dois domínios de clock diferentes, o sistema não terá problemas com metaestabilidade, desde que o controle de fase entre os dois domínios seja bem gerenciado. 
		 É essencial entender a relação entre ambos os clocks. Sendo determinístico, as análises temporais podem ser feitas de modo que sejam atendidas para ambos os domínios de clock. 
		 O Time Quest Timing Analyzer foi utilizado para resolver a questão da metaestabilidade tanto para o MIPS quanto para o multiplicador separadamente, garantindo que as restrições temporais sejam cumpridas.
		 Essa abordagem garante que os problemas de metaestabilidade sejam evitados, considerando que a análise determinística e as restrições temporais são adequadamente gerenciadas para ambos os domínios de clock.
	
	
	 g) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido, 
		 é eficiente em termos de velocidade? Por que?
	
		A aplicação de um multiplicador de deslocamento e soma no sistema MIPS não é eficiente 
		em termos de velocidade. Isso se deve à alta latência do multiplicador, que necessita de 34 ciclos de clock 
		para realizar uma multiplicação, resultando em uma redução significativa na frequência máxima do sistema MIPS. 
		Conforme informações anteriores, a frequência máxima de operação do sistema, 
		que era de ?? MHz, caiu para 9,237 MHz ao incluir o multiplicador.

		 
	 h) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema 
		 mais rápido (frequência de operação maior). Para cada modificação sugerida, qual 
	    a nova latência e throughput do sistema?
	 
		Sabemos que o multiplicador utilizado no sistema possui uma latência alta e necessita de 34 pulsos de clock para finalizar uma multiplicação, 
		o que reduz a máxima frequência de operação do sistema (MIPS + multiplicador). Uma modificação viável seria segmentar o terceiro estágio do pipeline (Execute) 
		em 34 subestágios, aumentando o total de estágios do pipeline do sistema para 38. Essa modificação não afetaria o throughput do sistema e permitiria aumentar a 
		máxima frequência de operação, pois não seria necessário dividir o clock do sistema por 34, utilizando assim um único clock com frequência de operação maior. 
		Com essa modificação, o throughput continuaria sendo de uma instrução por ciclo de clock, mas a latência aumentaria para 38 ciclos de clock, 
		o que exigiria uma maior complexidade no circuito e, consequentemente, um custo mais elevado. 
		Além disso, essa modificação exigiria a mudança da arquitetura de pipeline enrolado do multiplicador para pipeline desenrolado.

		Outra possível modificação seria substituir o multiplicador atual por um com menor latência e maior frequência máxima de operação. 
		Mesmo que ainda fosse necessário utilizar dois clocks, a frequência 
		máxima de operação do sistema seria proporcionalmente maior. 
		O throughput continuaria sendo de uma instrução por ciclo de clock, 
		e a latência do MIPS permaneceria em 5 ciclos de clock.

*/
module cpu 
(
	input  CLK_SYS, RST, 
	inout  [31:0] Data_BUS_READ,
	inout  [31:0] Prog_BUS_READ,
	output [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog,
	output CS, WR_RD, CS_P
);
 
	//(*keep=1*) wire CLK_SYS, CLK_MUL;
	(*keep=1*) wire [31:0] writeBack;
	wire [31:0] fio_Address;
	wire [31:0] fio_produto_saida, fio_A, fio_B, fio_instruction, fio_D_saida,
	fio_M_entrada, fio_reg_cs, fio_memoria, fio_D_entrada, fio_Alu, fio_mux_alu_entrada, fio_imm,
	fio_ctrl1, fio_ctrl2, fio_ctrl3, fio_ctrl4, fio_offset_ext, addressCorrigido, addressCorrigidoInst,
	fio_mux_DataMemory, fio_saida_mux_inst;
	
	assign addressCorrigido = ADDR - 32'hD40; // Correção do endereço que chega no DataMemory
	assign addressCorrigidoInst = ADDR_Prog - 32'h940; // Correção do endereço que chega no InstructionMemory
	
	
	// Descrição estrutural do MIPS:
	
	// PLL (Divisão do clock)
	// O CLK_MUL deve ser 34 vezes mais rápido do que o CLK_SYS.
//	PLL PLL
//	( 
//		.areset(RST),
//		.inclk0(CLK),
//		.c0(CLK_MUL), // CLK / 1
//		.c1(CLK_SYS)  // CLK / 34
//	);

	// Primeiro estagio - (Instruction Fetch)
	instructionmemory ProgramMemory
	(
		.address(addressCorrigidoInst),
		.clk(CLK_SYS),
		.dataOut(fio_instruction)
	);
	//assign CLK_SYS = CLK;
	assign ADDR_Prog = fio_Address;
	
	pc PC   
	(
		.reset(RST),
		.clk(CLK_SYS),
		.Address(fio_Address)
	);
	
	ADDRDecoding_Prog ADDRDecoding_Prog  
	(
		.ADDR(fio_Address),
		.CS(CS_P)
	);
	
	mux MUX_SAIDA_Instruction 
	(
		.EntradaA(Prog_BUS_READ),
		.EntradaB(fio_instruction),
		.SEL(CS_P),
		.Saida(fio_saida_mux_inst)
	);

	// Segundo estagio - (Instruction Decode)  
	registerfile RegisterFile  
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

	control Control  
	(
		.instrucao(fio_saida_mux_inst),  
		.controle(fio_ctrl1)
	);

	extend Extend  
	(
		.Entrada(fio_saida_mux_inst[15:0]),
		.Saida(fio_offset_ext),
		.Enable(fio_ctrl1[20])
	);

	Register IMM  
	(
		.rst(RST), 
		.clk(CLK_SYS),
		.Entrada(fio_offset_ext),      
		.Saida(fio_imm)	
	);

	Register CRTL1  
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada({8'b0,fio_ctrl1}),      
		.Saida(fio_ctrl2)	
	);

	// Terceiro estagio - Execute  
	mux MUX_ALU_Entrada  
	(
		.EntradaA(fio_imm),
		.EntradaB(fio_B),
		.SEL(fio_ctrl2[19]),
		.Saida(fio_mux_alu_entrada)
	);

	Register CRTL2  
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_ctrl2),      
		.Saida(fio_ctrl3)	
	);

	alu ALU  
	(
		.EntradaA(fio_A),
		.EntradaB(fio_mux_alu_entrada),
		.OP(fio_ctrl2[22:21]),
		.Saida(fio_Alu)
	);

	mux MUX_ALU_Saida  
	(
		.EntradaA(fio_Alu),
		.EntradaB(fio_produto_saida),
		.SEL(fio_ctrl2[18]),
		.Saida(fio_D_entrada)
	);
	//assign fio_produto_saida = 32'b0;
	Multiplicador MULT  
	(
		.St(fio_ctrl2[15]), 
		.Clk(CLK_MUL), 
		.Reset(RST),
		.Produto(fio_produto_saida),
		.Multiplicador(fio_A),
		.Multiplicando(fio_B)
	);

	Register D  
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_D_entrada),      
		.Saida(ADDR)	
	);

	Register Reg_B2  
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_B),      
		.Saida(Data_BUS_WRITE)	
	);

	// Quarto estagio - (Memory)  
	assign WR_RD = fio_ctrl3[16]; 
		
	datamemory DataMemory  
	(
		.address(addressCorrigido[9:0]),
		.dataIn(Data_BUS_WRITE),
		.we(fio_ctrl3[16]),
		.clk(CLK_SYS),
		.dataOut(fio_memoria)
	);

	mux Saida_DataMemory
	(
		.EntradaA(fio_memoria),
		.EntradaB(Data_BUS_READ),
		.SEL(fio_reg_cs),
		.Saida(fio_mux_DataMemory)
	);


	ADDRDecoding ADDRDecoding
	(
		.ADDR(ADDR),
		.CS(CS)
	);

	Register Reg_CS
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(CS),      
		.Saida(fio_reg_cs)	
	);

	Register D2
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(ADDR),      
		.Saida(fio_D_saida)	
	);

	Register CRTL3
	(
		.rst(RST),
		.clk(CLK_SYS),
		.Entrada(fio_ctrl3),      
		.Saida(fio_ctrl4)	
	);

	// Quinto estagio - (Write Back)
	mux MUX_WB
	(
		.EntradaA(fio_mux_DataMemory),
		.EntradaB(fio_D_saida),
		.SEL(fio_ctrl4[17]),
		.Saida(writeBack)
	);

endmodule
