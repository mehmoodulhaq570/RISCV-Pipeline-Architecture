module alu_buffer2
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] alubuffer1_out,       // Input from the main PC
    output logic [31:0] alubuffer2_out      // Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            alubuffer2_out <= 32'b0;         // Reset value
        else
            alubuffer2_out <= alubuffer1_out;         // Pass PC to Decode stage
    end
endmodule