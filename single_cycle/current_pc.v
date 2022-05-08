module current_pc(
    input   wire            clk_i,
    input   wire            rst_i,
    input   wire    [31:0]  din_i,
    output  reg     [31:0]  pc_o
    );

always@(posedge clk_i or posedge rst_i) begin
    pc_o  <=  rst_i ? -32'd4 : din_i;
end

endmodule
