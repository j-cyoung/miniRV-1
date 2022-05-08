module miniRV(
    input   wire    rst_i,
    input   wire    clk_i        
    );

// 控制信号
wire    [1:0]   npc_op;
wire            rf_we;
wire    [2:0]   sext_op;
wire    [1:0]   wd_sel;
wire            alub_sel;
wire            lt;
wire            eq;
wire    [5:0]   alu_op;
wire            dram_we;
// 数据信号
wire    [31:0]  pc4;
wire    [31:0]  inst;
wire    [31:0]  rD1;
wire    [31:0]  rD2;
wire    [31:0]  ext;
wire    [31:0]  alu_c;
wire    [31:0]  rd;
wire    [31:0]  debug_wb_value;

ifetch top_ifetch(
    .clk(clk_i),
    .npc_op(npc_op),
    .rst_i(rst_i),
    .ra(rD1),
    .imm(ext),
    .pc4(pc4),
    .inst(inst)
);

idecode top_idecode(
    .clk_i(clk_i),
    .rf_we(rf_we),
    .sext_op(sext_op),
    .wd_sel(wd_sel),
    .inst(inst),
    .pc4(pc4),
    .alu_c(alu_c),
    .dram_rd(rd),
    .rst_i(rst_i),
    .ext(ext),
    .rD1(rD1),
    .rD2(rD2),
    .debug_wb_value(debug_wb_value)
);

dmem top_dmem(
    .clk_i(clk_i),
    .addr_i(alu_c),
    .rd_data_o(rd),
    .memwr_i(dram_we),
    .wr_data_i(rD2)
);

execute top_execute(
    .rst_i(rst_i),
    .alub_sel(alub_sel),
    .alu_op(alu_op),
    .A(rD1),
    .rD2(rD2),
    .ext(ext),
    .C(alu_c),
    .eq(eq),
    .lt(lt)
);

control top_control(
    .rst_i(rst_i),
    .inst(inst),
    .npc_op(npc_op),
    .rf_we(rf_we),
    .sext_op(sext_op),
    .wd_sel(wd_sel),
    .alub_sel(alub_sel),
    .lt(lt),
    .eq(eq),
    .alu_op(alu_op),
    .dram_we(dram_we)
 );
    
endmodule
