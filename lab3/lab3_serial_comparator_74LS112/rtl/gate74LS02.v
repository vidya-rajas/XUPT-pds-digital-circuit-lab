// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS02(A1,B1,A2,B2,A3,B3,A4,B4,Y1,Y2,Y3,Y4);
  input  A1,B1,A2,B2,A3,B3,A4,B4;
  output Y1,Y2,Y3,Y4;

  assign Y1 = ~(A1 | B1);
  assign Y2 = ~(A2 | B2);
  assign Y3 = ~(A3 | B3);
  assign Y4 = ~(A4 | B4);

endmodule
