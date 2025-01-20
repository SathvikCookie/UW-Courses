module normalLight (
  input logic clk, reset,

  // L - True when left key (KEY[3]) is pressed
  // R - True when right key (KEY[0]) is pressed
  // NL - True when the light to the left of this one is ON
  // NR - True when the light on the right of this one is ON
  input logic L, R, NL, NR,

  // lightOn – True when this normal light should be ON/lit
  output logic lightOn
  );

  // YOUR CODE GOES HERE
  enum logic {S_0 = 1'b0, S_1 = 1'b1} ps = S_0, ns;
	
	always_comb
		case (ps)
			S_0:  if ((NL & R) | (NR & L)) ns = S_1;
					else   ns = S_0;
			S_1:  if (L | R) ns = S_0;
					else   ns = S_1;
			default:     ns = ps;
		endcase
		
	assign lightOn = (ps == S_1);
	
	always_ff @(posedge clk)
    if (reset)
      ps <= S_0;
    else
      ps <= ns;
  

endmodule  // normalLight
