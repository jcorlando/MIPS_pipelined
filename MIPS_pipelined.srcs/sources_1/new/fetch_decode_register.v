`timescale 1ns / 1ps

module fetch_decode_register # (parameter WL = 32)
(
    input CLK,
    input CLR,
    input StallD,
    input [WL - 1 : 0] InstrF,
    input [WL - 1 : 0] PCPlus1F,
    output reg [WL - 1 : 0] InstrD,
    output reg [WL - 1 : 0] PCPlus1D
);
    initial begin InstrD <= 0; PCPlus1D <= 0; end
    
    always @ (posedge CLK)
    begin
        if(CLR)
        begin
            InstrD <= 0;
            PCPlus1D <= 0;
        end
        else
        begin
            if(!StallD)
            begin
                InstrD <= InstrF;
                PCPlus1D <= PCPlus1F;
            end
        end
    end
    
endmodule
