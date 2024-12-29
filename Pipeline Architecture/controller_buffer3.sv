module controller_buffer3
(
    input  logic        clk,
    input  logic        rst,

       
    input logic [1:0] wb_selb2,
    input logic rf_enb2,

    output logic [1:0] wb_selb3,
    output logic rf_enb3

    
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            rf_enb3 <= 0;
        else begin
            rf_enb3 <= rf_enb2;
            wb_selb3 <= wb_selb2;
        end
            
    end
endmodule