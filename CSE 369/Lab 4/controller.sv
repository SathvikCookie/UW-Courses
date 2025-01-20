module controller (
	input logic [3:0] SW,
	output logic [1:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	lab3 l0(.LEDR(LEDR), .SW(SW));
	upc_display d0(.upc(SW[2:0]), .disp0(HEX0), .disp1(HEX1), .disp2(HEX2), .disp3(HEX3), .disp4(HEX4), .disp5(HEX5));

endmodule 