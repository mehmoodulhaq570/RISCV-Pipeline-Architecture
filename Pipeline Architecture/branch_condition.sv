module branch_condition
(
    input  logic [31:0] rdata1,     
    input  logic [31:0] rdata2,     
    input  logic [2:0]  br_type,  // Branch operation code
    output logic        br_taken // Output: whether the branch condition is met
);

    always_comb
    begin
        case (br_type)
            3'b000: br_taken = (rdata1 == rdata2);             
            3'b001: br_taken = (rdata1 != rdata2);             
            3'b100: br_taken = (rdata1< rdata2); 
            3'b101: br_taken = (rdata1>= rdata2); 
            3'b110: br_taken = ($unsigned(rdata1) <$unsigned(rdata2));              
            3'b111: br_taken = ($unsigned(rdata1) >= $unsigned(rdata2));             
            default: br_taken = 1'b0;                          
        endcase
    end

endmodule
