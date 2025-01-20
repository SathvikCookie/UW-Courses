module victory_tb();
  logic leftWins;
  logic rightWins;
  logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5;

  victory dut (
    .leftWins(leftWins),
    .rightWins(rightWins),
    .disp0(disp0),
    .disp1(disp1),
    .disp2(disp2),
    .disp3(disp3),
    .disp4(disp4),
    .disp5(disp5)
  );

  initial begin
    leftWins = 1;
    rightWins = 0;
    #10;

    leftWins = 0;
    rightWins = 1;
    #10;

    leftWins = 0;
    rightWins = 0;
    #10;

    $stop;
  end
endmodule
