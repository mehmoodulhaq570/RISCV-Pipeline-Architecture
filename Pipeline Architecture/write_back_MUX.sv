module MUX_write_back
(
    input  logic [31:0] opr_res,
    input  logic [31:0] pc_out, 
    input  logic [31:0] rdata3,
    input  logic [1:0] wb_sel,
    input logic [31:0] rdata4,
    output logic [31:0] wdata
);

    always_comb
    begin
        case (wb_sel)
            2'b00: wdata = opr_res;             
            2'b01: wdata = pc_out + 32'd4;             
            2'b10: wdata = rdata3;
            2'b11: wdata = rdata4; 
            default: ;                                               
        endcase
    end

endmodule
