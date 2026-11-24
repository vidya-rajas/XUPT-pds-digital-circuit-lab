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
