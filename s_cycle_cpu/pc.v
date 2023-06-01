module pc(pc,clock,reset,npc);



output [31:0] pc;

input clock;

input reset;

input [31:0] npc;
reg [31:0] pc;
always @(posedge clock or negedge reset)
	begin 
        if(!reset) 
            begin
            pc <= 32'h0000_3000;
            //0x3000000
            end
        else 
            begin
            pc <= npc;
            end 
	end
endmodule