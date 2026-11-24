`timescale 10ns/1ns
module gate74LS151_tb( );
    reg [7:0] Din;
    reg C,B,A,STROBE;
    wire Y,W;
    gate74LS151 U1(Din,C,B,A,STROBE,Y,W);
    integer i;
    parameter sim_count=10;
    initial
        begin
            STROBE=1;
            Din=8'b0000_0000;
            for(i=0;i<sim_count;i=i+1)
                begin
                    #10 STROBE=0;
                    #10 Din=8'b0000_0001; {C,B,A}=3'b000;
                    #10 Din=8'b0000_0010; {C,B,A}=3'b001;
                    #10 Din=8'b0000_0100; {C,B,A}=3'b010;
                    #10 Din=8'b0000_1000; {C,B,A}=3'b011;
                    #10 Din=8'b0001_0000; {C,B,A}=3'b100;
                    #10 Din=8'b0010_0000; {C,B,A}=3'b101;
                    #10 Din=8'b0100_0000; {C,B,A}=3'b110;
                    #10 Din=8'b1000_0000; {C,B,A}=3'b111;
                    #10 Din=8'b1111_1110; {C,B,A}=3'b000;
                    #10 Din=8'b1111_1101; {C,B,A}=3'b001;
                    #10 Din=8'b1111_1011; {C,B,A}=3'b010;
                    #10 Din=8'b1111_0111; {C,B,A}=3'b011;
                    #10 Din=8'b1110_1111; {C,B,A}=3'b100;
                    #10 Din=8'b1101_1111; {C,B,A}=3'b101;
                    #10 Din=8'b1011_1111; {C,B,A}=3'b110;
                    #10 Din=8'b0111_1111; {C,B,A}=3'b111;
                end
        $stop;

        end
endmodule
