// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module and_gate(a,b,f);
  input  a,b;
  output f;

  wire n1;
  wire y3_unused,y4_unused;

  gate74LS00 U1 (
    .A1(a),  .B1(b),  .Y1(n1),
    .A2(n1), .B2(n1), .Y2(f),
    .A3(1'b0), .B3(1'b0), .Y3(y3_unused),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

endmodule
