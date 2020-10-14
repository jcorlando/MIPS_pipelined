`timescale 1ns / 1ps

module execute_memory_register # ( parameter WL = 32 )
(
    input CLK,
    input RegWriteE,
    input MemtoRegE,
    input MemWriteE,
    input BranchE,
    input zero,
    input [WL - 1 : 0] ALU_Out,
    input [WL - 1 : 0] RFRD2E,
    input [4 : 0] WriteReg,
    input [WL - 1 : 0] PCBranch,
    output reg RegWriteM,
    output reg MemtoRegM,
    output reg MemWriteM,
    output reg BranchM,
    output reg zeroM,
    output reg [WL - 1 : 0] ALUOutM,
    output reg [WL - 1 : 0] WriteDataM,
    output reg [4 : 0] WriteRegM,
    output reg [WL - 1 : 0] PCBranchM
);
    
    always @ (posedge CLK)
    begin
        RegWriteM <= RegWriteE;
        MemtoRegM <= MemtoRegE;
        MemWriteM <= MemWriteE;
        BranchM <= BranchE;
        zeroM <= zero;
        ALUOutM <= ALU_Out;
        WriteDataM <= RFRD2E;
        WriteRegM <= WriteReg;
        PCBranchM <= PCBranch;
    end
    
endmodule
