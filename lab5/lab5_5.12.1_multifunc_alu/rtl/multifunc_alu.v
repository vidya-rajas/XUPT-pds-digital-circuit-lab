module multifunc_alu(a,b,c1,c0,d1,d0,led_add,led_sub,led_mul,sign,
           seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
           dig1,dig2,dig3,dig4);
  input  a,b,c1,c0,d1,d0;
  output led_add,led_sub,led_mul,sign;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output dig1,dig2,dig3,dig4;

  wire gt,lt,eq;
  wire [3:0] sum,dif,mag,prod,sub_r,res;
  wire [3:0] difn;
  wire neg;
  wire p0,n1,n2,n3,carry1;
  wire co1,co2,co3;
  reg  [6:0] code;

  assign gt = a  & ~b;
  assign lt = ~a &  b;
  assign eq = ~(gt | lt);

  assign difn = ~dif;
  assign neg  =  dif[3];
  assign sub_r = neg ? mag : dif;
  assign res   = gt ? sum : (eq ? prod : sub_r);

  assign led_add = gt;
  assign led_sub = lt;
  assign led_mul = eq;
  assign sign    = lt & neg;

  assign p0 = c0 & d0;
  assign n1 = c1 & d0;
  assign n2 = c0 & d1;
  assign n3 = c1 & d1;

  gate74LS283 U_SUM (
    .A1(c0), .A2(c1), .A3(1'b0), .A4(1'b0),
    .B1(d0), .B2(d1), .B3(1'b0), .B4(1'b0),
    .C0(1'b0),
    .S1(sum[0]), .S2(sum[1]), .S3(sum[2]), .S4(sum[3]), .C4(co1)
  );

  gate74LS283 U_DIF (
    .A1(c0), .A2(c1), .A3(1'b0), .A4(1'b0),
    .B1(~d0), .B2(~d1), .B3(1'b1), .B4(1'b1),
    .C0(1'b1),
    .S1(dif[0]), .S2(dif[1]), .S3(dif[2]), .S4(dif[3]), .C4(co2)
  );

  gate74LS283 U_ABS (
    .A1(difn[0]), .A2(difn[1]), .A3(difn[2]), .A4(difn[3]),
    .B1(1'b0), .B2(1'b0), .B3(1'b0), .B4(1'b0),
    .C0(1'b1),
    .S1(mag[0]), .S2(mag[1]), .S3(mag[2]), .S4(mag[3]), .C4(co3)
  );

  gate74LS283 U_M1 (
    .A1(n2), .A2(1'b0), .A3(1'b0), .A4(1'b0),
    .B1(n1), .B2(1'b0), .B3(1'b0), .B4(1'b0),
    .C0(1'b0),
    .S1(prod[1]), .S2(carry1)
  );

  gate74LS283 U_M2 (
    .A1(carry1), .A2(1'b0), .A3(1'b0), .A4(1'b0),
    .B1(n3), .B2(1'b0), .B3(1'b0), .B4(1'b0),
    .C0(1'b0),
    .S1(prod[2]), .S2(prod[3])
  );

  assign prod[0] = p0;

  always @(*)
    begin
      case (res)
        4'd0: code = 7'b1111110;
        4'd1: code = 7'b0110000;
        4'd2: code = 7'b1101101;
        4'd3: code = 7'b1111001;
        4'd4: code = 7'b0110011;
        4'd5: code = 7'b1011011;
        4'd6: code = 7'b1011111;
        4'd7: code = 7'b1110000;
        4'd8: code = 7'b1111111;
        4'd9: code = 7'b1111011;
        default: code = 7'b0000000;
      endcase
    end

  assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = ~code;
  assign seg_dp = 1'b1;

  assign dig1 = 1'b1;
  assign dig2 = 1'b1;
  assign dig3 = 1'b1;
  assign dig4 = 1'b0;

endmodule
