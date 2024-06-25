module ADDRDecoding(
	input [31:0] Address,
	output reg CS //CS = 0 memoria interna; = 1 memoria externa 
);
	reg [31:0] Lower, Upper;
	
	//Memoria interna 0xD40 a 0x113f
	
	always @(*)begin
		Lower <= 32'hD40; //Lower Limit 0xD40 = 0x350* grupo
		Upper <= 32'h113F; //Upper Limit 0x113f = 0xD40 + 0x400 - 1
		if(Address >= Lower)begin
			if(Address <= Upper)begin
				CS = 1'b0;
			end
			else begin
				CS = 1'b1;
			end
		end
		else begin
			CS = 1'b1;
		end
	end
endmodule	