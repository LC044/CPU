`define JR 6'b001000
`define J 6'b000010
`define JAL 6'b000011
`define BEQ 6'b000100
// ALU控制信号
`define ALU_OP_ADDU     4'b0001
`define ALU_OP_ADD      4'b0000
`define ALU_OP_SUBU     4'b0011
`define ALU_OP_AND      4'b0100
`define ALU_OP_OR       4'b0101
`define ALU_OP_SLT      4'b1010
`define ALU_OP_LUI      4'b1111
// `define ALU_OP_NOP      4'b1111
// I型指令
`define ALUOp_ADDI      6'b001000
`define ALUOp_ADDIU     6'b001001
`define ALUOp_ANDI      6'b001100
`define ALUOp_ORI       6'b001101
`define ALUOp_LUI       6'b001111
`define ALUOp_SW        6'b101011
`define ALUOp_LW        6'b100011
// PC跳转指令
`define PC_J 2'b01
`define PC_4 2'b11
`define PC_JR 2'b10
`define PC_BEQ 2'b00

// 写寄存器选择信号 
// 0:写入rt寄存器 
// 1：写入rd寄存器 
// 2：写入31号寄存器
`define NUM_WRITE_RT 2'b00
`define NUM_WRITE_RD 2'b01
`define NUM_WRITE_31 2'b10

// ALU 源操作数 b选择信号
// 0: b = GPR[rt]
// 1：b = ext_imm
`define ALU_GPR 0
`define ALU_IMM 1 

// s_data_write 信号
`define ALU_OUT 2'b01
`define MEM_OUT 2'b10
`define PC_4_OUT 2'b00

// alu旁路输入信号
`define ALU_OUT_MEM 2'b00
`define ALU_OUT_WB  2'b01
`define REG1_EXE    2'b10
`define REG2_EXE    2'b11
`define DATA_WRITE_WB 2'b01

// s_forwardA2/B2
`define REG1_ID 2'b10
`define REG2_ID 2'b10
`define ALU_OUT_MEM_REG 2'b01
`define DATA_WRITE_WB3 2'b00

// PC寄存器控制信号

`define PC_REG_NPC 1
`define PC_REG_PC 0
