module extend (
	input  [15:0] Entrada,
	input Enable,
	output reg [31:0] Saida	
);

	always @(*) begin
		Saida = 32'd0;
		if(Enable) begin
			if(Entrada[15])
				Saida = {16'b1111111111111111, Entrada[15:0]};
			else
				Saida = {16'd0, Entrada[15:0]};
		end
	end	
endmodule	