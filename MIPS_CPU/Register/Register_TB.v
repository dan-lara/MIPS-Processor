`timescale 1ns/100ps

module Register_TB();

reg rst, clk;
reg [31:0] Entrada;
wire [31:0] Saida;
	
integer i;
	
Register DUT(
	.rst(rst),
	.clk(clk),
	.Entrada(Entrada),
	.Saida(Saida)
);
	
	
initial 
begin
	clk = 0;
	rst = 1;	
	#10 rst = 0;
		
	for(i = 0; i < 15; i = i + 1) 
	begin	
		#10 Entrada = i;
	end

	#100 $stop;
end
	
always #5 clk = ~clk;
	
endmodule