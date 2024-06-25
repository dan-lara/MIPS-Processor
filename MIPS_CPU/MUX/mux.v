module mux (
	input [31:0] EntradaA,EntradaB,
	input SEL,
	output reg [31:0] Saida
);

	always @(*)begin
		if(SEL)begin
			Saida <= EntradaA;
		end
		else begin
			Saida <= EntradaB;
		end 
	end

endmodule 