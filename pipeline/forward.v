module forward(
// ex 数据冒险
input               rf_we_ex_i,     // ex 阶段是否写入 rf
input       [2 :0]  wb_sel_ex_i,    // ex 选择写入内容
input       [4 :0]  wR_ex_i,        // ex 阶段写入寄存器地址
input       [31:0]  imm_ex_i,
input       [31:0]  pcimm_ex_i,
input       [31:0]  pc4_ex_i,
input       [31:0]  alu_c_ex_i,
// dm 数据冒险
input               rf_we_dm_i,     // dm 阶段是否写入 rf
input       [2 :0]  wb_sel_dm_i,    // dm 选择写入内容
input       [4 :0]  wR_dm_i,        // dm 阶段写入寄存器地址
input       [31:0]  imm_dm_i,       
input       [31:0]  pcimm_dm_i,
input       [31:0]  pc4_dm_i,
input       [31:0]  rd_out_dm_i,
input       [31:0]  alu_c_dm_i,
// wb 数据冒险
input               rf_we_wb_i,
input       [2 :0]  wb_sel_wb_i,
input       [4 :0]  wR_wb_i,
input       [31:0]  imm_wb_i,
input       [31:0]  pcimm_wb_i,
input       [31:0]  pc4_wb_i,
input       [31:0]  rd_out_wb_i,
input       [31:0]  alu_c_wb_i,

input       [4 :0]  rR1_if_i,       // 需要用到的寄存器地址
input       [4 :0]  rR2_if_i,
input       [31:0]  rD1_if_i,       // 当前寄存器地址值
input       [31:0]  rD2_if_i,
output  reg         flash_id_ex_o,
output  reg         keep_pc_o,
output  reg         keep_if_id_o,
output  reg [31:0]  rD1_o,
output  reg [31:0]  rD2_o
    );

reg [31:0]  ex_rd;
reg [31:0]  dm_rd;
reg [31:0]  wb_rd;

// 选择 ex 阶段前递的数据
always@(*) begin
    case(wb_sel_ex_i)
    3'd0: ex_rd = imm_ex_i;
    3'd1: ex_rd = pcimm_ex_i;
    3'd2: ex_rd = pc4_ex_i;
    default: ex_rd = alu_c_ex_i;
    endcase
end

// 选择 dm 阶段前递的数据
always@(*) begin
    case(wb_sel_dm_i)
    3'd0: dm_rd = imm_dm_i;
    3'd1: dm_rd = pcimm_dm_i;
    3'd2: dm_rd = pc4_dm_i;
    3'd3: dm_rd = rd_out_dm_i;
    default: dm_rd = alu_c_dm_i;
    endcase
end

// 选择 rd 阶段前递的数据
always@(*) begin
    case(wb_sel_wb_i)
    3'd0: wb_rd = imm_wb_i;
    3'd1: wb_rd = pcimm_wb_i;
    3'd2: wb_rd = pc4_wb_i;
    3'd3: wb_rd = rd_out_wb_i;
    default: wb_rd = alu_c_wb_i;
    endcase
end

always@(*) begin
    if (rR1_if_i == wR_ex_i && rf_we_ex_i && wb_sel_ex_i != 3'b011 && wR_ex_i)
        rD1_o = ex_rd;
    else if (rR1_if_i == wR_dm_i && rf_we_dm_i && wR_dm_i)
        rD1_o = dm_rd;
    else if (rR1_if_i == wR_wb_i && rf_we_wb_i && wR_wb_i)
        rD1_o = wb_rd;
    else rD1_o = rD1_if_i;
end

always@(*) begin
    if (rR2_if_i == wR_ex_i && rf_we_ex_i && wb_sel_ex_i != 3'b011 && wR_ex_i)
        rD2_o = ex_rd;
    else if (rR2_if_i == wR_dm_i && rf_we_dm_i && wR_dm_i)
        rD2_o = dm_rd;
    else if (rR2_if_i == wR_wb_i && rf_we_wb_i && wR_wb_i)
        rD2_o = wb_rd;
    else rD2_o = rD2_if_i;
end


always@(*) begin
    if ((rR1_if_i == wR_ex_i || rR2_if_i == wR_ex_i) && rf_we_ex_i && wb_sel_ex_i == 3'b011 && wR_ex_i) begin   
        flash_id_ex_o = 1'b0;
        keep_pc_o = 1'b1;
        keep_if_id_o = 1'b1;
    end
    else begin
        flash_id_ex_o = 1'b1;
        keep_pc_o = 1'b0;
        keep_if_id_o = 1'b0;
    end
end


endmodule
