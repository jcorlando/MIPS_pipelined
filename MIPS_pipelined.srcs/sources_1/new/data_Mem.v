`timescale 1ns / 1ps

module data_Mem # ( parameter WL = 32, MEM_Depth = 512 )
(
    input CLK, MemWriteM,
    input signed [WL - 1 : 0] DMA,
    input [WL - 1 : 0] DMWD,
    output [WL - 1 : 0] DMRD
);
    
    reg [WL - 1 : 0] ram[0 : MEM_Depth - 1];
    initial $readmemh("my_Data_Memory.mem", ram);
    
    assign DMRD = ram[DMA[WL - 1 : 0]];        // Word Aligned
    
    always @ (posedge CLK)
    if (MemWriteM) ram[DMA[WL - 1 : 0]] <= DMWD;    // Word Aligned
    
    
endmodule


