`include "func_define.v"
module id_exe (
            input clock,
            input reset,
            input id_exe_flush,
            input mem_write_in,
            input mem_read_in,
            input reg_write_in,
            input s_i_instruction_in,
            input s_b_in,
            input [31:0] pc_4,
            input [3:0] aluop_in,
            input [4:0] rs_in,
            input [4:0] rt_in,
            input [1:0] s_data_write_in,
            input [31:0] data_1,
            input [31:0] data_2,
            input [31:0] ext_imm_in,
            input [4:0] num_write_in,
            input [1:0] s_forwardA3,
            input [1:0] s_forwardB3,
            input [1:0] s_forwardA2,
            input [1:0] s_forwardB2,
            input [5:0] op_in,
            output reg [5:0] op_out,
            output reg [1:0] s_forwardA2_out,
            output reg [1:0] s_forwardB2_out,
            output reg s_i_instruction_out,
            output reg s_b_out,
            output reg reg_write_out,
            output reg mem_write_out,
            output reg mem_read_out,
            output reg [1:0] s_forwardB3_out,
            output reg [1:0] s_forwardA3_out,
            output reg [3:0] aluop_out,
            output reg [1:0] s_data_write_out, 
            output reg [31:0] pc_4_out,
            output reg [31:0] data_1_out,
            output reg [31:0] data_2_out,
            output reg [31:0] ext_imm_out,
            output reg [4:0] num_write_out,
            output reg [4:0] rs_out,
            output reg [4:0] rt_out
               );
    
    always@(posedge clock,negedge reset)
        if (!reset )
            begin
                pc_4_out = {32{1'b0}};
                data_1_out = {32{1'b0}};
                data_2_out = {32{1'b0}};
                ext_imm_out = {32{1'b0}};
                num_write_out={5{1'b0}}; 
                reg_write_out=0;
                mem_write_out=0;
                s_data_write_out=2'b00;
                rs_out = 5'b00000;
                rt_out = 5'b00000;
                op_out = 0;
            end
        else if (id_exe_flush)
            begin
                mem_read_out <= 0;
                reg_write_out <= 0;
                // aluop_out <= `ALUOP_NOP;
                rs_out <= {5{1'b0}};
                rt_out <= {5{1'b0}};
                pc_4_out <= {32{1'b0}};
                data_1_out <= {32{1'b0}};
                data_2_out <= {32{1'b0}};
                ext_imm_out <= {32{1'b0}};
                num_write_out <= {5{1'b0}};
                mem_write_out <= 0;
                s_i_instruction_out <= 0;
            end
        else
            begin
                mem_read_out <= mem_read_in;
                rs_out<=rs_in;
                rt_out<=rt_in;
                reg_write_out <=reg_write_in;
                s_b_out<=s_b_in;
                s_data_write_out<=s_data_write_in;
                mem_write_out<=mem_write_in;
                pc_4_out      <= pc_4;
                data_1_out    <= data_1;
                data_2_out    <= data_2;
                ext_imm_out   <= ext_imm_in;
                num_write_out <= num_write_in;
                aluop_out<=aluop_in;
                s_forwardA3_out <= s_forwardA3;
                s_forwardB3_out <= s_forwardB3;
                s_i_instruction_out <= s_i_instruction_in;
                s_forwardA2_out <= s_forwardA2;
                s_forwardB2_out <= s_forwardB2;
                op_out<=op_in;
            end
    
endmodule //id_exe

