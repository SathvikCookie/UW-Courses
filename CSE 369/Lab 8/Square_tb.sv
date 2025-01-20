module Square_tb;
    logic clk, reset, select, markX, markO, isActive;
    logic flashClock;
    
    logic [15:0] grnPixels;
    logic occupied, stateX, stateO;
    
    Square dut (
        .clk(clk),
        .reset(reset),
        .select(select),
        .markX(markX),
        .markO(markO),
        .isActive(isActive),
        .flashClock(flashClock),
        .grnPixels(grnPixels),
        .occupied(occupied),
        .stateX(stateX),
        .stateO(stateO)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 1;
        select = 0;
        markX = 0;
        markO = 0;
        isActive = 0;
        flashClock = 0;
        
        #10 reset = 0;
        
        #10;
        
        isActive = 1;
        select = 1;
        markX = 1;
        #10;
        
        markO = 1;
        #10;
        
        reset = 1;
        #10 reset = 0;
		  markX = 0;
        isActive = 1;
        flashClock = 1;
        #10;
        
        reset = 1;
        #10 reset = 0;
        isActive = 1;
        select = 1;
        markO = 1;
        #10;
		  
        
        #10;
		  $stop;
    end
	 
endmodule 