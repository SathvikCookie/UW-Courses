module synch_tb();
  logic clk;
  logic reset;
  logic in;
  logic out;

  synch dut (
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    reset = 1;
    in = 0;
    @(posedge clk);

    reset = 0;
    @(posedge clk);

    in = 1; @(posedge clk);
    in = 0; @(posedge clk);
    in = 1; @(posedge clk);
    in = 0; @(posedge clk);

    in = 1; @(posedge clk);
    in = 1; @(posedge clk);
    in = 1; @(posedge clk);

    reset = 1; @(posedge clk);
    reset = 0; @(posedge clk);
    in = 1; @(posedge clk);

    $stop;
  end
endmodule
