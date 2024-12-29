module reg_file
(
    input  logic clk,
    input  logic rf_en,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] wdata,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);
    logic [31:0] reg_mem [32];

    //asynchronous read
    always_comb
    begin
        rdata1 = reg_mem[rs1];
        rdata2 = reg_mem[rs2];
    end

    //synchronous write
    always_ff @(posedge clk)
    begin
        if(rf_en)
        begin
            reg_mem[rd] <= wdata;
        end
    end

    //     initial begin
    //     // Wait for a small delay to allow signals to settle
    //     #1;
    //     $display("Data at rdata1: %b", rdata1);
    //     $display("Data at rdata2: %b", rdata2);
    //     $display("Data at wdata: %b", wdata);
    // end
endmodule
