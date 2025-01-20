module timer (
    input logic clk,        // Fast system clock
    input logic slow_clk,   // Slow clock for countdown
    input logic reset,      // Asynchronous reset
    input logic playerSelect, // Signal triggered when a player selects
    output logic [9:0] ledTime, // LED display for time remaining
    output logic timeOut    // Signal for when time runs out
);
    // Internal registers
    logic [3:0] countdown;

    // Countdown logic on slow clock
    always_ff @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            countdown <= 4'd10;  // Reset countdown to 10
        end else if (playerSelect) begin
            countdown <= 4'd10;  // Reset countdown when player selects
        end else if (countdown > 0) begin
            countdown <= countdown - 1'b1; // Decrement countdown
        end
    end

    // Generate timeOut signal based on countdown value
    always_comb begin
        timeOut = (countdown == 0);
    end

    // Map countdown to LED display (linear scaling)
    always_comb begin
        ledTime = (countdown == 0) ? 10'b0000000000 : (10'b1111111111 >> (10 - countdown));
    end
endmodule
