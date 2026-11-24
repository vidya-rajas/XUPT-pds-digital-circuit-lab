module xor_gate(a,b,f);
  input  a,b;
  output f;

  wire n1,n2,n3;

  gate74LS00 U1 (
    .A1(a), .B1(b),  .Y1(n1),
    .A2(a), .B2(n1), .Y2(n2),
    .A3(b), .B3(n1), .Y3(n3),
    .A4(n2), .B4(n3), .Y4(f)
  );

endmodule
