module edgeDetector (
	input logic clk, pressed, reset,
	output logic out
	);
	
	enum logic [1:0] {S_0 = 2'b00, S_1 = 2'b01, S_10 = 2'b10} ps = S_1, ns;
	
	always_comb
		case (ps)
			S_0:  if (pressed) ns = S_0;
					else   ns = S_1;
			S_1:  if (pressed) ns = S_10;
					else   ns = S_1;
			S_10: if (pressed) ns = S_0;
					else   ns = S_1;
			default:     ns = ps;
		endcase
		
	assign out = (ns == S_10);
	
	always_ff @(posedge clk)
    if (reset)
      ps <= S_1;
    else
      ps <= ns;

endmodule // edgeDetector