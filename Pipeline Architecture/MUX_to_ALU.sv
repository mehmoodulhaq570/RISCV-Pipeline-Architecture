module MUX_to_ALU
(
    input  logic [31:0] rdata2,      
    input  logic [31:0] imm_to_mux,  
    input  logic        is_R_type,          
    output logic [31:0] MUX_output    // ALU input for b
);

    always_comb begin
        if (is_R_type)
            MUX_output = rdata2;
            
        else 
            MUX_output = imm_to_mux;  
    end
endmodule
