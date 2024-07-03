module registerfile 
(
	input [31:0] din,
	input writeEnable,
	input clk, rst,
	input [4:0] rs, rt, rd,
	output reg [31:0] regA, regB
);

	integer i;
	
	reg [31:0] register [0:31]; // Banco de 32 registradores de 32 bits cada.
	
	always @ (negedge clk, posedge rst) begin
	i = 0;
		if(rst)
			for(i = 0; i < 32; i = i+1)  // Resetar cada um dos 16 registradores
				register[i] <= 32'b0;
	
		else if (writeEnable) 
			register[rd] <= din;
	end
	
	
	always @ (posedge clk) begin
			regA <= register[rs];
			regB <= register[rt];
	end

endmodule
