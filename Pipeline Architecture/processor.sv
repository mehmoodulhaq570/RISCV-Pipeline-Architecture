module processor
(
    input  logic clk,
    input  logic rst
);
    logic [31:0] pc_out;
    logic [31:0] pc_in;
    logic [31:0] inst;

    logic [ 6:0] opcode;
    logic [ 2:0] func3;
    logic [ 6:0] func7;
    logic [ 4:0] rs1;
    logic [ 4:0] rs2;
    logic [ 4:0] rd;

    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] wdata;

    logic [31:0] MUX_output;
    logic [31:0] mux_out_a;
    logic [31:0] opr_res;

    logic [31:0] rdata3;
    logic rd_en,wr_en;
    logic [31:0] wdata2;
    
    logic [2:0] br_type;
    logic        br_taken;
    logic        rf_en;
    logic [3:0] aluop;
    logic [1:0] wb_sel;
    logic        is_I_type;
    logic        is_AUIPC;
    logic        is_LUI;
    logic        is_R_type;
    logic        is_S_type;
    logic        is_Iload_type;
    logic        is_B_type;
    logic        is_JAL;
    logic        is_JALR;
    logic        is_CSR;

    logic [31:0] imm_to_mux;

    logic [31:0] rdata4;

    logic trap, is_mret, epc_taken;
    logic [31:0] epc;

    //signals for pc buffers
    logic [31:0] pcbuffer1_out;
    logic [31:0] pcbuffer2_out;
    logic [31:0] pcbuffer3_out;
    logic [31:0] pcbuffer4_out;

    //signals for RD,WD,imm, rs1 and rs2  buffers
    logic [31:0] rs1buffer_out;
    logic [31:0] rs2buffer_out;
    logic [31:0] immbuffer_out;
    logic [31:0] WDbuffer_out;
    logic [31:0] RDbuffer_out;

    //signals for alu1 and alu2 buffers
    logic [31:0] alubuffer1_out;
    logic [31:0] alubuffer2_out;

    //signals for IR1, IR2, IR3 and IR4 buffers
    logic [31:0] IRbuffer1_out;
    logic [31:0] IRbuffer2_out;
    logic [31:0] IRbuffer3_out;
    logic [4:0] IRbuffer4_out;

    //signals for controller buffer1
    logic is_I_typeb1;
    logic is_AUIPCb1;
    logic is_LUIb1;
    logic is_R_typeb1;
    logic is_S_typeb1;
    logic is_Iload_typeb1;
    logic is_B_typeb1;
    logic is_JALb1;
    logic is_JALRb1;
    logic is_CSRb1;

    logic rd_enb1;   
    logic wr_enb1;   
    logic [1:0] wb_selb1;
    logic rf_enb1;
    logic [2:0] br_typeb1;
    logic [3:0] aluopb1;
    logic csr_rdb1;
    logic csr_wrb1;
    logic is_mretb1;

    //signals for controller buffer2
    logic rd_enb2;  
    logic wr_enb2;  
    logic [1:0] wb_selb2;
    logic rf_enb2;
    logic csr_rdb2;
    logic csr_wrb2;
   

    //signals for controller buffer3
    logic [1:0] wb_selb3;
    logic rf_enb3;
   

    // Program Counter instance
    pc pc_inst
    (
        .clk   (clk),
        .rst   (rst),
        .pc_in (pc_in),
        .pc_out (pc_out)
    );

    pc_buffer_fetch pc_buffer1
    (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),            
        .pcbuffer1_out(pcbuffer1_out)
    );

    pc_buffer_decode pc_buffer2 (
        .clk(clk),
        .rst(rst),
        .pcbuffer1_out(pcbuffer1_out),   
        .pcbuffer2_out(pcbuffer2_out)  
    );

     // Instantiate Execute PC Buffer
    pc_buffer_execute pc_buffer3 (
        .clk(clk),
        .rst(rst),
        .pcbuffer2_out(pcbuffer2_out),    // Input from Decode PC buffer
        .pcbuffer3_out(pcbuffer3_out)     // Output to Memory PC buffer
    );

    pc_buffer_memory pc_buffer4 (
        .clk(clk),
        .rst(rst),
        .pcbuffer3_out(pcbuffer3_out),    // Input from Execute PC buffer
        .pcbuffer4_out(pcbuffer4_out)     // Output to Writeback MUX
    );

    CSR csr_inst
    (
        .clk   (clk),
        .rst   (rst),
        .inst(inst),
        .pc_in(pc_in),
        .rdata4(rdata4),
        .wdata3(rs1buffer_out),
        .csr_rd(csr_rdb2),
        .csr_wr(csr_wrb2),
        .is_mret(is_mretb1),
        .epc(epc),
        .epc_taken(epc_taken)

    );

    // Instruction Memory Instance
    inst_mem imem
    (
        .addr(pc_out),
        .data(inst)
    );

    IR_buffer1 ir_buffer1
    (
        .clk   (clk),
        .rst   (rst),
        .inst  (inst),
        .IRbuffer1_out(IRbuffer1_out)
    );

    IR_buffer2 ir_buffer2
    (
        .clk   (clk),
        .rst   (rst),
        .IRbuffer1_out(IRbuffer1_out),
        .IRbuffer2_out(IRbuffer2_out)
    );

    IR_buffer3 ir_buffer3
    (
        .clk   (clk),
        .rst   (rst),
        .IRbuffer2_out(IRbuffer2_out),
        .IRbuffer3_out(IRbuffer3_out)
    );

    IR_buffer4 ir_buffer4
    (
        .clk   (clk),
        .rst   (rst),
        .IRbuffer3_out(IRbuffer3_out),
        .IRbuffer4_out(rd)
    );

    // Instruction Decoder
    inst_dec inst_instance
    (
        .inst    (IRbuffer1_out),
        .rs1     (rs1),
        .rs2     (rs2),
        .opcode  (opcode),
        .func3   (func3),
        .func7   (func7)
    );

    // Immediate Generator
    immediate_gen imm_gen
    (
        .inst(IRbuffer1_out),
        .imm_to_mux(imm_to_mux),
        .is_AUIPC(is_AUIPC),
        .is_LUI(is_LUI),
        .is_S_type(is_S_type),
        .is_Iload_type(is_Iload_type),
        .is_I_type(is_I_type),
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),
        .is_JALR(is_JALR)
    );

    imm_buffer imm_buffer
    (
        .clk(clk),
        .rst(rst),
        .imm_to_mux(imm_to_mux),          
        .immbuffer_out(immbuffer_out)
    );

    

    //Register File
    reg_file reg_file_inst
    (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .rf_en(rf_enb3),
        .clk(clk),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .wdata(wdata)
    );

    rs1_buffer Rs1_buffer (
        .clk(clk),
        .rst(rst),
        .rdata1(rdata1),          // Input from register file
        .rs1buffer_out(rs1buffer_out)      // Output to MUX_to_ALUa
    );

    rs2_buffer Rs2_buffer (
        .clk(clk),
        .rst(rst),
        .rdata2(rdata2),          // Input from register file
        .rs2buffer_out(rs2buffer_out)      // Output to MUX_to_ALUa
    );


    //Controller
    controller contr_inst
    (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .rf_en(rf_en),
        .aluop(aluop),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .wb_sel(wb_sel),
        .is_AUIPC(is_AUIPC),
        .is_LUI(is_LUI),
        .is_R_type(is_R_type),
        .is_S_type(is_S_type),
        .is_Iload_type(is_Iload_type),
        .is_I_type(is_I_type),
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),
        .is_JALR(is_JALR),
        .br_type(br_type),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_CSR(is_CSR),
        .is_mret(is_mret)
    );

    controller_buffer1 contb1
    (
        .clk(clk),
        .rst(rst),
        .rf_en(rf_en),
        .aluop(aluop),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .wb_sel(wb_sel),
        .is_AUIPC(is_AUIPC),
        .is_LUI(is_LUI),
        .is_R_type(is_R_type),
        .is_S_type(is_S_type),
        .is_Iload_type(is_Iload_type),
        .is_I_type(is_I_type),
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),
        .is_JALR(is_JALR),
        .br_type(br_type),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_CSR(is_CSR),
        .is_mret(is_mret),
        .rf_enb1(rf_enb1),
        .aluopb1(aluopb1),
        .rd_enb1(rd_enb1),
        .wr_enb1(wr_enb1),
        .wb_selb1(wb_selb1),
        .is_AUIPCb1(is_AUIPCb1),
        .is_LUIb1(is_LUIb1),
        .is_R_typeb1(is_R_typeb1),
        .is_S_typeb1(is_S_typeb1),
        .is_Iload_typeb1(is_Iload_typeb1),
        .is_I_typeb1(is_I_typeb1),
        .is_B_typeb1(is_B_typeb1),
        .is_JALb1(is_JALb1),
        .is_JALRb1(is_JALRb1),
        .br_typeb1(br_typeb1),
        .csr_rdb1(csr_rdb1),
        .csr_wrb1(csr_wrb1),
        .is_CSRb1(is_CSRb1),
        .is_mretb1(is_mretb1)
    );

    controller_buffer2 contb2
    (
        .clk(clk),
        .rst(rst),
        .rd_enb1(rd_enb1),   
        .wr_enb1(wr_enb1),   
        .wb_selb1(wb_selb1),
        .rf_enb1(rf_enb1),
        .csr_rdb1(csr_rdb1),
        .csr_wrb1(csr_wrb1),
        .rd_enb2(rd_enb2),   
        .wr_enb2(wr_enb2),   
        .wb_selb2(wb_selb2),
        .rf_enb2(rf_enb2),
        .csr_rdb2(csr_rdb2),
        .csr_wrb2(csr_wrb2)

    );

    controller_buffer3 contb3
    (
        .clk(clk),
        .rst(rst),   
        .wb_selb2(wb_selb2),
        .rf_enb2(rf_enb2),  
        .wb_selb3(wb_selb3),
        .rf_enb3(rf_enb3)
    );



    // ALU Mux (for selecting between rdata2 and imm_to_mux)
    MUX_to_ALU alu_mux
    (
        .rdata2(rs2buffer_out),
        .imm_to_mux(immbuffer_out),
        .is_R_type(is_R_typeb1),
        .MUX_output(MUX_output)
    );
     MUX_to_ALUa alu_mux_a
    (
        .rdata1(rs1buffer_out),      // Register file data 1
        .pc_out(pcbuffer2_out),      // Program Counter output
        .is_LUI(is_LUIb1),
        .is_AUIPC(is_AUIPCb1),  
        .is_B_type(is_B_typeb1),
        .is_JAL(is_JALb1),   
        .mux_out_a(mux_out_a)  
    );

     PC_MUX pc_mux
    (
        .pc_out   (pc_out),
        .opr_res  (alubuffer1_out),
        .br_taken (br_taken),
        .is_JAL (is_JAL),
        .is_JALR (is_JALR),
        .epc_taken(epc_taken),
        .epc(epc),
        .pc_in (pc_in)
    );

    //ALU
    alu alu_inst
    (
        .opr_a(mux_out_a),
        .opr_b(MUX_output),
        .aluop(aluopb1),
        .opr_res(opr_res)
    );

    alu_buffer1 Alu_buffer1
    (
        .clk(clk),
        .rst(rst),
        .opr_res(opr_res),          
        .alubuffer1_out(alubuffer1_out)
    );

    alu_buffer2 Alu_buffer2
    (
        .clk(clk),
        .rst(rst),
        .alubuffer1_out(alubuffer1_out),          
        .alubuffer2_out(alubuffer2_out)
    );



    branch_condition br_cndtn
    (
        .rdata1(rs1buffer_out),
        .rdata2(rs2buffer_out),
        .br_type(br_typeb1),
        .br_taken(br_taken)

    );

    // Data Memory
    data_mem data_mem_inst (
        .clk(clk),
        .rd_en(rd_enb2),
        .wr_en(wr_enb2),
        .addr(alubuffer1_out),
        .wdata2(WDbuffer_out),
        .rdata3(rdata3),
        .func3(func3) 
    );

    WD_buffer wd_buffer
    (
        .clk(clk),
        .rst(rst),
        .rs2buffer_out(rs2buffer_out),          
        .WDbuffer_out(WDbuffer_out)
    );

    RD_buffer rd_buffer
    (
        .clk(clk),
        .rst(rst),
        .rdata3(rdata3),          
        .RDbuffer_out(RDbuffer_out)
    );

    // Write-Back MUX
    MUX_write_back wb_mux (
        .opr_res(alubuffer2_out),
        .rdata3(RDbuffer_out),
        .wb_sel(wb_selb3),
        .wdata(wdata),
        .pc_out(pcbuffer4_out),
        .rdata4(rdata4)
    );
//     initial begin
//     $monitor("PC: %b, Inst: %b, Opcode: %b, Func3: %b, Func7: %b, rs1: %d, rs2: %d, rd: %d,rdata1: %b, rdata2: %b, wdata: %b",
//              pc_out, inst, opcode, func3, func7, rs1, rs2, rd, rdata1, rdata2, wdata);
// end

endmodule
