module multiplier_2x2(a1,a0,b1,b0,p3,p2,p1,p0);
  input  a1,a0,b1,b0;
  output p3,p2,p1,p0;

  wire n1,n2,n3;
  wire c1;

  assign p0 = a0 & b0;
  assign n1 = a1 & b0;
  assign n2 = a0 & b1;
  assign n3 = a1 & b1;

  gate74LS283 U1 (
    .A1(n2), .A2(1'b0), .A3(1'b0), .A4(1'b0),
    .B1(n1), .B2(1'b0), .B3(1'b0), .B4(1'b0),
    .C0(1'b0),
    .S1(p1), .S2(c1)
  );

  gate74LS283 U2 (
    .A1(c1), .A2(1'b0), .A3(1'b0), .A4(1'b0),
    .B1(n3), .B2(1'b0), .B3(1'b0), .B4(1'b0),
    .C0(1'b0),
    .S1(p2), .S2(p3)
  );

endmodule
