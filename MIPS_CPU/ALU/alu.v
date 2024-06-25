module alu (
	input 	  [31:0] EntradaA, EntradaB,
	input 	  [1:0] OP,
	output reg [31:0] Saida
);

	always @(*)begin
		case(OP)
			0: Saida <= EntradaA + EntradaB;
			1: Saida <= EntradaA - EntradaB;
			2: Saida <= EntradaA & EntradaB;
			3: Saida <= EntradaA | EntradaB;
		endcase
	end

endmodule	