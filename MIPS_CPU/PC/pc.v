module pc (
	input reset, clk,
	output reg [11:0] Address
);
	
	always @(posedge clk or posedge reset)begin 
		if(reset)
			Address <= 12'b1001_0100_0000; //Reseta para o endereço Grupo 4 * 0x250 = 0x940
		else
			Address <= Address + 12'b1; //Contagem Incremental
	end	
endmodule


// Grupo 4 //
// Address 0:		 4 * 0x250 			 = 0x940
// Address 1023:	 0x940 + 0x400 - 1 = 0xD3F
