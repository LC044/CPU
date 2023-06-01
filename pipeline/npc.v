`include "func_define.v"
module npc(
           input [31:0] pc,
           output reg [31:0] npc,
           input [25:0]  instr_index, 
           input [31:0] pc_gpr,
           input [1:0] s_npc,
           input zero
          );    
    always@(*)
    begin
        case(s_npc)
            `PC_J:
                begin
                    npc = {pc[31:28], instr_index,2'b00};
                end
            `PC_JR:
                begin
                    npc = pc_gpr;
                end
            `PC_BEQ:
                begin
                    npc = zero? pc+({{16{instr_index[15]}}, instr_index[15:0]}<<2):pc+4;
                end
            `PC_4:
                    npc = pc+4;
        endcase
    end
    
endmodule
