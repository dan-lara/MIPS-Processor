`timescale 1ns/100ps

module ADDRDecoding_TB();

	wire CS;
	reg [31:0] ADDR;
	
	integer i;
	
	ADDRDecoding DUT(
		.CS(CS),
		.Address(ADDR)
	);
	
	initial begin
		for(i = 16'hD30; i <= 16'h1150; i = i + 1)
		#20 ADDR = i;				
	end
	initial begin
		#30000 $stop;
	end
	
endmodule 