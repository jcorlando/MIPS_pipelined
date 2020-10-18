`timescale 1ns / 1ps

module mux3 # ( parameter WL = 32 )
(
    input [1 : 0] sel,
    input [WL - 1 : 0] in_00,
    input [WL - 1 : 0] in_01,
    input [WL - 1 : 0] in_10,
    output reg [WL - 1 : 0] out
);
    always @ (*)
    begin
        case(sel)
        2'b00: out <= in_00;
        2'b01: out <= in_01;
        2'b10: out <= in_10;
        default: out <= in_00;
        endcase
    end
endmodule
