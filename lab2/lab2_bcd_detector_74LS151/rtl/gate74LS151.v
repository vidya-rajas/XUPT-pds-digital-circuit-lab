module gate74LS151(Din,C,B,A,STROBE,Y,W);
  input  [7:0] Din;
  input  C,B,A,STROBE;
  output Y,W;

  reg regout;

  always @(*)
    begin
      if (STROBE)
        begin
          regout = 1'b0;
        end
      else
        begin
          case ({C,B,A})
            3'b000: regout = Din[0];
            3'b001: regout = Din[1];
            3'b010: regout = Din[2];
            3'b011: regout = Din[3];
            3'b100: regout = Din[4];
            3'b101: regout = Din[5];
            3'b110: regout = Din[6];
            3'b111: regout = Din[7];
            default: regout = 1'b0;
          endcase
        end
    end

  assign Y = regout;
  assign W = ~Y;

endmodule
