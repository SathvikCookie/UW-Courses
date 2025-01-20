module victory (
    input logic [8:0] xMarks, oMarks,
    output logic gameOver,
    output logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5,
	 output logic [8:0] winningSquares,
	 output logic winner
);

    parameter [6:0] BLANK = 7'b1111111;
	 parameter [6:0] X     = 7'b0001001;
	 parameter [6:0] O     = 7'b1000000;
	 parameter [6:0] W     = 7'b1000001;
	 parameter [6:0] I     = 7'b1111001;
	 parameter [6:0] N     = 7'b0101011;
	 parameter [6:0] S     = 7'b0010010;

	 parameter [6:0] D     = 7'b1000000;
	 parameter [6:0] R     = 7'b0101111;
	 parameter [6:0] A     = 7'b0100011;
	 
	 logic [8:0] allMarks;
	 
    always_comb begin
    // Default values to prevent latches
    gameOver = 0;
    disp0 = BLANK;
    disp1 = BLANK;
    disp2 = BLANK;
    disp3 = BLANK;
    disp4 = BLANK;
    disp5 = BLANK;
    winningSquares = 0;
    winner = 0;

    allMarks = xMarks | oMarks;

    // Check for X wins
    if (xMarks[0] && xMarks[1] && xMarks[2]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b111000000;
        winner = 1;
    end else if (xMarks[3] && xMarks[4] && xMarks[5]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b000111000;
        winner = 1;
    end else if (xMarks[6] && xMarks[7] && xMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b000000111;
        winner = 1;
    end else if (xMarks[0] && xMarks[3] && xMarks[6]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b100100100;
        winner = 1;
    end else if (xMarks[1] && xMarks[4] && xMarks[7]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b010010010;
        winner = 1;
    end else if (xMarks[2] && xMarks[5] && xMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b001001001;
        winner = 1;
    end else if (xMarks[0] && xMarks[4] && xMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b100010001;
        winner = 1;
    end else if (xMarks[2] && xMarks[4] && xMarks[6]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = X;
        winningSquares = 9'b001010100;
        winner = 1;
    end 
    // Check for O wins
    else if (oMarks[0] && oMarks[1] && oMarks[2]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b111000000;
        winner = 0;
    end else if (oMarks[3] && oMarks[4] && oMarks[5]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b000111000;
        winner = 0;
    end else if (oMarks[6] && oMarks[7] && oMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b000000111;
        winner = 0;
    end else if (oMarks[0] && oMarks[3] && oMarks[6]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b100100100;
        winner = 0;
    end else if (oMarks[1] && oMarks[4] && oMarks[7]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b010010010;
        winner = 0;
    end else if (oMarks[2] && oMarks[5] && oMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b001001001;
        winner = 0;
    end else if (oMarks[0] && oMarks[4] && oMarks[8]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b100010001;
        winner = 0;
    end else if (oMarks[2] && oMarks[4] && oMarks[6]) begin
        gameOver = 1;
        disp0 = S; disp1 = N; disp2 = I; disp3 = W; disp4 = BLANK; disp5 = O;
        winningSquares = 9'b001010100;
        winner = 0;
    end 
    // Check for draw
    else if (allMarks == 9'b111111111) begin
        gameOver = 1;
        disp0 = W; disp1 = A; disp2 = R; disp3 = D; disp4 = BLANK; disp5 = BLANK;
        winningSquares = 0;
    end
end


endmodule
