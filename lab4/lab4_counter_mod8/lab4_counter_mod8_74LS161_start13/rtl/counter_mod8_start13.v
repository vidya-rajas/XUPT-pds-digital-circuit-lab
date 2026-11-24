// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module counter_mod8_start13(clk,rst,q3,q2,q1,q0);
  input  clk,rst;
  output q3,q2,q1,q0;

  reg [24:0] cnt;
  reg        cp;

  initial
    begin
      cnt = 25'd0;
      cp  = 1'b0;
    end

  always @(posedge clk)
    begin
      if (cnt == 25'd24999999)
        begin
          cnt <= 25'd0;
          cp  <= ~cp;
        end
      else
        cnt <= cnt + 1'b1;
    end

  wire nq0,nq2,nq3,rst_n,det,and_n;
  wire load_n,y2u1,y3u1,y4u1;
  wire co;

  gate74LS00 U_INV1 (
    .A1(q0), .B1(q0), .Y1(nq0),
    .A2(q2), .B2(q2), .Y2(nq2),
    .A3(q3), .B3(q3), .Y3(nq3),
    .A4(rst), .B4(rst), .Y4(rst_n)
  );

  gate74LS00 U_INV2 (
    .A1(and_n), .B1(and_n), .Y1(load_n),
    .A2(1'b0), .B2(1'b0), .Y2(y2u1),
    .A3(1'b0), .B3(1'b0), .Y3(y3u1),
    .A4(1'b0), .B4(1'b0), .Y4(y4u1)
  );

  gate74LS20 U_NAND (
    .A1(nq0), .B1(q1), .C1(nq2), .D1(nq3), .Y1(det),
    .A2(rst_n), .B2(det), .C2(1'b1), .D2(1'b1), .Y2(and_n)
  );

  gate74LS161 U_CNT (
    .Clear(1'b1), .Load(load_n), .ENP(1'b1), .ENT(1'b1),
    .D(1'b1), .C(1'b1), .B(1'b0), .A(1'b1),
    .CLK(cp), .CO(co),
    .QD(q3), .QC(q2), .QB(q1), .QA(q0)
  );

endmodule
