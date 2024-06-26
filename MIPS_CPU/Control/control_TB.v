`timescale 1ns/100ps
module control_TB();

	// Sinais para simulação
	reg  [31:0] instrucao;
	wire [23:0] controle;
	
	// Device Under Test
	control DUT 
	(
		.instrucao(instrucao),
		.controle(controle)
	);
	
	
	// Simulação dos sinais de controle para cada uma das instruções.
	initial begin
		$monitor("Time = %0t : Instrucao = %b, Controle = %b", $time, instrucao, controle);
		// Formato i:
		    instrucao = 32'b000101_00000_00001_0100_0001_0000_0000; 	  //LW
		#10 instrucao = 32'b000110_00000_00001_0000_0000_0000_0000; //SW
		
		
		// Formato R:
		#10 instrucao = 32'b000100_00001_00010_00101_01010_110010;  //MUL
		#10 instrucao = 32'b001110_00011_00100_00110_01010_100000;  //ADD
		#10 instrucao = 32'b001110_00101_00110_00111_01010_100010;  //SUB
		#10 $stop;
	end
	
endmodule
