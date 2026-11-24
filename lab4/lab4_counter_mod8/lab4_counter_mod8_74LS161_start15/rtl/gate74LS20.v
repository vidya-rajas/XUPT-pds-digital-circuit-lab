// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS20(A1,B1,C1,D1,Y1,A2,B2,C2,D2,Y2);
  input  A1,B1,C1,D1,A2,B2,C2,D2;
  output Y1,Y2;

  assign Y1 = ~(A1 & B1 & C1 & D1);
  assign Y2 = ~(A2 & B2 & C2 & D2);

endmodule
