//--------------------------------------------
// 取指模块
// 在时钟上升沿 pc <= npc
// 同时发出下一条指令
//---------------------------------------------
module ifetch(
    input   wire            clk_i   ,
    input   wire            rst_i   ,
    input   wire    [1:0]   npc_op  , // 选择生成 npc 的方式
    input   wire    [31:0]  ra_i    , // 寄存器文件输出
    input   wire    [31:0]  imm_i   , // 立即数
    output  wire    [31:0]  pc4_o   , // pc + 4
    output  wire    [31:0]  inst_o  , // 指令
    output  wire    [31:0]  pcimm_o
    );
    
    wire    [31:0]  npc_wire;
    wire    [31:0]  pc_wire;
    
    next_pc ifetch_npc (
        .rst_i    (rst_i),
        .npc_op_i (npc_op),
        .imm_i    (imm_i),
        .ra_i     (ra_i),
        .pc_i     (pc_wire),
        .npc_o    (npc_wire),
        .pc4_o    (pc4_o),  
        .pcimm_o  (pcimm_o)
    );
    
    current_pc  ifetch_pc (
        .clk_i  (clk_i),
        .rst_i  (rst_i),
        .din_i  (npc_wire),
        .pc_o   (pc_wire)
    );
    
    inst_mem imem (
        .a(pc_wire[15:2]),
        .spo(inst_o)
    );
endmodule
