module adder_9bit (
    input logic [8:0] A,
    input logic [8:0] B,
	 output logic [8:0] Sum,
    output logic Cout
);

    assign { Cout, Sum} = A + B; 

endmodule
