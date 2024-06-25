`timescale 1ns/100ps

module alu_TB();

	reg  [31:0] EntradaA, EntradaB;
	reg  [1:0] Operation;
	wire [31:0] Saida;	
	
	alu DUT(
		.EntradaA(EntradaA),
		.EntradaB(EntradaB),
		.OP(Operation),
		.Saida(Saida)
	);
	
	initial begin
		EntradaA = 32'd2001;
		EntradaB = 32'd4001;
		Operation = 2'b00;
		#50 Operation = 2'b01;
		#50 Operation = 2'b10;
		#50 Operation = 2'b11;
		
		#50
		EntradaA = 32'd4294967295;
		EntradaB = 32'd1;
		Operation = 2'b00;
		#50 Operation = 2'b01;
		#50 Operation = 2'b10;
		#50 Operation = 2'b11;
		
		
		
		#50 $stop;
	end
endmodule