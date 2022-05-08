module top(
input   clk,
input   rst_n,
output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

wire    [31:0]  pc_if2r;
wire    [31:0]  inst_if2r;
wire    [1 :0]  jump_c2if;
wire    [31:0]  immra_id2if;
wire    [31:0]  pcimm_id2if;
wire            keep_pc_f2if;

ifetch top_ifetch(
.clk_i(clk),
.rst_n_i(rst_n),
.keep_pc_i(keep_pc_f2if),
.immra_i(immra_id2if),
.pcimm_i(pcimm_id2if),
.jump_i(jump_c2if),
.inst_o(inst_if2r),
.pc_o(pc_if2r)
);

reg null_start;
always@(posedge clk) begin
    if (~rst_n) null_start <= 1'b1;
    else null_start <= 1'b0;
end

wire    [31:0]  inst_r2id;
wire    [31:0]  pc_r2id;
wire            keep_if_id_f2r;
wire            null_r2id;
if_id top_if_id(
.rst_n_i(rst_n & (~|jump_c2if)),
.clk_i(clk),
.keep_if_id_i(keep_if_id_f2r),
.inst_i(inst_if2r),
.pc_i(pc_if2r),
.inst_o(inst_r2id),
.pc_o(pc_r2id),
.null_i(null_start),
.null_o(null_r2id)
);

wire    [31:0]  alu_c_wb;
wire    [31:0]  rd_out_wb;
wire    [31:0]  pc4_wb;
wire    [31:0]  pcimm_wb;
wire    [31:0]  imm_wb;
wire    [2 :0]  wb_sel_wb;
wire            rf_we_wb;
wire    [4 :0]  wR_wb;
wire    [31:0]  rD1_f2r;
wire    [31:0]  rD2_f2r;

wire    [31:0]  pc4_id2r;
wire    [31:0]  imm_id2r;
wire            cmp_sign_c2id;
wire    [1 :0]  cmp_id2c;
wire    [2 :0]  sext_op_c2id;
wire    [31:0]  rD1_id2f;
wire    [31:0]  rD2_id2f;

idecode top_idecode(                      
.rst_n_i(rst_n),
.clk_i(clk),
.wb_sel_i(wb_sel_wb),
.rf_we_i(rf_we_wb),
.sext_op_i(sext_op_c2id),
.cmp_sign_i(cmp_sign_c2id),
.cmp_o(cmp_id2c),
.imm_last_i(imm_wb),
.pcimm_last_i(pcimm_wb),
.pc4_last_i(pc4_wb),
.rd_i(rd_out_wb),
.alu_c_i(alu_c_wb),
.wR_last_i(wR_wb),
.inst_i(inst_r2id),
.pc_i(pc_r2id),
.rD1_f_i(rD1_f2r),
.rD2_f_i(rD2_f2r),
.rD1_o(rD1_id2f),
.rD2_o(rD2_id2f),
.pc4_o(pc4_id2r),
.pcimm_o(pcimm_id2if),
.imm_o(imm_id2r),
.immra_o(immra_id2if),
.debug_wb_value_o(debug_wb_value)
);

wire            alub_sel_c2r;
wire    [4:0]   alu_op_c2r;
wire    [1:0]   mask_op_c2r;
wire            mask_sign_c2r;
wire            dram_we_c2r;
wire    [2:0]   wb_sel_c2r;
wire            rf_we_c2r;

controler top_controler(
.rst_n_i(rst_n),
.inst_i(inst_r2id),
.cmp_i(cmp_id2c),
.cmp_sign_o(cmp_sign_c2id),
.jump_o(jump_c2if),
.sext_op_o(sext_op_c2id),
.alub_sel_o(alub_sel_c2r),
.alu_op_o(alu_op_c2r),
.mask_op_o(mask_op_c2r),
.mask_sign_o(mask_sign_c2r),
.dram_we_o(dram_we_c2r),
.wb_sel_o(wb_sel_c2r),
.rf_we_o(rf_we_c2r)
);

wire    [4 :0]  wR_r2ex;
wire    [31:0]  rD1_r2ex;
wire    [31:0]  rD2_r2ex;
wire    [31:0]  pc4_r2ex;
wire    [31:0]  pcimm_r2ex;
wire    [31:0]  imm_r2ex;
wire            alub_sel_r2ex;
wire    [4 :0]  alu_op_r2ex;
wire    [1 :0]  mask_op_r2ex;
wire            mask_sign_r2ex;
wire            dram_we_r2ex;
wire    [2 :0]  wb_sel_r2ex;
wire            rf_we_r2ex;
wire            flash_id_ex_f2r;
wire            null_r2ex;

id_ex top_id_ex(
.rst_n_i(rst_n & flash_id_ex_f2r),
.clk_i(clk),
.wR_i(inst_r2id[11:7]),
.rD1_i(rD1_f2r),
.rD2_i(rD2_f2r),
.pc4_i(pc4_id2r),
.pcimm_i(pcimm_id2if),
.imm_i(imm_id2r),
.alub_i(alub_sel_c2r),
.alu_op_i(alu_op_c2r),
.mask_op_i(mask_op_c2r),
.mask_sign_i(mask_sign_c2r),
.dram_we_i(dram_we_c2r),
.wb_sel_i(wb_sel_c2r),
.rf_we_i(rf_we_c2r),
.wR_o(wR_r2ex),
.rD1_o(rD1_r2ex),
.rD2_o(rD2_r2ex),
.pc4_o(pc4_r2ex),
.pcimm_o(pcimm_r2ex),
.imm_o(imm_r2ex),
.alub_o(alub_sel_r2ex),
.alu_op_o(alu_op_r2ex),
.mask_op_o(mask_op_r2ex),
.mask_sign_o(mask_sign_r2ex),
.dram_we_o(dram_we_r2ex),
.wb_sel_o(wb_sel_r2ex),
.rf_we_o(rf_we_r2ex),
.null_i(null_r2id),
.null_o(null_r2ex)
);

wire    [31:0]  alu_c_ex2r;
execute top_execute(
.rst_n_i(rst_n),
.alu_b_sel_i(alub_sel_r2ex),
.alu_op_i(alu_op_r2ex),
.rD1_i(rD1_r2ex),
.rD2_i(rD2_r2ex),
.imm_i(imm_r2ex),
.alu_c_o(alu_c_ex2r)
);

wire    [4 :0]  wR_r2dm;
wire    [31:0]  alu_c_r2dm;
wire    [31:0]  rD2_r2dm;
wire    [31:0]  pc4_r2dm;
wire    [31:0]  pcimm_r2dm;
wire    [31:0]  imm_r2dm;

wire    [1 :0]  mask_op_r2dm;
wire            mask_sign_r2dm;
wire            dram_we_r2dm;
wire    [2 :0]  wb_sel_r2dm;
wire            rf_we_r2dm;
wire            null_r2dm;

ex_dmem top_ex_dmem(
 .rst_n_i(rst_n),
 .clk_i(clk),
 .alu_c_i(alu_c_ex2r),
 .rD2_i(rD2_r2ex),
 .pc4_i(pc4_r2ex),
 .pcimm_i(pcimm_r2ex),
 .imm_i(imm_r2ex),
 .wR_i(wR_r2ex),
 .wR_o(wR_r2dm),
 .alu_c_o(alu_c_r2dm),
 .rD2_o(rD2_r2dm),
 .pc4_o(pc4_r2dm),
 .pcimm_o(pcimm_r2dm),
 .imm_o(imm_r2dm),
 .mask_op_i(mask_op_r2ex),
 .mask_sign_i(mask_sign_r2ex),
 .dram_we_i(dram_we_r2ex),
 .wb_sel_i(wb_sel_r2ex),
 .rf_we_i(rf_we_r2ex),
 .mask_op_o(mask_op_r2dm),
 .mask_sign_o(mask_sign_r2dm),
 .dram_we_o(dram_we_r2dm),
 .wb_sel_o(wb_sel_r2dm),
 .rf_we_o(rf_we_r2dm),
 .null_i(null_r2ex),
 .null_o(null_r2dm)
 );
 
 wire   [31:0]  rd_dm2r;

 dmem top_dmem(
 .rst_i(~rst_n),
 .clk_i(clk),
 .dram_we_i(dram_we_r2dm),
 .sign_i(mask_sign_r2dm),
 .mask_op_i(mask_op_r2dm),
 .addr_i(alu_c_r2dm),
 .data_i(rD2_r2dm),
 .rd_o(rd_dm2r)
 );
 
 wire   null_wb;
 
 dmem_wb top_dmem_wb(
 .rst_n_i(rst_n),
 .clk_i(clk),
 .alu_c_i(alu_c_r2dm),
 .rd_out_i(rd_dm2r),
 .pc4_i(pc4_r2dm),
 .pcimm_i(pcimm_r2dm),
 .imm_i(imm_r2dm),
 .wR_i(wR_r2dm),
 .wR_o(wR_wb),
 .alu_c_o(alu_c_wb),
 .rd_out_o(rd_out_wb),
 .pc4_o(pc4_wb),
 .pcimm_o(pcimm_wb),
 .imm_o(imm_wb),
 .wb_sel_i(wb_sel_r2dm),
 .rf_we_i(rf_we_r2dm),
 .wb_sel_o(wb_sel_wb),
 .rf_we_o(rf_we_wb),
 .null_i(null_r2dm),
 .null_o(null_wb)
 );
 
assign debug_wb_pc = pc4_wb - 32'd4;
assign debug_wb_ena = rf_we_wb;
assign debug_wb_reg = wR_wb;
assign debug_wb_have_inst = ~null_wb;

forward top_forward(
// ex 数据冒险
.rf_we_ex_i(rf_we_r2ex),     
.wb_sel_ex_i(wb_sel_r2ex),    
.wR_ex_i(wR_r2ex),        
.imm_ex_i(imm_r2ex),       
.pcimm_ex_i(pcimm_r2ex),     
.pc4_ex_i(pc4_r2ex),       
.alu_c_ex_i(alu_c_ex2r),
// dm 数据冒险     
.rf_we_dm_i(rf_we_r2dm),     
.wb_sel_dm_i(wb_sel_r2dm),    
.wR_dm_i(wR_r2dm),        
.imm_dm_i(imm_r2dm),       
.pcimm_dm_i(pcimm_r2dm),     
.pc4_dm_i(pc4_r2dm),       
.rd_out_dm_i(rd_dm2r),    
.alu_c_dm_i(alu_c_r2dm),   
// wb 数据冒险
.rf_we_wb_i(rf_we_wb), 
.wb_sel_wb_i(wb_sel_wb),
.wR_wb_i(wR_wb),    
.imm_wb_i(imm_wb),   
.pcimm_wb_i(pcimm_wb), 
.pc4_wb_i(pc4_wb),   
.rd_out_wb_i(rd_out_wb),
.alu_c_wb_i(alu_c_wb),
  
.rR1_if_i(inst_r2id[19:15]),       
.rR2_if_i(inst_r2id[24:20]),       
.rD1_if_i(rD1_id2f),       
.rD2_if_i(rD2_id2f),       
.flash_id_ex_o(flash_id_ex_f2r),  
.keep_pc_o(keep_pc_f2if),      
.keep_if_id_o(keep_if_id_f2r),   
.rD1_o(rD1_f2r),          
.rD2_o(rD2_f2r)           
);

endmodule