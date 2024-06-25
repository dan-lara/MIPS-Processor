`timescale 1ns/100ps

module mux_TB();

	reg [31:0] EntradaA,EntradaB;
	reg SEL;
	wire [31:0] Saida;
	
	mux DUT (
	.EntradaA(EntradaA),
	.EntradaB(EntradaB),
	.SEL(SEL),
	.Saida(Saida)
	);
	
	initial begin
		SEL = 0;
		EntradaA = 1;
		EntradaB = 2;
		
		#25 SEL = 1;
		
		#20 SEL = 0;
		
		#60 $stop;
	end

endmodule 
