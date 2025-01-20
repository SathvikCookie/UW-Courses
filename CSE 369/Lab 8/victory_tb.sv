module victory_tb;
    logic [8:0] xMarks, oMarks;
    logic gameOver;
    logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5;
    
    victory dut (
        .xMarks(xMarks),
        .oMarks(oMarks),
        .gameOver(gameOver),
        .disp0(disp0),
        .disp1(disp1),
        .disp2(disp2),
        .disp3(disp3),
        .disp4(disp4),
        .disp5(disp5)
    );
    
    initial begin
        oMarks = 9'b000000000;
        
        xMarks = 9'b000000111;
        #10;
        
        xMarks = 9'b000111000;
        #10;
        
        xMarks = 9'b111000000;
        #10;
        
        xMarks = 9'b001010100;
        #10;
        
        xMarks = 9'b010010010;
        #10;
        
        xMarks = 9'b100010001;
        #10;
        
        xMarks = 9'b001010010;
        #10;
        
        xMarks = 9'b100010100;
        #10;
        
        xMarks = 9'b000000000;
        oMarks = 9'b000000111;
        #10;
        
        oMarks = 9'b000111000;
        #10;
        
        oMarks = 9'b111000000;
        #10;
        
        oMarks = 9'b001010100;
        #10;
        
        oMarks = 9'b010010010;
        #10;
        
        oMarks = 9'b100010001;
        #10;
        
        oMarks = 9'b001010010;
        #10;
        
        oMarks = 9'b100010100;
        #10;
        
        $stop;
    end
endmodule