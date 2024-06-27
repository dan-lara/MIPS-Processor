module pc (
	input reset, clk,
	output reg [31:0] Address
);
	
	always @(posedge clk or posedge reset)begin 
		if(reset)
			Address = 9'h940; //Reseta para o endereço Grupo 4 * 0x250 = 0x940
		else
			Address = Address + 9'b1; //Contagem Incremental
	end	
endmodule

//module pc 
//(
//	input Reset, clk,
//	output reg [9:0] Pc
//);
//	
//	always @ (posedge clk or posedge Reset) begin									
//		// Se ocorrer borda de subida do Reset, o contador volta para zero
//		if (Reset) 
//			Pc = 9'b0;
//		else 
//			Pc = Pc + 9'b1; // Soma uma unidade a cada borda de subida de clock
//	end
//endmodule

// Grupo 4 //
// Address 0:		 4 * 0x250 			 = 0x940
// Address 1023:	 0x940 + 0x400 - 1 = 0xD3F
