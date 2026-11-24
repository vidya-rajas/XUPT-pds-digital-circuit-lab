// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module freq_meter(clk,sig,g1,g0,
                  seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                  dig1,dig2,dig3,dig4);
  input  clk,sig,g1,g0;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output reg dig1,dig2,dig3,dig4;

  reg [15:0] div;

  initial div = 16'd0;

  always @(posedge clk)
    if (div == 16'd49999) div <= 16'd0;
    else                  div <= div + 1'b1;

  wire tick = (div == 16'd49999);

  wire [1:0] gsel = {g1,g0};

  reg [10:0] gms;
  reg        gate;
  reg        gate_d;

  initial
    begin
      gms    = 11'd0;
      gate   = 1'b0;
      gate_d = 1'b0;
    end

  wire [10:0] gt = (gsel == 2'd0) ? 11'd1 :
                   (gsel == 2'd1) ? 11'd10 :
                   (gsel == 2'd2) ? 11'd100 : 11'd1000;

  always @(posedge clk)
    begin
      gate_d <= gate;
      if (tick)
        begin
          if (gms == gt - 1'b1)
            begin
              gms  <= 11'd0;
              gate <= ~gate;
            end
          else
            gms <= gms + 1'b1;
        end
    end

  reg sig_d;

  initial sig_d = 1'b0;

  always @(posedge clk) sig_d <= sig;

  wire sig_rise = sig & ~sig_d;

  reg [23:0] cnt;
  reg [23:0] lat;

  initial
    begin
      cnt = 24'd0;
      lat = 24'd0;
    end

  always @(posedge clk)
    if (gate)
      begin
        if (sig_rise) cnt <= cnt + 1'b1;
      end
    else if (gate_d)
      begin
        lat <= cnt;
        cnt <= 24'd0;
      end

  wire over = (lat > 24'd9999);

  reg [13:0] t;
  reg [3:0]  n1,n2,n3,n4;
  integer i;

  always @(*)
    begin
      t  = (lat > 24'd9999) ? 14'd9999 : lat[13:0];
      n1 = 4'd0;
      n2 = 4'd0;
      n3 = 4'd0;
      for (i = 0; i < 10; i = i + 1)
        if (t >= 14'd1000) begin t = t - 14'd1000; n1 = n1 + 1'b1; end
      for (i = 0; i < 10; i = i + 1)
        if (t >= 14'd100) begin t = t - 14'd100; n2 = n2 + 1'b1; end
      for (i = 0; i < 10; i = i + 1)
        if (t >= 14'd10) begin t = t - 14'd10; n3 = n3 + 1'b1; end
      n4 = t[3:0];
    end

  reg [3:0]  d1,d2,d3,d4;
  reg        p1,p2,p3,p4;

  always @(*)
    begin
      if (over)
        begin
          d1 = 4'hE; d2 = 4'hE; d3 = 4'hE; d4 = 4'hE;
        end
      else
        begin
          d1 = n1; d2 = n2; d3 = n3; d4 = n4;
        end
      p1 = (gsel == 2'd3);
      p2 = (gsel == 2'd2);
      p3 = (gsel == 2'd1);
      p4 = 1'b0;
    end

  reg [1:0] scan;

  initial scan = 2'd0;

  always @(posedge clk)
    if (tick) scan <= scan + 1'b1;

  reg [3:0] cur;
  reg       cdp;
  reg [6:0] code;

  always @(*)
    begin
      case (scan)
        2'd0: begin dig1 = 1'b0; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; cur = d1; cdp = p1; end
        2'd1: begin dig1 = 1'b1; dig2 = 1'b0; dig3 = 1'b1; dig4 = 1'b1; cur = d2; cdp = p2; end
        2'd2: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b0; dig4 = 1'b1; cur = d3; cdp = p3; end
        default: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b0; cur = d4; cdp = p4; end
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
        4'hE: code = 7'b0000001;
        default: code = 7'b0000000;
      endcase
    end

  assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = ~code;
  assign seg_dp = ~cdp;

endmodule
