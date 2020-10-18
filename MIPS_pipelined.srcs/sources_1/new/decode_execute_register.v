`timescale 1ns / 1ps

module decode_execute_register # (parameter WL = 32)
(
    input CLK,
    input CLR,
    input RegWriteD,
    input MemtoReg,
    input MemWriteD,
    input Branch,
    input [3 : 0] ALUControlD,
    input ALUSrc,
    input RegDst,
    input [WL - 1 : 0] RFRD1,
    input [WL - 1 : 0] RFRD2,
    input [4 : 0] rs,
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
    output reg [4 : 0] rsE,
    output reg [4 : 0] rtE,
    output reg [4 : 0] rdE,
    output reg [WL - 1 : 0] SImmE,
    output reg [WL - 1 : 0] PCPlus1E,
    output reg [4 : 0] shamtE
);
    always @ (posedge CLK)
    begin
        if(CLR)
        begin
            RegWriteE <= 0;
            MemtoRegE <= 0;
            MemWriteE <= 0;
            BranchE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;
            RegDstE <= 0;
            RFRD1E <= 0;
            RFRD2E <= 0;
            rsE <= 0;
            rtE <= 0;
            rdE <= 0;
            SImmE <= 0; 
            PCPlus1E <= 0;
            shamtE <= 0;
        end
        else
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
            rsE <= rs;
            rtE <= rt;
            rdE <= rd;
            SImmE <= SImm; 
            PCPlus1E <= PCPlus1D;
            shamtE <= top.shamt;
        end
    end
endmodule
