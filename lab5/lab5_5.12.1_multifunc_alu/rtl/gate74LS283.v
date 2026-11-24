// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS283(A1,A2,A3,A4,B1,B2,B3,B4,C0,S1,S2,S3,S4,C4);
  input  A1,A2,A3,A4,B1,B2,B3,B4,C0;
  output S1,S2,S3,S4,C4;

  assign {C4,S4,S3,S2,S1} =
         {1'b0,A4,A3,A2,A1} + {1'b0,B4,B3,B2,B1} + C0;

endmodule
