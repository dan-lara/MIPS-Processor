module ADDRDecoding_Prog(
    input [31:0] ADDR,
    output CS
);
	assign CS = (ADDR >= 32'h00000940) && (ADDR <= 32'h00000D3F) ? 0 : 1;
endmodule
