module cpu 
(
	input CLK, RST,
	input [31:0] Data_BUS_READ, Prog_BUS_READ,
	output [31:0] Data_BUS_WRITE, ADDR, ADDR_Prog,
	output CS, CS_P, WR_RD
);

	
	//FIOS PLL
	(*keep=1*) wire CLK_SYS, CLK_MUL;
	
	//FIOS ESTÁGIO 1
	wire [31:0] w_PC_OUT, w_IM_IN, w_IM_OUT, w_MUX_IM_OUT;
	wire w_CS_P;
	
	//FIOS ESTÁGIO 2
	wire [23:0] w_CONTROL_OUT;
	wire [31:0] w_EXTEND_OUT, w_IMM_OUT, w_CTRL1_OUT, w_RFA_OUT, w_RFB_OUT;
	(* keep=1 *) wire [31:0] writeBack;
	
	//FIOS ESTÁGIO 3
	wire [31:0] w_MUX_ALU_IN_OUT, w_ALU_OUT, w_MULT_OUT, MUX_ALU_OUT_OUT, w_CTRL2_OUT, w_D_OUT, w_B2_OUT;
	wire w_IDLE, W_DONE;
	
	//FIOS ESTÁGIO 4
	wire [31:0] w_MUX_DM_OUT;
	wire [31:0] w_DM_OUT, w_D2_OUT, w_DM_IN;
	wire [31:0] w_CTRL3_OUT;
	wire w_CS;
		
	//ASSIGNS ESTÁGIO 1
	assign w_IM_IN = w_PC_OUT - 32'h940;
	assign ADDR_Prog = w_PC_OUT;
	assign CS_P = w_CS_P;
	
	//ASSIGNS ESTÁGIO 4
	assign Data_BUS_WRITE = w_B2_OUT;
	assign ADDR = w_D_OUT;
	assign w_DM_IN = w_D_OUT - 32'hD40;
	assign WR_RD = w_CTRL2_OUT[16];
	assign CS = w_CS;
	
	//------------------------------------------------------ESTÁGIO 1 - INSTRUCTION FETCH------------------------------------------------------\\
	
	PLL PLL (
	.areset ( RST ),
	.inclk0 ( CLK ),
	.c0 ( CLK_MUL ), // CLK / 1
	.c1 ( CLK_SYS ), //CLK / 34
	);
		
	//------------------------------------------------------ESTÁGIO 1 - INSTRUCTION FETCH------------------------------------------------------\\
	
	//module pc(input reset, clk,	output reg [31:0] Address); //CONFERIDO
	pc PC(
		.reset(RST), .clk(CLK),
		.Address(w_PC_OUT)
	);
	
	//module ADDRDecoding_Prog(input [31:0] ADDR, output CS); //CONFERIDO
	ADDRDecoding_Prog ADDRDecoding_Prog(
		.ADDR(w_PC_OUT),
		.CS(w_CS_P)
	);
	
	//instructionmemory(input [ADDR_WIDTH-1:0] address, input clk, output reg [data_WIDTH-1:0] dataOut); //CONFERIDO
	instructionmemory InstructionMemory(
		.address(w_IM_IN[9:0]),
		.clk(CLK),
		.dataOut(w_IM_OUT)
	);
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //CONFERIDO
	mux MUX_IM(
		.EntradaA(Prog_BUS_READ), .EntradaB(w_IM_OUT),
		.SEL(w_CS_P),
		.Saida(w_MUX_IM_OUT)
	);
	
	//------------------------------------------------------ESTÁGIO 2 - INSTRUCTION DECODE------------------------------------------------------\\
	
	//module control(input [31:0] instrucao, output [23:0] controle); //CONFERIDO
	control Control(
		.instrucao(w_MUX_IM_OUT),
		.controle(w_CONTROL_OUT)
	);
	
	//module extend(input  [15:0] Entrada, input Enable, output reg [31:0] Saida); //CONFERIDO
	extend Extend(
		.Entrada(w_MUX_IM_OUT[15:0]),
		.Enable(w_CONTROL_OUT[20]),
		.Saida(w_EXTEND_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida); //CONFERIDO
	Register IMM(
		.rst(RST), .clk(CLK),
		.Entrada(w_EXTEND_OUT),
		.Saida(w_IMM_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida); //CONFERIDO
	Register CTRL1(
		.rst(RST), .clk(CLK),
		.Entrada({8'b00000000, w_CONTROL_OUT}),
		.Saida(w_CTRL1_OUT)
	);
	
	//module registerfile (input [31:0] din, input writeEnable, input clk, rst, input [4:0] rs, rt, rd, output reg [31:0] regA,regB); //CONFERIR w_CTRL3_OUT
	registerfile RegisterFile(
		.din(writeBack),
		.writeEnable(w_CTRL3_OUT[23]),
		.clk(CLK), .rst(RST),
		.rs(w_CONTROL_OUT[14:10]), .rt(w_CONTROL_OUT[9:5]), .rd(w_CTRL3_OUT[4:0]),
		.regA(w_RFA_OUT), .regB(w_RFB_OUT)		
	);
	
	//------------------------------------------------------------ESTÁGIO 3 - EXECUTE-----------------------------------------------------------\\
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //CONFERIDO
	mux MUX_ALU_IN(
		.EntradaA(w_IMM_OUT), .EntradaB(w_RFB_OUT),
		.SEL(w_CTRL1_OUT[19]), //SEL = 1 -> LOAD E STORE
		.Saida(w_MUX_ALU_IN_OUT)
	);
	
	//module alu (input [31:0] EntradaA, EntradaB, input [1:0] OP, output reg [31:0] Saida); //CONFERIDO
	alu ALU(
		.EntradaA(w_RFA_OUT), .EntradaB(w_MUX_ALU_IN_OUT),
		.OP(w_CTRL1_OUT[22:21]),
		.Saida(w_ALU_OUT)
	);
	
	
	assign w_MULT_OUT = 32'b0; //RETIRAR
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //CONFERIDO
	mux MUX_ALU_OUT(
		.EntradaA(w_ALU_OUT), .EntradaB(w_MULT_OUT),
		.SEL(w_CTRL1_OUT[18]), //SEL = 1 -> ALU, SEL = 0 -> MULT
		.Saida(MUX_ALU_OUT_OUT)
	);
	
	/*
	//module Multiplicador(input [15:0] Multiplicando, input [15:0] Multiplicador, input St, Clk, Reset, output Idle, Done, output [31:0] Produto);
	Multiplicador Multiplicador(
		.Multiplicando(w_RFA_OUT[15:0]), .Multiplicador(w_RFB_OUT[15:0]),
		.St(w_CTRL1_OUT[15]), .Clk(CLK), .Reset(RST),
		.Idle(w_IDLE), .Done(W_DONE),
		.Produto(w_MULT_OUT)
	);
	*/
	  
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register CTRL2(
		.rst(RST), .clk(CLK),
		.Entrada(w_CTRL1_OUT),
		.Saida(w_CTRL2_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register D(
		.rst(RST), .clk(CLK),
		.Entrada(MUX_ALU_OUT_OUT),
		.Saida(w_D_OUT)
	);

	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register B2(
		.rst(RST), .clk(CLK),
		.Entrada(w_RFB_OUT),
		.Saida(w_B2_OUT)
	);
	
	//------------------------------------------------------------ESTÁGIO 4 - MEMORY-----------------------------------------------------------\\
	
	//module datamemory(input [ADDR_WIDTH-1:0] address, input [DATA_WIDTH-1:0] dataIn, input WR_RD, input clk, output [DATA_WIDTH-1:0] dataOut); //CONFERIDO
	datamemory DataMemory(
		.address(w_DM_IN),
		.dataIn(w_B2_OUT),
		.WR_RD(w_CTRL2_OUT[16]), .clk(CLK),
		.dataOut(w_DM_OUT)
	);
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //CONFERIDO
	mux MUX_DM(
		.EntradaA(Data_BUS_READ), .EntradaB(w_DM_OUT),
		.SEL(w_CS), //SEL = 0 -> MEMÓRIA INTERNA
		.Saida(w_MUX_DM_OUT)
	);
	
	//module ADDRDecoding(input [31:0] ADDR, output CS); //CONFERIDO
	ADDRDecoding ADDRDecoding(
		.ADDR(w_D_OUT),
		.CS(w_CS)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register D2(
		.rst(RST), .clk(CLK),
		.Entrada(w_D_OUT),
		.Saida(w_D2_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register CTRL3(
		.rst(RST), .clk(CLK),
		.Entrada(w_CTRL2_OUT),
		.Saida(w_CTRL3_OUT)
	);
	
	//------------------------------------------------------------ESTÁGIO 5 - MEMORY-----------------------------------------------------------\\
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //CONFERIDO
	mux MUX_WB(
		.EntradaA(w_MUX_DM_OUT), .EntradaB(w_D2_OUT),
		.SEL(w_CTRL3_OUT[17]), //SEL = 1 -> LOAD E STORE
		.Saida(writeBack)
	);

endmodule
