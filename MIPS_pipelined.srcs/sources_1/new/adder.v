`timescale 1ns / 1ps

module adder # (parameter WL = 32)
(
    input [WL - 1 : 0] pc_Out,
    output [WL - 1 : 0] PCPlus1
);
    
    assign PCPlus1 = pc_Out + 1;
    
endmodule
