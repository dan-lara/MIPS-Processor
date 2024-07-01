`timescale 1ns/100ps
module ADDRDecoding_Prog_TB();

	// Sinais para simulação
	wire CS;
	reg [31:0] ADDR;
	integer i;
	
	// Device Under Test
	ADDRDecoding_Prog DUT
	(
		.CS(CS),
		.ADDR(ADDR)
	);
	
	// Teste para verificar o valor de CS para o intervalode 0000h até FFFFh.
	initial begin
		for(i = 32'h920; i <= 32'hDFF; i = i + 1)
			#20 ADDR = i;				
	end
	
endmodule 