module gpr(a,b,clock,reg_write,num_write,rs,rt,data_write);
output [31:0] a;  
output [31:0] b;
input clock;
input reg_write;
input [4:0] rs; //读寄存器1
input [4:0] rt; //读寄存器2
input [4:0] num_write; //写寄存器
input [31:0] data_write; //写数据
reg [31:0] gp_registers[31:0];


always @(posedge clock) 
    begin
    if(reg_write)
        gp_registers[num_write] <= data_write;
    gp_registers[0] <= 0;
    end
    
assign a = gp_registers[rs];
assign b = gp_registers[rt];
endmodule