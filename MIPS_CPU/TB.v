`timescale 1ns/100ps
module TB();
	
	reg CLK;
	reg CLK_SYS, CLK_MUL;
	reg RST;
	wire [31:0] ADDR, Data_BUS_WRITE;
	reg  [31:0] writeBack;
	wire [31:0] Data_BUS_READ;

	wire CS, WR_RD;
	
	cpu DUT 
	(
		.CLK(CLK),
		.RST(RST),
		.Data_BUS_READ(Data_BUS_READ),
		.Prog_BUS_READ(Prog_BUS_READ),
		.ADDR(ADDR), 
		.Data_BUS_WRITE(Data_BUS_WRITE),
		.ADDR_Prog(ADDR_Prog),
		.CS(CS),
		.WR_RD(WR_RD),
		.CS_P(CS_P)
	);
	
	// Sinal de clock
	
	always #10 CLK = ~CLK; // Perído de 20ns -> 50 MHz
	
	// CLK_SYS = 50 MHz / 34 = 1.47 MHz < 9.24 MHz
	// CLK_MUL = 50 MHz < 314.47 MHz
	// O sistema irá funcionar com o clock do testbench rodado em GateLevel.
	
	initial begin
		$init_signal_spy("DUT/CLK_SYS","CLK_SYS",1);
		$init_signal_spy("DUT/CLK_MUL","CLK_MUL",1);
		$init_signal_spy("DUT/writeBack","writeBack",1);		
		
		CLK = 0;
		RST = 1;
		#100 RST = 0;	
	end
	
	
	initial #23000 $stop;
		
	
endmodule 

