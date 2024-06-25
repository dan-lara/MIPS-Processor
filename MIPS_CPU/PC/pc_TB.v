`timescale 1ns/100ps

module pc_TB();

	reg reset, clk;
	wire [12:0] Address;
	
	pc DUT(		
		.reset(reset),
		.clk(clk),
		.Address(Address)	
	);

initial begin
	clk = 0;
	reset = 1;
	#20 reset = 0;
	
	#10000 
	
	#700 reset = 1;
	#100 reset = 0;
	
	
	#400	$stop;
end

always #5 clk = ~clk;

endmodule 