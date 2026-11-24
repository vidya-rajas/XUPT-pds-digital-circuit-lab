// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module nand_gate_check(a1,b1,a2,b2,a3,b3,y1,y2,y3);
  input  a1,b1,a2,b2,a3,b3;
  output y1,y2,y3;

  wire y4_unused;

  gate74LS00 U1 (
    .A1(a1), .B1(b1), .Y1(y1),
    .A2(a2), .B2(b2), .Y2(y2),
    .A3(a3), .B3(b3), .Y3(y3),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

endmodule
