`timescale 1ns / 1ps

module equals # ( parameter WL = 32 )
(
    input [WL - 1 : 0] RFRD1,
    input [WL - 1 : 0] RFRD2,
    output EqualD
);
    assign EqualD = (RFRD1 == RFRD2) ? 1 : 0;
endmodule
