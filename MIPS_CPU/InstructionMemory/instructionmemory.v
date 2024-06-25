module instructionmemory #(
//---------Sizes-----------------
	parameter data_WIDTH = 32,//Words de 32 bits
	parameter ADDR_WIDTH = 10//2^10 = 1024 Enderecos
)
(
//---------Input-----------------
	input [ADDR_WIDTH-1:0] address,
	input clk,
//---------Output-----------------
	output reg [data_WIDTH-1:0] dataOut
);

//---------Interno---------------
	reg [data_WIDTH-1:0] memoria [0:(1<<ADDR_WIDTH)-1];
//
	initial begin //Carregamento de dados iniciais na memoria, no caso, instrucoes
		memoria[0] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[1] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[2] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B

		memoria[3] = 32'b000101_01111_00000_0000_1101_0100_0000;  // load A in r0
		memoria[4] = 32'b000101_01111_00001_0000_1101_0100_0001;  // load B in r1
		memoria[5] = 32'b000101_01111_00010_0000_1101_0100_0010;  // load C in r2
		memoria[6] = 32'b000101_01111_00011_0000_1101_0100_0011;  // load D in r3

		memoria[7] = 32'b000100_00001_00000_00100_01010_100010;   // r4 receive sub B-A 
		memoria[8] = 32'b000100_00010_00011_00101_01010_100010;   // r5 receive sub C-D 
		memoria[9] = 32'b000100_00100_00101_00110_01010_110010;   // r6 receive mul (B-A)*(C-D)

		memoria[10] = 32'b000110_01111_00110_0001_0001_0011_1111; // store r6 in last mem position (0000113Fh)

		memoria[11] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[12] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[13] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[14] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B

		// segunda vez com inserção de bolha
		memoria[15] = 32'b000101_01111_00000_0000_1101_0100_0000;  // load A in r0
		memoria[16] = 32'b000101_01111_00001_0000_1101_0100_0001;  // load B in r1
		memoria[17] = 32'b000101_01111_00010_0000_1101_0100_0010;  // load C in r2
		memoria[18] = 32'b000101_01111_00011_0000_1101_0100_0011;  // load D in r3

		memoria[19] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[20] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[21] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B

		memoria[22] = 32'b000100_00001_00000_00100_01010_100010;   // r4 receive sub B-A 
		memoria[23] = 32'b000100_00010_00011_00101_01010_100010;   // r5 receive sub C-D 

		memoria[24] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[25] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[26] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B

		memoria[27] = 32'b000100_00100_00101_00110_01010_110010;   // r6 receive mul (B-A)*(C-D)

		memoria[28] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[29] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[30] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B

		memoria[31] = 32'b000110_01111_00110_0001_0001_0011_1111; // store r6 in last mem position (0000113Fh)

		memoria[32] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[33] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[34] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
		memoria[35] = 32'b000101_01111_00001_0000_1101_0100_0001;  // bolha load B
	end

//Nao precisa implementar uma estrutura de leitura ou escrita, visto que a memoria sera utilizada apenas como leitura
	always @ (posedge clk) begin
		dataOut <= memoria[address];//Leitura
	end

endmodule
