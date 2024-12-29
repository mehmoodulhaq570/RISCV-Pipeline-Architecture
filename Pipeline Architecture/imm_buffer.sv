module imm_buffer
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] imm_to_mux,     // Input from register file (rdata1)
    output logic [31:0] immbuffer_out     // Output to MUX_to_ALUa
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            immbuffer_out <= 32'b0;       // Reset value
        else
            immbuffer_out <= imm_to_mux;      // Store rdata1
    end
endmodule