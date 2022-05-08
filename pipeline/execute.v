module execute(
input           rst_n_i,
input           alu_b_sel_i,
input   [4:0]   alu_op_i,
input   [31:0]  rD1_i,
input   [31:0]  rD2_i,
input   [31:0]  imm_i,
output  [31:0]  alu_c_o
);

alu execute_alu(
.rst_n_i(rst_n_i),
.alu_op_i(alu_op_i),
.alu_a_i(rD1_i),
.alu_b_i(alu_b_sel_i ? imm_i : rD2_i),
.alu_c_o(alu_c_o)
);

endmodule