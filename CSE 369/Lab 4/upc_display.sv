module upc_display (
    input logic [2:0] upc,
    output logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5
);
    
    always_comb begin
        disp0 = 7'b0000000;
        disp1 = 7'b0000000;
        disp2 = 7'b0000000;
        disp3 = 7'b0000000;
        disp4 = 7'b0000000;
        disp5 = 7'b0000000;

        case (upc)
            3'b000: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b1111111;
                    disp2 = 7'b1000010;
                    disp3 = 7'b0001000;
                    disp4 = 7'b0000000;
                    disp5 = 7'b1111111;
                end
            3'b001: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b0000101;
                    disp2 = 7'b0100011;
                    disp3 = 7'b0100011;
                    disp4 = 7'b0000000;
                    disp5 = 7'b1111111;
                end
            3'b011: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b1000111;
                    disp2 = 7'b1000111;
                    disp3 = 7'b0001000;
                    disp4 = 7'b0000000;
                    disp5 = 7'b1111111;
                end
            3'b100: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b1000111;
                    disp2 = 7'b1000111;
                    disp3 = 7'b0000110;
                    disp4 = 7'b1000110;
                    disp5 = 7'b1111111;
                end
            3'b101: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b0000110;
                    disp2 = 7'b1101010;
                    disp3 = 7'b0001000;
                    disp4 = 7'b1000010;
                    disp5 = 7'b1111111;
                end
            3'b110: 
                begin
                    disp0 = 7'b1111111;
                    disp1 = 7'b1111111;
                    disp2 = 7'b0000111;
                    disp3 = 7'b0001000;
                    disp4 = 7'b0001001;
                    disp5 = 7'b1111111;
                end
            default: 
                begin
                    disp0 = 7'bX;
                    disp1 = 7'bX;
                    disp2 = 7'bX;
                    disp3 = 7'bX;
                    disp4 = 7'bX;
                    disp5 = 7'bX;
                end
        endcase
    end
    
endmodule 