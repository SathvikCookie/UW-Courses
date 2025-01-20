module edgeLight (
  input logic clk, reset,

  // onKey - True when assocaited on key is pressed
  // offKey - True when assocaited off key is pressed
  // prev - True when the associated previous light is on
  input logic onKey, offKey, prev,

  // lightOn – True when this normal light should be ON/lit
  output logic lightOn
  );

  // YOUR CODE GOES HERE
  enum logic {S_0 = 1'b0, S_1 = 1'b1} ps = S_0, ns;
	
	always_comb
		case (ps)
			S_0:  if (prev & onKey) ns = S_1;
					else   ns = S_0;
			S_1:  if (offKey) ns = S_0;
					else   ns = S_1;
			default:     ns = ps;
		endcase
		
	assign lightOn = (ps == S_1);
	
	always_ff @(posedge clk)
    if (reset)
      ps <= S_0;
    else
      ps <= ns;
  

endmodule  // edgeLight
