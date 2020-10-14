`timescale 1ns / 1ps

module memory_writeback_register # (parameter WL = 32)
(
    input CLK,
    input RegWriteM,
    input MemtoRegM,
    input [WL - 1 : 0] ALUOutM,
    input [WL - 1 : 0] DMRD,
    input [4 : 0] WriteRegM,
    output reg RegWriteW,
    output reg MemtoRegW,
    output reg [WL - 1 : 0] ALUOutW,
    output reg [WL - 1 : 0] ReadDataW,
    output reg [4 : 0] WriteRegW
);
    
    
    always @ (posedge CLK)
    begin
        RegWriteW <= RegWriteM;
        MemtoRegW <= MemtoRegM;
        ALUOutW <= ALUOutM;
        ReadDataW <= DMRD;
        WriteRegW <= WriteRegM;
    end
    
    
endmodule
