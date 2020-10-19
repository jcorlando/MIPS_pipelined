`timescale 1ns / 1ps

module hazard_unit # ( parameter WL = 32 )
(
    input RegWriteM,
    input RegWriteW,
    input RegWriteE,
    input MemtoRegE,
    input MemtoRegM,
    input Branch,
    input Jump,
    input [4 : 0] rs,
    input [4 : 0] rt,
    input [4 : 0] rsE,
    input [4 : 0] rtE,
    input [4 : 0] WriteReg,
    input [4 : 0] WriteRegM,
    input [4 : 0] WriteRegW,
    output FlushE,
    output StallF,
    output StallD,
    output reg [1 : 0] ForwardAE,
    output reg [1 : 0] ForwardBE,
    output reg ForwardAD,
    output reg ForwardBD
);
    reg lwstall = 0;
    reg lwstall_track = 0;
    reg [1 : 0] lwstall_counter = 0;
    reg branchstall = 0;
    
    always @ (posedge top.CLK)                                  // lw stall logic
    begin                                                       // lw stall logic
        if(lwstall != 0 || lwstall_track != 0)                  // lw stall logic
        begin                                                   // lw stall logic
            if(lwstall_counter < 2)                             // lw stall logic
            begin                                               // lw stall logic
                lwstall_counter <= lwstall_counter + 1;         // lw stall logic
                lwstall_track <= 1;                             // lw stall logic
            end                                                 // lw stall logic
            else                                                // lw stall logic
            begin                                               // lw stall logic
                lwstall_counter <= 0;                           // lw stall logic
                lwstall_track <= 0;                             // lw stall logic
            end                                                 // lw stall logic
        end                                                     // lw stall logic
    end                                                         // lw stall logic
    
    
    always @ (*)
    begin
        if ( (rsE != 0) && (rsE == WriteRegM) && RegWriteM ) ForwardAE <= 2'b10;
        else if ( (rsE != 0) && (rsE == WriteRegW ) && RegWriteW) ForwardAE <= 2'b01;
        else ForwardAE <= 2'b00;
        
        if ( (rtE != 0) && (rtE == WriteRegM) && RegWriteM ) ForwardBE <= 2'b10;
        else if ( (rtE != 0) && (rtE == WriteRegW ) && RegWriteW) ForwardBE <= 2'b01;
        else ForwardBE <= 2'b00;
        
        
        lwstall <= ((rs == rtE) || (rt == rtE)) && MemtoRegE;           // lw stall logic
        
        
        ForwardAD <= (rs != 0) && (rs == WriteRegM) && RegWriteM;                           // Branch Mux Logic
        ForwardBD <= (rt != 0) && (rt == WriteRegM) && RegWriteM;                           // Branch Mux Logic
        
        
        branchstall <= Branch && RegWriteE && (WriteReg == rs || WriteReg == rt) ||                 // Branch Stall Logic
                                Branch && MemtoRegM && (WriteRegM == rs || WriteRegM == rt);        // Branch Stall Logic
        
    end
    
    assign FlushE = lwstall || branchstall || Jump;
    assign StallF = lwstall || branchstall;
    assign StallD = lwstall || branchstall;
    
endmodule
