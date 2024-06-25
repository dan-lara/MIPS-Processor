module extend (
	input  [15:0] Entrada,
	output reg [31:0] Saida,
	input Enable
);

	always @(*)begin
		Saida <= 32'd0;
		if(Enable) begin
			if(Entrada[15])begin
				Saida <= {16'd65535,Entrada[15:0]};//Preenche os 16 MSB com 1's
			end
			else begin
				Saida <= {16'd0,Entrada[15:0]};//Preenche os 16 MSB com 0's
			end
		end
	end
	
endmodule	