module counter_mod8_start9(clk,rst,q3,q2,q1,q0);
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

  wire nq0,nq1,nq2,nq3,rst_n,det;
  wire and_n,load_n,y3u1,y4u1;
  wire co;

  gate74LS00 U_INV1 (
    .A1(q0), .B1(q0), .Y1(nq0),
    .A2(q1), .B2(q1), .Y2(nq1),
    .A3(q2), .B3(q2), .Y3(nq2),
    .A4(q3), .B4(q3), .Y4(nq3)
  );

  gate74LS00 U_INV2 (
    .A1(rst), .B1(rst), .Y1(rst_n),
    .A2(and_n), .B2(and_n), .Y2(load_n),
    .A3(1'b0), .B3(1'b0), .Y3(y3u1),
    .A4(1'b0), .B4(1'b0), .Y4(y4u1)
  );

  gate74LS20 U_NAND (
    .A1(nq0), .B1(nq1), .C1(nq2), .D1(nq3), .Y1(det),
    .A2(rst_n), .B2(det), .C2(1'b1), .D2(1'b1), .Y2(and_n)
  );

  gate74LS161 U_CNT (
    .Clear(1'b1), .Load(load_n), .ENP(1'b1), .ENT(1'b1),
    .D(1'b1), .C(1'b0), .B(1'b0), .A(1'b1),
    .CLK(cp), .CO(co),
    .QD(q3), .QC(q2), .QB(q1), .QA(q0)
  );

endmodule
