module counter (
  input logic clk,
  input logic reset,
  input logic count,
  output logic [6:0] disp
);
  logic [2:0] current_score;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      current_score <= 3'b000;
    end else if (count) begin
      if (current_score < 3'b111) begin
        current_score <= current_score + 1'b1;
      end
    end
  end 
  
  always_comb begin
    case(current_score)
      3'b000: disp = 7'b1000000;
      3'b001: disp = 7'b1111001;
      3'b010: disp = 7'b0100100;
      3'b011: disp = 7'b0110000;
      3'b100: disp = 7'b0011001;
      3'b101: disp = 7'b0010010;
      3'b110: disp = 7'b0000010;
      3'b111: disp = 7'b1111000;
      default: disp = 7'b1111111;
    endcase
  end

endmodule 