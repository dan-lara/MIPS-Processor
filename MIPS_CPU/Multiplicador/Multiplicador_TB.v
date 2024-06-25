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
	
	
	integer n, j;
	
	initial begin
		for (n=0; n<3; n=n+1)
		begin
			Clk = 0;
			St = 0;
			Multiplicando = 0;
			Multiplicador = 0;
			
			#10 Clk = 1;
			St = 0;
			Multiplicando = 0;
			Multiplicador = 0;
			
			for (j=0; j<2; j = j+1)
				begin
					case (n)
					0:
					begin
						#10 Clk = j;
						St = 1;
						Multiplicando = 0;
						Multiplicador = 16'hFFFF;
					end
					
					1:
					begin
						#10 Clk = j;
						St = 1;
						Multiplicando = 2;
						Multiplicador = 10;
					end
					
					2:
					begin
						#10 Clk = j;
						St = 1;
						Multiplicando = 15;
						Multiplicador = 15;
					end					
					
					endcase
				
				end
			
			
			while (Done != 1)
			begin
				for (j=0; j<2; j = j+1)
				begin
					case (n)
					0:
					begin
						#10 Clk = j;
						St = 1;
						Multiplicando = 0;
						Multiplicador = 16'hFFFF;
					end
					
					1:
					begin
						#10 Clk = j;
						St = 0;
						Multiplicando = 2;
						Multiplicador = 10;
					end
					
					2:
					begin
						#10 Clk = j;
						St = 0;
						Multiplicando = 15;
						Multiplicador = 15;
					end					
					
					endcase
				
				end			
			
			end
			
		end
				
	end
	

endmodule 