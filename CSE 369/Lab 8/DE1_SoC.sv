module DE1_SoC (
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR,
    input logic [3:0] KEY,
    input logic [9:0] SW,
    output logic [35:0] GPIO_1,
    input logic CLOCK_50
);
    logic [31:0] clk;
    logic SYSTEM_CLOCK;
    clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
    assign SYSTEM_CLOCK = clk[14];
    
    logic tempNext, tempSelect;
    synch sNext (.clk(CLOCK_50), .reset(~KEY[0]), .in(~KEY[3]), .out(tempNext));
    synch sSelect (.clk(CLOCK_50), .reset(~KEY[0]), .in(~KEY[2]), .out(tempSelect));
    
    logic next, select;
    edge_detector edNext (.clk(CLOCK_50), .pressed(tempNext), .reset(~KEY[0]), .out(next));
    edge_detector edSelect (.clk(CLOCK_50), .pressed(tempSelect), .reset(~KEY[0]), .out(select));
    
    logic [15:0][15:0] RedPixels;
    
    assign RedPixels[0] = 16'b0;
    assign RedPixels[1] = 16'b0000010000100000;
    assign RedPixels[2] = 16'b0000010000100000;
    assign RedPixels[3] = 16'b0000010000100000;
    assign RedPixels[4] = 16'b0000010000100000;
    assign RedPixels[5] = 16'b0111111111111110;
    assign RedPixels[6] = 16'b0000010000100000;
    assign RedPixels[7] = 16'b0000010000100000;
    assign RedPixels[8] = 16'b0000010000100000;
    assign RedPixels[9] = 16'b0000010000100000;
    assign RedPixels[10] = 16'b0111111111111110;
    assign RedPixels[11] = 16'b0000010000100000;
    assign RedPixels[12] = 16'b0000010000100000;
    assign RedPixels[13] = 16'b0000010000100000;
    assign RedPixels[14] = 16'b0000010000100000;
    assign RedPixels[15] = 16'b0;
    
    logic gameOver = 1'b0;
    logic currentPlayerX;
    logic [3:0] selectionIndex;
    
    logic [9:0] ledTime;
    logic timerTimeOut;
	 
	 logic occupied[8:0];

    timer playerTimer (
        .clk(CLOCK_50),
		  .slow_clk(clk[25]),
        .reset(~KEY[0] || select),
        .playerSelect(select),
        .ledTime(ledTime),
        .timeOut(timerTimeOut)
    );
    
    assign LEDR = ledTime;

    always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
        if (!KEY[0])
            currentPlayerX <= 1;
        else if (~gameOver && select && ~occupied[selectionIndex])
            currentPlayerX <= ~currentPlayerX;
    end
    
   always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
    if (!KEY[0]) begin
        selectionIndex <= 0; // Reset to the first square
    end else if (~gameOver && ((~timerTimeOut && next) || select)) begin
        logic [3:0] nextIndex;
        nextIndex = selectionIndex;
        
        // Find the next unoccupied square
        for (int j = 0; j < 9; j++) begin
            nextIndex = (nextIndex + 1'b1) % 4'b1001;
            if (!occupied[nextIndex]) begin
                selectionIndex <= nextIndex;
                break;
            end
        end
    end
end

	logic [8:0] winningSquares;
	logic winner;
    
    logic [15:0] GrnPixels[8:0];
    logic [8:0] stateX, stateO;
    genvar i;
    generate
        for (i = 0; i < 9; i++) begin : squares
            Square square (
                .clk(CLOCK_50),
                .reset(~KEY[0]),
                .select(select),
                .markX(currentPlayerX),
                .markO(~currentPlayerX),
                .isActive(selectionIndex == i),
                .flashClock(clk[25]),
					 .flash(winningSquares[i]),
					 .winner(winner),
                .grnPixels(GrnPixels[i]),
                .occupied(occupied[i]),
                .stateX(stateX[i]),
                .stateO(stateO[i]),
					 .gameOver(gameOver)
            );
        end
    endgenerate
    
    victory vic (
        .xMarks(stateX), 
        .oMarks(stateO), 
        .gameOver(gameOver), 
        .disp0(HEX0), 
        .disp1(HEX1), 
        .disp2(HEX2), 
        .disp3(HEX3), 
        .disp4(HEX4), 
        .disp5(HEX5),
		  .winningSquares(winningSquares),
		  .winner(winner)
    );
    
    logic [15:0][15:0] boardGrnPixels;
    assign boardGrnPixels[0] = 16'b0;
    assign boardGrnPixels[1] = {1'b0, GrnPixels[0][3:0], 1'b0, GrnPixels[1][3:0], 1'b0, GrnPixels[2][3:0], 1'b0};
    assign boardGrnPixels[2] = {1'b0, GrnPixels[0][7:4], 1'b0, GrnPixels[1][7:4], 1'b0, GrnPixels[2][7:4], 1'b0};
    assign boardGrnPixels[3] = {1'b0, GrnPixels[0][11:8], 1'b0, GrnPixels[1][11:8], 1'b0, GrnPixels[2][11:8], 1'b0};
    assign boardGrnPixels[4] = {1'b0, GrnPixels[0][15:12], 1'b0, GrnPixels[1][15:12], 1'b0, GrnPixels[2][15:12], 1'b0};
    assign boardGrnPixels[5] = 16'b0;
    assign boardGrnPixels[6] = {1'b0, GrnPixels[3][3:0], 1'b0, GrnPixels[4][3:0], 1'b0, GrnPixels[5][3:0], 1'b0};
    assign boardGrnPixels[7] = {1'b0, GrnPixels[3][7:4], 1'b0, GrnPixels[4][7:4], 1'b0, GrnPixels[5][7:4], 1'b0};
    assign boardGrnPixels[8] = {1'b0, GrnPixels[3][11:8], 1'b0, GrnPixels[4][11:8], 1'b0, GrnPixels[5][11:8], 1'b0};
    assign boardGrnPixels[9] = {1'b0, GrnPixels[3][15:12], 1'b0, GrnPixels[4][15:12], 1'b0, GrnPixels[5][15:12], 1'b0};
    assign boardGrnPixels[10] = 16'b0;
    assign boardGrnPixels[11] = {1'b0, GrnPixels[6][3:0], 1'b0, GrnPixels[7][3:0], 1'b0, GrnPixels[8][3:0], 1'b0};
    assign boardGrnPixels[12] = {1'b0, GrnPixels[6][7:4], 1'b0, GrnPixels[7][7:4], 1'b0, GrnPixels[8][7:4], 1'b0};
    assign boardGrnPixels[13] = {1'b0, GrnPixels[6][11:8], 1'b0, GrnPixels[7][11:8], 1'b0, GrnPixels[8][11:8], 1'b0};
    assign boardGrnPixels[14] = {1'b0, GrnPixels[6][15:12], 1'b0, GrnPixels[7][15:12], 1'b0, GrnPixels[8][15:12], 1'b0};
    assign boardGrnPixels[15] = 16'b0;
    
    LEDDriver Driver (
        .CLK(SYSTEM_CLOCK),
        .RST(~KEY[0]),
        .EnableCount(1'b1),
        .RedPixels(RedPixels),
        .GrnPixels(boardGrnPixels),
        .GPIO_1(GPIO_1)
    );

endmodule 