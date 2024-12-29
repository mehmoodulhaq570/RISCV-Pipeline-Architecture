module IR_buffer3
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] IRbuffer2_out,       // Input from the main PC
    output logic [31:0] IRbuffer3_out       // Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            IRbuffer3_out <= 32'b0;         // Reset value
        else
            IRbuffer3_out <= IRbuffer2_out;         // Pass PC to Decode stage
    end
endmodule