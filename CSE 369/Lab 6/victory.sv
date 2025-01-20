module victory(
  input logic leftWins, rightWins,
  output logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5
);

  parameter [6:0] BLANK = 7'b111_1111;
  parameter [6:0] ONE   = 7'b111_1001;
  parameter [6:0] TWO   = 7'b010_0100;
  parameter [6:0] W     = 7'b100_1001;
  parameter [6:0] I     = 7'b111_1001;
  parameter [6:0] N     = 7'b100_1000;
  parameter [6:0] S     = 7'b001_0010;

  always_comb begin
    disp0 = BLANK;
    disp1 = BLANK;
    disp2 = BLANK;
    disp3 = BLANK;
    disp4 = BLANK;
    disp5 = BLANK;

    if (leftWins) begin
      disp0 = ONE;
		disp1 = BLANK;
      disp2 = W;
      disp3 = I;
      disp4 = N;
      disp5 = S;
    end 
    else if (rightWins) begin
      disp0 = TWO;
		disp1 = BLANK;
      disp2 = W;
      disp3 = I;
      disp4 = N;
      disp5 = S;
    end
  end

endmodule 