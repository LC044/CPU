module s_cycle_cpu(clock,reset);
//输入
input clock;
input reset;

wire [31:0] pc;                 //存储当前指令地址
wire [31:0] instruction;        //机器指令
wire [31:0] npc;                //存储下一条指令
wire reg_write = 1;             //寄存器写使能，高电平有效
wire [4:0] rs,rt;               //rs，rt寄存器编号
wire  [31:0] data_write;        //写入寄存器的数据
wire [4:0] num_write;           //写入数据的寄存器编号
wire [31:0] a;                  //alu操作数a
wire [31:0] b;                  //alu操作数b
wire [31:0] c;                  //alu运算结果
wire [5:0] funct;               //instruction的funct字段(低六位)
wire [3:0] aluop;               //alu控制信号
wire [5:0] op;                  //instruction的op字段(高六位)

pc PC(  .pc(pc),
        .clock(clock),
        .reset(reset),
        .npc(npc));

im IM(
       .instruction(instruction),
       .pc(pc)
       );

assign npc = pc + 4;
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign funct = instruction[5:0];
assign op = instruction[31:26];
assign reg_write = 1;
assign num_write = instruction[15:11];

ctrl CTRL(
          .reg_write(reg_write),
          .aluop(aluop),
          .op(op),
          .funct(funct) 
             );

gpr GPR(
        .a(a),
        .b(b),
        .clock(clock),
        .reg_write(reg_write),
        .num_write(num_write),
        .rs(rs),
        .rt(rt),
        .data_write(data_write)
        );

alu ALU(
        .c(c),
        .a(a),
        .b(b),
        .aluop(aluop)
        );


assign data_write = c;
endmodule