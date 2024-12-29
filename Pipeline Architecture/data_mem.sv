module data_mem
(
    input  logic clk,
    input  logic rd_en,   // Enable signal for reading
    input  logic wr_en,   // Enable signal for writing
    input  logic [31:0] addr,  // Address from ALU output
    input  logic [31:0] wdata2, // Data to write for store
    output logic [31:0] rdata3, // Data read for load
    input  logic [2:0] func3
);
    // Data memory with 100 32-bit entries
    logic [31:0] mem [100];

    // Asynchronous read
    always_comb begin
        if (rd_en) 
            begin
            case (func3)
                3'b000: // LB (Load Byte - sign-extend)
                    rdata3 = {{24{mem[addr[31:0]][7]}}, mem[addr[31:0]][7:0]};  // Sign-extend byte
                3'b001: // LH (Load Halfword - sign-extend)
                    rdata3 = {{16{mem[addr[31:0]][15]}}, mem[addr[31:0]][15:0]}; // Sign-extend halfword
                3'b010: // LW (Load Word - no extension)
                    rdata3 = mem[addr[31:0]];  // No sign or zero extension needed for LW
                3'b100: // LBU (Load Byte Unsigned - zero-extend)
                    rdata3 = {24'b0, mem[addr[31:0]][7:0]};  // Zero-extend byte
                3'b101: // LHU (Load Halfword Unsigned - zero-extend)
                    rdata3 = {16'b0, mem[addr[31:0]][15:0]}; // Zero-extend halfword
                default:
                    rdata3 = 32'b0; // Default case (shouldn't happen)
            endcase
        end
        else
            rdata3 = 32'b0;
    end

    // Synchronous write
    always_ff @(posedge clk) begin
        if (wr_en) 
            begin
            case (func3)
            3'b000: // SB (Store Byte)
                case (addr[1:0])
                    2'b00: mem[addr[31:0]] <= {mem[addr[31:0]][31:8], wdata2[7:0]};                  // Byte 0
                    2'b01: mem[addr[31:0]] <= {mem[addr[31:0]][31:16], wdata2[7:0], mem[addr[31:0]][7:0]}; // Byte 1
                    2'b10: mem[addr[31:0]] <= {mem[addr[31:0]][31:24], wdata2[7:0], mem[addr[31:0]][15:0]}; // Byte 2
                    2'b11: mem[addr[31:0]] <= {wdata2[7:0], mem[addr[31:0]][23:0]};                  // Byte 3
                endcase

            3'b001: // SH (Store Halfword)
                case (addr[1])
                    1'b0: mem[addr[31:0]] <= {mem[addr[31:0]][31:16], wdata2[15:0]};         // Lower halfword
                    1'b1: mem[addr[31:0]] <= {wdata2[15:0], mem[addr[31:0]][15:0]};         // Upper halfword
                endcase

            3'b010: // SW (Store Word)
                mem[addr[31:0]] <= wdata2;  // Store entire word

            default:
                ;  
            endcase
            end
    end
endmodule
