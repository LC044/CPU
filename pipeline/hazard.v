`include "func_define.v"
module hazard(
        input reset,
        input clock,
        input mem_read_EXE,
        input [4:0] rs_ID,
        input [4:0] rt_ID,
        input [4:0] num_write_EXE,
        input mem_read_ID,
        input s_i_instruction_ID,
        input [1:0] s_npc,
        input zero,
        output reg pc_write,
        output reg if_id_flush,
        output reg if_id_write,
        output reg id_exe_flush
);
wire flag,flag1,flag_beq;
assign flag = s_i_instruction_ID?(((s_npc == `PC_BEQ) && (rs_ID == num_write_EXE))? 1:
                (mem_read_EXE) && (rs_ID == num_write_EXE)):    
              ((s_npc == `PC_BEQ) && ((rs_ID == num_write_EXE) || (rt_ID == num_write_EXE)))? 1:
              (mem_read_EXE) && ((rs_ID == num_write_EXE)||(rt_ID == num_write_EXE));
assign flag1 = (s_npc == `PC_4)? 0:
               ((s_npc == `PC_BEQ) && zero ==1)? 1:
               ((s_npc == `PC_J) || (s_npc == `PC_JR))? 1:0;
// assign flag_beq = (s_npc == `PC_BEQ)
always @(*)
    begin
        if(!reset)
        begin
            pc_write     = 1;
            if_id_write  = 1;
            id_exe_flush = 0;
            if_id_flush = 0;
        end
        else
        if(flag)
            begin
                id_exe_flush = 1;
                pc_write = `PC_REG_PC;
                if_id_write = 0;
                if_id_flush = 0;
            end
        else
            begin
                id_exe_flush = 0;
                pc_write = `PC_REG_NPC;
                if_id_write = 1;
                if_id_flush = 0;
            end
        if(flag1)
            begin
                if_id_flush = 1;
                if_id_write = 0;
            end
        else 
            begin
            if_id_flush = 0;
            // if_id_write = 1;
            end
    end
endmodule