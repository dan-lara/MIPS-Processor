module Counter(
	input Load, Clk,
	output reg K
);
    reg [5:0] i;

	always @(posedge Clk, posedge Load) begin
		if (Load) begin
				i = 0; // Reinicia o contador se Load estiver alto
				K = 1'b0;
			end
		else if (i != 6'b01_1110) begin
				i = i + 1; // Incrementa o contador se Load estiver baixo e K não estiver no valor máximo
				K = (i == 6'b01_1110) ? 1 : 0;
			end
		else K = 1;
	end
endmodule
