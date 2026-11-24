// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module serial_comparator(a,b,cp,rst,g,l,e,cpled);
  input  a,b,cp,rst;
  output g,l,e,cpled;

  wire na,nb,ng,nl;
  wire njg,njl,jg,jl,nrst;
  wire qg_n,ql_n;

  gate74LS02 U_NOR1 (
    .A1(a), .B1(a), .Y1(na),
    .A2(b), .B2(b), .Y2(nb),
    .A3(g), .B3(g), .Y3(ng),
    .A4(l), .B4(l), .Y4(nl)
  );

  gate74LS20 U_NAND (
    .A1(a),  .B1(nb), .C1(nl), .D1(1'b1), .Y1(njg),
    .A2(na), .B2(b),  .C2(ng), .D2(1'b1), .Y2(njl)
  );

  gate74LS02 U_NOR2 (
    .A1(njg), .B1(njg), .Y1(jg),
    .A2(njl), .B2(njl), .Y2(jl),
    .A3(g),   .B3(l),   .Y3(e),
    .A4(rst), .B4(rst), .Y4(nrst)
  );

  gate74LS112 U_FF (
    .PR1(1'b1), .CLR1(nrst), .CLK1(cp), .J1(jg), .K1(1'b0), .Q1(g), .Q1n(qg_n),
    .PR2(1'b1), .CLR2(nrst), .CLK2(cp), .J2(jl), .K2(1'b0), .Q2(l), .Q2n(ql_n)
  );

  assign cpled = cp;

endmodule
