module rf(
    input   wire            rst_i,
    input   wire            clk_i,  // 在时钟下降沿进行写入
    input   wire            rf_we_i,  // 写使能信号
    input   wire    [4:0]   rR1_i,
    input   wire    [4:0]   rR2_i,
    input   wire    [4:0]   wR_i,
    input   wire    [31:0]  wD_i,
    output  reg     [31:0]  rD1_o,
    output  reg     [31:0]  rD2_o
);

reg [31:0]  registers[31:0];

// 寄存器读出没有时钟限制
always@(*) begin
    if (rst_i) begin
        rD1_o = 32'b0;
        rD2_o = 32'b0;
    end
    else begin
        rD1_o = registers[rR1_i];
        rD2_o = registers[rR2_i];
    end
end

always@(posedge clk_i) begin
    if (rst_i) begin
        registers[ 1] <= 32'b0;
        registers[ 2] <= 32'b0;
        registers[ 3] <= 32'b0;
        registers[ 4] <= 32'b0;
        registers[ 5] <= 32'b0;
        registers[ 6] <= 32'b0;
        registers[ 7] <= 32'b0;
        registers[ 8] <= 32'b0;
        registers[ 9] <= 32'b0;
        registers[10] <= 32'b0;
        registers[11] <= 32'b0;
        registers[12] <= 32'b0;
        registers[13] <= 32'b0;
        registers[14] <= 32'b0;
        registers[15] <= 32'b0;
        registers[16] <= 32'b0;
        registers[17] <= 32'b0;
        registers[18] <= 32'b0;
        registers[19] <= 32'b0;
        registers[20] <= 32'b0;
        registers[21] <= 32'b0;
        registers[22] <= 32'b0;
        registers[23] <= 32'b0;
        registers[24] <= 32'b0;
        registers[25] <= 32'b0;
        registers[26] <= 32'b0;
        registers[27] <= 32'b0;
        registers[28] <= 32'b0;
        registers[29] <= 32'b0;
        registers[30] <= 32'b0;
        registers[31] <= 32'b0;
        registers[0 ] <= 32'b0;
    end
    else if (rf_we_i && wR_i)   // 注意，向 x0 中的写入无效
        registers[wR_i] <= wD_i;
    else            
        registers[wR_i] <= registers[wR_i];
end

endmodule