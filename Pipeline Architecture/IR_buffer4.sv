module IR_buffer4
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] IRbuffer3_out,       // Input from the main PC
    output logic [4:0] IRbuffer4_out       // Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            IRbuffer4_out <= 32'b0;         // Reset value
        else
            IRbuffer4_out <= IRbuffer3_out[11:7];         // Pass PC to Decode stage
    end
endmodule