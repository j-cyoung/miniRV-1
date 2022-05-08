module id_ex(
input   wire            rst_n_i,
input   wire            clk_i,
// 数据信号
input   wire    [4 :0]  wR_i,
input   wire    [31:0]  rD1_i,
input   wire    [31:0]  rD2_i,
input   wire    [31:0]  pc4_i,
input   wire    [31:0]  pcimm_i,
input   wire    [31:0]  imm_i,
// 控制信号
input   wire            alub_i,
input   wire    [4 :0]  alu_op_i,
input   wire    [1 :0]  mask_op_i,
input   wire            mask_sign_i,
input   wire            dram_we_i,
input   wire    [2:0]   wb_sel_i,
input   wire            rf_we_i,
// 数据信号
output  reg     [4 :0]  wR_o,
output  reg     [31:0]  rD1_o,
output  reg     [31:0]  rD2_o,
output  reg     [31:0]  pc4_o,
output  reg     [31:0]  pcimm_o,
output  reg     [31:0]  imm_o,
// 控制信号
output  reg             alub_o,
output  reg     [4 :0]  alu_op_o,
output  reg     [1 :0]  mask_op_o,
output  reg             mask_sign_o,
output  reg             dram_we_o,
output  reg     [2:0]   wb_sel_o,
output  reg             rf_we_o,
input   wire            null_i,
output  reg             null_o
);

always@(posedge clk_i) begin
    if (~rst_n_i) begin
        wR_o        <=  5'b0;
        rD1_o       <=  32'b0;
        rD2_o       <=  32'b0;
        pc4_o       <=  32'b0;
        pcimm_o     <=  32'b0;
        imm_o       <=  32'b0;
        alub_o      <=   1'b0;
        alu_op_o    <=   4'b0;
        mask_op_o   <=   2'b0;
        mask_sign_o <=   1'b0;
        dram_we_o   <=   1'b0;
        wb_sel_o    <=   3'b0;
        rf_we_o     <=   1'b0;
        null_o      <=   1'b1;
    end
    else begin
        wR_o        <=  wR_i     ;
        rD1_o       <=  rD1_i      ;
        rD2_o       <=  rD2_i      ;
        pc4_o       <=  pc4_i      ;
        pcimm_o     <=  pcimm_i    ;
        imm_o       <=  imm_i      ;
        alub_o      <=  alub_i     ;
        alu_op_o    <=  alu_op_i   ;
        mask_op_o   <=  mask_op_i  ;
        mask_sign_o <=  mask_sign_i;
        dram_we_o   <=  dram_we_i  ;
        wb_sel_o    <=  wb_sel_i   ;
        rf_we_o     <=  rf_we_i    ;
        null_o      <=  null_i;
    end
end

endmodule
