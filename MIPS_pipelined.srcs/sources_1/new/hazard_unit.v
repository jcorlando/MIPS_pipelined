`timescale 1ns / 1ps

module hazard_unit # ( parameter WL = 32 )
(
    input RegWriteM,
    input RegWriteW,
    input MemtoRegE,
    input [4 : 0] rs,
    input [4 : 0] rt,
    input [4 : 0] rsE,
    input [4 : 0] rtE,
    input [4 : 0] WriteRegM,
    input [4 : 0] WriteRegW,
    output FlushE,
    output StallF,
    output StallD,
    output reg [1 : 0] ForwardAE,
    output reg [1 : 0] ForwardBE
);
    reg lwstall = 0;
    reg lwstall_track = 0;
    reg [1 : 0] lwstall_counter = 0;
    
    always @ (posedge top.CLK)
    begin
        if(lwstall != 0 || lwstall_track != 0)
        begin
            if(lwstall_counter < 2)
            begin
                lwstall_counter <= lwstall_counter + 1;
                lwstall_track <= 1;
            end
            else
            begin
                lwstall_counter <= 0;
                lwstall_track <= 0;
            end
        end
    end
    
    
    reg lwstall = 0;
    
    always @ (*)
    begin
        if ( (rsE != 0) && (rsE == WriteRegM) && RegWriteM ) ForwardAE <= 2'b10;
        else if ( (rsE != 0) && (rsE == WriteRegW ) && RegWriteW) ForwardAE <= 2'b01;
        else ForwardAE <= 2'b00;
        
        if ( (rtE != 0) && (rtE == WriteRegM) && RegWriteM ) ForwardBE <= 2'b10;
        else if ( (rtE != 0) && (rtE == WriteRegW ) && RegWriteW) ForwardBE <= 2'b01;
        else ForwardBE <= 2'b00;
        
        lwstall <= ((rs == rtE) || (rt == rtE)) && MemtoRegE;
    end
    
    assign FlushE = lwstall;
    assign StallF = lwstall;
    assign StallD = lwstall;
    
    
    
    
    
    
endmodule
