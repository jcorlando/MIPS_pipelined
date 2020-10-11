`timescale 1ns / 1ps

module pc # (  parameter WL = 32 )
(
    input CLK,
    input [WL - 1 : 0] pc_In,
    output reg [WL - 1 : 0] pc_Out
);
    wire [WL - 1 : 0] pc;
    assign pc = pc_In;
    
    initial pc_Out <= 0;
    always @ (posedge CLK) pc_Out <= pc_In;
    
endmodule
