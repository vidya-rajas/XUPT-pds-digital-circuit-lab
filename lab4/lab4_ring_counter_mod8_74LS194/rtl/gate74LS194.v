module gate74LS194(Clear,S1,S0,Left,Right,A,B,C,D,CLK,QA,QB,QC,QD);
  input  Clear,S1,S0,Left,Right,A,B,C,D,CLK;
  output QA,QB,QC,QD;

  reg [3:0] Q;

  always @(posedge CLK or negedge Clear)
    begin
      if (!Clear)
        Q <= 4'b0000;
      else
        case ({S1,S0})
          2'b11: Q <= {A,B,C,D};
          2'b01: Q <= {Right,Q[3],Q[2],Q[1]};
          2'b10: Q <= {Q[2],Q[1],Q[0],Left};
          2'b00: Q <= Q;
        endcase
    end

  assign {QA,QB,QC,QD} = Q;

endmodule
