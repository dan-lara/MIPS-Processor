`timescale 1ns/10ps

module datamemory_TB();

	parameter data_WIDTH = 32;
	parameter ADDR_WIDTH = 10;
	//--------------Input Ports-----------------------
	reg [ADDR_WIDTH-1:0] address;
	reg we;
	reg clk;
	reg [data_WIDTH-1:0] dataIn;
	wire [data_WIDTH-1:0] dataOut;
	integer k = 0;
	
	datamemory DUT(
		.ADDR(address),  
		.WR_RD(we), 
		.clk(clk),
		.din(dataIn), 
		.dout(dataOut)
	);

	initial begin
		clk=0;
		we = 0;
		address = 10'd0;
		#50 address = 10'd1;
		#50 address = 10'd2;
		#50 address = 10'd3;
		#50 $stop;
	end

	always begin
		#10 clk = ~clk;
	end

endmodule
