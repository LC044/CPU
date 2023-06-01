module ext (
    input  s_ext,
    input [15:0] imm,
    output [31:0] ext_imm
);

assign ext_imm = (s_ext) ? {{16{imm[15]}},imm} : {{16{1'b0}},imm};

endmodule //extend