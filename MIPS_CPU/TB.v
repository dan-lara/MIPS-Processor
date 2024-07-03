`timescale 1ns/100ps
module TB();
	
	reg CLK, RST;
	reg CLK_SYS, CLK_MUL;
	
	reg  [31:0] writeBack;
	reg [31:0] Data_BUS_READ, Prog_BUS_READ;

	wire CS, WR_RD, CS_P;
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
	
	always #20 CLK = ~CLK; // Perído de 20ns -> 50 MHz
	
	// CLK_SYS = 50 MHz / 34 = 1.47 MHz < 9.24 MHz
	// CLK_MUL = 50 MHz < 314.47 MHz
	
	initial begin
		$init_signal_spy("DUT/writeBack","writeBack",1);
		$init_signal_spy("DUT/CLK_SYS","CLK_SYS",1);
		$init_signal_spy("DUT/CLK_MUL","CLK_MUL",1);
		
		Data_BUS_READ = 32'b0;
		Prog_BUS_READ = 32'b0;
		
		CLK = 0;
		RST = 1;
		#100 RST = 0;	
	end
	
	
	initial #50000 $stop;
		
	
endmodule 

