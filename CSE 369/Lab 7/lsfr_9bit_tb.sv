module lsfr_9bit_tb();
  logic clk;
  logic reset;
  logic [8:0] lfsr;

  lsfr_9bit dut (
    .clk(clk),
    .reset(reset),
    .lfsr(lfsr)
  );

  parameter CLOCK_PERIOD = 100;

  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    reset = 1;
    @(posedge clk);
    reset = 0;
    
    repeat (10) begin
      @(posedge clk);
    end

    reset = 1;
    @(posedge clk);
    reset = 0;
    @(posedge clk);

    repeat (20) begin
      @(posedge clk);
    end
    
    $stop;
  end
endmodule
