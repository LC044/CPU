// `include "ctrl.v"
// `include "gpr.v"
// `include "im.v"
// `include "pc.v"
// `include "ext.v"
// `include "alu.v"
// `include "dm.v"
// `include "npc.v"
// `include "if_id.v"
// `include "id_exe.v"
// `include "exe_mem.v"
// `include "mem_wb.v"
// `include "side_road.v"

`include "func_define.v"
module pipeline_cpu(clock, reset);
//输入
input clock;
input reset;
wire [31:0] pc;                 // 存储当前指令地址
wire [31:0] instruction;        // 机器指令
wire [31:0] npc;                // 存储下一条指令
wire reg_write;                 // 寄存器写使能，高电平有效
wire [4:0] rs,rt,rd;            // rs，rt寄存器编号
wire  [31:0] data_write;        // 写入寄存器的数据
wire [4:0] num_write;           // 写入数据的寄存器编号
wire [31:0] a;                  // alu操作数a
wire [31:0] b;                  // alu操作数b
wire [31:0] c;                  // alu运算结果
wire [5:0] funct;               // instruction的funct字段(低六位)
wire [3:0] aluop;               // alu控制信号
wire [5:0] op;                  // instruction的op字段(高六位)
wire [1:0] s_num_write;         // 写寄存器选择信号 1?rd:rs
wire s_b;                       //  alu 第二个输入端选择信号 s_b==0?寄存器:符号扩展
wire [15:0] imm;                // 立即数
wire [31:0] ext_imm;            // 扩展后的立即数
wire s_ext;                     // 立即数扩展选择信号 1?符号扩展:零扩展
wire [31:0] reg1,reg2;          // 寄存器的两个输出信号
wire mem_write;                 // 存储器写使能信号，高电平有效
wire [1:0] s_data_write;        // GPR 写数据选择信号 1?MEM:ALU
wire [31:0] data_in,data_out;   // MEM 输入数据和输出数据
wire [31:0] address;            // MEM 地址
wire [1:0] s_npc;               // npc控制信号，00,

wire [25:0] instr_index;

// 流水线阻塞控制信号
wire if_id_flush,if_id_write;
wire id_exe_flush;
wire pc_write;
wire s_i_instruction;
wire s_i_instruction_EXE,s_i_instruction_ID;
assign s_i_instruction = (op == 6'b000000)?0:
                         (op[5:4]==2'b00)?1:0;
wire mem_read;
assign mem_read = (op == `ALUOp_LW)?1:0;

// wire [31:0] pc_gpr;

// if_id 控制信号
wire [4:0] rs_ID,rt_ID,rd_ID;
wire [4:0] num_write_ID;
wire [3:0] aluop_ID;
wire [15:0] imm_ID;
wire [25:0] instr_index_ID;
wire s_b_ID,reg_write_ID,mem_write_ID,s_ext_ID;
wire mem_read_ID;
wire [1:0] s_npc_ID,s_data_write_ID,s_num_write_ID;
wire [31:0] pc_4_ID;
wire [31:0] reg1_ID,reg2_ID;
wire [31:0] ext_imm_ID;
wire [5:0] op_ID;
// id_exe 控制信号
wire [5:0] op_EXE;
wire s_b_EXE,reg_write_EXE,mem_write_EXE;
wire mem_read_EXE;
wire [3:0] aluop_EXE;
wire [1:0] s_data_write_EXE;
wire [31:0] pc_4_EXE,reg1_EXE,reg2_EXE,ext_imm_EXE;
wire [4:0] num_write_EXE,rs_EXE,rt_EXE;
wire [31:0] alu_out_EXE;

// exe_mem 控制信号
wire reg_write_MEM,mem_write_MEM;
wire mem_read_MEM;
wire [1:0] s_data_write_MEM;
wire [4:0] num_write_MEM;
wire [31:0] pc_4_MEM,alu_out_MEM,reg2_MEM;
wire [31:0] mem_out_MEM;

// mem_wb 控制信号
wire reg_write_WB;
wire [1:0] s_data_write_WB;
wire [4:0] num_write_WB;
wire [31:0] pc_4_WB,alu_out_WB,mem_out_WB;

// 旁路选择信号
wire [1:0] s_forwardA3_EXE,s_forwardB3_EXE;
wire [1:0] s_forwardA3,s_forwardB3;
wire [1:0] s_forwardA2,s_forwardB2;
wire [1:0] s_forwardA2_EXE,s_forwardB2_EXE;
wire [31:0] forward_reg1,forward_reg2; // 寄存器旁路选择
// assign npc = pc + 4;
// ALU 源操作数1，一直等于寄存器输出信号1
assign a = (s_forwardA3_EXE == `REG1_EXE )? reg1_EXE:
           (s_forwardA3_EXE == `ALU_OUT_WB)? data_write:
           alu_out_MEM;

// ALU源操作数2
wire [31:0] mem_data_in;
assign b = s_b_EXE ? ext_imm_EXE:
           (s_forwardB3_EXE == `REG2_EXE) ? reg2_EXE: 
           (s_forwardB3_EXE == `ALU_OUT_WB) ? data_write:
           alu_out_MEM;

assign mem_data_in = (s_forwardB3_EXE == `REG2_EXE) ? reg2_EXE: 
                        (s_forwardB3_EXE == `ALU_OUT_WB) ? data_write:
                        alu_out_MEM;
                        
assign num_write_ID = s_num_write_ID[0]? rd_ID: 
                      s_num_write_ID[1]? 5'b11111: 
                      rt_ID;

assign data_write = (num_write_WB == 0)? 0:
                    s_data_write_WB[0]? alu_out_WB:
                    s_data_write_WB[1]? mem_out_WB:
                    pc_4_WB;  // 寄存器堆写入数据

pc PC(  .pc(pc),
        .clock(clock),
        .reset(reset),
        .pc_write(pc_write),
        .npc(npc));


wire zero;
// wire temp;

// assign temp = forward_reg1^forward_reg2;
assign zero = (forward_reg1^forward_reg2)?0:1;
npc NPC(
           .pc(pc),
           .npc(npc),
           .instr_index(instr_index_ID), 
           .pc_gpr(forward_reg1),
           .s_npc(s_npc_ID),
           .zero(zero)
          );

im IM(
       .instruction(instruction),
       .pc(pc)
       );
       
gpr GPR(
        .a(reg1_ID),
        .b(reg2_ID),
        .clock(clock),
        .reg_write(reg_write_WB),
        .num_write(num_write_WB),
        .rs(rs_ID),
        .rt(rt_ID),
        .data_write(data_write)
        );

ext EXT(
    .s_ext(s_ext_ID),
    .imm(imm_ID),
    .ext_imm(ext_imm_ID)
        );
alu ALU(
        .c(alu_out_EXE),
        .a(a),
        .b(b),
        .aluop(aluop_EXE)
        // .zero(zero)
        );

dm DM(
        .data_out(mem_out_MEM),
        .clock(clock),
        .mem_write(mem_write_MEM),
        .address(alu_out_MEM),
        .data_in(reg2_MEM)
        );
assign funct = instruction[5:0];
assign op = instruction[31:26];

assign forward_reg1 = (s_forwardA2 == `REG1_ID)? reg1_ID: 
                        (s_forwardA2 == `ALU_OUT_MEM_REG)? alu_out_MEM:
                        data_write;
assign forward_reg2 = (s_forwardB2 == `REG2_ID)? reg2_ID: 
                        (s_forwardB2 == `ALU_OUT_MEM_REG)? alu_out_MEM:
                        data_write;
                        
// assign if_id_flush = (s_npc == `PC_4)? 0:1;
ctrl CTRL(
        .op(op),
        .reset(reset),
        .funct(funct),
        .aluop(aluop),
        .s_b(s_b),
        .s_num_write(s_num_write),
        .reg_write(reg_write),
        .s_ext(s_ext),
        .mem_write(mem_write),
        .s_data_write(s_data_write),
        .s_npc(s_npc)
        );

if_id IF_ID(
            .clock(clock),
            .reset(reset),
            .op_in(op),
            .op_out(op_ID),
            .s_i_instruction_in(s_i_instruction),
            .s_i_instruction_out(s_i_instruction_ID),
            .if_id_write(if_id_write),
            .if_id_flush(if_id_flush),
            .s_b_in(s_b),
            .pc_4(npc),
            .s_npc_in(s_npc),
            .reg_write_in(reg_write),
            .s_ext_in(s_ext),
            .s_num_write_in(s_num_write),
            .s_data_write_in(s_data_write),
            .mem_write_in(mem_write),
            .mem_read_in(mem_read),
            .aluop_in(aluop),
            .instruction(instruction),
            .s_npc_out(s_npc_ID),
            .mem_read_out(mem_read_ID),
            .reg_write_out(reg_write_ID),
            .s_ext_out(s_ext_ID),
            .s_num_write_out(s_num_write_ID),
            .s_data_write_out(s_data_write_ID),
            .mem_write_out(mem_write_ID),
            .aluop_out(aluop_ID),
            .s_b_out(s_b_ID),
            .pc_4_out(pc_4_ID),
            .imm(imm_ID),
            .instr_index(instr_index_ID),
            .rs(rs_ID),
            .rd(rd_ID),
            .rt(rt_ID)
              );
            
id_exe ID_EXE(
            .op_in(op_ID),
            .op_out(op_EXE),
            .s_forwardA3(s_forwardA3),
            .s_forwardB3(s_forwardB3),
            .s_forwardA2(s_forwardA2),
            .s_forwardB2(s_forwardB2),
            .s_forwardA3_out(s_forwardA3_EXE),
            .s_forwardB3_out(s_forwardB3_EXE),
            .s_forwardA2_out(s_forwardA2_EXE),
            .s_forwardB2_out(s_forwardB2_EXE),
            .s_i_instruction_in(s_i_instruction_ID),
            .s_i_instruction_out(s_i_instruction_EXE),
            .clock(clock),
            .reset(reset),
            .id_exe_flush(id_exe_flush),
            .pc_4(pc_4_ID),
            .aluop_in(aluop_ID),
            .s_b_in(s_b_ID),
            .rs_in(rs_ID),
            .rt_in(rt_ID),
            .s_data_write_in(s_data_write_ID),
            .mem_write_in(mem_write_ID),
            .mem_read_in(mem_read_ID),
            .reg_write_in(reg_write_ID),
            .data_1(forward_reg1),
            .data_2(forward_reg2),
            .ext_imm_in(ext_imm_ID),
            .num_write_in(num_write_ID),
            .reg_write_out(reg_write_EXE),
            .aluop_out(aluop_EXE),
            .s_data_write_out(s_data_write_EXE), 
            .mem_write_out(mem_write_EXE),
            .mem_read_out(mem_read_EXE),
            .pc_4_out(pc_4_EXE),
            .data_1_out(reg1_EXE),
            .data_2_out(reg2_EXE),
            .ext_imm_out(ext_imm_EXE),
            .num_write_out(num_write_EXE),
            .rs_out(rs_EXE),
            .rt_out(rt_EXE),
            .s_b_out(s_b_EXE)
               );

exe_mem EXE_MEM(
                .clock(clock),
                .reset(reset),
                .pc_4(pc_4_EXE),
                .alu_in(alu_out_EXE),
                .data_in(mem_data_in),
                .s_data_write_in(s_data_write_EXE),
                .mem_write_in(mem_write_EXE),
                .reg_write_in(reg_write_EXE),
                .mem_read_in(mem_read_EXE),
                .num_write_in(num_write_EXE),
                .reg_write_out(reg_write_MEM),
                .s_data_write_out(s_data_write_MEM),
                .mem_write_out(mem_write_MEM),
                .mem_read_out(mem_read_MEM),
                .pc_4_out(pc_4_MEM),
                .alu_out(alu_out_MEM),
                .data_out(reg2_MEM),
                .num_write_out(num_write_MEM)
                );

mem_wb MEM_WB(

               .clock(clock),
               .reset(reset),
               .pc_4(pc_4_MEM),
               .alu_in(alu_out_MEM),
               .mem_in(mem_out_MEM),
               .num_write_in(num_write_MEM),
               .s_data_write_in(s_data_write_MEM),
               .reg_write_in(reg_write_MEM),
               .reg_write_out(reg_write_WB),
               .s_data_write_out(s_data_write_WB),
               .pc_4_out(pc_4_WB),
               .alu_out(alu_out_WB),
               .mem_out(mem_out_WB),
               .num_write_out(num_write_WB)
               );

side_road SIDE_ROAD(
    .rs_ID(rs_ID),
    .rt_ID(rt_ID),
    .rs_EXE(rs_EXE),
    .rt_EXE(rt_EXE),
    .op_EXE(op_EXE),
    .op_ID(op_ID),
    .num_write_ID(num_write_ID),
    .num_write_EXE(num_write_EXE),
    .num_write_MEM(num_write_MEM),
    .num_write_WB(num_write_WB),
    .reg_write_EXE(reg_write_EXE),
    .reg_write_MEM(reg_write_MEM),
    .reg_write_WB(reg_write_WB),
    .s_forwardA3(s_forwardA3),
    .s_forwardB3(s_forwardB3),
    .s_forwardA2(s_forwardA2),
    .s_forwardB2(s_forwardB2)
    );
hazard HAZARD(
        .clock(clock),
        .reset(reset),
        .s_npc(s_npc_ID),
        .zero(zero),
        .mem_read_ID(mem_read_ID),
        .mem_read_EXE(mem_read_EXE),
        .s_i_instruction_ID(s_i_instruction_ID),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .num_write_EXE(num_write_EXE),
        .pc_write(pc_write),
        .if_id_flush(if_id_flush),
        .if_id_write(if_id_write),
        .id_exe_flush(id_exe_flush)
        );

endmodule