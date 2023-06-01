`include "func_define.v"
module ctrl(aluop,
        reset,
            op,
            funct,
            s_b,
            s_num_write,
            reg_write,
            s_ext,
            mem_write,
            s_data_write,
            s_npc
            );
    output reg [3:0] aluop;     // aluop代表六种基本运算标志信号
    output reg s_b;             // 选择数据存入alu的源操作敄,1为寄存器2，0位扩展后的立即数
    output reg [1:0] s_num_write;     // 选择存入写寄存器的数捄，1为rd,0为rt
    output reg reg_write;       // 写使能信号，1为写有效，0为写无效
    output reg s_ext;           // 选择扩展方式 1为符号扩屄1，0为零位扩屄
    output reg mem_write;       // MEM写使能信号，高电平有效
    output reg [1:0] s_data_write;    // 寄存器写数据选择信号，1为MEM输出数据，0为ALU输出数据
    output reg [1:0] s_npc;
    input [5:0] op;
    input [5:0] funct;
    input reset;
    
    always@(op or funct,negedge reset)
    begin
        if (!reset)
                begin
                  s_num_write = 0;
                end
        if (op == 6'b000000)
            if(funct == `JR)      
                begin 
                        s_npc = `PC_JR;
                        reg_write = 0;
                        mem_write = 0;
                end
            else
                begin
                        s_num_write=`NUM_WRITE_RD;
                        reg_write = 1;
                        mem_write = 0;    
                        aluop = funct[3:0];
                        s_b = `ALU_GPR;
                        s_npc = `PC_4;
                        s_data_write = `ALU_OUT;
                end

        else
            case(op)
                `ALUOp_ADDI:
                        begin
                                aluop=`ALU_OP_ADD;
                                s_b = `ALU_IMM;
                                s_ext = 1;
                                s_num_write = `NUM_WRITE_RT;
                                reg_write = 1;
                                mem_write = 0;
                                s_data_write=`ALU_OUT;
                                s_npc = `PC_4;
                        end
                `ALUOp_ADDIU:
                        begin 
                                aluop=`ALU_OP_ADDU;
                                s_b=`ALU_IMM;
                                s_ext=1;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write=1;
                                mem_write = 0;
                                s_data_write=`ALU_OUT;
                                s_npc = `PC_4;
                        end
                `ALUOp_ANDI:
                        begin 
                                aluop=`ALU_OP_AND;
                                s_b=`ALU_IMM;
                                s_ext=0;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write = 1;
                                mem_write = 0;
                                s_data_write=`ALU_OUT;
                                s_npc = `PC_4;
                        end
                `ALUOp_ORI:
                        begin 
                                aluop=`ALU_OP_OR;
                                s_b=`ALU_IMM;
                                s_ext=0;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write = 1;
                                mem_write = 0;
                                s_data_write=`ALU_OUT;
                                s_npc = `PC_4;
                        end
                `ALUOp_LUI:
                        begin
                                aluop=`ALU_OP_LUI;
                                s_b=`ALU_IMM;
                                s_ext=0;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write=1;
                                mem_write = 0;
                                s_data_write=`ALU_OUT;
                                s_npc = `PC_4;
                        end
                `ALUOp_SW:
                // 6'b101011:
                        begin
                                aluop=`ALU_OP_ADDU;
                                s_b=`ALU_IMM;
                                s_ext=1;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write = 0;
                                mem_write = 1;
                                s_data_write=`ALU_OUT;
                                // s_data_write= 0;
                                s_npc = `PC_4;
                        end
                `ALUOp_LW:
                        begin
                                aluop=`ALU_OP_ADDU;
                                s_b=`ALU_IMM;
                                s_ext=1;
                                s_num_write=`NUM_WRITE_RT;
                                reg_write=1;
                                mem_write=0;
                                s_data_write=`MEM_OUT;
                                // s_data_write = 1;
                                s_npc = `PC_4;
                        end
                `J:
                        begin
                                s_npc = `PC_J;
                                reg_write = 0;
                                mem_write = 0;
                        end
                `JAL:
                        begin
                                s_npc = `PC_J;
                                s_data_write = `PC_4_OUT;
                                s_num_write =  `NUM_WRITE_31;
                                reg_write = 1;
                                mem_write = 0;
                        end
                `BEQ:
                        begin
                                aluop = `ALU_OP_SUBU;
                                s_b = `ALU_GPR;
                                s_npc = `PC_BEQ;
                                reg_write = 0;
                                mem_write = 0;
                        end
            endcase
    end
    
    
endmodule
