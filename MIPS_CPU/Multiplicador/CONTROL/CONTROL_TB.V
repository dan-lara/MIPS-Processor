`timescale 1ns/100ps
module CONTROL_TB();
	reg Clk, K, St, M, Reset;
	wire Idle, Done, Load, Sh, Ad;
	
	reg [1:0] state;

	CONTROL DUT(
	  .Clk(Clk),
	  .K(K),
	  .St(St),
	  .M(M),
	  .Reset(Reset),
	  .Idle(Idle),
	  .Done(Done),
	  .Load(Load),
	  .Sh(Sh),
	  .Ad(Ad)
	);   

	initial begin
		Clk = 0;
		Reset = 1;
		St = 0;
		K = 0;
		M = 0;
		
		#20 Reset = 0;
		St = 0;
		K = 0;
		M = 0;
	
		#20 St = 1;
		K = 0;
		M = 0;
	
		#20 St = 0;
		K = 0;
		M = 1;
		
		#20 St = 0;
		K = 0;
		M = 1;
		
		#20 St = 0;
		K = 0;
		M = 0;
		
		#20 St = 0;
		K = 0;
		M = 1;
		
		#20 St = 0;
		K = 1;
		M = 0;
	
		#40 St = 1;
		K = 0;
		M = 0;
	end

	initial #240 $stop;

	always #10 Clk = ~Clk;
	initial $init_signal_spy("DUT/CONTROL/state", "state", 1);
endmodule
