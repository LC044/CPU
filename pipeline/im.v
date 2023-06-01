module im(instruction,pc);



output [31:0] instruction;

input [31:0] pc;


//reg instruction;

reg [31:0] ins_memory[1023:0]; //4k指令存储器



assign instruction = ins_memory[(pc&32'h0000_0fff)>>2];


endmodule