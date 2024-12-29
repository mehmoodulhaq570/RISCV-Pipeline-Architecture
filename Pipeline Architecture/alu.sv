module alu
(
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,
    input  logic [3:0] aluop,
    output logic [31:0] opr_res
);

    always_comb
    begin
        case (aluop)
            // write 10 operations of ALU
            // operands by default unsigned because of logic command
            4'b0000 : opr_res = opr_a + opr_b;   //ADD
            4'b0001 : opr_res = opr_a - opr_b;   //SUB
            4'b0010 : opr_res = opr_a << opr_b[4:0];    //SLL-logic left shift
            4'b0011 : opr_res = ($signed(opr_a) < $signed(opr_b)) ? 32'b1 : 32'b0;    //SLT- set all 32bits as 1 if signed opr_a is less than signed opr_b
            4'b0100 : opr_res = (opr_a < opr_b) ? 32'b1 : 32'b0;    //SLTU-  set all 32bits as 1 if unsigned opra is less than unsigned oprb
            4'b0101 : opr_res = opr_a ^ opr_b;   //XOR
            4'b0110 : opr_res = opr_a >> opr_b[4:0];   //SRL-logic right shift  (shift and fill msb new bits by 0)
            4'b0111 : opr_res = $signed(opr_a) >>> opr_b[4:0];   //SRA-arithmetic right shift (shift and fill msb new bits by the sign of bits positive-0, negative - 1)
            4'b1000 : opr_res = opr_a | opr_b;   //OR
            4'b1001 : opr_res = opr_a & opr_b;   //AND
            4'b1011: opr_res = opr_a * opr_b; //MUL
            default : opr_res = 32'b0;
        endcase
    end
   // initial begin
   //     $monitor("Time: %0t | opr_a: %b | opr_b: %b | aluop: %b | opr_res: %b",
   //              $time, opr_a, opr_b, aluop, opr_res);
   // end
endmodule
