`timescale 1ns / 1ps

module reg_File # (parameter WL = 32)
(
    input CLK,
    input RegWriteW,
    input [4 : 0] RFR1, RFR2, RFWA,
    input [WL - 1 : 0] RFWD,
    output reg [WL - 1 : 0] RFRD1, RFRD2            // reg for Read First mode
);
    reg [WL - 1 : 0] rf[0 : 31];
    initial begin RFRD1 <= 0; RFRD2 <= 0; end
    always @ (*)
    begin
        if( (top.rs != 0) && (top.rs == top.WriteRegW) && top.RegWriteW )
        begin
            RFRD1 <= top.ALUOutW;
            RFRD2 <= rf[RFR2];
        end
        else if( (top.rt != 0) && (top.rt == top.WriteRegW) && top.RegWriteW )
        begin
            RFRD1 <= rf[RFR1];
            RFRD2 <= top.ALUOutW;
        end
        else if( ((top.rs != 0) && (top.rs == top.WriteRegW) && top.RegWriteW) && ( (top.rt != 0) && (top.rt == top.WriteRegW) && top.RegWriteW ) )
        begin
            RFRD1 <= top.ALUOutW;
            RFRD2 <= top.ALUOutW;
        end
        else
        begin
            RFRD1 <= rf[RFR1];
            RFRD2 <= rf[RFR2];
        end
    end
    
    initial $readmemh("my_Reg_Memory.mem", rf);       // Initialize Register File
    
    always @ (posedge CLK)
    begin
        if (RegWriteW) begin rf[RFWA] <= RFWD; end
    end
    
//    assign RFRD1 = rf[RFR1];                          // Write First Mode
//    assign RFRD2 = rf[RFR2];                          // Write First Mode
    
endmodule

