module controller_buffer1
(
    input  logic        clk,
    input  logic        rst,

    input logic is_I_type,
    input logic is_AUIPC,
    input logic is_LUI,
    input logic is_R_type,
    input logic is_S_type,
    input logic is_Iload_type,
    input logic is_B_type,
    input logic is_JAL,
    input logic is_JALR,
    input logic is_CSR,

    input logic rd_en,   
    input logic wr_en,   
    input logic [1:0] wb_sel,
    input logic rf_en,
    input logic [2:0] br_type,
    input logic [3:0] aluop,
    input logic csr_rd,
    input logic csr_wr,
    input logic is_mret,


    output logic is_I_typeb1,
    output logic is_AUIPCb1,
    output logic is_LUIb1,
    output logic is_R_typeb1,
    output logic is_S_typeb1,
    output logic is_Iload_typeb1,
    output logic is_B_typeb1,
    output logic is_JALb1,
    output logic is_JALRb1,
    output logic is_CSRb1,

    output logic rd_enb1,   
    output logic wr_enb1,   
    output logic [1:0] wb_selb1,
    output logic rf_enb1,
    output logic [2:0] br_typeb1,
    output logic [3:0] aluopb1,
    output logic csr_rdb1,
    output logic csr_wrb1,
    output logic is_mretb1
    
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst) begin
             is_I_typeb1 <= 0;
            is_AUIPCb1 <= 0;
            is_LUIb1 <= 0;
            is_R_typeb1 <= 0;
            is_S_typeb1 <= 0;
            is_Iload_typeb1 <= 0;
            is_B_typeb1 <= 0;
            is_JALb1 <= 0;
            is_JALRb1 <= 0;
            is_CSRb1 <= 0;
            rd_enb1 <= 0;
            wr_enb1 <= 0;
            rf_enb1 <= 0;
            csr_rdb1 <= 0;
            csr_wrb1 <= 0;
            is_mretb1 <= 0;        
        end else begin
            is_I_typeb1 <= is_I_type;
            is_AUIPCb1 <= is_AUIPC;
            is_LUIb1 <= is_LUI;
            is_R_typeb1 <= is_R_type;
            is_S_typeb1 <= is_S_type;
            is_Iload_typeb1 <= is_Iload_type;
            is_B_typeb1 <= is_B_type;
            is_JALb1 <= is_JAL;
            is_JALRb1 <= is_JALR;
            is_CSRb1 <= is_CSR;
            rd_enb1 <= rd_en;
            wr_enb1 <= wr_en;
            wb_selb1 <= wb_sel;
            rf_enb1 <= rf_en;
            br_typeb1 <= br_type;
            aluopb1 <= aluop;
            csr_rdb1 <= csr_rd;
            csr_wrb1 <= csr_wr;
            is_mretb1 <= is_mret;
        end

    end
endmodule