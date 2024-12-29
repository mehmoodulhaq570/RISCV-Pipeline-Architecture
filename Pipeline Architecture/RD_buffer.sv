module RD_buffer
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] rdata3,       // Input from Fetch stage
    output logic [31:0] RDbuffer_out       // Output to Execute stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            RDbuffer_out <= 32'b0;         // Reset value
        else
            RDbuffer_out <= rdata3;         // Pass PC to Execute stage
    end
endmodule