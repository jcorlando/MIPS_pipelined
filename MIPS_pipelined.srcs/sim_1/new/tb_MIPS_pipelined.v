`timescale 1ns / 1ps

module tb_MIPS_pipelined;
    
// Parameters
parameter WL = 32, MEM_Depth = 512;
//Inputs
reg CLK;                                                            // Clock
// Outputs
wire [WL - 1 : 0] pc_Out = DUT.pc_Out;                              // Program Counter
wire [WL - 1 : 0] instruction = DUT.instruction;                    // Instruction Memory
wire [5 : 0] opcode = DUT.opcode;                                   // Control Unit
wire [4 : 0] rs = DUT.rs;                                           // Control Unit
wire [4 : 0] rt = DUT.rt;                                           // Control Unit
wire [4 : 0] rd = DUT.rd;                                           // Control Unit
wire [15 : 0] Imm = DUT.Imm;                                        // Control Unit
wire [4 : 0] shamt = DUT.shamt;                                     // Control Unit
wire [5 : 0] funct = DUT.funct;                                     // Control Unit
wire [25 : 0] Jaddr = DUT.Jaddr;                                    // Control Unit
wire signed [WL - 1 : 0] SImm = DUT.SImm;                           // Control Unit
wire [WL - 1 : 0] RFRD1 = DUT.RFRD1;                                // Register File
wire [WL - 1 : 0] RFRD2 = DUT.RFRD2;                                // Register File
wire [4 : 0] RFR1 = DUT.RFR1;                                       // Register File
wire [4 : 0] RFR2 = DUT.RFR2;                                       // Register File
wire [WL - 1 : 0] rf[0 : 31] = DUT.registerFile.rf;                 // Register File
wire [WL - 1 : 0] ALUSrcOut = DUT.ALUSrcOut;                        // ALU Source mux out
wire signed [WL - 1 : 0] ALU_Out = DUT.ALU_Out;                     // ALU
wire MemWriteD = DUT.MemWriteD;                                     // Data Memory
wire signed [WL - 1 : 0] DMA = DUT.dataMemory.DMA;                  // Data Memory
wire [WL - 1 : 0] DMWD = DUT.DMWD;                                  // Data Memory
wire [WL - 1 : 0] DMRD = DUT.DMRD;                                  // Data Memory
wire [WL - 1 : 0] ram[0 : MEM_Depth - 1] = DUT.dataMemory.ram;      // Data Memory
wire [WL - 1 : 0] Result = DUT.Result;                              // Result mux out
// Instantiate DUT
    top # ( .WL(WL), .MEM_Depth(MEM_Depth) ) DUT( .CLK(CLK) );      // Clock
// Clock generation
always #5 CLK <= ~CLK;
    initial
    begin
        CLK <= 0;                                   // Clock
        @(posedge CLK);                             // Clock
        @(posedge CLK);                             // Clock
        @(posedge CLK);                             // Clock
        @(posedge CLK);                             // Clock
    end
    
endmodule
