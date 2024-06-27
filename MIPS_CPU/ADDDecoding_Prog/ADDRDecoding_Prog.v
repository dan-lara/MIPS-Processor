module ADDRDecoding_Prog(
    input [31:0] ADDR,
    output CS
);
	assign CS = (ADDR >= 32'h940) && (ADDR <= 32'hD3F) ? 0 : 1;
endmodule
