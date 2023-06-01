`include "ctrl.v"
`include "gpr.v"
`include "im.v"
`include "pc.v"
`include "ext.v"
`include "func_define.v"
`include "alu.v"
`include "dm.v"
`include "npc.v"
`include "if_id.v"
`include "id_exe.v"
`include "exe_mem.v"
`include "mem_wb.v"
`include "pipeline_cpu.v"
`include "side_road.v"
`include "hazard.v"
`timescale 10ns / 1ns
module pipeline_cpu_test;
integer handle;  // 文件变量
reg CLOCK, RESET;
//实例化被测试模块
pipeline_cpu PIPELINE_CPU(.clock(CLOCK),
                        .reset(RESET) );
//产生时钟激励
initial
begin
	CLOCK = 0;
	forever #5 CLOCK = ~CLOCK;
    
end
reg  [4:0] t_rs, t_rt;
//
always @(posedge CLOCK)
	if(RESET)
	begin
	$display("time = %3d", $time);

	$display("CLOCK = %d, RESET = %d, pc = %h, 		instruction = %h", CLOCK, RESET, PIPELINE_CPU.PC.pc, PIPELINE_CPU.IM.instruction);		
	// $display("GPR.rs = %h, GPR.rt = %h, GPR.a = %h, GPR.b  = %h", PIPELINE_CPU.GPR.rs, PIPELINE_CPU.GPR.rt, PIPELINE_CPU.GPR.a, PIPELINE_CPU.GPR.b);       
	// $display("CTRL.op = %b,  CTRL.funct = %b", PIPELINE_CPU.CTRL.op,PIPELINE_CPU.CTRL.funct);
	// $display("aluop_ID = %b", PIPELINE_CPU.aluop_ID);
	$display("rs_ID = %h,rs_EXE = %h", PIPELINE_CPU.rs_ID,PIPELINE_CPU.rs_EXE);
	$display("rt_ID = %h,rt_EXE = %h", PIPELINE_CPU.rt_ID,PIPELINE_CPU.rt_EXE);
	$display("rd_ID = %h", PIPELINE_CPU.rd_ID);
	$display("if_id_write = %b,pc_write = %b,id_exe_flush = %b",
	PIPELINE_CPU.if_id_write,PIPELINE_CPU.pc_write,PIPELINE_CPU.id_exe_flush);

	$display("num_write_ID = %h,num_write_EXE = %h,num_write_MEM = %h,num_write_WB = %h",
		PIPELINE_CPU.num_write_ID,PIPELINE_CPU.num_write_EXE,PIPELINE_CPU.num_write_MEM,PIPELINE_CPU.num_write_WB);
    $display("flag = %b",PIPELINE_CPU.HAZARD.flag);
	$display("s_i =%b,s_i_ID = %b,s_i_EXE = %b",PIPELINE_CPU.s_i_instruction,
	PIPELINE_CPU.s_i_instruction_ID,PIPELINE_CPU.s_i_instruction_EXE);
	if (PIPELINE_CPU.mem_write)
		$display("addr = %h, data_in = %h,MEM[addr] = %h", PIPELINE_CPU.address[11:2],PIPELINE_CPU.data_in,PIPELINE_CPU.data_out);
	if(PIPELINE_CPU.GPR.reg_write)begin
		$display("s_data_write_WB = %b" , PIPELINE_CPU.s_data_write_WB);
		$display("GPR.regwrite = %h, GPR.num_write = %h, GPR.data_write = %h", PIPELINE_CPU.GPR.reg_write, PIPELINE_CPU.GPR.num_write, PIPELINE_CPU.GPR.data_write);
		end
	else
		$display("GPR.regwrite = %h", PIPELINE_CPU.GPR.reg_write);
	$display("------------------------------------");
	// for(i=0; i<32; i=i+1)//代码运行完，打印GPR的值
	// 		$display("gp_registers[%2d] = %h", i,PIPELINE_CPU.GPR.gp_registers[i]);
	end
	
	// else
	// $display("****** gp_registers[rs]")
//加载指令，初始化GPR
integer i;
initial
begin
	$readmemh("000.txt", PIPELINE_CPU.IM.ins_memory);
	for(i=0; i<32; i=i+1)
			PIPELINE_CPU.GPR.gp_registers[i] = i;
	// for(i=0; i<32; i=i+1)
	// 		PIPELINE_CPU.DM.data_memory[i] = i;

	// PIPELINE_CPU.GPR.gp_registers[6] = 32'h00000005;
	// PIPELINE_CPU.GPR.gp_registers[7] = 32'h00000005;
	// PIPELINE_CPU.GPR.gp_registers[29] = 32'h00002ffc;
end
// 产生reset信号	
initial
begin
	    RESET = 1;
	#5  RESET = 0;
	$dumpfile("zs_clk_wave.vcd");              // 指定记录模拟波形的文件
    $dumpvars(0, PIPELINE_CPU);          // 指定记录的模块层级
	#10 RESET = 1;
    
	#190 for(i=0; i<32; i=i+1)//代码运行完，打印GPR的值
			$display("gp_registers[%2d] = %h", i,PIPELINE_CPU.GPR.gp_registers[i]);
		// $stop;
	#5  RESET = 0;
	#5 $readmemh("001.txt", PIPELINE_CPU.IM.ins_memory);
	for(i=0; i<32; i=i+1)
			PIPELINE_CPU.GPR.gp_registers[i] = 0;
	#10 RESET = 1;

	// #5 $readmemh("001.txt", PIPELINE_CPU.IM.ins_memory);
    #300 $finish;
	
end
// gtkwave zs_clk_wave.vcd
// gtkwave zs_clk_wave0.vcd
// gtkwave zs_clk_wave1.vcd

endmodule