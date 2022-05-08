module pc (
input               clk_i,
input               rst_n_i,
input               keep_pc_i,
input       [31:0]  in,
output  reg [31:0]  pc_o);

always@(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i)
        pc_o <= -32'd4;
    else if (~keep_pc_i)
        pc_o <= in;
    else pc_o <= pc_o;
end

endmodule