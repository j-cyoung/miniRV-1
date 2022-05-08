module top(
    input           clk,
    input           rst_n,
    output          debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output  [31:0]  debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output          debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output  [4:0]   debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output  [31:0]  debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

/*
 *  控制信号
 */
 
// 取指单元
wire    [1:0]   npc_op; // 选择 npc 下一条指令的格式
// 译指单元
wire            rf_we;  // 是否向 rf 写入
wire    [2:0]   sext_op;// sext 中立即数扩展的模式
wire    [2:0]   wd_sel; // mux_5_1 选择
wire            alub_sel;// 选择 alu B 端口的输入
// 执行单元
wire            lt;     // 小于信号
wire            eq;     // 等于信号
wire    [5:0]   alu_op; // 选择 alu 运算方式
// 存储单元
wire            dram_we;// 控制是否向 dmem 写入
wire    [1:0]   mask_op;// 控制 dmem 输入输出数据格式
wire            sign;   // 控制是否从 dmem 中读出无符号数

/*
 *  数据信号
 */
 
// 取指单元
wire    [31:0]  pc4_w;  // pc + 4
wire    [31:0]  pcimm_w;// pc + imm
wire    [31:0]  inst_w; // inst
// 译指单元
wire    [31:0]  rD1_w;  // rf 第一个输出
wire    [31:0]  rD2_w;  // rf 第二个输出
wire    [31:0]  ext_w;  // sext 扩展后的立即数
// 执行单元
wire    [31:0]  alu_c_w;// alu c
wire    [31:0]  rd_w;   // dmem 的读出数据     


assign  debug_wb_have_inst = 1'b1;
assign  debug_wb_pc = pc4_w - 32'd4;
assign  debug_wb_ena = rf_we;
assign  debug_wb_reg = inst_w[11:7];


ifetch top_ifetch(
    .clk_i  (clk),
    .rst_i  (~rst_n),
    .npc_op (npc_op),
    .ra_i   (rD1_w),
    .imm_i  (ext_w),
    .pc4_o  (pc4_w),
    .inst_o (inst_w),
    .pcimm_o(pcimm_w)
);

idecode top_idecode(
    .clk_i      (clk),
    .rst_i      (~rst_n),
    .rf_we_i    (rf_we),
    .sext_op_i  (sext_op),
    .wd_sel_i   (wd_sel),
    .inst_i     (inst_w),
    .pc4_i      (pc4_w),
    .alu_c_i    (alu_c_w),
    .dram_rd_i  (rd_w),
    .pcimm_i    (pcimm_w),
    .ext_o      (ext_w),
    .rD1_o      (rD1_w),
    .rD2_o      (rD2_w),
    .debug_wb_value(debug_wb_value)
);

dmem top_dmem(
    .rst_i(~rst_n),
    .clk_i(clk),
    .dram_we_i(dram_we),
    .sign_i(sign),
    .mask_op_i(mask_op),
    .addr_i(alu_c_w),
    .data_i(rD2_w),
    .rd_o(rd_w)
);

execute top_execute(
    .rst_i      (~rst_n),
    .alub_sel_i (alub_sel),
    .alu_op_i   (alu_op),
    .A_i        (rD1_w),
    .rD2_i      (rD2_w),
    .ext_i      (ext_w),
    .C_o        (alu_c_w),
    .eq_o       (eq),
    .lt_o       (lt)
);

control top_control(
    .rst_i(~rst_n),
    .inst_i(inst_w),
    .lt_i(lt),
    .eq_i(eq),
    .npc_op_o(npc_op),
    .rf_we_o(rf_we),
    .sext_op_o(sext_op),
    .wd_sel_o(wd_sel),
    .alub_sel_o(alub_sel),
    .alu_op_o(alu_op),
    .dram_we_o(dram_we),
    .mask_op_o(mask_op),
    .sign_o(sign)
 );
endmodule
