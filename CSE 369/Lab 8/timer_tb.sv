module timer_tb;
    // Testbench signals
    logic clk, slow_clk, reset, playerSelect;
    logic [9:0] ledTime;
    logic timeOut;
    
    // Device Under Test (DUT) instantiation
    timer dut (
        .clk(clk),
        .slow_clk(slow_clk),
        .reset(reset),
        .playerSelect(playerSelect),
        .ledTime(ledTime),
        .timeOut(timeOut)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    always #20 slow_clk = ~slow_clk; // Slower clock for countdown
    
    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        slow_clk = 0;
        reset = 1;
        playerSelect = 0;
        
        // Remove reset
        #10 reset = 0;
        
        // Wait a few cycles to see initial state
        #20;
        
        // Test normal countdown
        #20 playerSelect = 1; // Trigger player selection
        #10 playerSelect = 0; // Release player select
        
        // Let countdown proceed
        #200;
        
        // Test reset during countdown
        reset = 1;
        #10 reset = 0;
        
        // Test multiple player selections
        playerSelect = 1;
        #10 playerSelect = 0;
        #50;
        playerSelect = 1;
        #10 playerSelect = 0;
        
        // Wait to see final state
        #400;
		  playerSelect = 1;
        #30 playerSelect = 0;
        
        // End simulation
        $stop;
    end
endmodule 