module instructionmemory 
#(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
)
(
	input [ADDR_WIDTH-1:0] address,
	input clk,
	output reg [DATA_WIDTH-1:0] dataOut
);

	reg [DATA_WIDTH-1:0] memoria [0:(1<<ADDR_WIDTH)-1];

	initial begin
	
		// COM PIPELINE HAZZARD	
		memoria[0] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A em R0 // {(Grupo+1), rs, rt, offset}
		memoria[1] <= 32'b000101_01111_00001_0000_1101_0100_0001; // Load B em R1 // {(Grupo+1), rs, rt, offset}
		memoria[2] <= 32'b000101_01111_00010_0000_1101_0100_0010; // Load C em R2 // {(Grupo+1), rs, rt, offset}
		memoria[3] <= 32'b000101_01111_00011_0000_1101_0100_0011; // Load D em R3 // {(Grupo+1), rs, rt, offset}
		
		memoria[4] <= 32'b000100_00001_00000_00100_01010_100010;  // SUB B-A em R4 // {Grupo, ts, rt, rd, 10, 34}	
		memoria[5] <= 32'b000100_00010_00011_00101_01010_100010;  // SUB C-D em R5	// {Grupo, ts, rt, rd, 10, 34}	
		memoria[6] <= 32'b000100_00100_00101_00110_01010_110010;  // MUL (B-A)*(C-D) em R6 // {Grupo, ts, rt, rd, 10, 50}	
		
		memoria[7] <= 32'b000110_01111_00110_0001_0001_0011_1111; // Store (B-A)*(C-D) em 113Fh // {(Grupo+2), rs, rt, offset}
			
		// SEM PIPELINE HAZZARD
		memoria[8]  <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A em R0
		memoria[9]  <= 32'b000101_01111_00001_0000_1101_0100_0001; // Load B em R1
		memoria[10] <= 32'b000101_01111_00010_0000_1101_0100_0010; // Load C em R2
		memoria[11] <= 32'b000101_01111_00011_0000_1101_0100_0011; // Load D em R3
		
		memoria[12] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[13] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		
		memoria[14] <= 32'b000100_00001_00000_00100_01010_100010;  // SUB B-A em R4	
		memoria[15] <= 32'b000100_00010_00011_00101_01010_100010;  // SUB C-D em R5		
		
		memoria[16] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[17] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[18] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		
		memoria[19] <= 32'b000100_00100_00101_00110_01010_110010;  // MUL (B-A)*(C-D) em R6
		
		memoria[20] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[21] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[22] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		
		memoria[23] <= 32'b000110_01111_00110_0001_0001_0011_1111; // Store (B-A)*(C-D) em 113Fh
		
		memoria[24] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[25] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
		memoria[26] <= 32'b000101_01111_00000_0000_1101_0100_0000; // Load A (Bolha)
	end

	always @(posedge clk) begin
			dataOut <= memoria[address];
	end

endmodule
