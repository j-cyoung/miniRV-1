module npc(
input   wire            rst_n_i,
input   wire    [31:0]  pc_i,
input   wire    [31:0]  ra_i,
input   wire    [31:0]  imm_i,
output  reg     [31:0]  pc4_o,
output  reg     [31:0]  pcimm_o,
output  reg     [31:0]  immra_o
);

always@(*) begin
    if (~rst_n_i) pc4_o = 32'b0;
    else pc4_o = pc_i + 32'd4;    
end

always@(*) begin
    if (~rst_n_i) pcimm_o = 32'b0;
    else pcimm_o = pc_i + imm_i;
end

always@(*) begin
    if (~rst_n_i) immra_o = 32'b0;
    else immra_o = imm_i + ra_i;
end

endmodule