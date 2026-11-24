module counter_mod36(clk,rst,t1,t0,u3,u2,u1,u0);
  input  clk,rst;
  output t1,t0,u3,u2,u1,u0;

  reg [23:0] div;

  always @(posedge clk)
    div <= div + 1'b1;

  wire cp = div[23];

  wire nu1,nu2,carry,clear_u_n,load_n,rst_n,and_n,clear_u;
  wire t3_unused,t2_unused;
  wire co_u,co_t;
  wire y3_unused,y4_unused;

  gate74LS00 U_INV (
    .A1(u2), .B1(u2), .Y1(nu2),
    .A2(u1), .B2(u1), .Y2(nu1),
    .A3(clear_u_n), .B3(clear_u_n), .Y3(carry),
    .A4(rst), .B4(rst), .Y4(rst_n)
  );

  gate74LS00 U_AND (
    .A1(clear_u_n), .B1(rst_n), .Y1(and_n),
    .A2(and_n), .B2(and_n), .Y2(clear_u),
    .A3(1'b0), .B3(1'b0), .Y3(y3_unused),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

  gate74LS20 U_NAND (
    .A1(u3), .B1(nu2), .C1(nu1), .D1(u0), .Y1(clear_u_n),
    .A2(t1), .B2(t0), .C2(u2), .D2(u0), .Y2(load_n)
  );

  gate74LS163 U_UNIT (
    .Clear(clear_u), .Load(load_n), .ENP(1'b1), .ENT(1'b1),
    .D(1'b0), .C(1'b0), .B(1'b0), .A(1'b0),
    .CLK(cp), .CO(co_u),
    .QD(u3), .QC(u2), .QB(u1), .QA(u0)
  );

  gate74LS161 U_TENS (
    .Clear(rst_n), .Load(load_n), .ENP(carry), .ENT(carry),
    .D(1'b0), .C(1'b0), .B(1'b0), .A(1'b0),
    .CLK(cp), .CO(co_t),
    .QD(t3_unused), .QC(t2_unused), .QB(t1), .QA(t0)
  );

endmodule
