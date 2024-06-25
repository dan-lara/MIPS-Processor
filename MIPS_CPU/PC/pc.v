module pc (
	input reset, clk,
	output reg [12:0] Address
);
	
	always @(posedge clk or posedge reset)begin 
		if(reset)begin
			Address <= 12'b1001_0100_0000; //Reseta para o endereço Grupo 4 * 0x250 = 0x940
		end
		else if(Address<12'b1101_0011_1111) begin
			Address <= Address + 1'b1; //Contagem Incremental
		end
		else begin
			Address <= 12'b1001_0100_0000; //Reseta para o endereço Grupo 4 * 0x250 = 0x940
		end	
	end	
endmodule


// Grupo 4 //
// Address 0:		 4 * 0x250 			 = 0x940
// Address 1023:	 0x940 + 0x400 - 1 = 0xD3F
