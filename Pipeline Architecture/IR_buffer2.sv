module IR_buffer2
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] IRbuffer1_out,       // Input from the main PC
    output logic [31:0] IRbuffer2_out       // Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            IRbuffer2_out <= 32'b0;         // Reset value
        else
            IRbuffer2_out <= IRbuffer1_out;         // Pass PC to Decode stage
    end
endmodule