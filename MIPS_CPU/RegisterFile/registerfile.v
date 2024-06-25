module registerfile (
//----------Input-----------
	input [31:0] din,
	input writeBack,
	input clk, rst,
	input [4:0] rs, rt, rd,
//----------Output-----------
	output reg [31:0] regA,regB
);
//--------Internal-----------------
	integer k;
	reg [31:0] register [31:0];
	
// resetar todos os registros e em seguida efetua a leitura, caso writeBack = 1;
	always @ (posedge clk, posedge rst) begin
		k = 0;
		if(rst)
			for(k=0; k<32; k=k+1)
				register[k] = 32'b0;
		else if (writeBack)
			register[rd] <= din;
	end

// mantém as saidas A e B com o conteudo dos registros selecionados
// os registros A e B da hierarquia, estao embutidos aqui
	always @ (posedge clk) begin
		regA <= register[rs];
		regB <= register[rt];
	end
endmodule
