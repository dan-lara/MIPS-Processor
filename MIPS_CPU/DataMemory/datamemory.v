module datamemory #(
//Sizes//
	parameter data_WIDTH = 32,//32 bits por word
	parameter ADDR_WIDTH = 11//2^10 = 1024 endereços
)

(
//Inputs//
	input [ADDR_WIDTH-1:0] ADDR,
	input [data_WIDTH-1:0] din,
	input WR_RD,
	input clk,
//
//Outputs
	output reg [data_WIDTH-1:0] dout
);

//Internal//
reg [data_WIDTH-1:0] mem [0:(1<<(ADDR_WIDTH-1))-1];
reg[ADDR_WIDTH-1:0] addfix;

always @(*)begin
	if((ADDR >= 10'h300)&&(ADDR <= 10'h3FF))begin
		addfix <= (ADDR^(10'h300));
	end
	else if((ADDR >= 10'h400)&&(ADDR <= 10'h4FF))begin
		addfix <= (ADDR^(10'h100));
	end
	else if((ADDR >= 10'h500)&&(ADDR <= 10'h5FF))begin
		addfix <= (ADDR^(10'h300));
	end
	else if((ADDR >= 10'h600)&&(ADDR <= 10'h6FF))begin
		addfix <= (ADDR^(10'h100));
	end
	else begin
		addfix <= ADDR;
	end
end

initial begin//Valores Iniciais da memoria
	$readmemb("D:/Downloads/MIPS_CPU_Grupo_1/MIPS_CPU/DataMemory/datamemory.txt", mem);
end

//Code//
	always @(posedge clk)begin
		if(WR_RD)begin//Escrita
			mem[addfix] <= din;
		end
		else begin//Leitura
			dout <= mem[addfix];
		end
	end
//

endmodule	