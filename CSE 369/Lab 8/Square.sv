module Square (
    input logic clk, reset, select, markX, markO, isActive,
    input logic flashClock,
	 input logic flash,
	 input logic winner,
	 input logic gameOver,
    output logic [15:0] grnPixels,
    output logic occupied,
    output logic stateX,
    output logic stateO
);
    typedef enum logic [1:0] {EMPTY = 2'b00, X = 2'b01, O = 2'b10} State;
    State state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= EMPTY;
        end else if (select && !occupied && isActive) begin
            if (markX) state <= X;
            else if (markO) state <= O;
        end
    end

    always_comb begin
        if (state == EMPTY) begin
            if (isActive && ~gameOver) begin
                grnPixels = flashClock ? 
                    (markX ? 16'b1001_0110_0110_1001 : 16'b0110_1001_1001_0110) : 
                    16'b0;
            end else begin
                grnPixels = 16'b0;
            end
        end else if (flash) begin
					 grnPixels = flashClock ? 
                    (winner ? 16'b1001_0110_0110_1001 : 16'b0110_1001_1001_0110) : 
                    16'b0;
		  end else begin
            case (state)
                X: grnPixels = 16'b1001_0110_0110_1001;
                O: grnPixels = 16'b0110_1001_1001_0110;
                default: grnPixels = 16'b0;
            endcase
        end
    end

    assign occupied = (state != EMPTY);
    assign stateX = (state == X);
    assign stateO = (state == O);
endmodule
