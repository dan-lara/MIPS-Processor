module Counter(
	input Load, Clk,
	output reg K
);
   reg [5:0] i;

	always @(posedge Clk, posedge Load) begin
		if (Load) begin
			K <= 0;
			i <= 6'b0;
		end
		else if (i == 29) 
			K <= 1;
		else
			i <= i + 1;
	end
endmodule
