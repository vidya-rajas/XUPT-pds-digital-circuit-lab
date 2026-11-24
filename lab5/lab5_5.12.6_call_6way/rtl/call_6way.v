// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module call_6way(clk,k1,k2,k3,k4,k5,k6,ack,
                 led1,led2,led3,led4,led5,led6,alarm,
                 seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                 dig1,dig2,dig3,dig4);
  input  clk,k1,k2,k3,k4,k5,k6,ack;
  output led1,led2,led3,led4,led5,led6,alarm;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output reg dig1,dig2,dig3,dig4;

  reg [15:0] div;

  initial div = 16'd0;

  always @(posedge clk)
    if (div == 16'd49999) div <= 16'd0;
    else                  div <= div + 1'b1;

  wire tick = (div == 16'd49999);

  reg [9:0] bs;

  initial bs = 10'd0;

  always @(posedge clk)
    if (tick) bs <= bs + 1'b1;

  reg [6:0] vin;

  always @(*) vin = {ack,k6,k5,k4,k3,k2,k1};

  reg [3:0] q [0:6];
  reg [6:0] lvl;
  reg [6:0] pls;
  integer i;

  initial
    begin
      lvl = 7'd0;
      pls = 7'd0;
      for (i = 0; i < 7; i = i + 1) q[i] = 4'd0;
    end

  always @(posedge clk)
    begin
      pls <= 7'd0;
      if (tick)
        begin
          for (i = 0; i < 7; i = i + 1)
            q[i] <= {q[i][2:0], vin[i]};
          for (i = 0; i < 7; i = i + 1)
            begin
              if (q[i] == 4'b1111 && !lvl[i])
                begin lvl[i] <= 1'b1; pls[i] <= 1'b1; end
              else if (q[i] == 4'b0000)
                lvl[i] <= 1'b0;
            end
        end
    end

  reg [5:0] pend;
  reg [3:0] last;
  reg [5:0] cd;
  reg       cd_on;
  reg [10:0] alm;
  reg       tmo;

  initial
    begin
      pend  = 6'd0;
      last  = 4'd0;
      cd    = 6'd0;
      cd_on = 1'b0;
      alm   = 11'd0;
      tmo   = 1'b0;
    end

  wire any_call = pls[5] | pls[4] | pls[3] | pls[2] | pls[1] | pls[0];

  always @(posedge clk)
    if (tick)
      begin
        if (alm != 11'd0) alm <= alm - 1'b1;

        if (any_call)
          begin
            alm <= 11'd2000;
            if (!cd_on) begin cd_on <= 1'b1; cd <= 6'd60; tmo <= 1'b0; end
          end

        if (pls[0]) begin pend[0] <= 1'b1; last <= 4'd1; end
        if (pls[1]) begin pend[1] <= 1'b1; last <= 4'd2; end
        if (pls[2]) begin pend[2] <= 1'b1; last <= 4'd3; end
        if (pls[3]) begin pend[3] <= 1'b1; last <= 4'd4; end
        if (pls[4]) begin pend[4] <= 1'b1; last <= 4'd5; end
        if (pls[5]) begin pend[5] <= 1'b1; last <= 4'd6; end

        if (pls[6])
          begin
            if (last != 4'd0) pend[last - 1'b1] <= 1'b0;
            if (pend == 6'd0) begin last <= 4'd0; cd_on <= 1'b0; end
          end

        if (cd_on && !any_call && !pls[6])
          begin
            if (cd == 6'd0) begin cd_on <= 1'b1; tmo <= 1'b1; end
            else            cd <= cd - 1'b1;
          end
      end

  assign led1 = pend[0];
  assign led2 = pend[1];
  assign led3 = pend[2];
  assign led4 = pend[3];
  assign led5 = pend[4];
  assign led6 = pend[5];

  wire blink = cd_on && !tmo && (cd <= 6'd5) && bs[9];

  assign alarm = (alm != 11'd0) | blink;

  reg [3:0] cur;
  reg [6:0] code;
  reg [1:0] scan;

  initial scan = 2'd0;

  always @(posedge clk)
    if (tick) scan <= scan + 1'b1;

  always @(*)
    begin
      cur = last;
      case (scan)
        2'd0: begin dig1 = 1'b0; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; end
        2'd1: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; end
        2'd2: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; end
        default: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; end
      endcase

      case (cur)
        4'd0: code = 7'b1111110;
        4'd1: code = 7'b0110000;
        4'd2: code = 7'b1101101;
        4'd3: code = 7'b1111001;
        4'd4: code = 7'b0110011;
        4'd5: code = 7'b1011011;
        4'd6: code = 7'b1011111;
        default: code = 7'b0000000;
      endcase
    end

  assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = ~code;
  assign seg_dp = 1'b1;

endmodule
