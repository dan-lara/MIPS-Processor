`timescale 1ns/100ps

module Adder_TB();

	reg [15:0] OperandoA, OperandoB;
	wire [16:0] Soma;

	Adder DUT (
		.OperandoA(OperandoA), 
		.OperandoB(OperandoB), 
		.Soma(Soma)
	);

	initial begin
		OperandoA = 0;
		OperandoB = 0;
		#10;
		
		OperandoA = 16'h0001;
		OperandoB = 16'h0001;
		#10;

		OperandoA = 16'hFFFF;
		OperandoB = 16'h0001;
		#10;

		OperandoA = 16'hFFFF;
		OperandoB = 16'hFFFF;
		#10;

		OperandoA = 16'h8000;
		OperandoB = 16'h8000;
		#100;

		$stop;
	
	end



endmodule
