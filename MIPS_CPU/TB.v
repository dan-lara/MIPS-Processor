`timescale 1ns/100ps
module TB();
	
	reg CLK, RST;
	
	reg  [31:0] writeBack;
	reg [31:0] Data_BUS_READ, Prog_BUS_READ;

	wire CS, WR_RD;
	wire [31:0] ADDR, Data_BUS_WRITE, ADDR_Prog;
	
	//module cpu(input CLK, RST, input [31:0] Data_BUS_READ, Prog_BUS_READ, output [31:0] Data_BUS_WRITE, ADDR, ADDR_Prog, output CS, CS_P, WR_RD);
	cpu DUT 
	(
		.CLK(CLK), .RST(RST),
		.Data_BUS_READ(Data_BUS_READ), .Prog_BUS_READ(Prog_BUS_READ),
		.Data_BUS_WRITE(Data_BUS_WRITE), .ADDR(ADDR), .ADDR_Prog(ADDR_Prog),
		.CS(CS), .CS_P(CS_P), .WR_RD(WR_RD)
	);
	
	// Sinal de clock
	
	always #50 CLK = ~CLK;
	
	initial begin
		$init_signal_spy("DUT/writeBack","writeBack",1);
		Data_BUS_READ = 32'b0;
		Prog_BUS_READ = 32'b0;
		
		CLK = 0;
		RST = 1;
		#100 RST = 0;	
	end
	
	
	initial #10000 $stop;
		
	
endmodule 

