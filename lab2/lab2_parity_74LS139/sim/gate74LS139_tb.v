`timescale 10ns/1ns
module gate74LS139_tb( );
    reg  G1,B1,A1;
    reg  G2,B2,A2;
    wire Y1_3,Y1_2,Y1_1,Y1_0;
    wire Y2_3,Y2_2,Y2_1,Y2_0;
    gate74LS139 U1(G1,B1,A1,Y1_3,Y1_2,Y1_1,Y1_0,G2,B2,A2,Y2_3,Y2_2,Y2_1,Y2_0);
    integer i,j;
    parameter sim_count=10;
    initial
        begin
            G1=1;
            B1=1;A1=1;
            for(i=0;i<sim_count;i=i+1)
                begin
                    #10 G1=0;
                    #10 B1=0;A1=0;
                    #10 B1=0;A1=1;
                    #10 B1=1;A1=0;
                    #10 B1=1;A1=1;
                end
        end
    initial
        begin
            G2=1;
            B2=1;A2=1;
            for(i=0;i<sim_count;i=i+1)
                begin
                    #10 G2=0;
                    #10 B2=0;A2=0;
                    #10 B2=0;A2=1;
                    #10 B2=1;A2=0;
                    #10 B2=1;A2=1;
                end
        end
endmodule
