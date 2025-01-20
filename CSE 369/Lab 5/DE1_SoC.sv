module DE1_SoC #(
  parameter whichClock = 25
)
(
  input  logic       CLOCK_50,
  output logic [2:0] LEDR,
  input  logic [1:0] SW,
  input  logic [3:0] KEY
);

  logic [31:0] clk;
  clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));

  logic [2:0] out;

  runwayFSM fsm (.clk(clk[whichClock]), .sw0(SW[0]), .sw1(SW[1]), .reset(~KEY[0]), .out(out));

  assign LEDR = out[2:0];

endmodule  // DE1_SoC
