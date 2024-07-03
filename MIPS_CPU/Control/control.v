module control 
(
	input  [31:0] Instrucao, 
	output [23:0] Controle
);

	reg RW;                
	reg [1:0] Operacao;         
	reg Habilitar_Offset;     
	reg MUX_ALU_Entrada;        
	reg MUX_ALU_Saida;       
	reg MUX_WB;            
	reg WR;                
	reg Habilita_MULT;	
	
	// Registradores Rs, Rt e Rd
	reg [4:0]  Rs;		     
	reg [4:0]  Rt;		      			  
	reg [4:0]  Rd;	        
	
	// Vetor que contém todas as intruções de controle necessárias.
	assign Controle = {RW, Operacao, Habilitar_Offset, MUX_ALU_Entrada, MUX_ALU_Saida, MUX_WB, WR, Habilita_MULT, Rs, Rt, Rd}; 
	
	always @(Instrucao) begin
		Rs = Instrucao[25:21];
		Rt = Instrucao[20:16];
		WR = 1;
		Habilita_MULT = 0;
		Operacao = 0;
		MUX_ALU_Entrada = 0;    
		MUX_ALU_Saida = 1;
		Rd = 0;
		MUX_WB = 0;
		Habilitar_Offset = 0;
		RW = 0;
		
		// Instruções de formato i
		if(Instrucao[31:26] == 32'd5) begin // (grupo + 1) = 4 + 1 = 5 - Load in register
			Habilita_MULT = 0;
			RW = 1;            
			Operacao = 0;           		
			Habilitar_Offset = 1; 
			MUX_ALU_Entrada = 1;    
			MUX_ALU_Saida = 1;   
			MUX_WB = 1;        
			WR = 1;            
			Rd = Rt; 											
		end
	
		if(Instrucao[31:26] == 32'd6) begin // (grupo + 2) = 4 + 2 = 6 - Store in memory
			RW = 0;            
			Operacao = 0;           		
			Habilitar_Offset = 1; 
			MUX_ALU_Entrada = 1;    
			MUX_ALU_Saida = 1;   
			MUX_WB = 1;        
			WR = 0;             
			Rd = 0;
		end
	
		// Instruções de formato R
		if(Instrucao[31:26] == 32'd4) begin // Grupo 4
			Rd = Instrucao[15:11];
			RW = 1;
			Habilitar_Offset = 0;
			MUX_ALU_Entrada = 0;
			MUX_WB = 0; 
			WR = 1; 
			if(Instrucao[10:6] == 10 && Instrucao[5:0] == 50) begin 			//MUL
				Habilita_MULT = 1;
				MUX_ALU_Saida = 0;
			end else if(Instrucao[10:6] == 10 && Instrucao[5:0] == 32) begin //ADD	            
				Operacao = 0; 
				Habilita_MULT = 0;	
				MUX_ALU_Saida = 1;        
			end else if(Instrucao[10:6] == 10 && Instrucao[5:0] == 34) begin //SUB
				Operacao = 1;
				Habilita_MULT = 0;
				MUX_ALU_Saida = 1;
			end else if(Instrucao[10:6] == 10 && Instrucao[5:0] == 36) begin	//AND
				Operacao = 2;
				Habilita_MULT = 0;
				MUX_ALU_Saida = 1;
			end else if(Instrucao[10:6] == 10 && Instrucao[5:0] == 37) begin //OR
				Operacao = 3; 
				Habilita_MULT = 0;
				MUX_ALU_Saida = 1;
			end
		end
	end

endmodule

