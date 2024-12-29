module tb_processor();
    logic clk;
    logic rst;

    // Processor DUT instantiation
    processor dut
    (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset Generator
    initial begin
        rst = 1;
        #10;
        rst = 0;
        #10000;
        $finish;
    end

    initial //initializng csr file
    begin
        #10 rst = 0; // Deassert reset
    #5 $readmemb("CSR", dut.csr_inst.csr_mem); // Initialize after reset
    end

    // Initializing Instruction, Register File, and Data Memories
    initial begin
        $readmemb("instruction_memory", dut.imem.mem);
        $readmemb("register_file", dut.reg_file_inst.reg_mem);
        $readmemb("data_memory", dut.data_mem_inst.mem); // Initialize data memory
       // $display("Data stored at address %h: %h", dut.data_mem_inst.addr, dut.data_mem_inst.mem[dut.data_mem_inst.addr[31:0]]);
    end

    // Dumping the simulation results
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, tb_processor);
        $dumpvars(1, dut.reg_file_inst.reg_mem); // Dump register file values
        $dumpvars(2, dut.csr_inst.csr_mem);
    end


/*
    // Monitor Data Memory after Store Operation
initial begin
    #50; // Wait for some cycles, enough for a store operation to complete

    // Check if wr_en is asserted (indicating store operation)
    if (dut.data_mem_inst.wr_en) begin
        // Assuming a store operation is happening
        $display("Store operation happening: Data stored at address %h", dut.data_mem_inst.addr);
        $display("Data to be stored: %h", dut.data_mem_inst.wdata2);
        $display("Memory content at address %h: %h", dut.data_mem_inst.addr, dut.data_mem_inst.mem[dut.data_mem_inst.addr]);
    end

    // Verify updated memory content after the store
    #50; // Wait for the next cycle or further operations
    $display("Updated memory content at address %h: %h", dut.data_mem_inst.addr, dut.data_mem_inst.mem[dut.data_mem_inst.addr]);
end
*/
endmodule
