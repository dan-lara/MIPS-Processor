module ADDRDecoding(
    input [31:0] ADDR,
    output CS
);
	assign CS = (ADDR >= 32'h00000D40) && (ADDR <= 32'h0000113F) ? 0 : 1;
endmodule
