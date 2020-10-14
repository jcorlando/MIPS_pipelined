`timescale 1ns / 1ps

module AndGatePCSrc
(
    input A, B,
    output reg out
);
    initial out <= 0;
//    and(out, A, B);
    always @ (*) out <= A & B;
    
endmodule
