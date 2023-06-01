module ctrl(reg_write,aluop,op,funct);
output reg_write;
output[3:0] aluop;
input [5:0] op;
input [5:0] funct ;


assign reg_write = 1;       // reg_write暂时取1，后面用到之后可以再改
assign aluop = funct[3:0];  //aluop取funct的低四位

endmodule