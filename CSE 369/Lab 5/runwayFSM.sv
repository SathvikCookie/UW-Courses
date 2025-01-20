module runwayFSM(
	input logic clk, sw0, sw1, reset,
	output logic [2:0] out
	);
	
	enum logic [1:0] {S_0 = 2'b00, S_01 = 2'b01, S_10 = 2'b10, S_11 = 2'b11} ps = S_0, ns;
	
	always_comb 
		case (ps)
			S_0: ns = S_01;
			S_01: if (~sw1 & ~sw0) ns = S_0;
				  else if (~sw1 & sw0) ns = S_10;
				  else ns = S_11;
			S_10: if (~sw1 & sw0) ns = S_11;
				  else ns = S_01;
			S_11: if (sw1 & ~sw0) ns = S_10;
				  else ns = S_01;
			default: ns = ps;
		endcase
		
	always_comb
		case (ns)
			S_0: out = 3'b101;
			S_01: out = 3'b010;
			S_10: out = 3'b100;
			S_11: out = 3'b001;
			default: out = 3'b000;
		endcase
	
	always_ff @ (posedge clk)
		if (reset)
			ps <= S_0;
		else
			ps <= ns;
		
endmodule 