module edgeLight_tb ();
  logic clk, reset;
  logic onKey, offKey, prev;
  logic lightOn;

  edgeLight dut (
    .clk(clk),
    .reset(reset),
    .onKey(onKey),
    .offKey(offKey),
    .prev(prev),
    .lightOn(lightOn)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1; onKey <= 0; offKey <= 0; prev <= 0; 
    @(posedge clk);
    reset <= 0; 
    @(posedge clk); 
    @(posedge clk);

    prev <= 1; onKey <= 1; @(posedge clk);
    onKey <= 0; @(posedge clk);

    offKey <= 1; @(posedge clk);
    offKey <= 0; @(posedge clk);

    prev <= 0; @(posedge clk);
    prev <= 1; onKey <= 1; @(posedge clk);
    onKey <= 0; @(posedge clk);

    reset <= 1; 
    @(posedge clk);  
    reset <= 0; 
    @(posedge clk); 

    prev <= 1; onKey <= 1; @(posedge clk);
    onKey <= 0; @(posedge clk);

    offKey <= 1; @(posedge clk);
    offKey <= 0; @(posedge clk);

    $stop;
  end
endmodule // edgeLight_tb
