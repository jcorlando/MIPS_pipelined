`timescale 1ns / 1ps

module PCBranchAdder # (parameter WL = 32)
(
    input [WL - 1 : 0] A,
    input [WL - 1 : 0] B,
    output [WL - 1 : 0] out
);
    assign out = A + B;
endmodule
