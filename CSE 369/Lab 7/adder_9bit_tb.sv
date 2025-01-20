module adder_9bit_tb();
    logic [8:0] A;
    logic [8:0] B;
    logic [8:0] sum;
    logic carry_out;

    adder_9bit dut (
        .A(A),
        .B(B),
		  .Sum(sum),
        .Cout(carry_out)
    );

    initial begin
        A = 9'b000000000;  // Case: An addition with one input being 0.
        B = 9'b000000000;
        #10;

        A = 9'b000000000;  // Case: An addition whose result is 511.
        B = 9'b111111111;
        #10;

        A = 9'b000000001;  // Case: An addition whose result is 0 (other than 0 + 0).
        B = 9'b111111110;
        #10;

        A = 9'b111111111;  // Case: An example of unsigned overflow.
        B = 9'b000000001;
        #10;

        A = 9'b011111111;  // Case: An example of positive signed overflow (pos + pos = neg).
        B = 9'b011111111;
        #10;

        A = 9'b100000000;  // Case: An example of negative signed overflow (neg + neg = pos).
        B = 9'b100000000;
        #10;

        $stop;
    end
endmodule
