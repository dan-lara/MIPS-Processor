module datamemory 
#(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
)
(
	input [ADDR_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] dataIn,
	input WR_RD,
	input clk,
	output [DATA_WIDTH-1:0] dataOut
);

	reg [DATA_WIDTH-1:0] memoria [0:(1<<ADDR_WIDTH)-1];

	reg [ADDR_WIDTH-1:0] reg_address;

	
	initial  begin
		memoria[0] = 32'd2001;
		memoria[1] = 32'd4001;
		memoria[2] = 32'd5001;
		memoria[3] = 32'd3001;
	end

	always @(posedge clk) begin
		if(~WR_RD)
			memoria[address] <= dataIn;
		
		reg_address <= address;
	end

	assign dataOut = memoria[reg_address];

endmodule
