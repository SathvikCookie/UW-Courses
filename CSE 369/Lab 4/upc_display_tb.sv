module upc_display_tb;
    logic [2:0] SW;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 

    upc_display uut (
        .upc(SW),
        .disp0(HEX0),
        .disp1(HEX1),
		  .disp2(HEX2),
		  .disp3(HEX3),
		  .disp4(HEX4),
		  .disp5(HEX5)
    );

    initial begin
        for (int i = 0; i < 8; i++) begin
            SW = i;
            #10;
        end
        $stop;
    end
endmodule
