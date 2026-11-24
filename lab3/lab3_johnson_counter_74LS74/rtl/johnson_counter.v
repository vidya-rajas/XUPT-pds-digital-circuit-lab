// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module johnson_counter(exclk,rst,q3,q2,q1,q0,clkout);
  input  exclk,rst;
  output q3,q2,q1,q0,clkout;

  reg  [23:0] cnt;
  reg  clk;
  wire nq3,nrst;
  wire y3_unused,y4_unused;
  wire q0_n,q1_n,q2_n,q3_n;

  initial
    begin
      cnt = 24'd0;
      clk = 1'b0;
    end

  always @(posedge exclk)
    begin
      if (rst)
        begin
          cnt <= 24'd0;
          clk <= 1'b0;
        end
      else if (cnt == 24'd13499999)
        begin
          cnt <= 24'd0;
          clk <= ~clk;
        end
      else
        cnt <= cnt + 1'b1;
    end

  gate74LS02 U_NOR (
    .A1(q3),  .B1(q3),  .Y1(nq3),
    .A2(rst), .B2(rst), .Y2(nrst),
    .A3(1'b0), .B3(1'b0), .Y3(y3_unused),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

  gate74LS74 U_FF1 (
    .PR1(1'b1), .CLR1(nrst), .CLK1(clk), .D1(nq3), .Q1(q0), .Q1n(q0_n),
    .PR2(1'b1), .CLR2(nrst), .CLK2(clk), .D2(q0),  .Q2(q1), .Q2n(q1_n)
  );

  gate74LS74 U_FF2 (
    .PR1(1'b1), .CLR1(nrst), .CLK1(clk), .D1(q1), .Q1(q2), .Q1n(q2_n),
    .PR2(1'b1), .CLR2(nrst), .CLK2(clk), .D2(q2), .Q2(q3), .Q2n(q3_n)
  );

  assign clkout = clk;

endmodule
