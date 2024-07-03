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
	
	//FIOS ESTÁGIO 2
	wire [23:0] w_CONTROL_OUT;
	wire [31:0] w_EXTEND_OUT, w_IMM_OUT, w_CTRL1_OUT, w_RFA_OUT, w_RFB_OUT;
	(* keep=1 *) wire [31:0] writeBack;
	
	//FIOS ESTÁGIO 3
	wire [31:0] w_MUX_ALU_IN_OUT, w_ALU_OUT, w_MULT_OUT, MUX_ALU_OUT_OUT, w_CTRL2_OUT;
	wire w_IDLE, W_DONE;
	
	//FIOS ESTÁGIO 4
	wire [31:0] w_MUX_DM_OUT;
	wire [31:0] w_DM_OUT, w_D2_OUT, w_DM_IN;
	wire [31:0] w_CTRL3_OUT, w_REG_CS;
		
	//ASSIGNS ESTÁGIO 1
	assign w_IM_IN = w_PC_OUT - 32'h940;
	assign ADDR_Prog = w_PC_OUT;
	
	//ASSIGNS ESTÁGIO 4
	assign w_DM_IN = ADDR - 32'hD40;
	assign WR_RD = w_CTRL2_OUT[16];
	
	//--------------------------------------------------------------- PLL --------------------------------------------------------------------\\
	
	PLL PLL( //OK
		.areset(RST),
		.inclk0(CLK),
		.c0(CLK_MUL), // CLK / 1
		.c1(CLK_SYS), //CLK / 34
	);
		
	//------------------------------------------------------ESTÁGIO 1 - INSTRUCTION FETCH------------------------------------------------------\\
	
	//instructionmemory(input [ADDR_WIDTH-1:0] address, input clk, output reg [data_WIDTH-1:0] dataOut); //OK
	instructionmemory InstructionMemory( 
		.address(w_IM_IN[9:0]),
		.clk(CLK_SYS),
		.dataOut(w_IM_OUT)
	);
	
	//module ADDRDecoding_Prog(input [31:0] ADDR, output CS); //OK
	ADDRDecoding_Prog ADDRDecoding_Prog(
		.ADDR(w_PC_OUT),
		.CS(CS_P)
	);
	
	//module pc(input reset, clk,	output reg [31:0] Address); //OK
	pc PC(
		.reset(RST), .clk(CLK_SYS),
		.Address(w_PC_OUT)
	);
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //OK
	mux MUX_IM(
		.EntradaA(Prog_BUS_READ), .EntradaB(w_IM_OUT),
		.SEL(CS_P),
		.Saida(w_MUX_IM_OUT)
	);
	
	//------------------------------------------------------ESTÁGIO 2 - INSTRUCTION DECODE------------------------------------------------------\\
	
	//module registerfile (input [31:0] din, input writeEnable, input clk, rst, input [4:0] rs, rt, rd, output reg [31:0] regA,regB); //OK
	registerfile RegisterFile(
		.din(writeBack),
		.writeEnable(w_CTRL3_OUT[23]),
		.clk(CLK_SYS), .rst(RST),
		.rs(w_CONTROL_OUT[14:10]), .rt(w_CONTROL_OUT[9:5]), .rd(w_CTRL3_OUT[4:0]),
		.regA(w_RFA_OUT), .regB(w_RFB_OUT)		
	);
	
	//module control(input [31:0] instrucao, output [23:0] controle); //OK
	control Control(
		.Instrucao(w_MUX_IM_OUT),
		.Controle(w_CONTROL_OUT)
	);
	
	//module extend(input  [15:0] Entrada, input Enable, output reg [31:0] Saida); //OK
	extend Extend(
		.Entrada(w_MUX_IM_OUT[15:0]),
		.Enable(w_CONTROL_OUT[20]),
		.Saida(w_EXTEND_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida); //
	Register IMM(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(w_EXTEND_OUT),
		.Saida(w_IMM_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida); //OK
	Register CTRL1(
		.rst(RST), .clk(CLK_SYS),
		.Entrada({8'b0, w_CONTROL_OUT}),
		.Saida(w_CTRL1_OUT)
	);

	
	//------------------------------------------------------------ESTÁGIO 3 - EXECUTE-----------------------------------------------------------\\
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //OK
	mux MUX_ALU_IN(
		.EntradaA(w_IMM_OUT), .EntradaB(w_RFB_OUT),
		.SEL(w_CTRL1_OUT[19]), //SEL = 1 -> LOAD E STORE
		.Saida(w_MUX_ALU_IN_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //OK
	Register CTRL2(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(w_CTRL1_OUT),
		.Saida(w_CTRL2_OUT)
	);
	
	//module alu (input [31:0] EntradaA, EntradaB, input [1:0] OP, output reg [31:0] Saida); //OK
	alu ALU(
		.EntradaA(w_RFA_OUT), .EntradaB(w_MUX_ALU_IN_OUT),
		.OP(w_CTRL1_OUT[22:21]),
		.Saida(w_ALU_OUT)
	);
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //OK
	mux MUX_ALU_OUT(
		.EntradaA(w_ALU_OUT), .EntradaB(w_MULT_OUT),
		.SEL(w_CTRL1_OUT[18]), //SEL = 1 -> ALU, SEL = 0 -> MULT
		.Saida(MUX_ALU_OUT_OUT)
	);
	
	
	//module Multiplicador(input [15:0] Multiplicando, input [15:0] Multiplicador, input St, Clk, Reset, output Idle, Done, output [31:0] Produto); //OK
	Multiplicador Multiplicador(
		.Multiplicando(w_RFA_OUT[15:0]), .Multiplicador(w_RFB_OUT[15:0]),
		.St(w_CTRL1_OUT[15]), .Clk(CLK_MUL), .Reset(RST),
		.Idle(w_IDLE), .Done(W_DONE),
		.Produto(w_MULT_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //OK
	Register D(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(MUX_ALU_OUT_OUT),
		.Saida(ADDR)
	);

	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //OK
	Register B2(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(w_RFB_OUT),
		.Saida(Data_BUS_WRITE)
	);
	
	//------------------------------------------------------------ESTÁGIO 4 - MEMORY-----------------------------------------------------------\\
	
	//module datamemory(input [ADDR_WIDTH-1:0] address, input [DATA_WIDTH-1:0] dataIn, input WR_RD, input clk, output [DATA_WIDTH-1:0] dataOut); //OK
	datamemory DataMemory(
		.address(w_DM_IN[9:0]),
		.dataIn(Data_BUS_WRITE),
		.WR_RD(w_CTRL2_OUT[16]), .clk(CLK_SYS),
		.dataOut(w_DM_OUT)
	);
	
	//module mux(input [31:0] EntradaA, EntradaB, input SEL, output reg [31:0] Saida); //OK
	mux MUX_DM(
		.EntradaA(Data_BUS_READ), .EntradaB(w_DM_OUT),
		.SEL(w_REG_CS), //SEL = 0 -> MEMÓRIA INTERNA
		.Saida(w_MUX_DM_OUT)
	);
	
	//module ADDRDecoding(input [31:0] ADDR, output CS); //OK
	ADDRDecoding ADDRDecoding(
		.ADDR(ADDR),
		.CS(CS)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //OK
	Register REG_CS(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(CS),
		.Saida(w_REG_CS)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register D2(
		.rst(RST), .clk(CLK_SYS),
		.Entrada(ADDR),
		.Saida(w_D2_OUT)
	);
	
	//module Register(input rst, clk, input [31:0] Entrada, output reg  [31:0] Saida) //CONFERIDO
	Register CTRL3(
		.rst(RST), .clk(CLK_SYS),
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
