module DE1_SoC_tb;
    // Testbench signals
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [35:0] GPIO_1;
    logic clk;

    // Device Under Test (DUT) instantiation
    DE1_SoC dut (
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .LEDR(LEDR),
        .KEY(KEY),
        .SW(SW),
        .GPIO_1(GPIO_1),
        .CLOCK_50(clk)
    );

    // Clock generation
    parameter CLOCK_PERIOD = 20; // 50 MHz clock (20 ns period)
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Task to simulate a button press
    task press_button(input logic [1:0] button);
        begin
            KEY[button] = 0;
            @(posedge clk);
            KEY[button] = 1;
            @(posedge clk);
        end
    endtask

    // Testbench stimulus
    initial begin
        // Initialize signals
        KEY = 4'b1111;  // Active low buttons
        SW = 10'b0;     // Switches off

        press_button(0);  // Press reset button (KEY[0])
        press_button(2);  // x wins
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  
		  @(posedge clk);
		  @(posedge clk);
		  
		  press_button(0);
		  press_button(3);  // O wins
        press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  
		  @(posedge clk);
		  @(posedge clk);
		  
		  press_button(0);
		  press_button(2);  // draw
        press_button(2);
		  press_button(2);
		  press_button(3);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
		  press_button(2);
        #100;
        $stop;
    end
endmodule