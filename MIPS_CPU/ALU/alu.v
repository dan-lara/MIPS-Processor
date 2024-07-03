module alu( 
	input 	  [31:0] EntradaA, EntradaB,
	input 	  [1:0] OP,
	output reg [31:0] Saida
);

	always @(*) begin
		case(OP)
			2'b00: Saida <= EntradaA + EntradaB; // Operação de soma
			2'b01: Saida <= EntradaA - EntradaB;	// Operação de subtração
			2'b10: Saida <= EntradaA & EntradaB; // Operação de AND
			2'b11: Saida <= EntradaA | EntradaB; // Operação de OR
		endcase
	end

endmodule
