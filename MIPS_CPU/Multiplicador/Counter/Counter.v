module Counter(
	input Load, Clk,
	output reg K
);
    reg [2:0] i;

	always @(posedge Clk, posedge Load) begin
		if (Load) begin
				i = 3'b000; // Reinicia o contador se Load estiver alto
				K = 0;
			end
		else if (i != 3'b111) begin
				i = i + 1; // Incrementa o contador se Load estiver baixo e K não estiver no valor máximo
				K = (i == 3'b111) ? 1 : 0;
			end
		else K = 1;
	end
endmodule
