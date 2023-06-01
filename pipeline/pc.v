`include "func_define.v"
module pc(
            output reg [31:0] pc,
            input clock,
            input reset,
            input pc_write,
            input [31:0] npc
            );

always @(posedge clock or negedge reset)
	begin 
        if(!reset) 
            begin
            pc <= 32'h0000_3000;
            //0x3000000
            end
        else
            begin
            if (pc_write == `PC_REG_NPC) pc <= npc;
            end 
	end
endmodule