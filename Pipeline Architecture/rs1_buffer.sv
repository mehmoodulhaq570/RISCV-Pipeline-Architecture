module rs1_buffer
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] rdata1,     // Input from register file (rdata1)
    output logic [31:0] rs1buffer_out     // Output to MUX_to_ALUa
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            rs1buffer_out <= 32'b0;       // Reset value
        else
            rs1buffer_out <= rdata1;      // Store rdata1
    end
endmodule