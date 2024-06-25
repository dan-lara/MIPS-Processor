`timescale 1ns/100ps

module registerfile_TB();
	
reg [31:0] din;
reg writeBack;
reg clk, rst;
reg [4:0] rs, rt, rd;
wire [31:0] regA, regB;


registerfile DUT(
	.din(din),  
	.writeBack(writeBack), 
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
		
		#20 writeBack = 1;
		din = 2001;
		rd = 1;
		
		#20 din = 4001;
		rd = 2;
		
		#20 din = 8002;
		rd = 6;
		
		#20 din = 3002;
		rd = 8;
		
		#20 writeBack = 0;
		rs = 1;
		rt = 2;
		
		#20 
		rs = 6;
		rt = 8;
		
		#20 rst = 1;
		
		#50 $stop; 
	end
		
	always #5 clk = ~clk;

endmodule 