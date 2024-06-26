`timescale 1ns/100ps
module instructionmemory_TB();
parameter data_WIDTH = 32;
parameter ADDR_WIDTH = 10;
//--------------Input Ports-----------------------
reg [ADDR_WIDTH-1:0] address;
reg clk;
wire [data_WIDTH-1:0] dataOut;
integer k = 0;

instructionmemory DUT(
	.address(address),  
	.clk(clk), 
	.dataOut(dataOut)
);

initial begin
	clk = 0;
	address = 10'b0;	
	#10
	
	for (k=0; k < 30; k = k + 1) 
	begin
		#100 address = k;
	end
	
end

initial #4000 $stop;

always begin
     #50 clk = ~clk;
end
 
endmodule
