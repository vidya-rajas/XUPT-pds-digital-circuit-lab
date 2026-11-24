// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 vidya-rajas
// Project: https://github.com/vidya-rajas/XUPT-pds-digital-circuit-lab
// Free for non-commercial use only; commercial use requires a license.
// Licensing or billing issues: open an issue at the project URL above.
module tug_of_war(clk,btn_a,btn_b,btn_rst,
                  led0,led1,led2,led3,led4,led5,led6,
                  seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                  dig1,dig2,dig3,dig4);
  input  clk,btn_a,btn_b,btn_rst;
  output led0,led1,led2,led3,led4,led5,led6;
  output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp;
  output reg dig1,dig2,dig3,dig4;

  reg [15:0] div;
  reg [19:0] por;
  reg [9:0]  tdiv;

  always @(posedge clk)
    if (div == 16'd49999) div <= 16'd0;
    else                  div <= div + 1'b1;

  wire tick = (div == 16'd49999);

  initial
    begin
      div  = 16'd0;
      por  = 20'd0;
      tdiv = 10'd0;
    end

  always @(posedge clk)
    if (por != 20'hFFFFF) por <= por + 1'b1;

  wire por_busy = (por != 20'hFFFFF);

  reg [3:0] qa,qb,qr;
  reg       la,lb,lr;
  reg       pa,pb,pr;

  initial
    begin
      qa = 4'd0; qb = 4'd0; qr = 4'd0;
      la = 1'b0; lb = 1'b0; lr = 1'b0;
      pa = 1'b0; pb = 1'b0; pr = 1'b0;
    end

  always @(posedge clk)
    begin
      pa <= 1'b0;
      pb <= 1'b0;
      pr <= 1'b0;
      if (tick)
        begin
          qa <= {qa[2:0], btn_a};
          qb <= {qb[2:0], btn_b};
          qr <= {qr[2:0], btn_rst};

          if (qa == 4'b1111 && !la) begin la <= 1'b1; pa <= 1'b1; end
          else if (qa == 4'b0000)   begin la <= 1'b0; end

          if (qb == 4'b1111 && !lb) begin lb <= 1'b1; pb <= 1'b1; end
          else if (qb == 4'b0000)   begin lb <= 1'b0; end

          if (qr == 4'b1111 && !lr) begin lr <= 1'b1; pr <= 1'b1; end
          else if (qr == 4'b0000)   begin lr <= 1'b0; end
        end
    end

  reg [2:0] pos;
  reg [5:0] ca,cb;
  reg       over;
  reg [1:0] winner;

  wire [6:0] total = {1'b0,ca} + {1'b0,cb};
  wire       rst_all = pr | por_busy;

  always @(posedge clk)
    begin
      if (rst_all)
        begin
          pos    <= 3'd3;
          ca     <= 6'd0;
          cb     <= 6'd0;
          over   <= 1'b0;
          winner <= 2'd0;
        end
      else if (!over)
        begin
          if (pa)
            begin
              ca <= ca + 1'b1;
              if (pos != 3'd0) pos <= pos - 1'b1;
              if (pos == 3'd1)
                begin
                  over   <= 1'b1;
                  winner <= 2'd1;
                end
              else if (total == 7'd29)
                over <= 1'b1;
            end
          else if (pb)
            begin
              cb <= cb + 1'b1;
              if (pos != 3'd6) pos <= pos + 1'b1;
              if (pos == 3'd5)
                begin
                  over   <= 1'b1;
                  winner <= 2'd2;
                end
              else if (total == 7'd29)
                over <= 1'b1;
            end
        end
    end

  assign led0 = (pos == 3'd0);
  assign led1 = (pos == 3'd1);
  assign led2 = (pos == 3'd2);
  assign led3 = (pos == 3'd3);
  assign led4 = (pos == 3'd4);
  assign led5 = (pos == 3'd5);
  assign led6 = (pos == 3'd6);

  reg phase;

  initial phase = 1'b0;

  always @(posedge clk)
    if (tick)
      begin
        if (tdiv == 10'd999)
          begin
            tdiv  <= 10'd0;
            phase <= ~phase;
          end
        else
          tdiv <= tdiv + 1'b1;
      end

  wire [3:0] ca_t = (ca > 6'd19) ? 4'd2 : ((ca > 6'd9) ? 4'd1 : 4'd0);
  wire [3:0] cb_t = (cb > 6'd19) ? 4'd2 : ((cb > 6'd9) ? 4'd1 : 4'd0);
  wire [5:0] ca_r = (ca > 6'd19) ? (ca - 6'd20) : ((ca > 6'd9) ? (ca - 6'd10) : ca);
  wire [5:0] cb_r = (cb > 6'd19) ? (cb - 6'd20) : ((cb > 6'd9) ? (cb - 6'd10) : cb);

  reg [3:0] d1,d2,d3,d4;

  always @(*)
    begin
      if (!phase)
        begin
          d1 = ca_t;
          d2 = ca_r[3:0];
          d3 = cb_t;
          d4 = cb_r[3:0];
        end
      else
        begin
          d1 = {1'b0,pos};
          d2 = 4'hF;
          d3 = 4'hF;
          d4 = 4'hF;
        end
    end

  reg [1:0] scan;

  initial scan = 2'd0;

  always @(posedge clk)
    if (tick) scan <= scan + 1'b1;

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
  assign seg_dp = 1'b1;

endmodule
