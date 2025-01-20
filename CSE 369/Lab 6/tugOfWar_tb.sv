module tugOfWar_tb();
  logic clk, reset;
  logic [9:0] SW;
  logic [3:0] KEY;

  logic [9:0] LEDR;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  tugOfWar dut (
    .CLOCK_50(clk),
    .LEDR(LEDR),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .SW(SW),
    .KEY(KEY)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD / 2) clk = ~clk;
  end

  initial begin
    reset = 1;
    SW = 10'b0;
    KEY = 4'b0;
    @(posedge clk); 

    reset = 0; @(posedge clk);

    // Test 1: Simulate both players pressing their buttons
    SW = 10'b1000000000; 
	 @(posedge clk);
	 SW = 10'b0;
    KEY = 4'b0001; 
    @(posedge clk);
    KEY = 4'b0000;  
    @(posedge clk);
    KEY = 4'b0010; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);

    // Test 2: Simulate a victory condition
    SW = 10'b1000000000; 
	 @(posedge clk);
	 SW = 10'b0;
    KEY = 4'b0001;  
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0001; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
	 KEY = 4'b0001;  
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0001; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
	 KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0001; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    
    // Test 3: Simulate another sequence of button presses
    KEY = 4'b0001;  
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    
    // Test 4: Test victory condition again
    SW = 10'b1000000000; 
	 @(posedge clk);
	 SW = 10'b0;
    KEY = 4'b0010;  
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0010; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
	 KEY = 4'b0010;  
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0010; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);
	 KEY = 4'b0000; 
    @(posedge clk);
    KEY = 4'b0010; 
    @(posedge clk);
    KEY = 4'b0000; 
    @(posedge clk);

    $stop;
  end
endmodule // tugOfWar_tb
