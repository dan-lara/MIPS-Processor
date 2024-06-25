`timescale 1ns/100ps

module Multiplicador_TB();

	reg St, Clk;
	reg [15:0]Multiplicando;
	reg [15:0]Multiplicador;
	wire Idle, Done; 
	wire [31:0]Produto;
	


	//Multiplicador(Idle, Done, Produto, St, Clk, Multiplicador, Multiplicando);
	Multiplicador DUT (
		.St(St),
		.Clk(Clk),
		.Multiplicando(Multiplicando),
		.Multiplicador(Multiplicador),
		.Idle(Idle),
		.Done(Done),
		.Produto(Produto)
	);
	
	
	always #5 Clk = ~Clk;		

	initial begin
		Clk = 0;
		Multiplicando = 0;
		Multiplicador = 0;
		St = 0;

		#330;

		Multiplicando = 16'b0011;
		Multiplicador = 16'b0010;
		St = 1;
		#330;
		St = 0;

		#330;

		Multiplicando = 16'b0101;
		Multiplicador = 16'b0011;
		St = 1;
		#330;
		St = 0;

		#330;

		Multiplicando = 16'hFFFF;
		Multiplicador = 16'hFFFF;
		St = 1;
		#330;
		St = 0;

		#500;

		$stop;
	end
	

endmodule 