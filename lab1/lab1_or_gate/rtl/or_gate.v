module or_gate(a,b,f);
  input  a,b;
  output f;

  wire na,nb;
  wire y4_unused;

  gate74LS00 U1 (
    .A1(a),  .B1(a),  .Y1(na),
    .A2(b),  .B2(b),  .Y2(nb),
    .A3(na), .B3(nb), .Y3(f),
    .A4(1'b0), .B4(1'b0), .Y4(y4_unused)
  );

endmodule
