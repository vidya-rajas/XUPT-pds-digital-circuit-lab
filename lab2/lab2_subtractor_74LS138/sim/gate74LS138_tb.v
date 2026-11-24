`timescale 10ns/1ns
module gate74LS138_tb( );
    reg  G1,G2A,G2B,C,B,A;
    wire Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0;
    integer i;
    parameter sim_count=10;
    gate74LS138 U1(G1,G2A,G2B,C,B,A,Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0);
    initial
        begin
            G1=0;
            G2A=1;G2B=1;
            C=1;B=1;A=1;
            for(i=0;i<sim_count;i=i+1)
                begin
                    #10 G1=1;
                    #10 G2A=0;
                    #10 G2B=0;
                    #10 C=0;B=0;A=0;
                    #10 C=0;B=0;A=1;
                    #10 C=0;B=1;A=0;
                    #10 C=0;B=1;A=1;
                    #10 C=1;B=0;A=0;
                    #10 C=1;B=0;A=1;
                    #10 C=1;B=1;A=0;
                    #10 C=1;B=1;A=1;
                end
        end
endmodule
