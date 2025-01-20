module tugOfWar #(
	parameter whichClock = 15
)
(
    input  logic       CLOCK_50,
    output logic [9:0] LEDR,
	 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    input  logic [9:0] SW,
    input  logic [3:0] KEY
);
	 logic [31:0] clk;
    clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));

	 assign HEX1 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX4 = 7'b1111111;
	 
	 logic res;
	 assign res = SW[9] | LEDR[9] | LEDR[1];
	 
	 // Add computer player
	 logic computerPressed;
	 logic [8:0] lsfr_out;
	 logic [8:0] sum;
	 lsfr_9bit lsfr (.clk(clk[whichClock]), .reset(SW[9]), .lfsr(lsfr_out));
	 adder_9bit add (.A(SW[8:0]), .B(lsfr_out), .Sum(sum), .Cout(computerPressed));

	 logic tempL;
	 synch sL (.clk(clk[whichClock]), .reset(SW[9]), .in(~KEY[3]), .out(tempL));
    
    logic L, R;
    edgeDetector edl (.clk(clk[whichClock]), .pressed(tempL), .reset(SW[9]), .out(L));
    edgeDetector edr (.clk(clk[whichClock]), .pressed(computerPressed), .reset(SW[9]), .out(R));
	 
	 edgeLight l9 (.clk(clk[whichClock]), .reset(res), .onKey(L), .offKey(R), .prev(LEDR[8]), .lightOn(LEDR[9]));
	 normalLight l8 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	 normalLight l7 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	 normalLight l6 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	 centerLight l5 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	 normalLight l4 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	 normalLight l3 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	 normalLight l2 (.clk(clk[whichClock]), .reset(res), .L(L), .R(R), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	 edgeLight l1 (.clk(clk[whichClock]), .reset(res), .onKey(R), .offKey(L), .prev(LEDR[2]), .lightOn(LEDR[1]));
	 
	 counter leftCounter (.clk(clk[whichClock]), .reset(SW[9]), .count(LEDR[9]), .disp(HEX5));
	 counter rightCounter (.clk(clk[whichClock]), .reset(SW[9]), .count(LEDR[1]), .disp(HEX0));
	 
endmodule
