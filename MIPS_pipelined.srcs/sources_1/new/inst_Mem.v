`timescale 1ns / 1ps

module inst_Mem # ( parameter WL = 32, MEM_Depth = 512 )
(
    input [WL - 1 : 0] addr,
    output wire [WL - 1 : 0] instruction
);

    reg [WL - 1 : 0] rom[ 0 : MEM_Depth - 1];

    initial $readmemh("my_Inst_Memory.mem", rom);

    assign instruction = rom[addr];

endmodule


