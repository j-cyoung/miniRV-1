module dmem(
    input   rst_i,
    input   clk_i,
    input   dram_we_i,
    input   sign_i,
    input       [1 :0]  mask_op_i,
    input       [31:0]  addr_i,     // ÊäÈë·Ã´æµØÖ·
    input       [31:0]  data_i,
    output      [31:0]  rd_o
    );

wire    [31:0]  addr;
wire    [31:0]  data;
wire    [31:0]  rd;


mask MASK(
    .rst_i(rst_i),
    .sign_i(sign_i),
    .mask_op_i(mask_op_i),
    .addr_i(addr_i),
    .data_i(data_i),
    .rd_o(rd_o),
    .rd_i(rd),
    .addr_o(addr),
    .data_o(data)
);

data_mem dmem (
    .clk    (clk_i),
    .a      (addr[15:2]),
    .spo    (rd),
    .we     (dram_we_i),
    .d      (data)
);
    
endmodule
