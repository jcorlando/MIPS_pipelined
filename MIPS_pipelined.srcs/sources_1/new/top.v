`timescale 1ns / 1ps

module top # (  parameter WL = 32, MEM_Depth = 512 )
(
    input CLK                                                   // Clock
);
    wire [WL - 1 : 0] PCSrcMuxOut;                              // PCSrc Mux Out
    wire [WL - 1 : 0] PCJumpMuxOut;                             // PCJump Mux Out
    wire [WL - 1 : 0] pc_Out;                                   // Program Counter
    wire [WL - 1 : 0] PCPlus1;                                  // Program Counter                  NOT USED!!!
    wire [WL - 1 : 0] PCPlus1F;                                 // Program Counter Fetch
    wire [WL - 1 : 0] PCPlus1D;                                 // Program Counter Decode
    wire [WL - 1 : 0] instruction;                              // Instruction Memory               NOT USED!!!
    wire [WL - 1 : 0] InstrF;                                   // Instruction Memory Fetch
    wire [WL - 1 : 0] InstrD;                                   // Instruction Memory Decode
    wire [5 : 0] opcode = control_Unit.opcode;                  // Control Unit
    wire [4 : 0] rs = control_Unit.rs;                          // Control Unit
    wire [4 : 0] rt = control_Unit.rt;                          // Control Unit
    wire [4 : 0] rd = control_Unit.rd;                          // Control Unit
    wire [15 : 0] Imm = control_Unit.Imm;                       // Control Unit
    wire [4 : 0] shamt = control_Unit.shamt;                    // Control Unit
    wire [5 : 0] funct = control_Unit.funct;                    // Control Unit
    wire [25 : 0] Jaddr = control_Unit.Jaddr;                   // Control Unit
    wire signed [WL - 1 : 0] SImm = control_Unit.SImm;          // Control Unit
    wire [WL - 1 : 0] PCJump = { PCPlus1D[31:26], Jaddr };      // PC Jump Wire
    
    wire RegWriteD;                                             // Control Unit
    wire MemtoReg;                                              // Control Unit
    wire MemWriteD;                                             // Control Unit
    wire Branch;                                                // Control Unit
    wire [3 : 0] ALUControlD;                                   // Control Unit
    wire ALUSrc;                                                // Control Unit
    wire RegDst;                                                // Control Unit
    wire Jump;                                                  // Control Unit
    
    wire [4 : 0] WriteReg;                                      // Write Reg mux out
    
    
    wire [WL - 1 : 0] RFRD1;                                    // Register File
    wire [WL - 1 : 0] RFRD2;                                    // Register File
    wire [4 : 0] RFR1 = registerFile.RFR1;                      // Register File
    wire [4 : 0] RFR2 = registerFile.RFR2;                      // Register File
    
    wire RegWriteE;                                             // decode_execute_register
    wire MemtoRegE;                                             // decode_execute_register
    wire MemWriteE;                                             // decode_execute_register
    wire BranchE;                                               // decode_execute_register
    wire [3 : 0] ALUControlE;                                   // decode_execute_register
    wire ALUSrcE;                                               // decode_execute_register
    wire RegDstE;                                               // decode_execute_register
    wire [WL - 1 : 0] RFRD1E;                                   // decode_execute_register
    wire [WL - 1 : 0] RFRD2E;                                   // decode_execute_register
    wire [4 : 0] rsE;                                           // decode_execute_register
    wire [4 : 0] rtE;                                           // decode_execute_register
    wire [4 : 0] rdE;                                           // decode_execute_register
    wire [WL - 1 : 0] SImmE;                                    // decode_execute_register
    wire [WL - 1 : 0] PCPlus1E;                                 // decode_execute_register
    wire [4 : 0] shamtE;                                        // decode_execute_register
    
    wire [WL - 1 : 0] PCBranch;                                 // PCBranch Adder Out
    
    wire [WL - 1 : 0] ALUSrcOut;                                // ALU Source mux out
    wire zero;                                                  // ALU zero flag
    wire signed [WL - 1 : 0] ALU_Out;                           // ALU
    wire PCSrc;                                                 // Branch AND gate
    
    wire RegWriteM;                                                             // execute_memory_register
    wire MemtoRegM;                                                             // execute_memory_register
    wire MemWriteM;                                                             // execute_memory_register
    wire BranchM;                                                               // execute_memory_register
    wire zeroM;                                                                 // execute_memory_register
    wire signed [WL - 1 : 0] ALUOutM;                                           // execute_memory_register
    wire [WL - 1 : 0] WriteDataM = execute_memory_register.WriteDataM;          // execute_memory_register
    wire [4 : 0] WriteRegM;                                                     // execute_memory_register
    wire [WL - 1 : 0] PCBranchM;                                                // execute_memory_register
    
    wire [WL - 1 : 0] DMA;                                                      // Data Memory
    wire [WL - 1 : 0] DMWD = RFRD2;                                             // Data Memory
    wire [WL - 1 : 0] DMRD;                                                     // Data Memory
    
    wire RegWriteW;                                                             // memory_writeback_register
    wire MemtoRegW;                                                             // memory_writeback_register
    wire signed [WL - 1 : 0] ALUOutW;                                           // memory_writeback_register
    wire [WL - 1 : 0] ReadDataW;                                                // memory_writeback_register
    wire [4 : 0] WriteRegW;                                                     // memory_writeback_register
    
    wire [WL - 1 : 0] Result;                                                   // Result mux out
    
    wire FlushE;                                                                // Hazard Unit
    wire StallF;                                                                // Hazard Unit
    wire StallD;                                                                // Hazard Unit
    wire ForwardAD;                                                             // Hazard Unit
    wire ForwardBD;                                                             // Hazard Unit
    
    wire EqualD;                                                                // Equals unit output
    
    wire [WL - 1 : 0] RFRD1_mux_out;                                            // RFRD1 mux out
    wire [WL - 1 : 0] RFRD2_mux_out;                                            // RFRD2 mux out
    
    
    
    hazard_unit hazard_unit( .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .MemtoRegM(MemtoRegM),               // Hazard Unit
    .RegWriteE(RegWriteE), .Branch(Branch), .Jump(Jump), .MemtoRegE(MemtoRegE), .rs(rs), .rt(rt),               // Hazard Unit
    .rsE(rsE), .rtE(rtE), .WriteReg(WriteReg), .WriteRegM(WriteRegM), .WriteRegW(WriteRegW),                    // Hazard Unit
    .FlushE(FlushE), .StallF(StallF), .StallD(StallD), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD) );          // Hazard Unit
    
    
    mux # ( .WL(WL) )                                                                               // RFRD1 Mux
        RFRD1_mux( .B(RFRD1), .A(ALUOutM), .sel(ForwardAD), .out(RFRD1_mux_out) );                  // RFRD1 Mux
    
    
    mux # ( .WL(WL) )                                                                               // RFRD2 Mux
        RFRD2_mux( .B(RFRD2), .A(ALUOutM), .sel(ForwardBD), .out(RFRD2_mux_out) );                  // RFRD2 Mux
    
    
    PCBranchAdder # (.WL(WL))                                                                       // PCBranch Adder
        myPCBranchAdder( .A(SImm), .B(PCPlus1D), .out(PCBranch) );                                  // PCBranch Adder
    
    equals equals( .RFRD1(RFRD1_mux_out), .RFRD2(RFRD2_mux_out), .EqualD(EqualD) );                 // Equals comparison
    
    
    AndGatePCSrc andGate( .A(Branch), .B(EqualD), .out(PCSrc) );                        // PCSrc AND gate
    
    
    mux # ( .WL(WL) )                                                                   // PCSrc Mux
        PCSrcMux( .A(PCBranch), .B(PCPlus1F), .sel(PCSrc), .out(PCSrcMuxOut) );         // PCSrc Mux
    
    
    mux # ( .WL(WL) )                                                                                   // PCJump Mux
        PCJumpMux( .A(PCJump), .B(PCSrcMuxOut), .sel(Jump), .out(PCJumpMuxOut) );                       // PCJump Mux
    
    
    adder # ( .WL(WL) )                                                                                 // Program Counter Adder
        pcAdder( .pc_Out(pc_Out), .PCPlus1(PCPlus1F) );                                                 // Program Counter Adder
    
    
    pc # ( .WL(WL) )                                                                                    // Program Counter
        programCounter( .CLK(CLK), .StallF(StallF), .pc_In(PCJumpMuxOut), .pc_Out(pc_Out) );            // Program Counter
    
    
    inst_Mem # ( .WL(WL), .MEM_Depth(MEM_Depth) )                                                       // Instruction Memory
        instMemory( .addr(pc_Out), .instruction(InstrF) );                                              // Instruction Memory
    
    
    fetch_decode_register  fetch_decode_register( .CLK(CLK), .CLR(PCSrc || Jump), .StallD(StallD),      // Fetch/Decode Register
        .InstrF(InstrF), .PCPlus1F(PCPlus1F), .InstrD(InstrD),  .PCPlus1D(PCPlus1D) );                  // Fetch/Decode Register
    
    
    control_Unit # ( .WL(WL) )                                                                          // Control Unit
        control_Unit( .instruction(InstrD), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD),               // Control Unit
                        .ALUControlD(ALUControlD), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),                // Control Unit
                            .RegDst(RegDst), .Branch(Branch), .Jump(Jump) );                            // Control Unit
    
    
    reg_File # ( .WL(WL) )                                                                              // Register File
        registerFile( .CLK(CLK), .RegWriteW(RegWriteW), .RFR1(rs), .RFR2(rt), .RFWA(WriteRegW),         // Register File
                        .RFWD(Result), .RFRD1(RFRD1), .RFRD2(RFRD2) );                                  // Register File
    
    
    decode_execute_register decode_execute_register(  .CLK(CLK), .CLR(hazard_unit.FlushE) ,             // Decode/Execute Register
    .RegWriteD(RegWriteD),                                                                              // Decode/Execute Register
    .MemtoReg(MemtoReg), .MemWriteD(MemWriteD), .Branch(Branch), .ALUControlD(ALUControlD),             // Decode/Execute Register
    .ALUSrc(ALUSrc), .RegDst(RegDst), .RFRD1(RFRD1), .RFRD2(RFRD2), .rs(rs), .rt(rt), .rd(rd),          // Decode/Execute Register
    .SImm(SImm), .PCPlus1D(PCPlus1D), .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE),                     // Decode/Execute Register
    .MemWriteE(MemWriteE), .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE),             // Decode/Execute Register
    .RegDstE(RegDstE), .RFRD1E(RFRD1E), .RFRD2E(RFRD2E), .rsE(rsE), .rtE(rtE), .rdE(rdE),               // Decode/Execute Register
    .SImmE(SImmE), .PCPlus1E(PCPlus1E), .shamtE(shamtE) );                                              // Decode/Execute Register
    
    
    
    
    
    mux3 RFRD1E_mux3( .sel(hazard_unit.ForwardAE), .in_00(RFRD1E), .in_01(Result), .in_10(ALUOutM) );       // Top 3 Mux
    
    
    mux3 ALUSrcMux_mux3( .sel(hazard_unit.ForwardBE), .in_00(RFRD2E), .in_01(Result), .in_10(ALUOutM) );    // Bot 3 Mux
    
    
    mux # ( .WL(5) )                                                                                    // WriteReg mux
        WriteRegMux( .A(rdE), .B(rtE), .sel(RegDstE), .out(WriteReg) );                                 // WriteReg mux
    
    
    mux # ( .WL(WL) )                                                                                   // ALU source mux
        ALUSrcMux( .A(SImmE), .B(ALUSrcMux_mux3.out), .sel(ALUSrcE), .out(ALUSrcOut) );                 // ALU source mux
    
    
    alu # (  .WL(WL) )                                                                                      // ALU
        alu( .A( RFRD1E_mux3.out ), .B(ALUSrcOut), .shamt(shamtE), .ALU_Out(ALU_Out), .zero(zero),           // ALU
                .ALUControlE(ALUControlE) );                                                                // ALU
    
    
    execute_memory_register execute_memory_register( .CLK(CLK), .RegWriteE(RegWriteE),              // Execute/Memory Register
    .MemtoRegE(MemtoRegE), .MemWriteE(MemWriteE), .BranchE(BranchE), .zero(zero),                   // Execute/Memory Register
    .ALU_Out(ALU_Out), .RFRD2E(ALUSrcMux_mux3.out), .WriteReg(WriteReg), .PCBranch(PCBranch),       // Execute/Memory Register
    .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM), .MemWriteM(MemWriteM),                            // Execute/Memory Register
    .BranchM(BranchM), .zeroM(zeroM), .ALUOutM(ALUOutM), .WriteDataM(),                             // Execute/Memory Register
    .WriteRegM(WriteRegM), .PCBranchM(PCBranchM) );                                                 // Execute/Memory Register
    
    
    data_Mem # ( .WL(WL), .MEM_Depth(MEM_Depth) )                                                               // Data Memory
        dataMemory( .CLK(CLK), .MemWriteM(MemWriteM), .DMA(ALUOutM), .DMWD(WriteDataM), .DMRD(DMRD) );          // Data Memory
    
    
    memory_writeback_register memory_writeback_register                                 // Memory/Writeback Register
    (                                                                                   // Memory/Writeback Register
      .CLK(CLK), .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM),                          // Memory/Writeback Register
      .ALUOutM(ALUOutM), .DMRD(DMRD), .WriteRegM(WriteRegM),                            // Memory/Writeback Register
      .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW), .ALUOutW(ALUOutW),                  // Memory/Writeback Register
      .ReadDataW(ReadDataW), .WriteRegW(WriteRegW)                                      // Memory/Writeback Register
    );
    
    mux # ( .WL(WL) )                                                                                   // result mux
        resultMux( .A(ReadDataW), .B(ALUOutW), .sel(MemtoRegW), .out(Result) );                         // result mux
    
endmodule
