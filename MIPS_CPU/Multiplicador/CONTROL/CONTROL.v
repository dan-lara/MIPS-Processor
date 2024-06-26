module CONTROL (
	input Clk, K, St, M, Reset,
	output reg Idle, Done, Load, Sh, Ad
);

	localparam s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
	reg [1:0] state;

	always @(posedge Clk, posedge Reset) begin
		if(Reset)
			state <= s0;
		else
		case(state) 
			s0: begin
				if (St == 0) state <= s0; 
				else 			 state <= s1;
			end
			s1: state <= s2; 
			s2: begin
				if (K == 0) state <= s1;
				else 			state <= s3;
			end
			s3: state <= s0;
			default: state <= s0;
		endcase
	end
	  
	always @(*) begin
		Idle = 1'b0; Done = 1'b0; Load = 1'b0; Sh = 1'b0; Ad = 1'b0;
		case(state)
			s0 : begin Idle = 1'b1; Load = St ? 1 : 0; end
			s1 : begin Ad = M ? 1 : 0; end
			s2 : begin Sh = 1'b1; end
			s3 : begin Done = 1'b1; end
		endcase
	end
endmodule
