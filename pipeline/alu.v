`include "func_define.v"
module alu(
            output reg [31:0] c,
            input [31:0] a,
            input [31:0] b,
            input  [3:0] aluop,
            output zero
            );


wire [31:0] addu_result,subu_result;
wire [31:0] or_result,and_result,add_result;
wire [31:0] slt_result,lui_result;
assign addu_result = a + b;
assign subu_result = a - b;
assign or_result = a | b;
assign and_result = a & b;
assign add_result = a + b;
assign slt_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
assign lui_result =  {b,16'b0};
assign zero = (subu_result==0)?1:0;
// 错误 reg c;把c的位数改变了，所以顶层模块返回c会出错
// wire aluop;
always @(*)
    begin
        case(aluop)
            `ALU_OP_ADDU:    c = addu_result ;
            `ALU_OP_SUBU:    c = subu_result ;
            `ALU_OP_ADD:     c = add_result ;
            `ALU_OP_AND:     c = and_result ;
            `ALU_OP_OR:      c = or_result ;  
            `ALU_OP_SLT:     c = slt_result ;
            `ALU_OP_LUI:     c = lui_result ;
            default:         c = 32'h0000 ;
        endcase 
            
    end
endmodule