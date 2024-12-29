module pc_buffer_memory
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pcbuffer3_out,       // Input from Execute stage
    output logic [31:0]  pcbuffer4_out       // Output to Writeback stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            pcbuffer4_out <= 32'b0;         // Reset value
        else
            pcbuffer4_out <= pcbuffer3_out;         // Pass PC to Writeback stage
    end
endmodule