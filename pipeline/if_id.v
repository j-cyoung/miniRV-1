module if_id(
input   wire            rst_n_i,
input   wire            clk_i,
input   wire            keep_if_id_i,
input   wire    [31:0]  inst_i,
input   wire    [31:0]  pc_i,
output  reg     [31:0]  inst_o,
output  reg     [31:0]  pc_o,
input   wire            null_i,
output  reg             null_o
);

always@(posedge clk_i) begin
    if (~rst_n_i) null_o <= 1'b1;
    else null_o <= null_i;
end

always@(posedge clk_i) begin
    if (~rst_n_i) pc_o <= 32'b0;
    else if (~keep_if_id_i) pc_o <= pc_i;
    else pc_o <= pc_o;
end

always@(posedge clk_i) begin
    if (~rst_n_i) inst_o <= 32'b0;
    else if (~keep_if_id_i) inst_o <= inst_i;
    else inst_o <= inst_o;
end

endmodule