module quiz_6way(clk,k1,k2,k3,k4,k5,k6,host,
                 led1,led2,led3,led4,
                 seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g,seg_dp,
                 dig1,dig2,dig3,dig4);
  input  clk,k1,k2,k3,k4,k5,k6,host;
  output led1,led2,led3,led4;
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

  always @(*) vin = {host,k6,k5,k4,k3,k2,k1};

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

  reg [10:0] hold;
  reg        armed;
  reg [3:0]  win;
  reg [3:0]  cd;
  reg [9:0]  bl;

  initial
    begin
      hold  = 11'd0;
      armed = 1'b0;
      win   = 4'd0;
      cd    = 4'd0;
      bl    = 10'd0;
    end

  always @(posedge clk)
    if (tick)
      begin
        if (host) hold <= hold + 1'b1;
        else      hold <= 11'd0;

        if (hold == 11'd1500)
          begin
            armed <= 1'b0;
            win   <= 4'd0;
            cd    <= 4'd0;
          end
        else if (pls[6] && hold == 11'd0)
          begin
            if (!armed && win == 4'd0)
              begin
                armed <= 1'b1;
                cd    <= 4'd10;
              end
          end

        if (armed)
          begin
            if (pls[0]) begin win <= 4'd1; armed <= 1'b0; bl <= 10'd2000; end
            else if (pls[1]) begin win <= 4'd2; armed <= 1'b0; bl <= 10'd2000; end
            else if (pls[2]) begin win <= 4'd3; armed <= 1'b0; bl <= 10'd2000; end
            else if (pls[3]) begin win <= 4'd4; armed <= 1'b0; bl <= 10'd2000; end
            else if (pls[4]) begin win <= 4'd5; armed <= 1'b0; bl <= 10'd2000; end
            else if (pls[5]) begin win <= 4'd6; armed <= 1'b0; bl <= 10'd2000; end
            else if (cd == 4'd0) armed <= 1'b0;
            else cd <= cd - 1'b1;
          end

        if (bl != 10'd0) bl <= bl - 1'b1;
      end

  wire bar_on = armed || (bl != 10'd0);
  wire [2:0] lvlv = (cd >= 4'd8) ? 3'd4 :
                    (cd >= 4'd6) ? 3'd3 :
                    (cd >= 4'd3) ? 3'd2 :
                    (cd >= 4'd1) ? 3'd1 : 3'd0;

  wire flash = (cd <= 4'd5) && bs[9];

  assign led1 = bar_on & ((lvlv >= 3'd1) || flash);
  assign led2 = bar_on & ((lvlv >= 3'd2) || flash);
  assign led3 = bar_on & ((lvlv >= 3'd3) || flash);
  assign led4 = bar_on & ((lvlv >= 3'd4) || flash);

  reg [3:0] d1,d2,d3;

  always @(*)
    begin
      d1 = win;
      if (armed) begin d2 = 4'hF; d3 = cd; end
      else       begin d2 = 4'hF; d3 = cd; end
    end

  reg [1:0] scan;

  initial scan = 2'd0;

  always @(posedge clk)
    if (tick) scan <= scan + 1'b1;

  reg [3:0] cur;
  reg [6:0] code;
  reg       blank;

  always @(*)
    begin
      case (scan)
        2'd0: begin dig1 = 1'b0; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; cur = d1; blank = 1'b0; end
        2'd1: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b1; cur = 4'hF; blank = 1'b1; end
        2'd2: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b0; dig4 = 1'b1; cur = 4'hF; blank = 1'b1; end
        default: begin dig1 = 1'b1; dig2 = 1'b1; dig3 = 1'b1; dig4 = 1'b0; cur = d3; blank = 1'b0; end
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
