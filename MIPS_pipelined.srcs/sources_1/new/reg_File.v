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
    reg [WL - 1 : 0] RFR1buf;
    reg [WL - 1 : 0] RFR2buf;
    initial $readmemh("my_Reg_Memory.mem", rf);       // Initialize Register File
    
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
            if( top.hazard_unit.lwstall_track ) RFRD2 <= top.Result;                // This is to handle lw
            else RFRD2 <= top.ALUOutW;                                              // This is to handle lw
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
    
    
    
    always @ (posedge CLK)
    begin
        if (RegWriteW) begin rf[RFWA] <= RFWD; end
//        RFR1buf <= RFR1;           //delay for 1 clock in the case that RFR1 == RFWA and RFWE = 1 (writing and reading from same location)
//        RFR2buf <= RFR2;           //delay for 1 clock in the case that RFR2 == RFWA and RFWE = 1  (writing and reading from same location) 
    end
    
//    assign RFRD1 = rf[RFR1buf];                          // Write First Mode
//    assign RFRD2 = rf[RFR2buf];                          // Write First Mode
    
endmodule

