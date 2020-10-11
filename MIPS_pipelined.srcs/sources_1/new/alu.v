`timescale 1ns / 1ps

module alu # ( parameter WL = 32 )
(
    input signed [WL - 1 : 0] A, B,
    input [4 : 0] shamt,
    input [3 : 0] ALU_Control,
    output reg zero,
    output reg signed [WL - 1 : 0] ALU_Out,
    output reg OVF
);
    always @(*)
    begin
        case(ALU_Control)
        4'b0000: // Addition
           ALU_Out <= A + B;
        4'b0001: // Subtraction
           ALU_Out <= A - B;
        4'b0010: // Logical shift-left
           ALU_Out <= B << shamt;
        4'b0011: // Logical shift-right
           ALU_Out <= B >> shamt;
        4'b0100: // Logical variable shift-left
           ALU_Out <= B << A;
        4'b0101: // Logical variabel shift-right
           ALU_Out <= B >>> A;
        4'b0110: //  Bitwise and
           ALU_Out <= A & B;
        4'b0111: //  Bitwise or
           ALU_Out <= A | B;
        4'b1000: //  Bitwise xor
           ALU_Out <= A ^ B;
        4'b1001: // Logical xnor
           ALU_Out <= ~(A ^ B);
          default: ALU_Out <= A + B;
        endcase
        if(ALU_Out == 0) zero <= 1;     // Zero Flag
        else zero <= 0;                 // Zero Flag
    end
    
    always @ (*)                     // Check for overflow
    case (ALU_Control)               // Check for overflow
        4'b0000: OVF <= ( A[WL - 1] & B[WL - 1] & ~ALU_Out[WL - 1] ) | ( ~A[WL - 1] & ~B[WL - 1] & ALU_Out[WL - 1] );
        4'b0001: OVF <= ( ~A[WL - 1] & B[WL - 1] & ALU_Out[WL - 1] ) | ( A[WL - 1] & ~B[WL - 1] & ~ALU_Out[WL - 1] );
        default: OVF <= 1'b0;
    endcase
endmodule

