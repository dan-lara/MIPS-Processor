`timescale 1ns/100ps

module registerfile_TB();
	
reg [31:0] din;
reg writeEnable;
reg clk, rst;
reg [4:0] rs, rt, rd;
wire [31:0] regA, regB;


registerfile DUT(
	.din(din),  
	.writeEnable(writeEnable), 
	.clk(clk),
	.rst(rst),
	.rs(rs),
	.rt(rt),
	.rd(rd),
	.regA(regA),
	.regB(regB)
);

	initial begin
		clk = 0;
		rst = 0;
		rs = 10;
		rt = 11;
		
		#2 writeEnable = 1;
		
		// Salvar o dado 1234 no registrador 1
		#10 din = 1234;
		rd = 1;
		
		// Salvar o dado 6666 no registrador 2
		#10 din = 6666;
		rd = 2;
		
		// Salvar o dado 7777 no registrador 10
		#10 din = 7777;
		rd = 10;
		
		// Salvar o dado 2021 no registrador 11
		#10 din = 2021;
		rd = 11;
		
		// Leitura dos registradores 1 e 2
		#10 writeEnable = 0;
		din = 2022;
		rs = 1;
		rt = 2;
		
		// Leitura dos registradores 10 e 11
		#10
		rs = 10;
		rt = 11;
		
		#20 rst = 1;
		
		#10 $stop; 
	end
		
	always #5 clk = ~clk;

endmodule 