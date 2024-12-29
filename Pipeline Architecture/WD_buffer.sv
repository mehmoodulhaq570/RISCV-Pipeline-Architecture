module WD_buffer
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] rs2buffer_out,       // Input from Fetch stage
    output logic [31:0] WDbuffer_out       // Output to Execute stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            WDbuffer_out <= 32'b0;         // Reset value
        else
            WDbuffer_out <= rs2buffer_out;         // Pass PC to Execute stage
    end
endmodule