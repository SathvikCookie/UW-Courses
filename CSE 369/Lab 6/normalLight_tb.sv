module normalLight_tb ();
  logic clk, reset;
  logic L, R, NL, NR;
  logic lightOn;

  normalLight dut (
    .clk(clk),
    .reset(reset),
    .L(L),
    .R(R),
    .NL(NL),
    .NR(NR),
    .lightOn(lightOn)
  );

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1; L <= 0; R <= 0; NL <= 0; NR <= 0; 
    @(posedge clk);  
    reset <= 0; 
    @(posedge clk);  
    @(posedge clk);  

    NL <= 1; R <= 1; @(posedge clk);
    R <= 0; @(posedge clk);
    NR <= 1; L <= 1; @(posedge clk);
    L <= 0; @(posedge clk);
    NL <= 0; NR <= 0; @(posedge clk);

    NL <= 1; NR <= 1; R <= 1; L <= 1; @(posedge clk);
    R <= 0; L <= 0; @(posedge clk);

    reset <= 1; 
    @(posedge clk);  
    reset <= 0; 
    @(posedge clk);  

    NL <= 1; R <= 1; @(posedge clk);
    R <= 0; @(posedge clk);
    NR <= 1; L <= 1; @(posedge clk);
    L <= 0; @(posedge clk);

    $stop;
  end
endmodule // normalLight_tb
