module subtractor(B,A,C0,S,C1);
input  B,A,C0;
output S,C1;
wire Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0;

gate74LS138 U1 (
    .G1(1'b1), .G2A(1'b0), .G2B(1'b0),
    .C(A), .B(B), .A(C0),
    .Y7(Y7), .Y6(Y6), .Y5(Y5), .Y4(Y4),
    .Y3(Y3), .Y2(Y2), .Y1(Y1), .Y0(Y0)
);

gate74LS20 U2 (
    .A1(Y1), .B1(Y2), .C1(Y4), .D1(Y7), .Y1(S),
    .A2(Y1), .B2(Y2), .C2(Y3), .D2(Y7), .Y2(C1)
);

endmodule
