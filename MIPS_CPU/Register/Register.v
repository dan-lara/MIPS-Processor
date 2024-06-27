module Register(//Registro Simples de 32bits
	input rst, clk,
	input [31:0] Entrada,      
	output reg  [31:0] Saida	
);
	
	always @(posedge clk or posedge rst)begin
		if(rst)
			Saida <= 0;
		else
			Saida <= Entrada;
	end

endmodule
//
	