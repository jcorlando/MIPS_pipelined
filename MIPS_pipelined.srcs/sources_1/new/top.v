`timescale 1ns / 1ps

module top # (  parameter WL = 32, MEM_Depth = 512 )
(
    input CLK                                                   // Clock
);
    wire [WL - 1 : 0] PCSrcMuxOut;                              // PCSrc Mux Out
    wire [WL - 1 : 0] PCJumpMuxOut;                             // PCJump Mux Out
    wire [WL - 1 : 0] pc_Out;                                   // Program Counter
    wire [WL - 1 : 0] PCPlus1;                                  // Program Counter
    wire [WL - 1 : 0] instruction;                              // Instruction Memory
    wire [5 : 0] opcode = control_Unit.opcode;                  // Control Unit
    wire [4 : 0] rs = control_Unit.rs;                          // Control Unit
    wire [4 : 0] rt = control_Unit.rt;                          // Control Unit
    wire [4 : 0] rd = control_Unit.rd;                          // Control Unit
    wire [15 : 0] Imm = control_Unit.Imm;                       // Control Unit
    wire [4 : 0] shamt = control_Unit.shamt;                    // Control Unit
    wire [5 : 0] funct = control_Unit.funct;                    // Control Unit
    wire [25 : 0] Jaddr = control_Unit.Jaddr;                   // Control Unit
    wire signed [WL - 1 : 0] SImm = control_Unit.SImm;          // Control Unit
    wire [WL - 1 : 0] PCJump = { PCPlus1[31:26], Jaddr };       // PC Jump Wire
    wire RFWE;                                                  // Control Unit
    wire DMWE;                                                  // Control Unit
    wire ALUSrc;                                                // Control Unit
    wire MemtoReg;                                              // Control Unit
    wire RegDst;                                                // Control Unit
    wire Branch;                                                // Control Unit
    wire Jump;                                                  // Control Unit
    wire [3 : 0] ALU_Control;                                   // Control Unit
    wire [4 : 0] WriteReg;                                      // Write Reg mux out
    wire [WL - 1 : 0] RFRD1;                                    // Register File
    wire [WL - 1 : 0] RFRD2;                                    // Register File
    wire [4 : 0] RFR1 = registerFile.RFR1;                      // Register File
    wire [4 : 0] RFR2 = registerFile.RFR2;                      // Register File
    wire [WL - 1 : 0] PCBranch;                                 // PCBranch Adder Out
    wire [WL - 1 : 0] ALUSrcOut;                                // ALU Source mux out
    wire signed [WL - 1 : 0] ALU_Out;                           // ALU
    wire zero;                                                  // ALU zero flag
    wire PCSrc;                                                 // Branch AND gate
    wire [WL - 1 : 0] DMA;                                      // Data Memory
    wire [WL - 1 : 0] DMWD = RFRD2;                             // Data Memory
    wire [WL - 1 : 0] DMRD;                                     // Data Memory
    wire [WL - 1 : 0] Result;                                   // Result mux out
    
    
    mux # ( .WL(WL) )                                                                       // PCSrc Mux
        PCSrcMux( .A(PCBranch), .B(PCPlus1), .sel(PCSrc), .out(PCSrcMuxOut) );              // PCSrc Mux
    
    mux # ( .WL(WL) )                                                                       // PCJump Mux
        PCJumpMux( .A(PCJump), .B(PCSrcMuxOut), .sel(Jump), .out(PCJumpMuxOut) );           // PCJump Mux
    
    pc # ( .WL(WL) )                                                                        // Program Counter
        programCounter( .CLK(CLK), .pc_In(PCJumpMuxOut), .pc_Out(pc_Out) );                 // Program Counter
    
    adder # ( .WL(WL) )                                                                     // Program Counter Adder
        pcAdder( .pc_Out(pc_Out), .PCPlus1(PCPlus1) );                                      // Program Counter Adder
    
    inst_Mem # ( .WL(WL), .MEM_Depth(MEM_Depth) )                                           // Instruction Memory
        instMemory( .addr(pc_Out), .instruction(instruction) );                             // Instruction Memory
    
    control_Unit # ( .WL(WL) )                                                              // Control Unit
        control_Unit( .instruction(instruction), .RFWE(RFWE), .DMWE(DMWE),                  // Control Unit
                        .ALU_Control(ALU_Control), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),    // Control Unit
                            .RegDst(RegDst), .Branch(Branch), .Jump(Jump) );                // Control Unit
    
    mux # ( .WL(5) )                                                                        // WriteReg mux
        WriteRegMux( .A(rd), .B(rt), .sel(RegDst), .out(WriteReg) );                        // WriteReg mux
    
    reg_File # ( .WL(WL) )                                                                  // Register File
        registerFile( .CLK(CLK), .RFWE(RFWE), .RFR1(rs), .RFR2(rt), .RFWA(WriteReg),        // Register File
                        .RFWD(Result), .RFRD1(RFRD1), .RFRD2(RFRD2) );                      // Register File
    
    PCBranchAdder # (.WL(WL))                                                               // PCBranch Adder
        myPCBranchAdder( .A(SImm), .B(PCPlus1), .out(PCBranch) );                           // PCBranch Adder
    
    mux # ( .WL(WL) )                                                                       // ALU source mux
        ALUSrcMux( .A(SImm), .B(RFRD2), .sel(ALUSrc), .out(ALUSrcOut) );                    // ALU source mux
    
    alu # (  .WL(WL) )                                                                      // ALU
        alu( .A(RFRD1), .B(ALUSrcOut), .shamt(shamt), .ALU_Out(ALU_Out), .zero(zero),       // ALU
                .ALU_Control(ALU_Control) );                                                // ALU
    
    AndGatePCSrc andGate( .A(Branch), .B(zero), .out(PCSrc) );                              // PCSrc AND gate
    
    data_Mem # ( .WL(WL), .MEM_Depth(MEM_Depth) )                                           // Data Memory
        dataMemory( .CLK(CLK), .DMWE(DMWE), .DMA(ALU_Out), .DMWD(RFRD2), .DMRD(DMRD) );     // Data Memory
    
    mux # ( .WL(WL) )                                                                       // result mux
        resultMux( .A(DMRD), .B(ALU_Out), .sel(MemtoReg), .out(Result) );                   // result mux
    
endmodule
