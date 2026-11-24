module parity_checker(B, A, C0, S, C1);
input  B, A, C0;
output S, C1;

wire nC;
wire Y1_3, Y1_2, Y1_1, Y1_0;
wire Y2_3, Y2_2, Y2_1, Y2_0;
wire n1, n2, n3, n4, n5;

gate74LS04 U_NOT (
    .A1(C0), .A2(1'b0), .A3(1'b0), .A4(1'b0), .A5(1'b0), .A6(1'b0),
    .Y1(nC), .Y2(n1),   .Y3(n2),   .Y4(n3),   .Y5(n4),   .Y6(n5)
);

gate74LS139 U_DEC (
    .G1(C0),   .B1(B), .A1(A), .Y1_3(Y1_3), .Y1_2(Y1_2), .Y1_1(Y1_1), .Y1_0(Y1_0),
    .G2(nC),   .B2(B), .A2(A), .Y2_3(Y2_3), .Y2_2(Y2_2), .Y2_1(Y2_1), .Y2_0(Y2_0)
);

gate74LS20 U_NAND (
    .A1(Y1_1), .B1(Y1_2), .C1(Y2_0), .D1(Y2_3), .Y1(S),
    .A2(Y1_0), .B2(Y1_3), .C2(Y2_1), .D2(Y2_2), .Y2(C1)
);

endmodule
