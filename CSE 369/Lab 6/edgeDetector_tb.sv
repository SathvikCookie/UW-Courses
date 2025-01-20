module edgeDetector_tb ();
  logic clk, reset, pressed;
  logic out;

  edgeDetector dut (
    .clk(clk),
    .reset(reset),
    .pressed(pressed),
    .out(out)
  );

  // Set up the clock
  parameter CLOCK_PERIOD=100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    // Initialize all input signals at t<=0 to avoid undefined values
    reset <= 1; pressed <= 0; @(posedge clk);  // Apply reset
    reset <= 0; pressed <= 0; @(posedge clk);  // Deassert reset, no press
									   @(posedge clk);
									   @(posedge clk);
    
    // Test: Rising edge on pressed signal
					 pressed <= 1; @(posedge clk);  // Rising edge
					 pressed <= 0; @(posedge clk);  // Falling edge, no press
									   @(posedge clk);

    // Test: Rising edge again
					 pressed <= 1; @(posedge clk);  // Rising edge
					 				   @(posedge clk);
    
    // Test: Hold pressed (no rising edge)
					 pressed <= 1; @(posedge clk);  // Hold pressed
									   @(posedge clk);
    
    // Test: Release button (falling edge)
					 pressed <= 0; @(posedge clk);  // Falling edge
									   @(posedge clk);
    $stop;  // Pause the simulation
  end
endmodule // edgeDetector_tb