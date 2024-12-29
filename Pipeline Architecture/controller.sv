module controller
(
    input  logic [ 6:0] opcode,
    input  logic [ 2:0] func3,
    input  logic [ 6:0] func7,

    output logic is_I_type,
    output logic is_AUIPC,
    output logic is_LUI,
    output logic is_R_type,
    output logic is_S_type,
    output logic is_Iload_type,
    output logic is_B_type,
    output logic is_JAL,
    output logic is_JALR,
    output logic is_CSR,

    output logic rd_en,   
    output logic wr_en,   
    output logic [1:0] wb_sel,
    output logic rf_en,
    output logic [2:0] br_type,
    output logic [3:0] aluop,
    output logic csr_rd,
    output logic csr_wr,
    output logic is_mret
);

    always_comb
    begin
        csr_rd = 1'b0;
        csr_wr = 1'b0;
        is_CSR = 1'b0;
        is_I_type = 1'b0;
        is_AUIPC = 1'b0;
        is_LUI = 1'b0;
        is_R_type = 1'b0;
        is_S_type = 1'b0;
        is_Iload_type = 1'b0;
        is_B_type = 1'b0;
        is_JAL = 1'b0;
        is_JALR = 1'b0;

        rf_en = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        case (opcode)
            7'b0110011:  // R-Type
            begin
                is_I_type = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b1;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                is_CSR = 1'b0;

                rf_en=1'b1;
                wb_sel = 2'b00;
                rd_en = 1'b0;
                wr_en = 1'b0;
                unique case (func3)
                    3'b000:
                    begin
                    unique case (func7)
                        7'b0000000: aluop = 4'b0000; // ADD
                        7'b0100000: aluop = 4'b0001; // SUB
                        7'b0000001: aluop = 4'b1011;  //MUL
                    endcase
                    end
                    3'b001: aluop = 4'b0010; //SLL
                    3'b010: aluop = 4'b0011; //SLT
                    3'b011: aluop = 4'b0100; //SLTU
                    3'b100: aluop = 4'b0101; //XOR
                    3'b101:
                    begin
                        unique case (func7)
                            7'b0000000:  aluop = 4'b0110; //SRL
                            7'b0100000:  aluop = 4'b0111; //SRA
                        endcase
                    end
                    3'b110: aluop = 4'b1000; //OR
                    3'b111: aluop = 4'b1001; //AND
                endcase
            end
            7'b0010011:  // I-Type 
            begin
                rf_en = 1'b1;
                is_CSR = 1'b0;
                is_I_type = 1'b1;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                is_CSR = 1'b0;
                wb_sel = 2'b00;
                rd_en = 1'b0;
                wr_en = 1'b0;
                unique case (func3)
                    3'b000: aluop = 4'b0000; // ADDI
                    3'b010: aluop = 4'b0011; // SLTI
                    3'b011: aluop = 4'b0100; // SLTIU
                    3'b100: aluop = 4'b0101; // XORI
                    3'b110: aluop = 4'b1000; // ORI
                    3'b111: aluop = 4'b1001; // ANDI
                    3'b001: aluop = 4'b0010; // SLLI
                    3'b101: 
                    begin
                        if (func7 == 7'b0000000) aluop = 4'b0110; // SRLI
                        else if (func7 == 7'b0100000) aluop = 4'b0111; // SRAI
                    end
                    
                endcase
            end
            7'b0000011: 
            begin // Load (I-type)
                rf_en = 1'b1;
                is_CSR = 1'b0;
                wr_en = 1'b0;
                is_I_type = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b1;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                rd_en = 1'b1;    // Enable data memory read
                wb_sel = 2'b10;   // Select data memory output for write-back
                aluop = 4'b0000;
            end
            7'b0100011: 
            begin // Store (S-type)
                rf_en = 1'b0;
                is_CSR = 1'b0;
                is_I_type = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b1;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                rd_en = 1'b0;
                wr_en = 1'b1;    // Enable data memory write
                aluop = 4'b0000;
            end
            7'b0110111: 
            begin // U-type (LUI)
                rf_en = 1'b1;
                is_I_type = 1'b0;
                is_CSR = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b1;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                wb_sel = 2'b00;   // Select ALU for write-back
                rd_en = 1'b0;
                wr_en = 1'b0;
                aluop = 4'b0000; // ALU just passes the immediate
            end
            7'b0010111: begin // U-type (AUIPC)
                rf_en = 1'b1;
                is_I_type = 1'b0;
                is_CSR = 1'b0;
                is_AUIPC = 1'b1;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                wb_sel = 2'b00;   // Select ALU for write-back
                rd_en = 1'b0;
                wr_en = 1'b0;
                aluop = 4'b0000; // ALU just adds PC and immediate
            end
            7'b1101111: begin // JAL
                rf_en = 1'b1;
                is_I_type = 1'b0;
                is_CSR = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b1;
                is_JALR = 1'b0;
                wb_sel = 2'b01;   
                rd_en = 1'b0;
                wr_en = 1'b0;
                aluop = 4'b0000; 
            end

            7'b1100111: begin // JALR
                rf_en = 1'b1;
                is_I_type = 1'b0;
                is_CSR = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b1;
                wb_sel = 2'b00;   
                rd_en = 1'b0;
                wr_en = 1'b0;
                aluop = 4'b0000; 
            end

            7'b1100011: begin // B-type
                rf_en = 1'b0;
                is_I_type = 1'b0;
                is_CSR = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b1;
                is_JAL = 1'b0;
                is_JALR = 1'b0;   
                rd_en = 1'b0;
                wr_en = 1'b0;
                aluop = 4'b0000;
                unique case (func3)
                    3'b000: br_type = 3'b000; // BEQ
                    3'b001: br_type = 3'b001; // BNE
                    3'b100: br_type = 3'b100; // BLT
                    3'b101: br_type = 3'b101; // BGE
                    3'b110: br_type = 3'b110; // BLTU
                    3'b111: br_type = 3'b111; // BGEU 
                endcase
            end

            7'b1110011: begin //CSRRW
                rf_en = 1'b1;
                is_CSR = 1'b1;
                is_I_type = 1'b0;
                is_AUIPC = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                wb_sel = 2'b11;   
                rd_en = 1'b0;
                wr_en = 1'b0;
                case (func3)
                    3'b000: begin
                    is_mret = 1'b1;
                end
                    3'b001: begin
                    csr_wr = 1'b1;
                end
                    3'b010: begin
                    csr_rd = 1'b1;
                end
                default: begin
                csr_rd  = 1'b1;
                csr_wr  = 1'b0;
                is_mret = 1'b0;
          end
        endcase
                
            end
            default:
            begin
                is_I_type = 1'b0;
                is_AUIPC = 1'b0;
                is_CSR = 1'b0;
                is_LUI = 1'b0;
                is_R_type = 1'b0;
                is_S_type = 1'b0;
                is_Iload_type = 1'b0;
                is_B_type = 1'b0;
                is_JAL = 1'b0;
                is_JALR = 1'b0;
                rf_en = 1'b0;
                rd_en = 1'b0;
                wr_en = 1'b0;
            end
        endcase
    end
// initial begin
//     $monitor("Time: %0t | opcode: %b | func3: %b | func7: %b | aluop: %b", $time, opcode, func3, func7, aluop);
// end

endmodule
