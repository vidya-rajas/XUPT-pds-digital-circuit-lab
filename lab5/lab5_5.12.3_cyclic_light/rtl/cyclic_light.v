module cyclic_light(clk,led0,led1,led2,led3,led4,led5,led6,led7);
  input  clk;
  output led0,led1,led2,led3,led4,led5,led6,led7;

  reg [23:0] cnt;
  reg        cp;

  initial
    begin
      cnt = 24'd0;
      cp  = 1'b0;
    end

  always @(posedge clk)
    if (cnt == 24'd12499999)
      begin
        cnt <= 24'd0;
        cp  <= ~cp;
      end
    else
      cnt <= cnt + 1'b1;

  reg [4:0] step;

  initial step = 5'd0;

  always @(posedge cp)
    if (step == 5'd29) step <= 5'd0;
    else               step <= step + 1'b1;

  reg [7:0] pat;

  always @(*)
    case (step)
      5'd0:  pat = 8'b10000000;
      5'd1:  pat = 8'b01000000;
      5'd2:  pat = 8'b00100000;
      5'd3:  pat = 8'b00010000;
      5'd4:  pat = 8'b00001000;
      5'd5:  pat = 8'b00000100;
      5'd6:  pat = 8'b00000010;
      5'd7:  pat = 8'b00000001;
      5'd8:  pat = 8'b11000000;
      5'd9:  pat = 8'b01100000;
      5'd10: pat = 8'b00110000;
      5'd11: pat = 8'b00011000;
      5'd12: pat = 8'b00001100;
      5'd13: pat = 8'b00000110;
      5'd14: pat = 8'b00000011;
      5'd15: pat = 8'b00000110;
      5'd16: pat = 8'b00001100;
      5'd17: pat = 8'b00011000;
      5'd18: pat = 8'b00110000;
      5'd19: pat = 8'b01100000;
      5'd20: pat = 8'b11000000;
      5'd21: pat = 8'b00110000;
      5'd22: pat = 8'b10000001;
      5'd23: pat = 8'b01000010;
      5'd24: pat = 8'b00100100;
      5'd25: pat = 8'b00011000;
      5'd26: pat = 8'b00100100;
      5'd27: pat = 8'b01000010;
      5'd28: pat = 8'b10000001;
      default: pat = 8'b00110000;
    endcase

  assign led0 = pat[7];
  assign led1 = pat[6];
  assign led2 = pat[5];
  assign led3 = pat[4];
  assign led4 = pat[3];
  assign led5 = pat[2];
  assign led6 = pat[1];
  assign led7 = pat[0];

endmodule
