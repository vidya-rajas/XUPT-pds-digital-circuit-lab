// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module traffic_light(clk,ts1,ts0,
                     mr,my,mg,sr,sy,sg,
                     seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                     dig1,dig2,dig3,dig4);
  input  clk,ts1,ts0;
  output mr,my,mg,sr,sy,sg;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output reg dig1,dig2,dig3,dig4;

  reg [23:0] div;

  initial div = 24'd0;

  always @(posedge clk)
    if (div == 24'd24999999) div <= 24'd0;
    else                     div <= div + 1'b1;

  wire tick = (div == 24'd24999999);

  reg [15:0] dms;

  initial dms = 16'd0;

  always @(posedge clk)
    if (dms == 16'd49999) dms <= 16'd0;
    else                  dms <= dms + 1'b1;

  wire ms = (dms == 16'd49999);

  wire [7:0] tg = (ts1 & ts0) ? 8'd45 :
                  (ts1 & ~ts0) ? 8'd30 :
                  (~ts1 & ts0) ? 8'd20 : 8'd15;
  wire [7:0] ty = 8'd5;

  reg [1:0] st;
  reg [7:0] cnt;

  initial
    begin
      st  = 2'd0;
      cnt = 8'd15;
    end

  wire [7:0] dur = (st == 2'd0) ? tg :
                   (st == 2'd1) ? ty :
                   (st == 2'd2) ? tg : ty;

  always @(posedge clk)
    if (tick)
      begin
        if (cnt == 8'd0)
          begin
            st  <= st + 1'b1;
            cnt <= (st == 2'd3) ? tg :
                   (st == 2'd0) ? ty :
                   (st == 2'd1) ? tg : ty;
          end
        else
          cnt <= cnt - 1'b1;
      end

  assign mg = (st == 2'd0);
  assign my = (st == 2'd1);
  assign mr = (st == 2'd2) | (st == 2'd3);
  assign sg = (st == 2'd2);
  assign sy = (st == 2'd3);
  assign sr = (st == 2'd0) | (st == 2'd1);

  wire [7:0] main_show = (st == 2'd0) ? (tg - cnt) :
                         (st == 2'd1) ? (ty - cnt) :
                         (st == 2'd2) ? (tg + ty - cnt) : (ty - cnt);
  wire [7:0] sec_show  = (st == 2'd0) ? (tg + ty - cnt) :
                         (st == 2'd1) ? (ty - cnt) :
                         (st == 2'd2) ? (tg - cnt) : (ty - cnt);

  function [3:0] t10;
    input [7:0] v;
    begin
      if      (v > 8'd89) t10 = 4'd9;
      else if (v > 8'd79) t10 = 4'd8;
      else if (v > 8'd69) t10 = 4'd7;
      else if (v > 8'd59) t10 = 4'd6;
      else if (v > 8'd49) t10 = 4'd5;
      else if (v > 8'd39) t10 = 4'd4;
      else if (v > 8'd29) t10 = 4'd3;
      else if (v > 8'd19) t10 = 4'd2;
      else if (v > 8'd9)  t10 = 4'd1;
      else                t10 = 4'd0;
    end
  endfunction

  function [7:0] b10;
    input [3:0] t;
    begin
      case (t)
        4'd1: b10 = 8'd10;
        4'd2: b10 = 8'd20;
        4'd3: b10 = 8'd30;
        4'd4: b10 = 8'd40;
        4'd5: b10 = 8'd50;
        4'd6: b10 = 8'd60;
        4'd7: b10 = 8'd70;
        4'd8: b10 = 8'd80;
        4'd9: b10 = 8'd90;
        default: b10 = 8'd0;
      endcase
    end
  endfunction

  wire [3:0] mt = t10(main_show);
  wire [3:0] mu = (main_show - b10(mt)) & 8'h0F;
  wire [3:0] st2 = t10(sec_show);
  wire [3:0] su = (sec_show - b10(st2)) & 8'h0F;

  reg [3:0] d1,d2,d3,d4;

  always @(*)
    begin
      d1 = mt; d2 = mu; d3 = st2; d4 = su;
    end

  reg [1:0] scan;

  initial scan = 2'd0;

  always @(posedge clk)
    if (ms) scan <= scan + 1'b1;

  reg [3:0] cur;
  reg [6:0] code;

  always @(*)
    begin
      case (scan)
        2'd0: begin dig1 = 1'b0; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; cur = d1; end
        2'd1: begin dig1 = 1'b1; dig2 = 1'b0; dig3 = 1'b1; dig4 = 1'b1; cur = d2; end
        2'd2: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b0; dig4 = 1'b1; cur = d3; end
        default: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b0; cur = d4; end
      endcase

      case (cur)
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
  assign seg_dp = (scan == 2'd1) ? 1'b0 : 1'b1;

endmodule
