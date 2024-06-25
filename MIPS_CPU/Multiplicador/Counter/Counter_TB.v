`timescale 1ns/100ps
module Counter_TB();

	reg Load, Clk;
	wire K;
	
	reg [5:0] i;

	Counter DUT (
		.Load(Load),
		.Clk(Clk),
		.K(K)
	);
	 
	
	always #5 Clk = ~ Clk;
	
	
	initial begin
		Clk = 0;
		Load = 1;
		#20;
		Load = 0;
		
	end
	
	initial #800 $stop;
	initial $init_signal_spy("DUT/Counter/i", "i", 1); 

	 
endmodule
