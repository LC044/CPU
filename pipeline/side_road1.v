`include "func_define.v"
module side_road(
    input [4:0] rs_ID,
    input [4:0] rt_ID,
    input [4:0] rs_EXE,
    input [4:0] rt_EXE,
    input [5:0] op_EXE,
    input [5:0] op_ID,
    input [4:0] num_write_ID,
    input [4:0] num_write_EXE,
    input [4:0] num_write_MEM,
    input [4:0] num_write_WB,
    input s_i_instruction_EXE,
    input reg_write_EXE,
    input reg_write_MEM,
    output [1:0] s_forwardA3,
    output [1:0] s_forwardB3,
    output  s_forwardA2,
    output  s_forwardB2
    );
// D号寄存器发生冒险
assign s_forwardA3 = (op_EXE == `ALUOp_SW) ?`REG1_EXE:
                    //  (rs_ID == 5'b00000  &&rt_ID == 5'b00000)? ((rs_EXE == num_write_WB)? `DATA_WRITE_WB3:`REG1_EXE):
                     (rs_ID == num_write_EXE && num_write_EXE != 0)? `ALU_OUT_MEM :
                     (rs_ID == num_write_MEM)? `DATA_WRITE_WB :
                     `REG1_EXE;
assign s_forwardB3 = (op_EXE == `ALUOp_SW) ?`REG2_EXE:
                    //  (rt_ID == 5'b00000 && rs_ID == 5'b00000)? ((rt_EXE == num_write_WB)? `DATA_WRITE_WB3:`REG2_EXE):
                     (rt_ID == num_write_EXE && num_write_EXE != 5'b00000)? `ALU_OUT_MEM :
                     (rt_ID == num_write_MEM && num_write_MEM != 5'b00000)? `DATA_WRITE_WB :
                     `REG2_EXE;
assign s_forwardA2 =  //(op_ID == `ALUOp_LW)? 
                      (rs_ID == num_write_WB)? `DATA_WRITE_WB3:
                      `REG1_ID;
assign s_forwardB2 = 
                     (rt_ID == num_write_WB)? `DATA_WRITE_WB3:
                     `REG2_ID;
endmodule 