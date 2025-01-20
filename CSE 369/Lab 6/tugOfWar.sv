module tugOfWar (
    input  logic       CLOCK_50,
    output logic [9:0] LEDR,
	 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    input  logic [9:0] SW,
    input  logic [3:0] KEY
);
	 logic tempL, tempR;
	 synch sL (.clk(CLOCK_50), .reset(SW[9]), .in(~KEY[3]), .out(tempL));
	 synch sR (.clk(CLOCK_50), .reset(SW[9]), .in(~KEY[0]), .out(tempR));
    
    logic L, R;
    edgeDetector edl (.clk(CLOCK_50), .pressed(tempL), .reset(SW[9]), .out(L));
    edgeDetector edr (.clk(CLOCK_50), .pressed(tempR), .reset(SW[9]), .out(R));
	 
	 edgeLight l9 (.clk(CLOCK_50), .reset(SW[9]), .onKey(L), .offKey(R), .prev(LEDR[8]), .lightOn(LEDR[9]));
	 normalLight l8 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	 normalLight l7 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	 normalLight l6 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	 centerLight l5 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	 normalLight l4 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	 normalLight l3 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	 normalLight l2 (.clk(CLOCK_50), .reset(SW[9]), .L(L), .R(R), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	 edgeLight l1 (.clk(CLOCK_50), .reset(SW[9]), .onKey(R), .offKey(L), .prev(LEDR[2]), .lightOn(LEDR[1]));
	 
	 victory vic (.leftWins(LEDR[9]), .rightWins(LEDR[1]), .disp0(HEX5), .disp1(HEX4), .disp2(HEX3), .disp3(HEX2), .disp4(HEX1), .disp5(HEX0));
endmodule
