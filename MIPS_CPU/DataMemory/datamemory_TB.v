`timescale 1ns/100ps
module datamemory_TB();
	parameter DATA_WIDTH = 32;
	parameter ADDR_WIDTH = 10;

	//	Sinais para simulação
	reg [ADDR_WIDTH-1:0] address;
	reg we;
	reg clk;
	reg [DATA_WIDTH-1:0] dataIn;
	wire [DATA_WIDTH-1:0] dataOut;
	integer k = 0;
	
	// Sinal de clock
	always #10 clk = ~clk;
	
	// Device Under Test
	datamemory DUT(
		.address(address), 
		.we(we), 
		.clk(clk),
		.dataIn(dataIn), 
		.dataOut(dataOut)
	);
	
	
	initial begin
		
		clk = 0;
		we = 1;
		address = 9'b0;
		dataIn = 32'b0;
		
		for (k=0; k < 10; k = k + 1) 
		begin
			#20 address = k;
		end
		
		we = 0;
		address = 9'b0;
		dataIn = 32'b0;
		we = 0;
		
		for (k=0; k < 1024; k = k + 1) 
		begin
			#20 address = k;
		end
		
	end

	
	initial #2300 $stop;

endmodule
