module alu_buffer1
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] opr_res,       // Input from the main PC
    output logic [31:0] alubuffer1_out      // Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            alubuffer1_out <= 32'b0;         // Reset value
        else
            alubuffer1_out <= opr_res;         // Pass PC to Decode stage
    end
endmodule