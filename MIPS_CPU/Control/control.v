module control 
(
	input  [31:0] instrucao, 
	output [23:0] controle
);

	reg RW;                
	reg [1:0] Operacao;         
	reg Offset_Enable;     
	reg MUX_ALU_IN;        
	reg MUX_ALU_OUT;       
	reg MUX_WB;            
	reg WR;                
	reg MULT_Enable;	
	
	// Registradores rs, rt e rd
	reg [4:0]  rs;		     
	reg [4:0]  rt;		      			  
	reg [4:0]  rd;	        
	
	// Vetor que contém todas as intruções de controle necessárias.
	assign controle = {RW, Operacao, Offset_Enable, MUX_ALU_IN, MUX_ALU_OUT, MUX_WB, WR, MULT_Enable, rs, rt, rd}; 
	
	always @(instrucao) begin
		rs = instrucao[25:21];
		rt = instrucao[20:16];
		WR = 1;
		MULT_Enable = 0;
		Operacao = 0;
		MUX_ALU_IN = 0;    
		MUX_ALU_OUT = 1;
		rd = 0;
		MUX_WB = 0;
		Offset_Enable = 0;
		RW = 0;
		
		// Instruções de formato i
		if(instrucao[31:26] == 6'b000101) begin // (grupo + 1) = 4 + 1 = 5 - LW 	
			MULT_Enable = 0;
			RW = 1;            
			Operacao = 0;           		
			Offset_Enable = 1; 
			MUX_ALU_IN = 1;    
			MUX_ALU_OUT = 1;   
			MUX_WB = 1;        
			WR = 1;            
			rd = rt; 											
		end
	
		if(instrucao[31:26] == 6'b000110) begin // (grupo + 2) = 4 + 2 = 6 - SW
			RW = 0;            
			Operacao = 0;           		
			Offset_Enable = 1; 
			MUX_ALU_IN = 1;    
			MUX_ALU_OUT = 1;   
			MUX_WB = 1;        
			WR = 0;             
			rd = 0;
		end
	
		// Instruções de formato R
		if(instrucao[31:26] == 6'b000100) begin // Grupo 4
			rd = instrucao[15:11];
			RW = 1;
			Offset_Enable = 0;
			MUX_ALU_IN = 0;
			MUX_WB = 0; 
			WR = 1; 
			if(instrucao[10:6] == 10 && instrucao[5:0] == 50) begin 			//MUL
				MULT_Enable = 1;
				MUX_ALU_OUT = 0;
			end else if(instrucao[10:6] == 10 && instrucao[5:0] == 32) begin //ADD	            
				Operacao = 0; 
				MULT_Enable = 0;	
				MUX_ALU_OUT = 1;        
			end else if(instrucao[10:6] == 10 && instrucao[5:0] == 34) begin //SUB
				Operacao = 1;
				MULT_Enable = 0;
				MUX_ALU_OUT = 1;
			end else if(instrucao[10:6] == 10 && instrucao[5:0] == 36) begin	//AND
				Operacao = 2;
				MULT_Enable = 0;
				MUX_ALU_OUT = 1;
			end else if(instrucao[10:6] == 10 && instrucao[5:0] == 37) begin //OR
				Operacao = 3; 
				MULT_Enable = 0;
				MUX_ALU_OUT = 1;
			end
		end
	end

endmodule
