module lab3 (
  output logic [1:0] LEDR,
  input  logic [3:0] SW
  );
  
  // Switch 0 is U
  // Switch 1 is P
  // Switch 2 is C
  // Switch 3 is M
  
  // Discount Light
  assign LEDR[0] = SW[1] | (SW[0] & SW[2]);
  
  // Stolen Light
  assign LEDR[1] = (SW[0] | ~SW[2]) & ~SW[3] & ~SW[1];

endmodule 