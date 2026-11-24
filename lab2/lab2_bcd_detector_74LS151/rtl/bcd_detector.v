// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module bcd_detector(D, C, B, A, F);
input  D, C, B, A;
output F;

wire W_unused;

gate74LS151 U_MUX (
    .Din({1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}),
    .C(D), .B(C), .A(B),
    .STROBE(1'b0),
    .Y(F),
    .W(W_unused)
);

endmodule
