// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS139(G1,B1,A1,Y1_3,Y1_2,Y1_1,Y1_0,G2,B2,A2,Y2_3,Y2_2,Y2_1,Y2_0);
  input  G1,B1,A1,G2,B2,A2;
  output Y1_3,Y1_2,Y1_1,Y1_0,Y2_3,Y2_2,Y2_1,Y2_0;

  reg [3:0] regout1;
  reg [3:0] regout2;

  always @(*)
    begin
      if (G1)
        begin
          regout1 = 4'b1111;
        end
      else
        begin
          case ({B1,A1})
            2'b00: regout1 = 4'b1110;
            2'b01: regout1 = 4'b1101;
            2'b10: regout1 = 4'b1011;
            2'b11: regout1 = 4'b0111;
            default: regout1 = 4'b1111;
          endcase
        end
    end

  always @(*)
    begin
      if (G2)
        begin
          regout2 = 4'b1111;
        end
      else
        begin
          case ({B2,A2})
            2'b00: regout2 = 4'b1110;
            2'b01: regout2 = 4'b1101;
            2'b10: regout2 = 4'b1011;
            2'b11: regout2 = 4'b0111;
            default: regout2 = 4'b1111;
          endcase
        end
    end

  assign {Y1_3,Y1_2,Y1_1,Y1_0} = regout1;
  assign {Y2_3,Y2_2,Y2_1,Y2_0} = regout2;

endmodule
