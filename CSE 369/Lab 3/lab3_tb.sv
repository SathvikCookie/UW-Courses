module lab3_tb();
  logic [9:0] LEDR;
  logic [9:0] SW;

  // instantiate device under test
  lab3 dut (.LEDR, .SW);

  // test input sequence - try all combinations of inputs
  integer i;
  initial begin
    for(i = 0; i < 16; i++) begin
      SW[3:0] = i; #10;
    end
  end
endmodule  // lab3_tb