`timescale 1ns/100ps
module CONTROL_TB();
	reg Clk, K, St, M;
	wire Idle, Done, Load, Sh, Ad;
	
	reg [1:0] state;

	CONTROL DUT(
	  .Clk(Clk),
	  .K(K),
	  .St(St),
	  .M(M),
	  .Idle(Idle),
	  .Done(Done),
	  .Load(Load),
	  .Sh(Sh),
	  .Ad(Ad)
	);   

	initial begin
	  Clk = 0;
	  St = 0;
	  K = 0;
	  M = 0;
	  #10 ;
	  
	  #10 St = 1;
	  
	  #10 St = 0;
	  M = 1;
	  #10 M = 0;
	  
	  #20 K = 1; M = 0;
	  #10 K = 0; St = 0;
	  #25 $stop;
	end

	initial #1000 $stop;

	always #5 Clk = ~Clk;
	initial $init_signal_spy("DUT/CONTROL/state", "state", 1);
endmodule
