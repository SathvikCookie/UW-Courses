module tugOfWar_tb();
    // Clock and interface signals
    logic CLOCK_50;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] SW;
    logic [3:0] KEY;

    // Instantiate the DUT
    tugOfWar #(.whichClock(1)) dut (.CLOCK_50(CLOCK_50), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .SW(SW), .KEY(KEY));

    // Clock generation - 50MHz
    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    task reset_game();
        SW[9] = 1'b1; 
        repeat(3) @(posedge CLOCK_50); 
        SW[9] = 1'b0;  
        repeat(3) @(posedge CLOCK_50);
    endtask

    task press_left_button();
        KEY = 4'b1111;  
        repeat(3) @(posedge CLOCK_50);
        KEY[3] = 1'b0; 
        repeat(3) @(posedge CLOCK_50); 
        KEY[3] = 1'b1;
        repeat(3) @(posedge CLOCK_50); 
    endtask

    initial begin
        KEY = 4'b1111;
        SW = 0;
		  SW[9] = 1;
        repeat(3) @(posedge CLOCK_50);
		  SW[9] = 0;
		  
		  press_left_button();
		  press_left_button();
		  press_left_button();
		  press_left_button();
		  press_left_button();
		  press_left_button();
		  
		  SW[8] = 1;
		  repeat(100) @(posedge CLOCK_50);
		  SW[8] = 0;
		  SW[9] = 1;
		  repeat(10) @(posedge CLOCK_50);
		  
        $stop;
    end

endmodule 