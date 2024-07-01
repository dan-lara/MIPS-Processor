`timescale 1ns/100ps
module ADDRDecoding_TB();

	// Sinais para simulação
	wire CS;
	reg [31:0] ADDR;
	integer i;
	
	// Device Under Test
	ADDRDecoding DUT
	(
		.CS(CS),
		.ADDR(ADDR)
	);
	
	// Teste para verificar o valor de CS para o intervalode 0000h até FFFFh.
	initial begin
		for(i = 32'hD00; i <= 16'h115F; i = i + 1)
			#20 ADDR = i;				
	end
	
endmodule 