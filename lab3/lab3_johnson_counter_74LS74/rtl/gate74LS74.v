module gate74LS74(PR1,CLR1,CLK1,D1,Q1,Q1n,PR2,CLR2,CLK2,D2,Q2,Q2n);
  input  PR1,CLR1,CLK1,D1,PR2,CLR2,CLK2,D2;
  output Q1,Q1n,Q2,Q2n;

  reg Q1,Q1n;
  reg Q2,Q2n;

  always @(posedge CLK1 or negedge PR1 or negedge CLR1)
    begin
      if (!PR1)
        begin
          {Q1,Q1n} <= 2'b10;
        end
      else if (!CLR1)
        begin
          {Q1,Q1n} <= 2'b01;
        end
      else
        begin
          {Q1,Q1n} <= {D1,~D1};
        end
    end

  always @(posedge CLK2 or negedge PR2 or negedge CLR2)
    begin
      if (!PR2)
        begin
          {Q2,Q2n} <= 2'b10;
        end
      else if (!CLR2)
        begin
          {Q2,Q2n} <= 2'b01;
        end
      else
        begin
          {Q2,Q2n} <= {D2,~D2};
        end
    end

endmodule
