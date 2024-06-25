module Multiplicador(
	input [15:0] Multiplicando,
	input [15:0] Multiplicador,
	input St, Clk,
	
	output Idle, Done,
	output [31:0] Produto
	
);
	//module Multiplicador(Idle, Done, Produto, St, Clk, Multiplicador, Multiplicando);
		
	wire Load, Sh, Ad, K;
	wire [16:0] Soma;
	wire [32:0] out;

	assign Produto = out[31:0];
	
	//module Counter (input Load, Clk,output K);
	Counter Counter (
		.Load(Load), 
		.Clk(Clk), 
		.K(K)
	);
	//module CONTROL (input Clk, K, St, M,	output Idle, Done, Load, Sh, Ad);
	CONTROL CONTROL (
		.Clk(Clk), 
		.K(K), 
		.St(St), 
		.M(Produto[0]), 
		.Idle(Idle), 
		.Done(Done), 
		.Load(Load), 
		.Sh(Sh), 
		.Ad(Ad)
	);
	//module Adder (input [15:0] OperandoA, OperandoB, output [16:0] Soma);
	Adder Adder (
		.OperandoA(Multiplicando),
		.OperandoB(out[31:16]), 
		.Soma(Soma)
	);
	//module ACC (input Load, Sh, Ad, Clk, input [32:0] Entradas, output [32:0] Saidas);
	ACC ACC (
		.Load(Load), 
		.Sh(Sh), 
		.Ad(Ad), 
		.Clk(Clk), 
		.Entradas({Soma, Multiplicador}), 
		.Saidas(out)
	);
	
	
endmodule