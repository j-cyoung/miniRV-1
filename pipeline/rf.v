module rf(
input   wire            rst_n_i,
input   wire            clk_i,
input   wire            rf_we_i,
input   wire    [4 :0]  rR1_i,
input   wire    [4 :0]  rR2_i,
input   wire    [4 :0]  wR_i,
input   wire    [31:0]  wD_i,
output  reg     [31:0]  rD1_o,
output  reg     [31:0]  rD2_o
);

reg [31:0]  rfs[31:0];

always@(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
        rfs[31] = 32'b0;
        rfs[30] = 32'b0;
        rfs[29] = 32'b0;
        rfs[28] = 32'b0;
        rfs[27] = 32'b0;
        rfs[26] = 32'b0;
        rfs[25] = 32'b0;
        rfs[24] = 32'b0;
        rfs[23] = 32'b0;
        rfs[22] = 32'b0;
        rfs[21] = 32'b0;
        rfs[20] = 32'b0;
        rfs[19] = 32'b0;
        rfs[18] = 32'b0;
        rfs[17] = 32'b0;
        rfs[16] = 32'b0;
        rfs[15] = 32'b0;
        rfs[14] = 32'b0;
        rfs[13] = 32'b0;
        rfs[12] = 32'b0;
        rfs[11] = 32'b0;
        rfs[10] = 32'b0;
        rfs[9 ] = 32'b0;
        rfs[8 ] = 32'b0;
        rfs[7 ] = 32'b0;
        rfs[6 ] = 32'b0;
        rfs[5 ] = 32'b0;
        rfs[4 ] = 32'b0;
        rfs[3 ] = 32'b0;
        rfs[2 ] = 32'b0;
        rfs[1 ] = 32'b0;
        rfs[0 ] = 32'b0;
    end
    else if((|wR_i) && rf_we_i) rfs[wR_i] = wD_i;
end

always@(*) begin
    if (~rst_n_i) rD1_o = 32'b0;
    else rD1_o = rfs[rR1_i];
end

always@(*) begin
    if (~rst_n_i) rD2_o = 32'b0;
    else rD2_o = rfs[rR2_i];
end

endmodule