module controller_tb;
    logic [3:0] SW;
    logic [1:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    controller uut (
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    initial begin
        for (int i = 0; i < 16; i++) begin
            SW = i; 
            #10;
        end
        $stop;
    end

endmodule
