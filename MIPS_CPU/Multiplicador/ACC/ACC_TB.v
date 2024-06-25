`timescale 1ns/100ps

module ACC_TB();

	reg Load, Sh, Ad, Clk;
	reg [32:0] Entradas; 
	wire [32:0] Saidas;		

	ACC DUT(
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad),
		.Clk(Clk),
		.Entradas(Entradas),
		.Saidas(Saidas)
	);
	
	always #5 Clk = ~Clk;	

	initial begin
		Clk = 0;	Load = 0; Sh = 0; Ad = 0; Entradas = 0;
		#10 Load = 1; Entradas = 7;
		#10 Load = 0; Sh = 1;
		#10 Sh = 0; Ad = 1; Entradas = 496;
		#10 Ad = 0;
		#10 Load = 1; Entradas = 15;
		#10 Load = 0;
		#10 Sh = 1;
		#10 Sh = 0;
		#10 Ad = 1; Entradas = 496;
		#10 Ad = 0;
		#10 $stop;
		
		
	end
	
endmodule
