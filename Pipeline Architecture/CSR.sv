module CSR 
(   input logic clk,
    input logic rst,
    input logic [31:0] wdata3,
    input logic [31:0] inst,
    input logic csr_rd,
    input logic csr_wr,
    input  logic        is_mret, //machine retrn from trap
    input  logic [31:0] pc_in,
    output logic [31:0] rdata4,
    output logic [31:0] epc,
    output logic        epc_taken
    
);
    logic [31:0] csr_mem [6];
    logic is_device_en_int;  // Device interrupt enable signal
    logic is_global_en_int;  // Global interrupt enable signal
    logic trap;  // Trap signal

    always_comb begin
        if (csr_rd) begin
            case (inst[31:20])    
                12'h300: rdata4 = csr_mem[0]; // mstatus
                12'h304: rdata4 = csr_mem[1]; // mie
                12'h305: rdata4 = csr_mem[2]; // mtvec
                12'h341: rdata4 = csr_mem[3]; // mepc
                12'h342: rdata4 = csr_mem[4]; // mcause
                12'h344: rdata4 = csr_mem[5]; // mip
            endcase
        end else begin
            rdata4 = 32'b0;        
        end
    end


   always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            csr_mem[0] <= 32'b0; // mstatus
            csr_mem[1] <= 32'b0; // mie
            csr_mem[2] <= 32'b0; // mtvec
            csr_mem[3] <= 32'b0; // mepc
            csr_mem[4] <= 32'b0; // mcause
            csr_mem[5] <= 32'b0; // mip
            epc        <= 32'b0;
            epc_taken  <= 1'b0;
            trap       <= 1'b0;
        end else if(csr_wr) begin
            case (inst[31:20])
                12'h300: csr_mem[0] <= wdata3; // mstatus machine status enabling/disabling interrupts and privilege levels.
                12'h304: csr_mem[1] <= wdata3; // mie Machine Interrupt Enable Controls which interrupts are enabled at the machine level.
                12'h305: csr_mem[2] <= wdata3; // mtvec Machine Trap-Vector Base Address Sets the base address for trap (interrupt/exception) handling routines.
                12'h341: csr_mem[3] <= wdata3; // mepc Machine Exception Program Counter Stores the program counter of the instruction that caused an exception.
                12'h342: csr_mem[4] <= wdata3; // mcause Machine Cause Indicates the reason (cause) of an exception or interrupt.
                12'h344: csr_mem[5] <= wdata3; // mip Machine Interrupt Pending Tracks which interrupts are pending.
                default: ; 
            endcase
        

        // Triggering a trap based on some condition (could be an interrupt or exception)
      if (is_mret) begin
        epc       <= csr_mem[3];  // Restore EPC from MEPC
        epc_taken <= 1'b1;
        trap      <= 1'b0;  // Reset trap once handled
      end else begin
        trap <= 1'b0;  // Ensure trap is reset if no condition is met
        epc_taken <= 1'b0;  // No EPC taken if no trap
      end

      // Handle trap logic
      if (trap) begin
        csr_mem[4] <= 32'b0;  // Clear MCAUSE (Machine Cause Register)
        csr_mem[5] <= csr_mem[5] | 32'd128;  // Set MIP (Machine Interrupt Pending)

        // Handle interrupt enabling logic
        is_device_en_int = csr_mem[5][7] & csr_mem[1][7];  // Check device interrupt enable
        is_global_en_int = csr_mem[0][3] & is_device_en_int;  // Check global interrupt enable

        if (is_global_en_int) begin
          csr_mem[3] <= pc_in;  // Save PC in MEPC
          epc        <= csr_mem[2] + (csr_mem[4] << 2);  // Calculate exception PC
          epc_taken  <= 1'b1;  // Indicate EPC is taken
        end
      end
    end

    end

endmodule