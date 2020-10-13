`timescale 1ns / 1ps

module decode_execute_register # (parameter WL = 32)
(
    input CLK,
    input RegWriteD,
    input MemtoReg,
    input MemWriteD,
    input Branch,
    input [3 : 0] ALUControlD,
    input ALUSrc,
    input RegDst,
    input [WL - 1 : 0] RFRD1,
    input [WL - 1 : 0] RFRD2,
    input [4 : 0] rt,
    input [4 : 0] rd,
    input [WL - 1 : 0] SImm,
    input [WL - 1 : 0] PCPlus1D,
    output reg RegWriteE,
    output reg MemtoRegE,
    output reg MemWriteE,
    output reg BranchE,
    output reg [3 : 0] ALUControlE,
    output reg ALUSrcE,
    output reg RegDstE,
    output reg [WL - 1 : 0] RFRD1E,
    output reg [WL - 1 : 0] RFRD2E,
    output reg [4 : 0] rtE,
    output reg [4 : 0] rdE,
    output reg [WL - 1 : 0] SImmE,
    output reg [WL - 1 : 0] PCPlus1E
);
    always @ (posedge CLK)
    begin
        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoReg;
        MemWriteE <= MemWriteD;
        BranchE <= Branch;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrc;
        RegDstE <= RegDst;
        RFRD1E <= RFRD1;
        RFRD2E <= RFRD2;
        rtE <= rt;
        rdE <= rd;
        SImmE <= SImm; 
        PCPlus1E <= PCPlus1D;
    end
endmodule
