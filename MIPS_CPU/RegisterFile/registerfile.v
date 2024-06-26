module registerfile (
//----------Input-----------
	input [31:0] din,
	input writeEnable,
	input clk, rst,
	input [4:0] rs, rt, rd,
//----------Output-----------
	output reg [31:0] regA,regB
);
//--------Internal-----------------
	integer k;
	reg [31:0] register [31:0]; //32 Registradores de 32 bits cada
	
	always @ (posedge clk, posedge rst) begin
		k = 0;
		if(rst)
			for(k=0; k<32; k=k+1)
				register[k] = 32'b0;
		else if (writeEnable)
			register[rd] <= din;
	end

	always @ (posedge clk) begin
		regA <= register[rs];
		regB <= register[rt];
	end
endmodule
