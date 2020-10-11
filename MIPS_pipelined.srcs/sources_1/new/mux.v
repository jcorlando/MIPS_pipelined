`timescale 1ns / 1ps

module mux # ( parameter WL = 32 )
(
    input [WL - 1 : 0] A,
    input [WL - 1 : 0] B,
    input sel,
    output [WL - 1 : 0] out
);
    assign out = sel ? A : B;
    
endmodule
