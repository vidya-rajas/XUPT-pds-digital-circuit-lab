module ring_counter(clk,clr_n,qa,qb,qc,qd);
  input  clk,clr_n;
  output qa,qb,qc,qd;

  reg [24:0] cnt;
  reg        cp;

  initial
    begin
      cnt = 25'd0;
      cp  = 1'b0;
    end

  always @(posedge clk or negedge clr_n)
    begin
      if (!clr_n)
        begin
          cnt <= 25'd0;
          cp  <= 1'b0;
        end
      else if (cnt == 25'd24999999)
        begin
          cnt <= 25'd0;
          cp  <= ~cp;
        end
      else
        cnt <= cnt + 1'b1;
    end

  wire na,nc,nd,s1,illegal_n,sr,sl;
  wire y4_unused;

  gate74LS00 U_INV (
    .A1(qa),  .B1(qa),  .Y1(na),
    .A2(qc),  .B2(qc),  .Y2(nc),
    .A3(qd),  .B3(qd),  .Y3(nd),
    .A4(illegal_n), .B4(illegal_n), .Y4(s1)
  );

  gate74LS20 U_DEC (
    .A1(na), .B1(qb), .C1(nc), .D1(nd), .Y1(illegal_n),
    .A2(1'b1), .B2(1'b1), .C2(1'b1), .D2(1'b1), .Y2(y4_unused)
  );

  gate74LS194 U_SR (
    .Clear(clr_n), .S1(s1), .S0(illegal_n),
    .Left(1'b0), .Right(nd),
    .A(s1), .B(1'b0), .C(1'b0), .D(1'b0),
    .CLK(cp),
    .QA(qa), .QB(qb), .QC(qc), .QD(qd)
  );

endmodule
