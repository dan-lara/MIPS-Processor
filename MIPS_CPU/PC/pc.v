module pc(
	input reset, clk,
	output reg [31:0] Address
);
	
	always @ (posedge clk or posedge reset) begin									
		// Se ocorrer borda de subida do Reset, o contador volta para zero
		if (reset) 
			Address = 32'h940; //Reseta para o endereço Grupo 4 * 0x250 = 0x940
		else 
			Address = Address + 32'b1; //Contagem Incremental
	end
endmodule

// Grupo 4 //
// Address 0:		 4 * 0x250 			 = 0x940
// Address 1023:	 0x940 + 0x400 - 1 = 0xD3F
