// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module clock_24h(clk,run,sel,set_h,set_m,
                 seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                 dig1,dig2,dig3,dig4,chime);
  input  clk,run,sel,set_h,set_m;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output reg dig1,dig2,dig3,dig4;
  output chime;

  reg [23:0] cnt;

  initial cnt = 24'd0;

  always @(posedge clk)
    if (cnt == 24'd24999999) cnt <= 24'd0;
    else                     cnt <= cnt + 1'b1;

  wire tick = (cnt == 24'd24999999);
  wire [1:0] scan = cnt[17:16];

  reg [5:0] sec,min;
  reg [4:0] hour;

  initial
    begin
      sec  = 6'd0;
      min  = 6'd0;
      hour = 5'd0;
    end

  always @(posedge clk)
    if (tick)
      begin
        if (set_h)
          hour <= (hour == 5'd23) ? 5'd0 : hour + 1'b1;
        else if (set_m)
          min <= (min == 6'd59) ? 6'd0 : min + 1'b1;
        else if (run)
          begin
            if (sec == 6'd59)
              begin
                sec <= 6'd0;
                if (min == 6'd59)
                  begin
                    min  <= 6'd0;
                    hour <= (hour == 5'd23) ? 5'd0 : hour + 1'b1;
                  end
                else
                  min <= min + 1'b1;
              end
            else
              sec <= sec + 1'b1;
          end
      end

  assign chime = run & (min == 6'd0) & (sec == 6'd0);

  wire [3:0] st = (sec > 6'd49) ? 4'd5 : (sec > 6'd39) ? 4'd4 : (sec > 6'd29) ? 4'd3 :
                  (sec > 6'd19) ? 4'd2 : (sec > 6'd9)  ? 4'd1 : 4'd0;
  wire [3:0] mt = (min > 6'd49) ? 4'd5 : (min > 6'd39) ? 4'd4 : (min > 6'd29) ? 4'd3 :
                  (min > 6'd19) ? 4'd2 : (min > 6'd9)  ? 4'd1 : 4'd0;
  wire [3:0] ht = (hour > 5'd19) ? 4'd2 : ((hour > 5'd9) ? 4'd1 : 4'd0);

  wire [5:0] s10 = (st == 4'd5) ? 6'd50 : (st == 4'd4) ? 6'd40 : (st == 4'd3) ? 6'd30 :
                   (st == 4'd2) ? 6'd20 : (st == 4'd1) ? 6'd10 : 6'd0;
  wire [5:0] m10 = (mt == 4'd5) ? 6'd50 : (mt == 4'd4) ? 6'd40 : (mt == 4'd3) ? 6'd30 :
                   (mt == 4'd2) ? 6'd20 : (mt == 4'd1) ? 6'd10 : 6'd0;
  wire [5:0] h10 = (ht == 4'd2) ? 6'd20 : ((ht == 4'd1) ? 6'd10 : 6'd0);

  wire [3:0] su = (sec  - s10) & 6'hF;
  wire [3:0] mu = (min  - m10) & 6'hF;
  wire [3:0] hu = (hour - h10) & 6'hF;

  reg [3:0] d1,d2,d3,d4;

  always @(*)
    if (sel)
      begin
        d1 = ht; d2 = hu; d3 = mt; d4 = mu;
      end
    else
      begin
        d1 = mt; d2 = mu; d3 = st; d4 = su;
      end

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
