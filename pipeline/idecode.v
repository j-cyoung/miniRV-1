module idecode(
input   wire            rst_n_i,
input   wire            clk_i,
input   wire    [2:0]   wb_sel_i,
input   wire            rf_we_i,
input   wire    [2:0]   sext_op_i,
input   wire            cmp_sign_i,
output  wire    [1:0]   cmp_o,
input   wire    [31:0]  imm_last_i,
input   wire    [31:0]  pcimm_last_i,
input   wire    [31:0]  pc4_last_i,
input   wire    [31:0]  rd_i,
input   wire    [31:0]  alu_c_i,
input   wire    [4 :0]  wR_last_i,
input   wire    [31:0]  inst_i,
input   wire    [31:0]  pc_i,
input   wire    [31:0]  rD1_f_i,
input   wire    [31:0]  rD2_f_i,
output  wire    [31:0]  rD1_o,
output  wire    [31:0]  rD2_o,
output  wire    [31:0]  pc4_o,
output  wire    [31:0]  pcimm_o,
output  wire    [31:0]  imm_o,
output  wire    [31:0]  immra_o,
output  wire    [31:0]  debug_wb_value_o
);

wire    [31:0]  ext;
reg     [31:0]  mux2wD;

assign  imm_o = ext;
assign  debug_wb_value_o = mux2wD;

always@(*) begin
    case(wb_sel_i)
        3'b000: mux2wD = imm_last_i;
        3'b001: mux2wD = pcimm_last_i;
        3'b010: mux2wD = pc4_last_i;
        3'b011: mux2wD = rd_i;
        default: mux2wD = alu_c_i; 
    endcase
end

rf idecode_rf(
.rst_n_i(rst_n_i),
.clk_i(clk_i),
.rf_we_i(rf_we_i),
.rR1_i(inst_i[19:15]),
.rR2_i(inst_i[24:20]),
.wR_i(wR_last_i),
.wD_i(mux2wD),
.rD1_o(rD1_o),
.rD2_o(rD2_o)
);

npc idecode_npc(
.rst_n_i(rst_n_i),
.pc_i(pc_i),
.ra_i(rD1_f_i),
.imm_i(ext),
.pc4_o(pc4_o),
.pcimm_o(pcimm_o),
.immra_o(immra_o)
);

sext idecode_sext(
.rst_n_i(rst_n_i),
.sext_op_i(sext_op_i),
.inst_i(inst_i),
.ext_o(ext)
);

cmp idecode_cmp(
.cmp_sign_i(cmp_sign_i),
.a_i(rD1_f_i),
.b_i(rD2_f_i),
.cmp_o(cmp_o)
);



endmodule
