// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module and_or_gate(a,b,c,d,f);
  input  a,b,c,d;
  output f;

  wire t1,t2;
  wire y4_unused;

  gate74LS00 U1 (
    .A1(a), .B1(b), .Y1(t1),
    .A2(c), .B2(d), .Y2(t2),
    .A3(t1), .B3(t2), .Y3(f),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

endmodule
