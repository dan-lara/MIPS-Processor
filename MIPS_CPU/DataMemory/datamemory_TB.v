`timescale 1ns/100ps
module datamemory_TB();
	parameter DATA_WIDTH = 32;
	parameter ADDR_WIDTH = 10;

	reg [ADDR_WIDTH-1:0] address;
	reg WR_RD;
	reg clk;
	reg [DATA_WIDTH-1:0] dataIn;
	wire [DATA_WIDTH-1:0] dataOut;
	integer k = 0;
	
	// Sinal de clock
	always #10 clk = ~clk;
	
	// Device Under Test
	datamemory DUT(
		.address(address), 
		.WR_RD(WR_RD), 
		.clk(clk),
		.dataIn(dataIn), 
		.dataOut(dataOut)
	);
	
	
	initial begin
		
		clk = 0;
		WR_RD = 1;
		address = 10'b0;
		dataIn = 32'b0;
		
		for (k=0; k < 10; k = k + 1) 
		begin
			#20 address = k;
		end
		
		WR_RD = 0;
		address = 10'b0;
		dataIn = 32'd35;
		WR_RD = 0;
		
		for (k=0; k < 5; k = k + 1) 
		begin
			dataIn = dataIn * 3;
			#20 address = k;
		end
		
		WR_RD = 1;
		address = 10'b0;
		dataIn = 32'b0;
		
		for (k=0; k < 6; k = k + 1) 
		begin
			#20 address = k;
		end
		
	end

	
	initial #2300 $stop;

endmodule
