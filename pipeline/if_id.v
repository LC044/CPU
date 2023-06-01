module if_id (
            input clock,
            input reset,
            input if_id_write,
            input if_id_flush,
            input s_b_in,
            input [31:0] pc_4,
            input [1:0] s_npc_in,
            input reg_write_in,
            input s_ext_in,
            input [1:0] s_num_write_in,
            input [1:0] s_data_write_in,
            input mem_write_in,
            input mem_read_in,
            input [3:0] aluop_in,
            input [31:0] instruction,
            input s_i_instruction_in,
            input [5:0] op_in,
            output reg [5:0] op_out,
            output reg s_i_instruction_out,
            output reg [1:0] s_npc_out,
            output reg mem_read_out,
            output reg reg_write_out,
            output reg s_ext_out,
            output reg [1:0] s_num_write_out,
            output reg [1:0] s_data_write_out,
            output reg mem_write_out,
            output reg [3:0] aluop_out,
            output reg s_b_out,
            output reg [31:0] pc_4_out,
            output reg [15:0] imm,
            output reg [25:0] instr_index,
            output reg [4:0] rs,
            output reg [4:0] rd,
            output reg [4:0] rt
              );
always@(posedge clock , negedge reset)
begin
    if (!reset)
        begin
            pc_4_out <= 32'h0000_0000;
            imm <= 16'h0000;
            instr_index <= {26{1'b0}};
            rs <= 5'b00000;
            rt <= 5'b00000;
            rd <= 5'b00000;
            mem_read_out <= 0;
            s_npc_out <= 2'b11;
            reg_write_out <=1;
            mem_write_out <= 0;
            s_num_write_out <= 2'b00;
            op_out <= 0;
        end
    else
        begin
            if(if_id_write)
                begin
                    s_npc_out        <= s_npc_in;
                    mem_read_out     <= mem_read_in;
                    aluop_out        <=aluop_in;
                    op_out           <= op_in;
                    s_b_out          <=s_b_in;
                    reg_write_out    <= reg_write_in;
                    s_ext_out        <=s_ext_in;
                    s_num_write_out  <=s_num_write_in;
                    s_data_write_out <=s_data_write_in;
                    mem_write_out    <=mem_write_in;
                    pc_4_out         <= pc_4;
                    imm              <= instruction[15:0];
                    instr_index      <= instruction[25:0];
                    rs               <= instruction[25:21];
                    rt               <= instruction[20:16];
                    rd               <= instruction[15:11];
                    s_i_instruction_out<=s_i_instruction_in;
                end
            if(if_id_flush)
                begin
                    pc_4_out <= 32'h0000_0000;
                    imm <= 16'h0000;
                    instr_index <= {26{1'b0}};
                    rs <= 5'b00000;
                    rt <= 5'b00000;
                    rd <= 5'b00000;
                    mem_read_out <= 0;
                    s_npc_out <= 2'b11;
                    // s_npc_out        <= s_npc_in;
                    reg_write_out <= 1;
                    mem_write_out <= 0;
                    s_num_write_out <= 2'b00;
                end
        end
end

endmodule //if_i
