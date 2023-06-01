module alu(c,a,b,aluop);

output reg [31:0] c;
input [31:0] a;
input [31:0] b;
input  [3:0] aluop;

wire [31:0] addu_result,subu_result,or_result,and_result,add_result,slt_result;
assign addu_result = a + b;
assign subu_result = a - b;
assign or_result = a | b;
assign and_result = a & b;
assign add_result = a + b;
assign slt_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
// reg [31:0] c;


// reg c;
// 错误 reg c;把c的位数改变了，所以顶层模块返回c会出错


// wire aluop;
always @(aluop or a or b)
    begin
        case(aluop)
            4'b0001:     c = addu_result ;
            4'b0011:     c = subu_result ;
            4'b0000:     c = add_result ;
            4'b0100:     c = and_result ;
            4'b0101:     c = or_result ;  
            4'b1010:     c = slt_result;
            default:     c = 32'h0123 ;
        endcase 
    end
endmodule