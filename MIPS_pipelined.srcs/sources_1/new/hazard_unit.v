`timescale 1ns / 1ps

module hazard_unit # ( parameter WL = 32 )
(
    input RegWriteM,
    input RegWriteW,
    input [4 : 0] rsE,
    input [4 : 0] rtE,
    input [4 : 0] WriteRegM,
    input [4 : 0] WriteRegW,
    output reg [1 : 0] ForwardAE,
    output reg [1 : 0] ForwardBE
);
    
    always @ (*)
    begin
        
        
        
        if ( (rsE != 0) && (rsE == WriteRegM) && RegWriteM ) ForwardAE <= 2'b10;
        
        else if ( (rsE != 0) && (rsE == WriteRegW ) && RegWriteW) ForwardAE <= 2'b01;
        
        else ForwardAE <= 2'b00;
        
        
        
        
        if ( (rtE != 0) && (rtE == WriteRegM) && RegWriteM ) ForwardBE <= 2'b10;
        
        else if ( (rtE != 0) && (rtE == WriteRegW ) && RegWriteW) ForwardBE <= 2'b01;
        
        
        
        else ForwardBE <= 2'b00;
        
        
        
    end
    
    
    
endmodule
