module runwayFSM_tb ();
  logic clk, sw0, sw1, reset;
  logic [2:0] out;

  runwayFSM dut (
    .clk(clk),
    .sw0(sw0),
    .sw1(sw1),
	 .reset(reset),
    .out(out)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 0; sw0 <= 0; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 0; @(posedge clk);
	 sw0 <= 1; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 1; @(posedge clk);
	 sw0 <= 1; sw1 <= 0; @(posedge clk);
	 sw0 <= 1; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 1; @(posedge clk);
	 reset<= 1; sw0 <= 0; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 1; @(posedge clk);
	 sw0 <= 0; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 1; @(posedge clk);
	 sw0 <= 1; sw1 <= 0; @(posedge clk);
	 sw0 <= 1; sw1 <= 0; @(posedge clk);
	 sw0 <= 0; sw1 <= 1; @(posedge clk);
    $stop;
  end
endmodule
