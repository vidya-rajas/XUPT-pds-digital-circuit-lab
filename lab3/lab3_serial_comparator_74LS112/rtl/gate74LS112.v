// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS112(PR1,CLR1,CLK1,J1,K1,Q1,Q1n,PR2,CLR2,CLK2,J2,K2,Q2,Q2n);
  input  PR1,CLR1,CLK1,J1,K1,PR2,CLR2,CLK2,J2,K2;
  output Q1,Q1n,Q2,Q2n;

  reg Q1,Q1n;
  reg Q2,Q2n;

  always @(negedge CLK1 or negedge PR1 or negedge CLR1)
    begin
      if (!PR1)
        begin
          {Q1,Q1n} <= 2'b10;
        end
      else if (!CLR1)
        begin
          {Q1,Q1n} <= 2'b01;
        end
      else
        begin
          case ({J1,K1})
            2'b00: {Q1,Q1n} <= {Q1,Q1n};
            2'b01: {Q1,Q1n} <= 2'b01;
            2'b10: {Q1,Q1n} <= 2'b10;
            2'b11: {Q1,Q1n} <= {~Q1,~Q1n};
          endcase
        end
    end

  always @(negedge CLK2 or negedge PR2 or negedge CLR2)
    begin
      if (!PR2)
        begin
          {Q2,Q2n} <= 2'b10;
        end
      else if (!CLR2)
        begin
          {Q2,Q2n} <= 2'b01;
        end
      else
        begin
          case ({J2,K2})
            2'b00: {Q2,Q2n} <= {Q2,Q2n};
            2'b01: {Q2,Q2n} <= 2'b01;
            2'b10: {Q2,Q2n} <= 2'b10;
            2'b11: {Q2,Q2n} <= {~Q2,~Q2n};
          endcase
        end
    end

endmodule
