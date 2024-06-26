module datamemory 
#(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
)
(
	input [ADDR_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] dataIn,
	input we,
	input clk,
	output [DATA_WIDTH-1:0] dataOut
);

	reg [DATA_WIDTH-1:0] memoria [0:(1<<ADDR_WIDTH)-1];

	reg [ADDR_WIDTH-1:0] reg_address;

	// Alguns valores iniciais para testar o MIPS
	initial  begin
		memoria[0] = 2001;
		memoria[1] = 4001;
		memoria[2] = 5001;
		memoria[3] = 3001;
	end

	always @(posedge clk) begin
		if(~we)
			memoria[address] <= dataIn;  // Escrita
		
		reg_address <= address;
	end

	assign dataOut = memoria[reg_address];

endmodule
