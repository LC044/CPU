module mem_wb (
               input clock,
               input reset,
               input [31:0] pc_4,
               input [31:0] alu_in,
               input [31:0] mem_in,
               input [4:0] num_write_in,
               input [1:0] s_data_write_in,
               input reg_write_in,
               output reg reg_write_out,
               output reg [1:0] s_data_write_out,
               output reg [4:0] num_write_out,
               output reg [31:0] pc_4_out,
               output reg [31:0] alu_out,
               output reg [31:0] mem_out
               );
    always@(posedge clock,negedge reset)
    begin
        if (!reset)
        begin
            pc_4_out      = {32{1'b0}};
            alu_out       = {32{1'b0}};
            mem_out       = {32{1'b0}};
            num_write_out = {5{1'b0}};
            reg_write_out=0;
            s_data_write_out=2'b00;
        end
        else
        begin
            reg_write_out<=reg_write_in;
            s_data_write_out<=s_data_write_in;
            pc_4_out      <= pc_4;
            alu_out       <= alu_in;
            mem_out       <= mem_in;
            num_write_out <= num_write_in;
        end
    end
    
endmodule //mem_w
