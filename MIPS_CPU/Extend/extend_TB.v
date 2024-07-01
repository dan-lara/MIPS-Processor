`timescale 1ns/100ps

module extend_TB ();

	reg [15:0] Entrada;
	reg Enable;
	wire [31:0] Saida;
	
	extend DUT (
	.Entrada(Entrada),
	.Saida(Saida),
	.Enable(Enable)
	);
	
	initial begin
		Enable = 1;
		Entrada = 16'b1000000000000000;
		#50 Entrada = 16'b0111111111111111;
		#50 Enable = 0;
		Entrada = 16'b1011000000000000;
		#50 $stop;
	end	
endmodule
