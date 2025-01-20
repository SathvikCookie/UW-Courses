module lsfr_9bit (
    input clk,
    input reset,
    output reg [8:0] lfsr
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 9'b1;
    end else begin
        lfsr[8:1] <= lfsr[7:0];
        lfsr[0] <= lfsr[8] ~^ lfsr[4];
    end
end
endmodule
