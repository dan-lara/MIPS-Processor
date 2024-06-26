`timescale 1ns/100ps
module 	();

	// Sinais para simulação
	reg  [31:0] Instrucao;
	wire [23:0] Controle;
	
	// Device Under Test
	control DUT 
	(
		.Instrucao(Instrucao),
		.Controle(Controle)
	);
	
	
	// Simulação dos sinais de controle para cada uma das instruções.
	initial begin
	
		// Formato i:
		Instrucao = 32'b001111_00000_00001_0100_0001_0000_0000; 	  //LW
		#10 Instrucao = 32'b010000_00000_00001_0000_0000_0000_0000; //SW
		
		
		// Formato R:
		#10 Instrucao = 32'b001110_00001_00010_00101_01010_110010;  //MUL
		#10 Instrucao = 32'b001110_00011_00100_00110_01010_100000;  //ADD
		#10 Instrucao = 32'b001110_00101_00110_00111_01010_100010;  //SUB
		#10 $stop;
	end
	
endmodule
