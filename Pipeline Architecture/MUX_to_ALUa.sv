module MUX_to_ALUa (
    input  logic [31:0] rdata1,     // Register file data 1
    input  logic [31:0] pc_out,     // Program counter output
    input  logic        is_AUIPC,    // Signal for AUIPC instruction
    input  logic        is_LUI,      // Signal for LUI instruction
    input  logic        is_B_type,
    input  logic        is_JAL,
    output logic [31:0] mux_out_a    // MUX output to ALU (opr_a)
);

    always_comb begin
        if (is_LUI) 
            mux_out_a = 32'b0;  // For LUI, set opr_a to zero
        else if (is_AUIPC||is_B_type||is_JAL) 
            mux_out_a = pc_out; // For AUIPC, set opr_a to program counter
        else 
            mux_out_a = rdata1; // For R-type, I-type, I-load, S-type, use rdata1
    end
endmodule
