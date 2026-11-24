module counter_mod8_start14(clk,rst,q3,q2,q1,q0);
  input  clk,rst;
  output q3,q2,q1,q0;

  reg [24:0] cnt;
  reg        cp;

  initial
    begin
      cnt = 25'd0;
      cp  = 1'b0;
    end

  always @(posedge clk)
    begin
      if (cnt == 25'd24999999)
        begin
          cnt <= 25'd0;
          cp  <= ~cp;
        end
      else
        cnt <= cnt + 1'b1;
    end

  wire nq0,nq2,rst_n,det,and_n,load_n;
  wire co;

  gate74LS00 U_INV1 (
    .A1(q0), .B1(q0), .Y1(nq0),
    .A2(q2), .B2(q2), .Y2(nq2),
    .A3(rst), .B3(rst), .Y3(rst_n),
    .A4(and_n), .B4(and_n), .Y4(load_n)
  );

  gate74LS20 U_NAND (
    .A1(nq0), .B1(q1), .C1(nq2), .D1(q3), .Y1(det),
    .A2(rst_n), .B2(det), .C2(1'b1), .D2(1'b1), .Y2(and_n)
  );

  gate74LS161 U_CNT (
    .Clear(1'b1), .Load(load_n), .ENP(1'b1), .ENT(1'b1),
    .D(1'b1), .C(1'b1), .B(1'b1), .A(1'b0),
    .CLK(cp), .CO(co),
    .QD(q3), .QC(q2), .QB(q1), .QA(q0)
  );

endmodule
