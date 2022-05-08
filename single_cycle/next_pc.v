module next_pc(
    input   wire            rst_i,
    input   wire    [1:0]   npc_op_i, // 生成下一条指令的控制信号
    input   wire    [31:0]  imm_i,
    input   wire    [31:0]  ra_i,
    input   wire    [31:0]  pc_i,
    output  reg     [31:0]  npc_o,
    output  reg     [31:0]  pc4_o,
    output  reg     [31:0]  pcimm_o
);

wire    [31:0]  pcimm_wire;
assign pcimm_wire = pc_i + imm_i;

always@(*) begin
    if (rst_i) pc4_o = 32'b0;
    else pc4_o = pc_i + 3'b100;
end

always@(*) begin
    if (rst_i) npc_o = 32'b0;
    else begin
        case(npc_op_i)
            2'b00: npc_o = pc_i + 3'b100;
            2'b01: npc_o = pcimm_wire;
            2'b10: npc_o = ra_i + imm_i;
            default: npc_o = pc_i + 3'b100;
        endcase
    end
end

always@(*) begin
    pcimm_o = pcimm_wire;
end

endmodule