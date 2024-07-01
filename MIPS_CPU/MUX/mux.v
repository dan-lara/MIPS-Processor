module mux (
	input [31:0] EntradaA,EntradaB,
	input SEL,
	output reg [31:0] Saida
);

	always @(EntradaA, EntradaB, SEL) begin
		if(SEL)
			Saida <= EntradaA;
		else
			Saida <= EntradaB;
	end
endmodule 