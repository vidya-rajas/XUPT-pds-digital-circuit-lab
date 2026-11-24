module gate74LS138(G1,G2A,G2B,C,B,A,Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0);
  input  G1,G2A,G2B,C,B,A;
  output Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0;

  reg [7:0] regout;

  always @(*)
    begin
      if (G1 && !G2A && !G2B)
        begin
          case ({C,B,A})
            3'b000: regout = 8'b1111_1110;
            3'b001: regout = 8'b1111_1101;
            3'b010: regout = 8'b1111_1011;
            3'b011: regout = 8'b1111_0111;
            3'b100: regout = 8'b1110_1111;
            3'b101: regout = 8'b1101_1111;
            3'b110: regout = 8'b1011_1111;
            3'b111: regout = 8'b0111_1111;
            default: regout = 8'b1111_1111;
          endcase
        end
      else
        begin
          regout = 8'b1111_1111;
        end
    end

  assign {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} = regout;

endmodule
