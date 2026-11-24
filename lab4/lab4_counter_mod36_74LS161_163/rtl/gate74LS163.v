// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module gate74LS163(Clear,Load,ENP,ENT,D,C,B,A,CLK,CO,QD,QC,QB,QA);
  input  Clear,Load,ENP,ENT,D,C,B,A,CLK;
  output CO,QD,QC,QB,QA;

  reg [3:0] Q;

  always @(posedge CLK)
    begin
      if (!Clear)
        Q <= 4'b0000;
      else if (!Load)
        Q <= {D,C,B,A};
      else if (ENP & ENT)
        Q <= Q + 1'b1;
    end

  assign {QD,QC,QB,QA} = Q;
  assign CO = ENT & (Q == 4'b1111);

endmodule
